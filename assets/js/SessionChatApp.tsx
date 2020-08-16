import React from "react";
import ReactDOM from "react-dom";
import { SessionChat } from "./SessionChat";
import { ApolloProvider } from "@apollo/client";
import { apolloClient } from "./apollo";

export function load() {
  ReactDOM.render(
    <ApolloProvider client={apolloClient}>
      <SessionChat />
    </ApolloProvider>,
    document.getElementById("session-chat")
  );
}
