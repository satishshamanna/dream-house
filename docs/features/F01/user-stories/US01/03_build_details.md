# Build Details: US01 - Contact Schema Updates

The following codebase modifications were constructed to implement User Story US01:

## 1. Schema Modifications
The standard `Contact` object is extended with custom fields to support preferences:
- **`force-app/main/default/objects/Contact/fields/Budget__c.field-meta.xml`**: Budget field (Currency(18,0)).
- **`force-app/main/default/objects/Contact/fields/Beds__c.field-meta.xml`**: Preferred Beds field (Number(2,0)).

## 2. Permissions & Security
- **`force-app/main/default/permissionsets/dreamhouse.permissionset-meta.xml`**:
  - Added field-level security permissions (editable and readable) for `Contact.Beds__c` and `Contact.Budget__c` custom fields.
