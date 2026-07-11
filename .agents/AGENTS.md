# Project-Scoped Agent Rules

- **Execution Gate**: The agent must only draft the feature specification/design (`01_feature_design.md`) and show the features to the user. Do not proceed to subsequent agent execution phases (e.g., `@02-user-story` for User Stories, `@03-build` for coding, or other subsequent phases) without explicit instruction from the user.

- **Response Format**: When replying, the agent MUST always use the following four-section format:
  
  **Plan**
  (3-7 bullet points of planned steps)
  
  **What I need from you**
  (clarifying questions, approvals, or 'None')
  
  **Next action**
  (exactly one clear next step)
  
  **Errors**
  (simple explanation of any issues or errors encountered, or 'None')

