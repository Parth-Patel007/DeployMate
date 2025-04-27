describe('Home page loads', () => {
    it('shows the app banner', () => {
        cy.visit('/');
        cy.contains('DeployMate').should('be.visible');
    });
});
