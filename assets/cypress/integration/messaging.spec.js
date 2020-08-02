/// <reference types="Cypress" />
/// <reference types="@testing-library/cypress" />

const { createNewSession } = require("../support/commands");

it("can send messages", function () {
  createNewSession();
  cy.findByTestId("message").type("hello!{enter}");
  cy.findByText("hello!").should("be.visible");
  cy.findByTestId("event-timestamp").should("be.visible");

  cy.findByTestId("message").should("have.value", "");
});
