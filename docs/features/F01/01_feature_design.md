# Feature Design Specification: F01 - VIP Buyer Matcher

This document details the functional design and technical specifications for the **VIP Buyer Matcher** feature on the Salesforce Platform.

---

## 1. Functional Overview
The **VIP Buyer Matcher** allows real estate brokers to instantly view potential buyers (Contacts) whose budget and bedroom preferences match the price and details of the current `Property__c` record.

### Business Value
Reduces the time brokers spend manually searching contact records by surfacing the top 5 most relevant buyer matches directly on the property detail page sidebar.

---

## 2. Data Model Schema Modifications
We will leverage the standard Salesforce `Contact` object to represent buyers. The following custom fields must be created:

| Object | Field API Name | Field Label | Data Type | Description |
| :--- | :--- | :--- | :--- | :--- |
| `Contact` | `Budget__c` | Budget | Currency(18, 0) | The maximum budget of the VIP buyer. |
| `Contact` | `Beds__c` | Preferred Beds | Number(2, 0) | The minimum bedroom requirements of the buyer. |

---

## 3. Backend Apex Architecture
A new controller class must be created to implement the matching logic.

* **Class Name**: `VIPBuyerController`
* **Method**: `@AuraEnabled(cacheable=true) public static List<Contact> getVipBuyers(Id propertyId)`

### Matching Logic
1. Query the current `Property__c` record's `Price__c` and `Beds__c` values based on `propertyId`.
2. Query `Contact` records where:
   - `Budget__c` is greater than or equal to the property `Price__c`.
   - `Beds__c` is equal to (or greater than) the property `Beds__c`.
3. Order the results by `Budget__c` ascending (to show the closest budget matches first).
4. Limit the query results to the **top 5** contacts.

### Security Constraints
- The query must execute using the `WITH USER_MODE` access modifier to enforce Object-Level Security (OLS), Field-Level Security (FLS), and sharing rules of the running user.
- Handle any exceptions gracefully and throw a `AuraHandledException` with a user-friendly error message.

---

## 4. Frontend LWC Widget
Create a Lightning Web Component (`vipBuyerMatcher`) to display the matched contacts on the UI.

* **LWC Component Name**: `vipBuyerMatcher`
* **Target Files**:
  - `vipBuyerMatcher.html`
  - `vipBuyerMatcher.js`
  - `vipBuyerMatcher.js-meta.xml`

### UI/UX Design
- **Container**: `lightning-card` with title "VIP Buyer Matches" and icon `standard:contact`.
- **Content**: A simple data table or custom list format displaying:
  - **Name** (First Name + Last Name)
  - **Email** (clickable `mailto:` link)
  - **Budget** (formatted currency)
- **State Handling**:
  - Show a spinner (`lightning-spinner`) while loading.
  - Render an illustration or error panel if no matches are found or if an error occurs.

### Integration Properties
- **Wire Adaptor**: Use `@wire(getVipBuyers, { propertyId: '$recordId' })` to bind record data reactively.
- **Flexipage Settings**: Expose the component to `lightning__RecordPage` for the `Property__c` object. Place it in the right-hand sidebar column of the standard Property Record Page.
