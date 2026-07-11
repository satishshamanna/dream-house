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

## BDD Scripts (Gherkin Scenarios)
```gherkin
Feature: Contact Schema Updates for VIP Buyer Matcher
  As a Salesforce Administrator
  I want to add Budget and Preferred Beds fields to the standard Contact object
  So that I can store preferences for VIP buyers in the system.

  Scenario: Verify creation of custom Currency field Budget__c on Contact
    Given the Contact object metadata is loaded
    When checking custom fields on Contact
    Then a custom field named "Budget__c" of type Currency exists
    And the label is "Budget"
    And length is 18 with 0 decimal places

  Scenario: Verify creation of custom Number field Beds__c on Contact
    Given the Contact object metadata is loaded
    When checking custom fields on Contact
    Then a custom field named "Beds__c" of type Number exists
    And the label is "Preferred Beds"
    And precision is 2 with 0 decimal places

  Scenario: Verify Broker Field Access Permissions for VIP Buyer fields
    Given the Contact custom fields "Budget__c" and "Beds__c" are deployed
    When a Broker user accesses Contact records
    Then the user should have both Read and Edit access to "Budget__c"
    And the user should have both Read and Edit access to "Beds__c"
```

## TDD Scripts (Apex/LWC Test Outline & Skeletons)
```apex
@isTest
private class ContactSchemaTest {
    @isTest
    static void testContactFieldsAccessibleByBroker() {
        // Retrieve standard Broker profile / user
        User brokerUser = [SELECT Id FROM User WHERE Profile.Name = 'Broker' LIMIT 1];
        
        System.runAs(brokerUser) {
            // TDD Check: Describe SObject fields
            Schema.DescribeSObjectResult contactDescribe = Contact.SObjectType.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = contactDescribe.fields.getMap();
            
            // Assert Budget__c field exists and is accessible
            Assert.isTrue(fieldsMap.containsKey('Budget__c'), 'Budget__c field should exist on Contact');
            Schema.DescribeFieldResult budgetField = fieldsMap.get('Budget__c').getDescribe();
            Assert.isTrue(budgetField.isAccessible(), 'Budget__c should be readable by Broker');
            Assert.isTrue(budgetField.isUpdateable(), 'Budget__c should be updateable by Broker');

            // Assert Beds__c field exists and is accessible
            Assert.isTrue(fieldsMap.containsKey('Beds__c'), 'Beds__c field should exist on Contact');
            Schema.DescribeFieldResult bedsField = fieldsMap.get('Beds__c').getDescribe();
            Assert.isTrue(bedsField.isAccessible(), 'Beds__c should be readable by Broker');
            Assert.isTrue(bedsField.isUpdateable(), 'Beds__c should be updateable by Broker');
        }
    }
}
```

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

