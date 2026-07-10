# GitHub Copilot Repository Instructions

Always follow these rules when developing Salesforce metadata in this repository:

1. **Development Environment**: Target Salesforce DX structure in `force-app/main/default/`.
2. **Backend (Apex)**:
   - Apex code must always be bulkified (no SOQL/DML in loops).
   - Use `WITH USER_MODE` or security checks to enforce CRUD/FLS.
   - Triggers must delegate to handlers. Limit to one trigger per SObject.
   - Apex classes must have unit test classes (with >= 85% coverage) asserting both positive and negative scenarios.
3. **Frontend (LWC)**:
   - LWC JS files must avoid hardcoded credentials or IDs.
   - Use Lightning Design System (SLDS) styling tokens.
   - Handle events bubble correctly using standard custom events.
