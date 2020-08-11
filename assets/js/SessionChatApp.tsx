import React from "react";
import ReactDOM from "react-dom";
import { SessionChat } from "./SessionChat";

export function load() {
  ReactDOM.render(
    React.createElement(SessionChat, null),
    document.getElementById("session-chat")
  );
}
