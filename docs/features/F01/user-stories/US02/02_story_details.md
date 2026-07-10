# User Story: US02 - VIP Buyer Matcher Apex Controller

## Story Description
**As a** Developer  
**I want to** build an Apex controller to query matching contacts based on property characteristics  
**So that** the frontend matcher widget displays the most relevant buyers securely.

---

## Acceptance Criteria
| Scenario | Given | When | Then | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Valid Property ID** | A valid Property record exists with specific `Price__c` and `Beds__c` | `getVipBuyers` is called with the Property ID | It queries Contacts where `Budget__c >= Price__c` AND `Beds__c = Beds__c` ordered by `Budget__c` ASC. | Verified |
| **Limit Results to Top 5** | Multiple matching Contacts exist | `getVipBuyers` is called | The query limits the returned list to exactly the top 5 closest matches. | Verified |
| **Database Security Enforced** | Query is executed | Method runs | Query includes `WITH USER_MODE` to validate object and field access of the current user. | Verified |
| **Null Property ID** | Property ID is passed as null | `getVipBuyers` is called | An `AuraHandledException` is thrown with 'Property ID cannot be null.'. | Verified |
| **Invalid Property ID** | Property ID is passed but does not exist | `getVipBuyers` is called | An `AuraHandledException` is thrown with 'Property record not found.'. | Verified |

---

## Technical Notes
- **Metadata Path**: `force-app/main/default/classes/VIPBuyerController.cls`
- **Method Signature**: `@AuraEnabled(cacheable=true) public static List<Contact> getVipBuyers(Id propertyId)`
- **Exception Handling**: Standard `try-catch` wrapper. Any DB exception is logged and rethrown as `AuraHandledException`.

---

## Manual Test Scripts
| Step # | Test Action | Expected Output | Status |
| :--- | :--- | :--- | :--- |
| 1 | Open the **Developer Console** > **Debug** > **Open Execute Anonymous Window**. | Execution window opens. | 🟢 Pass |
| 2 | Run Apex code to query active Property and pass its ID: `VIPBuyerController.getVipBuyers('a00...');` with a valid ID. | The execution completes successfully and returns a list of contacts. | 🟢 Pass |
| 3 | Run Apex code passing null: `VIPBuyerController.getVipBuyers(null);` | The transaction fails, throwing an `AuraHandledException` stating "Property ID cannot be null." | 🟢 Pass |
| 4 | Run Apex code passing a fake ID: `VIPBuyerController.getVipBuyers('a00000000000000AAA');` | The transaction fails, throwing an `AuraHandledException` stating "Property record not found." | 🟢 Pass |
| 5 | Verify class permissions in permission set: Navigate to **Setup** > **Permission Sets** > **dreamhouse** > **Apex Class Access**. | `VIPBuyerController` is listed in the Enabled Apex Classes. | 🟢 Pass |

