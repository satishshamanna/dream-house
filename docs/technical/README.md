# Continuous Technical Documentation

This folder contains the source of truth for the technical architecture, data model, APIs, and component specifications of the Salesforce application.

## Guidelines for Agents
- Whenever an Apex Class, Trigger, or LWC is added or modified, you must update the technical specifications here.
- Document any:
  - Custom Objects/Fields.
  - Apex Class signatures, controller methods, and triggers.
  - LWC public properties (`@api`), wired methods, and standard event schemas.
  - External integration API contracts.

## Current Technical Index
*(To be populated continuously by @03-build-agent and @06-release-agent)*
- **F01: VIP Buyer Matcher Components**:
  - **Custom Fields (Contact)**: `Budget__c` (Currency), `Beds__c` (Number).
  - **Apex Class**: `VIPBuyerController` (handles secure user-mode query logic).
  - **LWC Component**: `vipBuyerMatcher` (reactively wired widget placed on Property Record Page sidebar).
  - [F01 Feature Spec](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/01_feature_design.md)
  - [US01 Build Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/user-stories/US01/03_build_details.md)
  - [US02 Build Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/user-stories/US02/03_build_details.md)
  - [US03 Build Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/user-stories/US03/03_build_details.md)
  - [F01 Release Package Manifest](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/package_20260710_0902.xml)
  - [F01 Release Notes](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/release_notes_20260710_0902.md)
  - [F01 Git Deployment Commands](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F01/git_commands_20260710_0932.md)
- **F02: Smart Property Open House Scheduler**:
  - **Custom Fields (Property)**: `Size_SqFt__c` (Number).
  - **Custom Object**: `Open_House__c` (with fields: `Property__c`, `Open_House_Date__c`, `Max_Capacity__c`, `Registered_Visitors__c`).
  - **Apex Class**: `OpenHouseController` (handles fetching, booking open houses, calculating capacity, and registering visitors securely).
  - **LWC Component**: `openHouseScheduler` (displays events schedule, schedules open houses, and registers visitors; integrated in Property Record Page tab layout).
  - [F02 Feature Spec](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/01_feature_design.md)
  - [US01 Build Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US01/03_build_details.md)
  - [US02 Build Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US02/03_build_details.md)
  - [US03 Build Details](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US03/03_build_details.md)
  - [US01 Deployment Report](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US01/06_deployment_report.md)
  - [F02 Release Package Manifest (US01)](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/package_20260710_1250.xml)
  - [F02 Release Notes (US01)](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/release_notes_20260710_1250.md)
  - [F02 Git Deployment Commands (US01)](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/git_commands_20260710_1250.md)
  - [US02 Deployment Report](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/user-stories/US02/06_deployment_report.md)
  - [F02 Release Package Manifest (US02)](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/package_20260710_1254.xml)
  - [F02 Release Notes (US02)](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/release_notes_20260710_1254.md)
  - [F02 Git Deployment Commands (US02)](file:///d:/SatishAIProjects/11-GitHubAgents/docs/features/F02/git_commands_20260710_1254.md)









