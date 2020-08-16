/// <reference types="Cypress" />
/// <reference types="@testing-library/cypress" />

const { createNewSession } = require("../support/commands");

it("can copy an invite link on the player name page", function () {
  cy.visit("/");
  cy.findByLabelText("Session Name").type("My Adventure!");
  cy.findByText("Create Session").click();
});
