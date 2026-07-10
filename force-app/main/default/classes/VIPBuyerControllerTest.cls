@isTest
private class VIPBuyerControllerTest {

    private static User createTestUser() {
        Profile standardUserProfile = [
            SELECT Name, Id
            FROM Profile
            WHERE UserType = 'Standard'
                AND PermissionsPrivacyDataAccess = FALSE
                AND PermissionsSubmitMacrosAllowed = TRUE
                AND PermissionsMassInlineEdit = TRUE
            LIMIT 1
        ];
        
        String uniqueName = 'vipuser' + DateTime.now().getTime();
        User testUser = new User(
            Alias = 'viptst',
            Email = 'vipuser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'VIPTesting',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = standardUserProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = uniqueName + '@dreamhouse-testorg.com'
        );
        insert testUser;

        PermissionSet ps = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'dreamhouse'
        ];
        insert new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = ps.Id
        );

        return testUser;
    }

    @isTest
    static void testGetVipBuyersSuccess() {
        User testUser = createTestUser();

        Property__c prop;
        List<Contact> contactsToInsert = new List<Contact>();

        System.runAs(new User(Id = UserInfo.getUserId())) {
            prop = new Property__c(
                Name = 'Match Property',
                Price__c = 500000,
                Beds__c = 3,
                Baths__c = 3
            );
            insert prop;

            // 1. Matches (Budget >= 500k, Beds == 3)
            contactsToInsert.add(new Contact(LastName = 'MatchMid', Budget__c = 600000, Beds__c = 3, Email = 'mid@test.com'));
            contactsToInsert.add(new Contact(LastName = 'MatchLow', Budget__c = 500000, Beds__c = 3, Email = 'low@test.com'));
            contactsToInsert.add(new Contact(LastName = 'MatchHigh', Budget__c = 800000, Beds__c = 3, Email = 'high@test.com'));

            // 2. Mismatches
            contactsToInsert.add(new Contact(LastName = 'NoMatchBeds', Budget__c = 700000, Beds__c = 2, Email = 'beds@test.com'));
            contactsToInsert.add(new Contact(LastName = 'NoMatchBudget', Budget__c = 400000, Beds__c = 3, Email = 'budget@test.com'));

            insert contactsToInsert;
        }

        System.runAs(testUser) {
            Test.startTest();
            List<Contact> results = VIPBuyerController.getVipBuyers(prop.Id);
            Test.stopTest();

            Assert.areEqual(3, results.size(), 'Should return exactly 3 matching contacts');
            
            // Check ascending budget sort ordering
            Assert.areEqual(500000, results[0].Budget__c, 'Lowest budget should be first');
            Assert.areEqual(600000, results[1].Budget__c, 'Mid budget should be second');
            Assert.areEqual(800000, results[2].Budget__c, 'Highest budget should be last');
        }
    }

    @isTest
    static void testGetVipBuyersBulkLimit() {
        User testUser = createTestUser();

        Property__c prop;
        List<Contact> contactsToInsert = new List<Contact>();

        System.runAs(new User(Id = UserInfo.getUserId())) {
            prop = new Property__c(
                Name = 'Bulk Property',
                Price__c = 100000,
                Beds__c = 2,
                Baths__c = 1
            );
            insert prop;

            // Insert 7 matching contacts
            for (Integer i = 0; i < 7; i++) {
                contactsToInsert.add(new Contact(
                    LastName = 'Buyer' + i,
                    Budget__c = 150000 + (i * 10000),
                    Beds__c = 2,
                    Email = 'buyer' + i + '@test.com'
                ));
            }
            insert contactsToInsert;
        }

        System.runAs(testUser) {
            Test.startTest();
            List<Contact> results = VIPBuyerController.getVipBuyers(prop.Id);
            Test.stopTest();

            Assert.areEqual(5, results.size(), 'Should limit the results to top 5 matches');
        }
    }

    @isTest
    static void testGetVipBuyersNullException() {
        User testUser = createTestUser();

        System.runAs(testUser) {
            Test.startTest();
            try {
                VIPBuyerController.getVipBuyers(null);
                Assert.fail('Should have thrown an exception for null Property ID');
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('Property ID cannot be null') || e.getMessage().contains('Script-thrown exception'), 'Expected message: ' + e.getMessage());
            }
            Test.stopTest();
        }
    }

    @isTest
    static void testGetVipBuyersNotFoundException() {
        User testUser = createTestUser();
        // Generate a fake Property ID
        Id fakePropertyId = Id.valueOf(Property__c.sObjectType.getDescribe().getKeyPrefix() + '000000000001AAA');

        System.runAs(testUser) {
            Test.startTest();
            try {
                VIPBuyerController.getVipBuyers(fakePropertyId);
                Assert.fail('Should have thrown an exception for non-existent Property record');
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('Property record not found') || e.getMessage().contains('Script-thrown exception'), 'Expected message: ' + e.getMessage());
            }
            Test.stopTest();
        }
    }
}
