# Project Specifications: Salesforce SDLC Agent System

## 1. Overview
The goal of this project is to build a suite of GitHub-integrated SDLC (Software Development Life Cycle) agents that automate the development, testing, review, and deployment of Salesforce Apex and Lightning Web Components (LWC).

These agents will interact with human developers and the codebase via GitHub Issues, Pull Requests, and Actions, running in an automated, spec-driven loop.

---

## 2. Pipeline Architecture

The multi-agent system follows a streamlined execution chain where context passes forward from epic creation, to features, user stories, coding, code review, validation/testing, and release:

```
 @00-epic
       │
       ▼ (Handoff: "Create Features")
 @01-feature
       │
       ▼ (Handoff: "Create User Stories")
 @02-user-story
       │
       ▼ (Handoff: "Write Code")
 @03-build
       │
       ▼ (Handoff: "Review Code")
 @04-code-review
       │
       ▼ (Handoff: "Generate Tests")
 @05-test
       │
       ▼ (Handoff: "Deploy & Release")
 @06-release
```

---

## 3. SDLC Agent Personas

### Agent 0: `@00-epic` (`.github/agents/00-epic.agent.md`)
* **Role**: Analyzes high-level goals or business requirements and breaks them down into structured Epics.
* **Output**: Epic definitions, system integrations, and business value documentation.
* **Handoff**: Hands off to `@01-feature`.

### Agent 1: `@01-feature` (`.github/agents/01-feature.agent.md`)
* **Role**: Takes an approved Epic and designs technical system features and designs (specs).
* **Output**: Feature specifications, API specs, schema/field maps, and architectural dependencies.
* **Handoff**: Hands off to `@02-user-story`.

### Agent 2: `@02-user-story` (`.github/agents/02-user-story.agent.md`)
* **Role**: Breaks features down into clear, actionable, and implementable User Stories.
* **Output**: User Story details containing Gherkin BDD Scripts, unit test TDD Scripts, Acceptance Criteria, and technical design notes (identifying new/existing components).
* **Handoff**: Hands off to `@03-build`.

### Agent 3: `@03-build` (`.github/agents/03-build.agent.md`)
* **Role**: Primary developer agent writing Apex backend (classes, triggers) and LWC frontend components to fulfill BDD scenarios and TDD scripts.
* **Output**: Generated Salesforce DX metadata (marked as new/existing) and build reports mapping implementation to BDD/TDD specs.
* **Handoff**: Hands off to `@04-code-review`.

### Agent 4: `@04-code-review` (`.github/agents/04-code-review.agent.md`)
* **Role**: Static code analyzer and gatekeeper enforcing security, governor limits, and BDD/TDD design alignment.
* **Output**: Code review reports verifying compliance with security guidelines, Gherkin BDD scenarios, and TDD script outlines.
* **Handoff**: Hands off to `@05-test`.

### Agent 5: `@05-test` (`.github/agents/05-test.agent.md`)
* **Role**: Quality assurance agent generating robust Apex unit tests and LWC Jest test suites.
* **Output**: Test classes and suites (marked as new/existing) ensuring coverage of all Gherkin BDD scenarios and implementing TDD outlines.
* **Handoff**: Hands off to `@06-release`.

### Agent 6: `@06-release` (`.github/agents/06-release.agent.md`)
* **Role**: Handles validation, deployment command generation, and release reporting via Salesforce CLI.
* **Output**: Deployment logs, Git command sequences, package manifests, and release notes explicitly listing component statuses (new vs. existing).

---

## 4. Operational Flow in VS Code & GitHub

1. **Epic Analysis**: Invoke the first agent:
   `@00-epic Gathers requirements and creates the Epic definition.`
2. **Feature Design**: Hand off to `@01-feature` to convert the Epic into technical features.
3. **Story Mapping**: Hand off to `@02-user-story` to write individual stories.
4. **Development**: Invoke `@03-build` on a user story to build Apex and LWC files:
   `@03-build Write a new trigger handler for Opportunity to update Account tiers.`
5. **Code Review**: Hand off to `@04-code-review` to check governor limits, security, and trigger-handler patterns.
6. **Testing**: Hand off to `@05-test` to write unit tests and achieve code coverage.
7. **Release**: Hand off to `@06-release` to validate and deploy code metadata via Salesforce CLI.

---

## 5. Output Location Rules

All agent-generated planning, design, and validation documentation must be stored under folders named after the specific feature or user story identifier:
* **Epics**: `docs/epics/<EPIC-ID>/00_epic_spec.md`
* **Features**: `docs/features/<FEATURE-ID>/01_feature_design.md`
* **User Stories**: `docs/features/<FEATURE-ID>/user-stories/<STORY-ID>/02_story_details.md` and build details as `03_build_details.md`.
* **Execution Logs & Reports**: Store review reports as `04_review_report.md`, test logs as `05_test_report.md`, and deployment logs as `06_deployment_report.md` in `docs/features/<FEATURE-ID>/user-stories/<STORY-ID>/logs/`.
* **Salesforce Source Code**: Keep actual `.cls`, `.trigger`, and `.js` metadata in the Salesforce DX structure (`force-app/main/default/`), but map and document their modifications in the corresponding User Story folder.
* **Continuous Documentation**: Global business flows and technical reference maps must be updated concurrently by agents:
  - **Functional Reference**: Kept up-to-date in `docs/functional/` folder (e.g., business rules, flow charts, user manuals).
  - **Technical Reference**: Kept up-to-date in `docs/technical/` folder (e.g., entity relationship diagrams, Apex class APIs, LWC event/property specs, integration specifications).


