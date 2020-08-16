import React, { useEffect, useState, useRef } from "react";
import { Socket, Channel } from "phoenix";
import { useGetSessionByIdQuery } from "./types";
import { Dropdown } from "react-bootstrap";

type EventData =
  | {
      type: "Message";
      text: string;
      player_name: string;
    }
  | {
      type: "DiceRoll";
      result: {
        total: number;
      };
      roll: string;
      player_name: string;
    }
  | {
      type: "PlayerJoined";
      player_name: string;
    };

type Event = {
  timestamp: string;
  data: EventData;
};

function getMeta(name: string): string {
  const element = document.querySelector(
    `meta[name="${name}"]`
  )! as HTMLMetaElement;
  return element.content;
}

const sessionId = getMeta("session-id");
const playerId = getMeta("player-id");
const token = getMeta("token");
let socket = new Socket(`/socket`, {
  params: {
    player_id: playerId,
    token,
  },
});
socket.connect();
let channel = socket.channel(`session:${sessionId}`);

channel.join();

function InviteButton(props: { inviteSlug: string }) {
  const inviteUrl = `${window.location.origin}/join-session/${props.inviteSlug}`;
  const [didCopy, setDidCopy] = useState(false);
  return (
    <Dropdown onToggle={() => setDidCopy(false)}>
      <Dropdown.Toggle size={"sm"} variant={"outline-primary"}>
        Invite Players
      </Dropdown.Toggle>
      <Dropdown.Menu>
        <Dropdown.ItemText>
          <div className="form-group" style={{ minWidth: 200 }}>
            <label htmlFor="invite_link">Invite Link</label>
            <input
              type="text"
              className={"form-control"}
              disabled
              value={inviteUrl}
            />
          </div>
          <button
            type="button"
            className={
              didCopy ? "btn btn-outline-success" : "btn btn-outline-primary"
            }
            data-testid="copy-link"
            onClick={() => {
              navigator.clipboard.writeText(inviteUrl).then(() => {
                setDidCopy(true);
              });
            }}
          >
            {didCopy ? <i className={"far fa-check-circle"} /> : "Copy"}
          </button>
        </Dropdown.ItemText>
      </Dropdown.Menu>
    </Dropdown>
  );
}

export function SessionChat() {
  let [events, setEvents] = useState<Event[]>([]);
  let [text, setText] = useState<string>("");

  const sessionQuery = useGetSessionByIdQuery({
    variables: {
      id: sessionId,
    },
  });

  useEffect(() => {
    const listener = channel.on("recent_messages", (response) => {
      setEvents(response.messages);
    });
    channel.push(`get_recent_messages`, {});

    return () => {
      channel.off("recent_messages", listener);
    };
  }, []);

  return (
    <div className="row mt-4">
      <div className="col-lg">
        <div className="card" data-testid="session-chat">
          <div className="card-header d-flex justify-content-between">
            <span>{sessionQuery.data?.session.name}</span>
            <InviteButton
              inviteSlug={sessionQuery.data?.session.inviteSlug ?? ""}
            />
          </div>
          <div>
            <form
              onSubmit={(event) => {
                event.preventDefault();
                setText("");
                channel.push("message", {
                  text,
                });
              }}
            >
              <input
                value={text}
                onChange={(event) => setText(event.target.value)}
                placeholder="Say something"
                data-testid={"message"}
                autoComplete={"off"}
                className={"form-control"}
              />
            </form>
          </div>
          <div className="card-body">
            <div>
              {events.map((event) => {
                return (
                  <div
                    key={event.timestamp}
                    data-testid={`event-type-${event.data.type}`}
                  >
                    <div data-testid="player-name">
                      <small className="text-muted">
                        {event.data.player_name}
                      </small>
                    </div>
                    <div style={{ lineHeight: "0.9" }} className="mb-2">
                      <small data-testid="event-timestamp">
                        {event.timestamp}
                      </small>{" "}
                      {event.data.type === "Message" ? (
                        <span data-testid="event-text">{event.data.text}</span>
                      ) : event.data.type === "DiceRoll" ? (
                        <span data-testid="event-text">
                          {event.data.player_name} rolled {event.data.roll} =
                          {"> "}
                          {event.data.result.total}
                        </span>
                      ) : event.data.type === "PlayerJoined" ? (
                        <span data-testid="event-text">
                          {event.data.player_name} joined
                        </span>
                      ) : null}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
