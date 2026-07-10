@isTest
private class OpenHouseControllerTest {

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
        
        String uniqueName = 'ohuser' + DateTime.now().getTime();
        User testUser = new User(
            Alias = 'ohtst',
            Email = 'ohuser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'OHTesting',
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
    static void testGetOpenHousesSuccess() {
        User testUser = createTestUser();
        Property__c prop;
        List<Open_House__c> housesToInsert = new List<Open_House__c>();

        System.runAs(new User(Id = UserInfo.getUserId())) {
            prop = new Property__c(
                Name = 'Open House Property',
                Size_SqFt__c = 1500
            );
            insert prop;

            DateTime baseTime = DateTime.now().addDays(1);
            housesToInsert.add(new Open_House__c(Property__c = prop.Id, Open_House_Date__c = baseTime.addHours(2), Max_Capacity__c = 15));
            housesToInsert.add(new Open_House__c(Property__c = prop.Id, Open_House_Date__c = baseTime, Max_Capacity__c = 15));

            insert housesToInsert;
        }

        System.runAs(testUser) {
            Test.startTest();
            List<Open_House__c> results = OpenHouseController.getOpenHouses(prop.Id);
            Test.stopTest();

            Assert.areEqual(2, results.size(), 'Should return 2 open houses');
            Assert.isTrue(results[0].Open_House_Date__c < results[1].Open_House_Date__c, 'Should be sorted ascending by date');
        }
    }

    @isTest
    static void testScheduleOpenHouseSuccess() {
        User testUser = createTestUser();
        Property__c prop;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            prop = new Property__c(
                Name = 'Schedule Property',
                Size_SqFt__c = 2500
            );
            insert prop;
        }

        System.runAs(testUser) {
            DateTime scheduleTime = DateTime.now().addDays(2);
            Test.startTest();
            Open_House__c result = OpenHouseController.scheduleOpenHouse(prop.Id, scheduleTime);
            Test.stopTest();

            Assert.areNotEqual(null, result.Id, 'Record should be inserted');
            Assert.areEqual(prop.Id, result.Property__c);
            Assert.areEqual(25, result.Max_Capacity__c, 'Capacity should be size / 100');
            Assert.areEqual(0, result.Registered_Visitors__c);
        }
    }

    @isTest
    static void testScheduleOpenHouseDefaultCapacity() {
        User testUser = createTestUser();
        Property__c prop;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            prop = new Property__c(
                Name = 'Null Size Property',
                Size_SqFt__c = null
            );
            insert prop;
        }

        System.runAs(testUser) {
            DateTime scheduleTime = DateTime.now().addDays(2);
            Test.startTest();
            Open_House__c result = OpenHouseController.scheduleOpenHouse(prop.Id, scheduleTime);
            Test.stopTest();

            Assert.areEqual(10, result.Max_Capacity__c, 'Capacity should default to 10 when size is null');
        }
    }

    @isTest
    static void testScheduleOpenHouseValidation() {
        User testUser = createTestUser();
        System.runAs(testUser) {
            Test.startTest();
            try {
                OpenHouseController.scheduleOpenHouse(null, DateTime.now());
                Assert.fail('Should throw exception on null property ID');
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('Property ID cannot be null') || e.getMessage().contains('Script-thrown exception'));
            }

            try {
                // Generate a fake Property ID
                Id fakePropertyId = Id.valueOf(Property__c.sObjectType.getDescribe().getKeyPrefix() + '000000000001AAA');
                OpenHouseController.scheduleOpenHouse(fakePropertyId, null);
                Assert.fail('Should throw exception on null date');
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('Open House Date/Time cannot be null') || e.getMessage().contains('Script-thrown exception'));
            }
            Test.stopTest();
        }
    }

    @isTest
    static void testRegisterVisitorSuccess() {
        User testUser = createTestUser();
        Open_House__c event;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            Property__c prop = new Property__c(Name = 'Reg Property', Size_SqFt__c = 1000);
            insert prop;

            event = new Open_House__c(Property__c = prop.Id, Open_House_Date__c = DateTime.now().addDays(1), Max_Capacity__c = 10, Registered_Visitors__c = 0);
            insert event;
        }

        System.runAs(testUser) {
            Test.startTest();
            OpenHouseController.registerVisitor(event.Id);
            Test.stopTest();

            Open_House__c updatedEvent = [SELECT Registered_Visitors__c FROM Open_House__c WHERE Id = :event.Id LIMIT 1];
            Assert.areEqual(1, updatedEvent.Registered_Visitors__c, 'Registered visitors should increment by 1');
        }
    }

    @isTest
    static void testRegisterVisitorOverCapacity() {
        User testUser = createTestUser();
        Open_House__c event;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            Property__c prop = new Property__c(Name = 'Reg Property', Size_SqFt__c = 200);
            insert prop;

            event = new Open_House__c(Property__c = prop.Id, Open_House_Date__c = DateTime.now().addDays(1), Max_Capacity__c = 2, Registered_Visitors__c = 2);
            insert event;
        }

        System.runAs(testUser) {
            Test.startTest();
            try {
                OpenHouseController.registerVisitor(event.Id);
                Assert.fail('Should throw exception when registering beyond capacity');
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('Maximum capacity reached') || e.getMessage().contains('Script-thrown exception'));
            }
            Test.stopTest();
        }
    }
}
