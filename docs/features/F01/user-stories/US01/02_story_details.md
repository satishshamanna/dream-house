# User Story: US01 - Contact Schema Updates for VIP Buyer Matcher

## Story Description
**As a** Salesforce Administrator  
**I want to** add Budget and Preferred Beds fields to the standard Contact object  
**So that** I can store preferences for VIP buyers in the system.

---

## Acceptance Criteria
| Scenario | Given | When | Then | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Create Budget field** | Standard Contact object in Salesforce DX | We define custom Currency field `Budget__c` | The field has length 18, 0 decimals, label 'Budget' and can be deployed. | Verified |
| **Create Preferred Beds field** | Standard Contact object in Salesforce DX | We define custom Number field `Beds__c` | The field has precision 2, 0 decimals, label 'Preferred Beds' and can be deployed. | Verified |
| **Broker Access Permissions** | Custom fields exist on Contact | Running user has standard broker permissions | Broker can read and write to both `Budget__c` and `Beds__c` fields. | Verified |

---

## Technical Notes
- **Metadata Path**: 
  - `force-app/main/default/objects/Contact/fields/Budget__c.field-meta.xml`
  - `force-app/main/default/objects/Contact/fields/Beds__c.field-meta.xml`
- **Exposed API Names**: `Contact.Budget__c`, `Contact.Beds__c`.
- **Validation Rules**: No strict validation rules required. The fields can be empty.

---

## Manual Test Scripts
| Step # | Test Action | Expected Output | Status |
| :--- | :--- | :--- | :--- |
| 1 | Navigate to **Setup** > **Object Manager** > **Contact** > **Fields & Relationships**. | Both `Budget` (`Budget__c`) and `Preferred Beds` (`Beds__c`) fields are visible in the relationships list. | 🟢 Pass |
| 2 | Select the `Budget__c` field details. | Field type is Currency (18, 0). | 🟢 Pass |
| 3 | Select the `Beds__c` field details. | Field type is Number (2, 0). | 🟢 Pass |
| 4 | Navigate to **Setup** > **Permission Sets** > **dreamhouse**. Select **Object Settings** > **Contacts**. | Both `Budget` and `Preferred Beds` fields have Read Access and Edit Access checked. | 🟢 Pass |

