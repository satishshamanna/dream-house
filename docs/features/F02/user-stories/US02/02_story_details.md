# User Story: US02 - Open House Apex Controller

## Story Description
**As a** Developer  
**I want to** implement an Apex controller to query open houses, schedule new dates with calculated capacities, and register visitors securely  
**So that** the frontend scheduler component has a reliable, secure backend API.

---

## Acceptance Criteria
| Scenario | Given | When | Then | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Fetch Open Houses** | A valid Property ID | `getOpenHouses` is called | Returns active `Open_House__c` records associated with the Property ID, sorted by date-time ascending, enforcing database security (`WITH USER_MODE`). | Verified |
| **Schedule Open House** | Valid Property ID and future Date-Time | `scheduleOpenHouse` is called | Calculates capacity based on Property size: `Size_SqFt__c / 100`. Inserts and returns a new `Open_House__c` record, enforcing security (`WITH USER_MODE`). | Verified |
| **Null Size Default Capacity** | Associated Property size is null, 0, or negative | `scheduleOpenHouse` is called | Set capacity to a default of **10**. | Verified |
| **Input Validation (Schedule)** | Property ID is null or Date-Time is null | `scheduleOpenHouse` is called | Throws an `AuraHandledException` with a descriptive message. | Verified |
| **Register Visitor** | Valid Open House ID | `registerVisitor` is called | Queries the Open House. If `Registered_Visitors__c` is less than `Max_Capacity__c`, increments the visitor counter by 1 and updates the record under user mode. | Verified |
| **Registration Over Capacity** | Open House has reached maximum capacity | `registerVisitor` is called | Throws an `AuraHandledException` stating "Maximum capacity reached for this open house." | Verified |

---

## Technical Notes
- **Metadata Path**: `force-app/main/default/classes/OpenHouseController.cls`
- **Method Signatures**:
  - `@AuraEnabled(cacheable=true) public static List<Open_House__c> getOpenHouses(Id propertyId)`
  - `@AuraEnabled public static Open_House__c scheduleOpenHouse(Id propertyId, DateTime openHouseDateTime)`
  - `@AuraEnabled public static void registerVisitor(Id openHouseId)`
- **Database Access Security**: Every query and DML operation must use the `WITH USER_MODE` suffix to enforce FLS and CRUD settings.
- **Exception Handling**: Standard `try-catch` structures. Custom error messages must be re-thrown using `AuraHandledException`.

---

## Manual Test Scripts
| Step # | Test Action | Expected Output | Status |
| :--- | :--- | :--- | :--- |
| 1 | Open **Developer Console** > **Debug** > **Open Execute Anonymous Window**. | Execution window opens. | 🟢 Pass |
| 2 | Execute anonymous Apex to call `OpenHouseController.scheduleOpenHouse` with a valid Property ID and future date. | A new `Open_House__c` record is inserted with `Max_Capacity__c` set to `Size_SqFt__c / 100` (or 10 if size is blank). | 🟢 Pass |
| 3 | Execute anonymous Apex to query open houses: `OpenHouseController.getOpenHouses(propertyId)`. | Returns a list containing the newly scheduled open house. | 🟢 Pass |
| 4 | Execute anonymous Apex to register visitors up to and beyond the calculated maximum capacity limit. | Visitors increment successfully until capacity is reached, after which calling `registerVisitor` throws an `AuraHandledException`. | 🟢 Pass |
| 5 | Verify class permissions in permission set: Navigate to **Setup** > **Permission Sets** > **dreamhouse** > **Apex Class Access**. | `OpenHouseController` is listed in the Enabled Apex Classes. | 🟢 Pass |
