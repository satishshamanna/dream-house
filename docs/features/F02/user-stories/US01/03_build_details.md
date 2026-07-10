# Build Details: US01 - Open House Schema Updates

The following codebase modifications were constructed to implement User Story US01:

## 1. Schema Modifications
* Custom field on `Property__c` object:
  - **`force-app/main/default/objects/Property__c/fields/Size_SqFt__c.field-meta.xml`**: Number(6,0) field labeled "Size (Sq Ft)" to store interior size.
* Custom Object `Open_House__c` metadata:
  - **`force-app/main/default/objects/Open_House__c/Open_House__c.object-meta.xml`**: Defined SObject labeled "Open House" with auto-number Name field `OH-{0000}`.
* Custom fields on `Open_House__c`:
  - **`force-app/main/default/objects/Open_House__c/fields/Property__c.field-meta.xml`**: Lookup field referencing `Property__c`.
  - **`force-app/main/default/objects/Open_House__c/fields/Open_House_Date__c.field-meta.xml`**: DateTime field for open house schedule.
  - **`force-app/main/default/objects/Open_House__c/fields/Max_Capacity__c.field-meta.xml`**: Number field for visitor capacity.
  - **`force-app/main/default/objects/Open_House__c/fields/Registered_Visitors__c.field-meta.xml`**: Number field (default 0) for visitor registration count.

## 2. Permissions & Security
* **`force-app/main/default/permissionsets/dreamhouse.permissionset-meta.xml`**:
  - Granted Read/Edit field permissions for `Property__c.Size_SqFt__c`.
  - Granted Read/Create/Edit/Delete object permissions for `Open_House__c`.
  - Granted Read/Edit field permissions for all new fields of `Open_House__c`.
