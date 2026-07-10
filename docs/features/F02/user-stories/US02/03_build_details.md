# Build Details: US02 - Open House Apex Controller

The following codebase modifications were constructed to implement User Story US02:

## 1. Backend Controller Logic
* **`force-app/main/default/classes/OpenHouseController.cls`**:
  - Apex controller with class signature `public with sharing class OpenHouseController`.
  - Method `getOpenHouses(Id propertyId)`: Queries open house records `WITH USER_MODE` sorted by date-time.
  - Method `scheduleOpenHouse(Id propertyId, DateTime openHouseDateTime)`: Queries associated property size, calculates max capacity (`size / 100`, defaults to 10), and inserts the record `WITH USER_MODE`.
  - Method `registerVisitor(Id openHouseId)`: Queries registration count, increments if below capacity, and updates the record `WITH USER_MODE`. Throws exception if capacity is exceeded.
* **`force-app/main/default/classes/OpenHouseController.cls-meta.xml`**:
  - Enabled active class metadata.

## 2. Permissions & Security
* **`force-app/main/default/permissionsets/dreamhouse.permissionset-meta.xml`**:
  - Added enabled Apex Class access for `OpenHouseController`.
