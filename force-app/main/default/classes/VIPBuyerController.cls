public with sharing class VIPBuyerController {
    /**
     * Finds the top 5 Contacts whose Budget__c and Beds__c match the current Property's details.
     * @param propertyId The Id of the active Property__c record.
     * @return List of Contact records matching the criteria, ordered by budget ascending.
     */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getVipBuyers(Id propertyId) {
        if (propertyId == null) {
            throw new AuraHandledException('Property ID cannot be null.');
        }

        // 1. Query the current property's Price__c and Beds__c
        List<Property__c> properties = [
            SELECT Price__c, Beds__c 
            FROM Property__c 
            WHERE Id = :propertyId 
            WITH USER_MODE 
            LIMIT 1
        ];

        if (properties.isEmpty()) {
            throw new AuraHandledException('Property record not found.');
        }

        Property__c prop = properties[0];
        Decimal price = prop.Price__c != null ? prop.Price__c : 0;
        Decimal beds = prop.Beds__c != null ? prop.Beds__c : 0;

        // 2. Query Contacts matching budget and beds requirements
        return [
            SELECT Id, Name, Email, Budget__c, Beds__c
            FROM Contact
            WHERE Budget__c >= :price AND Beds__c = :beds
            WITH USER_MODE
            ORDER BY Budget__c ASC
            LIMIT 5
        ];
    }
}
