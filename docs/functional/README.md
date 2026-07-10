# Continuous Functional Documentation

This folder contains the source of truth for the functional, business-level behavior of the Salesforce application. 

## Guidelines for Agents
- Whenever an Epic or User Story changes the functional flow, business rules, or user interface, you must update the relevant markdown files in this directory.
- Maintain a clean list of functional capabilities and user journeys.

## Current Functional Index
*(To be populated continuously by @00-epic-agent, @01-feature-agent, and @02-user-story-agent)*
- **F01: VIP Buyer Matcher**: Auto-matches potential buyers (Contacts) to Properties based on budget and bedroom requirements. Surfaces them on the Property record page sidebar. [F01 Feature Spec](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/01_feature_design.md).
  - **US01**: Contact Schema Updates [US01 Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/user-stories/US01/02_story_details.md)
  - **US02**: VIP Buyer Matcher Apex Controller [US02 Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/user-stories/US02/02_story_details.md)
  - **US03**: VIP Buyer Matcher LWC Widget [US03 Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/user-stories/US03/02_story_details.md)
- **F02: Smart Property Open House Scheduler**: Allows scheduling open houses for a Property, dynamically calculates maximum visitor capacity based on property size, and enables visitor registration. [F02 Feature Spec](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/01_feature_design.md).
  - **US01**: Open House Schema Updates [US01 Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US01/02_story_details.md) | [US01 Deployment Report](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US01/06_deployment_report.md)
  - **US02**: Open House Apex Controller [US02 Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US02/02_story_details.md) | [US02 Deployment Report](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US02/06_deployment_report.md)
  - **US03**: Open House Scheduler LWC & Flexipage Integration [US03 Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US03/02_story_details.md)







