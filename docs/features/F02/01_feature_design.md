# Feature Design Specification: F02 - Smart Property Open House Scheduler

This document details the functional design and technical specifications for the **Smart Property Open House Scheduler** feature on the Salesforce Platform.

---

## 1. Functional Overview
The **Smart Property Open House Scheduler** allows real estate brokers to schedule open houses for a specific property. The system dynamically calculates the maximum visitor capacity based on the property size. It also displays a schedule of active events, tracks the number of registered visitors, and blocks registrations once capacity is reached.

### Business Value
Prevents overcrowding during property viewings and gives brokers real-time attendance details. By automating capacity calculations and visitor registration directly on the property record page, it streamlines viewing management and complies with building capacity safety guidelines.

---

## 2. Data Model Schema Modifications

### Property Custom Fields
We will add a custom field to store the interior size of the property.

| Object | Field API Name | Field Label | Data Type | Description |
| :--- | :--- | :--- | :--- | :--- |
| `Property__c` | `Size_SqFt__c` | Size (Sq Ft) | Number(6, 0) | The total interior size of the property in square feet. |

### Open House Custom Object
A new custom object `Open_House__c` will represent scheduled open house events.

- **Object API Name**: `Open_House__c`
- **Plural Label**: Open Houses
- **Name Field**: `Name` (AutoNumber: `OH-{0000}`)
- **Sharing Model**: ReadWrite (Public Read/Write)

Custom fields on `Open_House__c`:

| Field API Name | Field Label | Data Type | Description |
| :--- | :--- | :--- | :--- |
| `Property__c` | Property | Lookup(Property__c) | The associated property for the open house. |
| `Open_House_Date__c` | Open House Date | DateTime | The scheduled date and time of the open house. (Required) |
| `Max_Capacity__c` | Max Capacity | Number(6, 0) | The calculated maximum visitor capacity for the event. |
| `Registered_Visitors__c` | Registered Visitors | Number(6, 0) | The number of registered visitors. Defaults to 0. |

---

## 3. Backend Apex Architecture
A new controller class `OpenHouseController` will manage the business logic and database queries for the open houses.

* **Class Name**: `OpenHouseController`

### Controller Methods

#### 1. `getOpenHouses`
- **Signature**: `@AuraEnabled(cacheable=true) public static List<Open_House__c> getOpenHouses(Id propertyId)`
- **Logic**: Queries all `Open_House__c` records related to the `propertyId`, ordered by `Open_House_Date__c` ascending.
- **Security**: Must execute using `WITH USER_MODE` to validate object and field accessibility.

#### 2. `scheduleOpenHouse`
- **Signature**: `@AuraEnabled public static Open_House__c scheduleOpenHouse(Id propertyId, DateTime openHouseDateTime)`
- **Logic**:
  1. Validates inputs: checks if `propertyId` is null (throws `AuraHandledException`).
  2. Queries the associated `Property__c` record's `Size_SqFt__c`.
  3. Calculates capacity: `Max Capacity = Size_SqFt__c / 100` (rounded down). If `Size_SqFt__c` is null, 0, or less, defaults capacity to **10**.
  4. Inserts a new `Open_House__c` record with the calculated capacity and `Registered_Visitors__c = 0`.
- **Security**: Must execute using `WITH USER_MODE` to validate security permissions. Returns the created record.

#### 3. `registerVisitor`
- **Signature**: `@AuraEnabled public static void registerVisitor(Id openHouseId)`
- **Logic**:
  1. Queries the `Open_House__c` record's `Max_Capacity__c` and `Registered_Visitors__c` fields using the `openHouseId`.
  2. Compares registered visitors to maximum capacity. If `Registered_Visitors__c >= Max_Capacity__c`, throws an `AuraHandledException` stating "Maximum capacity reached for this open house."
  3. Otherwise, increments `Registered_Visitors__c` by 1 and updates the record.
- **Security**: Must execute using `WITH USER_MODE` to enforce FLS and CRUD.

---

## 4. Frontend LWC Widget
Create a Lightning Web Component (`openHouseScheduler`) to display the schedule and handle registration/booking.

* **LWC Component Name**: `openHouseScheduler`
* **Target Files**:
  - `openHouseScheduler.html`
  - `openHouseScheduler.js`
  - `openHouseScheduler.js-meta.xml`
  - `openHouseScheduler.css`

### UI/UX Design
- **Container**: `lightning-card` with title "Open House Scheduler" and icon `custom:custom14` or `utility:event`.
- **Event Schedule List**: Displays scheduled events with Date, Time, Registered count, and Max capacity.
  - If capacity is full, display a red SLDS badge "Full".
  - If spots are available, display a green or neutral badge "X / Y Spots".
- **Visitor Registration Action**: A button next to each event labeled "Register Visitor".
  - Disabled and styled differently if the event capacity is full.
- **Scheduling Form**: A section at the bottom of the card with a `lightning-input` of type `datetime` and a button "Schedule Open House".
- **Feedback & States**:
  - Displays `lightning-spinner` while loading or processing.
  - Fires success and error Toast messages using `ShowToastEvent`.

### Integration Properties
- **Wire Adaptor**: Uses `@wire(getOpenHouses, { propertyId: '$recordId' })` to reactively fetch the schedule.
- **Flexipage Settings**: Configured to be placed in the standard main tab layout of the `Property_Record_Page` flexipage as a tab named "Open House".
