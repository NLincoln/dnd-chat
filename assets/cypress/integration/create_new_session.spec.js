/// <reference types="Cypress" />
/// <reference types="@testing-library/cypress" />

it("can create a new session", function () {
  cy.visit("/");
  cy.findByLabelText("Session Name").type("My Adventure!");
  cy.findByText("Create Session").click();
  cy.url().should("match", /session\/[a-z0-9-]+/);
});
