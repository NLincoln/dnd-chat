/// <reference types="Cypress" />
/// <reference types="@testing-library/cypress" />

const { createNewSession } = require("../support/commands");

it("can send messages", function () {
  createNewSession({ playerName: "Friendneir" });
  cy.findByTestId("message").type("hello!{enter}");
  cy.findByTestId("message").should("have.value", "");

  cy.findByTestId("event-type-Message").within(() => {
    cy.findByText("hello!").should("be.visible");
    cy.findByTestId("event-timestamp").should("be.visible");
    cy.findByTestId("event-text").should("contain.text", "hello!");
    cy.findByTestId("player-name").should("contain.text", "Friendneir");
  });
});

it("can execute dice rolls", function () {
  createNewSession({ playerName: "Tortimer" });
  cy.findByTestId("message").type("#2d1+3{enter}");
  cy.findByTestId("event-type-DiceRoll").within(() => {
    cy.findByTestId("event-text").should(
      "contain.text",
      "Tortimer rolled #2d1+3 => 5"
    );
  });
});
