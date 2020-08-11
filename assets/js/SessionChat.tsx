import React, { useEffect, useState, useRef } from "react";
import { Socket, Channel } from "phoenix";

type EventData =
  | {
      type: "Message";
      text: string;
      player_name: string;
    }
  | {
      type: "DiceRoll";
      result: string;
      roll: string;
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

export function SessionChat() {
  let [events, setEvents] = useState<Event[]>([]);
  let [text, setText] = useState<string>("");

  let channelRef = useRef<Channel>();

  useEffect(() => {
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
    let channel = (channelRef.current = socket.channel(`session:${sessionId}`));

    channel.join();
    channel.on("recent_messages", (response) => {
      setEvents(response.messages);
    });
    channel.push(`get_recent_messages`, {});

    return () => {
      socket.disconnect();
    };
  }, []);

  return (
    <div className="row mt-4">
      <div className="col-lg">
        <div className="card" data-testid="session-chat">
          <div className="card-header">Chat: {"playsession.name"}</div>
          <div>
            <form
              onSubmit={(event) => {
                event.preventDefault();
                setText("");
                channelRef.current?.push("message", {
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
                  <>
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
                          {event.data.result}
                        </span>
                      ) : null}
                    </div>
                  </>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
