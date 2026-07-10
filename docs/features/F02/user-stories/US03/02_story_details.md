# User Story: US03 - Open House Scheduler LWC & Flexipage Integration

## Story Description
**As a** Real Estate Broker  
**I want to** view scheduled open houses, schedule new ones, and register visitors inside an Open House tab on the Property page  
**So that** I can easily coordinate viewings directly on the record.

---

## Acceptance Criteria
| Scenario | Given | When | Then | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Display Events List** | Associated open houses exist | The Open House tab loads on Property detail page | Renders scheduled open houses list containing Date, Time, Registered Visitors, and Max Capacity. | Verified |
| **Visual Capacity Highlights** | Open house has registered visitors | Renders event item | If capacity is full, display a red SLDS badge "Full". If spots are available, display a badge "X / Y Spots". | Verified |
| **Schedule Open House** | User enters valid datetime | Clicks "Schedule Open House" button | Apex method is called to schedule, schedule list is refreshed reactively, and a success Toast is shown. | Verified |
| **Register Visitor Action** | Available spots exist on an event | Broker clicks "Register Visitor" button | Increments visitor count by 1 in database, refreshes the component list, and displays a success Toast. | Verified |
| **Disable Registration (Full)** | Capacity is reached | Renders event item | The "Register Visitor" button is disabled. | Verified |
| **Empty State Display** | No open houses scheduled | Component loads | Displays "No open houses scheduled for this property." | Verified |
| **FlexiPage Tab Integration** | Standard Property record page | We view the page | The `openHouseScheduler` component is embedded inside a new tab titled "Open House" in the main tab set layout. | Verified |

---

## Technical Notes
- **Metadata Paths**:
  - `force-app/main/default/lwc/openHouseScheduler/`
  - `force-app/main/default/flexipages/Property_Record_Page.flexipage-meta.xml`
- **LWC Wiring**:
  - Wires to `OpenHouseController.getOpenHouses` passing `propertyId: '$recordId'`.
  - Refreshes wire cache using `refreshApex()`.
- **Target Page**: Standard Property record page (`lightning__RecordPage`). Target object constraints set to `Property__c`.
- **FlexiPage Integration**:
  - Added new tab inside standard main tabset on Property Record Page.
  - Placed the custom LWC component `openHouseScheduler` within this tab's facet region.

---

## Manual Test Scripts
| Step # | Test Action | Expected Output | Status |
| :--- | :--- | :--- | :--- |
| 1 | Navigate to the **Sales** or **Dreamhouse** app, open a **Property** record page. | A new tab labeled "Open House" is visible in the main tabset. | 🟢 Pass |
| 2 | Click on the "Open House" tab. | The `openHouseScheduler` component loads. If no open houses are scheduled, "No open houses scheduled for this property." is displayed. | 🟢 Pass |
| 3 | In the scheduling form, select a future date-time using the picker and click "Schedule Open House". | The loading spinner is displayed, then a success Toast is shown, and the scheduled event is added to the list. | 🟢 Pass |
| 4 | Click "Register Visitor" on a scheduled open house. | The visitor count increments (e.g. from "0 / 10 Spots" to "1 / 10 Spots"). | 🟢 Pass |
| 5 | Register visitors until capacity is reached. | The "Register Visitor" button becomes disabled, and the capacity indicator changes to a red badge labeled "Full". | 🟢 Pass |
