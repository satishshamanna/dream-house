# User Story: US03 - VIP Buyer Matcher LWC Component

## Story Description
**As a** Real Estate Broker  
**I want to** see a list of matched VIP buyers directly on the Property detail page sidebar  
**So that** I can instantly view their contact details and reach out to them.

---

## Acceptance Criteria
| Scenario | Given | When | Then | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Display Table** | Matching Contacts exist | Component loads on Property Record Page sidebar | Renders Name, Email, and Budget formatted as USD Currency. | Verified |
| **Contact Email Links** | Email field is populated | Broker clicks on the Email address | Opens default mail client using a clickable `mailto:` link. | Verified |
| **Loading Spinner** | Component is executing wire adapter | Query is in progress | Displays a standard `lightning-spinner` widget. | Verified |
| **Empty Match States** | No contacts match criteria | Query returns 0 records | Displays 'No matching VIP buyers found.' in place of the table. | Verified |
| **Error Handling Display** | Apex controller throws an exception | Apex call fails | Displays the error message to the broker. | Verified |

---

## Technical Notes
- **Metadata Path**: `force-app/main/default/lwc/vipBuyerMatcher/`
- **Method binding**: Wires to Apex controller method `getVipBuyers` dynamically using `propertyId: '$recordId'`.
- **Target Page**: Standard Property record page (`lightning__RecordPage`). Target object constraints set to `Property__c`.

---

## Manual Test Scripts
| Step # | Test Action | Expected Output | Status |
| :--- | :--- | :--- | :--- |
| 1 | Navigate to the **Sales** or **Dreamhouse** app, open a **Property** record page. | Page loads, and the `vipBuyerMatcher` component is visible in the sidebar. | 🟢 Pass |
| 2 | Check the component while data is fetching. | A loading spinner is displayed inside the card body. | 🟢 Pass |
| 3 | View the table after loading is complete (assuming matching contacts exist). | A table listing the matching contacts with Name, Email, and Budget (formatted with `$` currency sign) is displayed. | 🟢 Pass |
| 4 | Click on a contact's email address link. | The system opens the local default mail client with the email address pre-populated in the 'To' field. | 🟢 Pass |
| 5 | Navigate to a Property record that has no matching contacts (e.g. extremely high price or 10 bedrooms). | The table is replaced by the message "No matching VIP buyers found." | 🟢 Pass |

