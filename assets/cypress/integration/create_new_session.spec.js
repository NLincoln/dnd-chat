/// <reference types="Cypress" />
/// <reference types="@testing-library/cypress" />

it("can create a new session", function () {
  cy.visit("/");
  cy.findByLabelText("Session Name").type("My Adventure!");
  cy.findByText("Create Session").click();
  cy.url().should("match", /join-session\/[A-Za-z0-9-_]+/);
  cy.findByText("Join My Adventure!");
  cy.findByLabelText("Player Name").type("Zaggy Boy");
  cy.findByText("Join!").click();
  cy.findByTestId("session-chat");

  cy.findByTestId(`event-type-PlayerJoined`).should(
    "contain.text",
    "Zaggy Boy joined"
  );
});
