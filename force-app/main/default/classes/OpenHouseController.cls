public with sharing class OpenHouseController {

    /**
     * Retrieves the list of scheduled open houses for a property, sorted by date-time.
     * @param propertyId The Id of the active Property__c record.
     * @return List of Open_House__c records.
     */
    @AuraEnabled(cacheable=true)
    public static List<Open_House__c> getOpenHouses(Id propertyId) {
        if (propertyId == null) {
            throw new AuraHandledException('Property ID cannot be null.');
        }
        return [
            SELECT Id, Name, Open_House_Date__c, Max_Capacity__c, Registered_Visitors__c
            FROM Open_House__c
            WHERE Property__c = :propertyId
            WITH USER_MODE
            ORDER BY Open_House_Date__c ASC
        ];
    }

    /**
     * Schedules a new open house and calculates its maximum capacity.
     * @param propertyId The Id of the active Property__c record.
     * @param openHouseDateTime The scheduled date and time of the open house.
     * @return The newly created Open_House__c record.
     */
    @AuraEnabled
    public static Open_House__c scheduleOpenHouse(Id propertyId, DateTime openHouseDateTime) {
        if (propertyId == null) {
            throw new AuraHandledException('Property ID cannot be null.');
        }
        if (openHouseDateTime == null) {
            throw new AuraHandledException('Open House Date/Time cannot be null.');
        }
        
        List<Property__c> props = [
            SELECT Size_SqFt__c
            FROM Property__c
            WHERE Id = :propertyId
            WITH USER_MODE
            LIMIT 1
        ];
        
        if (props.isEmpty()) {
            throw new AuraHandledException('Property record not found.');
        }
        
        Decimal size = props[0].Size_SqFt__c;
        Integer maxCapacity = 10; // Default capacity if size is null or 0
        if (size != null && size > 0) {
            maxCapacity = Integer.valueOf(size / 100);
        }
        
        Open_House__c oh = new Open_House__c();
        oh.Property__c = propertyId;
        oh.Open_House_Date__c = openHouseDateTime;
        oh.Max_Capacity__c = maxCapacity;
        oh.Registered_Visitors__c = 0;
        
        try {
            insert as user oh;
            return oh;
        } catch (Exception e) {
            throw new AuraHandledException('Error scheduling open house: ' + e.getMessage());
        }
    }

    /**
     * Registers a visitor for an open house, throwing an exception if capacity is exceeded.
     * @param openHouseId The Id of the Open_House__c record.
     */
    @AuraEnabled
    public static void registerVisitor(Id openHouseId) {
        if (openHouseId == null) {
            throw new AuraHandledException('Open House ID cannot be null.');
        }
        
        List<Open_House__c> events = [
            SELECT Max_Capacity__c, Registered_Visitors__c
            FROM Open_House__c
            WHERE Id = :openHouseId
            WITH USER_MODE
            LIMIT 1
        ];
        
        if (events.isEmpty()) {
            throw new AuraHandledException('Open House record not found.');
        }
        
        Open_House__c event = events[0];
        Decimal registered = event.Registered_Visitors__c != null ? event.Registered_Visitors__c : 0;
        Decimal capacity = event.Max_Capacity__c != null ? event.Max_Capacity__c : 10;
        
        if (registered >= capacity) {
            throw new AuraHandledException('Maximum capacity reached for this open house.');
        }
        
        event.Registered_Visitors__c = registered + 1;
        
        try {
            update as user event;
        } catch (Exception e) {
            throw new AuraHandledException('Error registering visitor: ' + e.getMessage());
        }
    }
}
