# #️⃣ Agent Operating Guide (Salesforce Apex & LWC Edition)

These instructions help turn human prompts into reliable, repeatable Salesforce systems.

AI can guess.
This system is designed to behave.

---

# #️⃣ How the Agent Is Structured

The system has three layers:

## ## How this works (simple)

– **Instructions** = what we want to happen (in `instructions/`)
– **Decision** = pick the right Apex class/trigger or LWC component to modify or build
– **Actions** = the real work (Salesforce metadata in `force-app/main/default/`)

The agent can plan, but it must execute by creating and deploying Salesforce metadata. No one-off code.

---

# #️⃣ File Structure

– `instructions/` ➔ Workflow and Persona descriptions (e.g., `apex_developer.md`, `code_reviewer.md`)
– `.github/` ➔ GitHub Specific Configurations
  – `workflows/` ➔ CI/CD workflows and automated agent pipelines
  – `copilot-instructions.md` ➔ Global repository instructions parsed natively by GitHub Copilot
– `agents/` ➔ Agent orchestration and execution scripts (e.g., Python/Node runner scripts)
– `docs/` ➔ All Agent planning, specifications, designs, and execution logs
  – `functional/` ➔ Continuous functional specs, process flows, and business capabilities
  – `technical/` ➔ Continuous technical designs, Apex API descriptions, LWC component structures
  – `epics/` ➔ Epic folders containing high-level specs (e.g., `docs/epics/EPIC-100/`)
  – `features/` ➔ Feature folders containing tech specs (e.g., `docs/features/F01/01_feature_design.md`)
    – `user-stories/` ➔ User story folders (e.g., `docs/features/F01/user-stories/US01/`) containing story specs (`02_story_details.md`), build details (`03_build_details.md`), reviews (`04_review_report.md`), test reports (`05_test_report.md`), and deployment reports (`06_deployment_report.md`)


– `force-app/main/default/` ➔ Salesforce DX Source Code
  – `classes/` ➔ Apex Classes and Test Classes (`*.cls` and `*-meta.xml`)
  – `lwc/` ➔ Lightning Web Components (`*.html`, `*.js`, `*.js-meta.xml`, `*.css`)
  – `triggers/` ➔ Apex Triggers (`*.trigger` and `*-meta.xml`)
– `config/` ➔ Scratch Org Definition files (e.g., `project-scratch-def.json`)
– `.tmp/` ➔ Temporary log files and deployment verification results
– `project_specs.md` ➔ Full project definition

---

# #️⃣ Step 1: Define the Project First

Before writing any Salesforce code, you must:

1. Create/update the file `project_specs.md`
2. Clearly define:
   — What triggers, classes, or LWC components are being added/modified
   — What Apex controller methods, triggers, or wire adapters are needed
   — UI wireframes or custom properties (`@api`) for LWC components
   — Expected user interactions and system behaviors
   — Core validation rules, sharing rules, and security checks (e.g. FLS/CRUD)
   — Testing strategy (Apex unit tests, Jest tests, test data factories)
   — Target org environment (Scratch Org, Developer Sandbox, etc.)
   — What “done” looks like
3. Show the file
4. Wait for approval

No code should be written before this file is approved.

---

# #️⃣ Development Rules

## ## Rule 1: Always Read First
Always read:
– `instructions.md`
– `project_specs.md`

Before taking action.

---

## ## Rule 2: Apex & LWC Only
All code must be written in Salesforce Apex (for backend logic, trigger handlers, and controllers) and Lightning Web Components (HTML, JavaScript, CSS, and XML configuration for frontend).

---

## ## Rule 3: Strict Testing & Coverage
Every Apex class must have a corresponding test class (ending in `Test.cls`).
- Target at least 85% Apex unit test coverage (with 100% target for trigger handlers).
- Tests must include robust assertions using the modern `Assert` class (e.g., `Assert.areEqual()`, `Assert.isTrue()`).
- All tests must use mock test data or standard test data factories. Avoid hardcoded IDs.
- Run tests via the Salesforce CLI (`sf apex run test`) before any deployment validation.

---

## ## Rule 4: Salesforce Best Practices
- **Bulkification**: All Apex code must be bulkified. Never perform DML statements or SOQL queries inside loops.
- **Trigger Pattern**: Limit to one trigger per SObject. Defer all logic to trigger handler classes.
- **Security Check**: Enforce object-level and field-level security checks using `WITH USER_MODE` or `Security.stripInaccessible` where appropriate.
- **LWC reactive states**: Correctly leverage `@track`, `@api`, and `@wire`. Use custom events for child-parent communication.

---

## ## Rule 5: Deployment Checklist (Salesforce CLI)
Before deploying to an org:

1. Run Apex unit tests to ensure they all pass.
2. Verify all component metadata files (like `.js-meta.xml` and `.cls-meta.xml`) are fully defined.
3. Show the deployment command (e.g., `sf project deploy start`).
4. Wait for approval.
5. Deploy.
6. Verify deployment status and run manual sanity checks in the target Salesforce Org.
7. **Release Notes Documentation**: Ensure the generated `release_notes_<timestamp>.md` details the exact pre-deployment and post-deployment manual actions (e.g., Lightning App Builder component placements, permission set assignments, page activation rules) that the deployment team must perform.
8. **Package Manifest**: Ensure a standard `package_<timestamp>.xml` deployment manifest is created under the parent Feature directory, capturing all metadata components included in the release.
9. **Git Command List**: Ensure a standard `git_commands_<timestamp>.md` file is created under the parent Feature directory, providing the exact Git sequences needed to stage, commit, and push changes to the local and remote feature branch.




---

## ## Rule 6: Strictly Limit Scope to User Requests
- Never execute pipeline actions, write code, run code reviews, or generate documentation/log files for adjacent user stories, features, or tasks unless explicitly directed to do so by the user.
- If the user commands work on a localized target (e.g., executing testing only for US01), strictly restrict all modifications, test classes, execution logs, and reports to that target user story folder. Do not preemptively expand the scope.
- **Do not proceed with subsequent agent execution phases (e.g., User Story generation, Build, Code Review, Test, Release) or generate their respective files/code without explicit instruction from the user. The agent must only draft/show the features (Feature Design Specification) and stop.**

---

## ## Rule 7: End-to-End Traceability (Epic to Release)
- Ensure complete traceability from Epic specifications down to the Release package and release notes.
- Every User Story must link back to its parent Feature Design Spec (`01_feature_design.md`), and the Feature Spec must link back to its parent Epic (`00_epic_spec.md`).
- Test reports (`05_test_report.md`) and deployment reports (`06_deployment_report.md`) must refer directly to the User Story ID and parent Feature ID.

---

## ## Rule 8: Pipeline Numbering Prefix on Files
All documentation and log files generated by the agents must be prefixed with the phase number of the agent that produced them:
- `00_epic_spec.md` (Product / Epic)
- `01_feature_design.md` (Technical / Feature)
- `02_story_details.md` (User Story)
- `03_build_details.md` (Construction / Build)
- `04_review_report.md` (Code Review)
- `05_test_report.md` (Quality / Test)
- `06_deployment_report.md` (Release)
- Package manifest `package_<timestamp>.xml`, Release Notes `release_notes_<timestamp>.md`, and Git deployment list `git_commands_<timestamp>.md` directly under the parent Feature folder (Release)

---




# #️⃣ When Something Breaks

1. Fix the Apex compile/runtime issue or LWC execution error.
2. Improve unit tests to catch the edge case so it doesn't fail the same way again.
3. Re-run test suites.
4. Update developer instructions if a platform limit or governor limit was encountered.

Errors are feedback.
Each fix should make the system stronger.

---

# #️⃣ Response Format

When replying, always use:

**Plan** (3-7 bullet points)
**What I need from you** (if anything)
**Next action** (one clear step)
**Errors** (explained simply)

---

# Core Principle

Define clearly.
Build in small steps.
Test before moving on.


Reliable systems are built intentionally.

---

# #️⃣ Quick Reference

## ## Directory & File Map
* **Project Specs**: [project_specs.md](project_specs.md) (Define before writing code!)
* **Workflow Logic**: `instructions/` (Markdown files describing the steps)
* **Agent Outputs/Docs**: `docs/` (Planning, specifications, designs)
  * **Epics**: `docs/epics/<EPIC-ID>/` (e.g. `docs/epics/EPIC-101/`)
  * **Features**: `docs/features/<FEATURE-ID>/` (e.g. `docs/features/F01/`)
  * **User Stories**: `docs/features/<FEATURE-ID>/user-stories/<STORY-ID>/` (e.g. `docs/features/F01/user-stories/US01/`)
* **Functional Docs**: `docs/functional/` (Continuous business and functional indexes)
* **Technical Docs**: `docs/technical/` (Continuous code references and APIs)

* **GitHub Configs**: `.github/` (Workflows and Copilot native instructions)
* **Agent Scripts**: `agents/` (Custom runner/orchestrator scripts)
* **Apex Classes**: `force-app/main/default/classes/` (Apex code and test classes)
* **LWC Components**: `force-app/main/default/lwc/` (HTML, JS, CSS, and configuration)
* **Triggers**: `force-app/main/default/triggers/` (Apex Triggers)
* **Local Temp Data**: `.tmp/` (For temporary files and logs)

## ## Workflow Checklist
1. **Define**: Specify the new workflow in [project_specs.md](project_specs.md) and get approval.
2. **Write Instructions**: Create `instructions/<workflow_name>.md`.
3. **Write Code**: Create Apex and LWC components in `force-app/main/default/`.
4. **Local Test**: Run Apex tests via SFDX (`sf apex run test`) and verify LWC in scratch org.
5. **CLI Deploy**: Show command, get approval, deploy, and test live in Salesforce.

## ## Standard Response Format
Always include these four parts in replies:
1. **Plan** (3-7 bullet points of planned steps)
2. **What I need from you** (questions or inputs needed)
3. **Next action** (exactly one clear next step)
4. **Errors** (simple explanation of any issues)