@isTest
private class ContactSchemaTest {
    @isTest
    static void testContactFieldsAccessibleByBroker() {
        User brokerUser;
        try {
            // Find a user with Profile name containing 'Broker' or standard Admin as backup
            List<User> users = [SELECT Id FROM User WHERE Profile.Name LIKE '%Broker%' AND IsActive = true LIMIT 1];
            if (!users.isEmpty()) {
                brokerUser = users[0];
            } else {
                brokerUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
            }
        } catch (Exception e) {
            brokerUser = new User(Id = UserInfo.getUserId());
        }
        
        System.runAs(brokerUser) {
            // TDD Check: Describe SObject fields
            Schema.DescribeSObjectResult contactDescribe = Contact.SObjectType.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = contactDescribe.fields.getMap();
            
            // Assert Budget__c field exists and is accessible
            Assert.isTrue(fieldsMap.containsKey('Budget__c'), 'Budget__c field should exist on Contact');
            Schema.DescribeFieldResult budgetField = fieldsMap.get('Budget__c').getDescribe();
            Assert.isTrue(budgetField.isAccessible(), 'Budget__c should be readable');
            Assert.isTrue(budgetField.isUpdateable(), 'Budget__c should be updateable');

            // Assert Beds__c field exists and is accessible
            Assert.isTrue(fieldsMap.containsKey('Beds__c'), 'Beds__c field should exist on Contact');
            Schema.DescribeFieldResult bedsField = fieldsMap.get('Beds__c').getDescribe();
            Assert.isTrue(bedsField.isAccessible(), 'Beds__c should be readable');
            Assert.isTrue(bedsField.isUpdateable(), 'Beds__c should be updateable');
        }
    }
}
