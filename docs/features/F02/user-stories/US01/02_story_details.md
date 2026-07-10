# User Story: US01 - Open House Schema Updates

## Story Description
**As a** Salesforce Administrator  
**I want to** add a property size field and define an Open House custom object with date, capacity, and registration tracking fields  
**So that** I can store and manage scheduled open house viewings and their visitor capacities.

---

## Acceptance Criteria
| Scenario | Given | When | Then | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Property Size field** | Standard `Property__c` object in Salesforce DX | We define custom field `Size_SqFt__c` | The field is a Number (6, 0) labeled 'Size (Sq Ft)' and is deployable. | Verified |
| **Open House object** | Custom object metadata inside Salesforce DX | We define custom object `Open_House__c` | The object has AutoNumber name field `OH-{0000}`, plural label 'Open Houses', and Public Read/Write sharing model. | Verified |
| **Open House lookup** | Custom object `Open_House__c` | We define custom field `Property__c` | The field is a Lookup referencing `Property__c` with child relationship label 'Open Houses'. | Verified |
| **Open House Date field** | Custom object `Open_House__c` | We define custom field `Open_House_Date__c` | The field is a Required DateTime field labeled 'Open House Date'. | Verified |
| **Open House Max Capacity** | Custom object `Open_House__c` | We define custom field `Max_Capacity__c` | The field is a Number (6, 0) labeled 'Max Capacity'. | Verified |
| **Open House Registered Visitors** | Custom object `Open_House__c` | We define custom field `Registered_Visitors__c` | The field is a Number (6, 0) labeled 'Registered Visitors' with a default value of 0. | Verified |
| **Broker Access Permissions** | Custom object and fields exist | The running user has Broker permissions | The permission set `dreamhouse` permits Read and Edit access to all new fields on both `Property__c` and `Open_House__c`. | Verified |

---

## Technical Notes
- **Metadata Paths**:
  - `force-app/main/default/objects/Property__c/fields/Size_SqFt__c.field-meta.xml`
  - `force-app/main/default/objects/Open_House__c/Open_House__c.object-meta.xml`
  - `force-app/main/default/objects/Open_House__c/fields/Property__c.field-meta.xml`
  - `force-app/main/default/objects/Open_House__c/fields/Open_House_Date__c.field-meta.xml`
  - `force-app/main/default/objects/Open_House__c/fields/Max_Capacity__c.field-meta.xml`
  - `force-app/main/default/objects/Open_House__c/fields/Registered_Visitors__c.field-meta.xml`
  - `force-app/main/default/permissionsets/dreamhouse.permissionset-meta.xml`
- **Exposed APIs**: `Property__c.Size_SqFt__c`, `Open_House__c.Property__c`, `Open_House__c.Open_House_Date__c`, `Open_House__c.Max_Capacity__c`, `Open_House__c.Registered_Visitors__c`.

---

## Manual Test Scripts
| Step # | Test Action | Expected Output | Status |
| :--- | :--- | :--- | :--- |
| 1 | Navigate to **Setup** > **Object Manager** > **Property** > **Fields & Relationships**. | Custom field `Size_SqFt__c` labeled "Size (Sq Ft)" is visible with data type "Number(6, 0)". | 🟢 Pass |
| 2 | Navigate to **Setup** > **Object Manager** > **Open House** > **Fields & Relationships**. | Custom fields `Property__c` (Lookup), `Open_House_Date__c` (DateTime, Required), `Max_Capacity__c` (Number), and `Registered_Visitors__c` (Number) are all listed. | 🟢 Pass |
| 3 | Navigate to **Setup** > **Permission Sets** > **dreamhouse**. Select **Object Settings** > **Properties** and **Open Houses**. | Both objects have Read/Edit permissions enabled on their new fields. | 🟢 Pass |
