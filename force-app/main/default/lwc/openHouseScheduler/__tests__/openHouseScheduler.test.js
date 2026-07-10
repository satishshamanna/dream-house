import { createElement } from '@lwc/engine-dom';
import OpenHouseScheduler from 'c/openHouseScheduler';
import { refreshApex } from '@salesforce/apex';
import getOpenHouses from '@salesforce/apex/OpenHouseController.getOpenHouses';
import scheduleOpenHouse from '@salesforce/apex/OpenHouseController.scheduleOpenHouse';
import registerVisitor from '@salesforce/apex/OpenHouseController.registerVisitor';

// Mock Apex wire adapter and imperative methods
jest.mock(
    '@salesforce/apex/OpenHouseController.getOpenHouses',
    () => {
        const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
        return {
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apex/OpenHouseController.scheduleOpenHouse',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apex/OpenHouseController.registerVisitor',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-open-house-scheduler', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    async function flushPromises() {
        return Promise.resolve();
    }

    it('renders scheduled open houses from wired data', async () => {
        const mockOpenHouses = [
            {
                Id: 'oh1',
                Open_House_Date__c: '2026-07-11T14:00:00.000Z',
                Max_Capacity__c: 15,
                Registered_Visitors__c: 5
            },
            {
                Id: 'oh2',
                Open_House_Date__c: '2026-07-12T16:00:00.000Z',
                Max_Capacity__c: 10,
                Registered_Visitors__c: 10
            }
        ];

        const element = createElement('c-open-house-scheduler', {
            is: OpenHouseScheduler
        });
        element.recordId = 'prop1';
        document.body.appendChild(element);

        // Emit wired data
        getOpenHouses.emit(mockOpenHouses);
        await flushPromises();

        // Check scheduled list count
        const items = element.shadowRoot.querySelectorAll('li.slds-item');
        expect(items.length).toBe(2);

        // Check badges
        const badges = element.shadowRoot.querySelectorAll('.slds-badge');
        expect(badges[0].textContent).toBe('5 / 15 Spots');
        expect(badges[0].className).toContain('slds-theme_success');

        expect(badges[1].textContent).toBe('Full');
        expect(badges[1].className).toContain('slds-theme_error');

        // Check register buttons disabled states
        const regButtons = element.shadowRoot.querySelectorAll('lightning-button[label="Register Visitor"]');
        expect(regButtons[0].disabled).toBe(false);
        expect(regButtons[1].disabled).toBe(true);
    });

    it('renders empty state when no open houses are returned', async () => {
        const element = createElement('c-open-house-scheduler', {
            is: OpenHouseScheduler
        });
        element.recordId = 'prop1';
        document.body.appendChild(element);

        // Emit empty list
        getOpenHouses.emit([]);
        await flushPromises();

        const emptyMessage = element.shadowRoot.querySelector('p.slds-text-align_center');
        expect(emptyMessage).not.toBeNull();
        expect(emptyMessage.textContent).toContain('No open houses scheduled');
    });

    it('schedules an open house successfully', async () => {
        scheduleOpenHouse.mockResolvedValue({ Id: 'new_oh' });

        const element = createElement('c-open-house-scheduler', {
            is: OpenHouseScheduler
        });
        element.recordId = 'prop1';
        document.body.appendChild(element);

        getOpenHouses.emit([]);
        await flushPromises();

        // Set date input value
        const inputEl = element.shadowRoot.querySelector('lightning-input');
        inputEl.value = '2026-07-15T10:00:00.000Z';
        inputEl.dispatchEvent(new CustomEvent('change', { target: { value: '2026-07-15T10:00:00.000Z' } }));

        // Click schedule button
        const scheduleBtn = element.shadowRoot.querySelector('lightning-button[label="Schedule Open House"]');
        scheduleBtn.click();
        await flushPromises();

        expect(scheduleOpenHouse).toHaveBeenCalledWith({
            propertyId: 'prop1',
            openHouseDateTime: '2026-07-15T10:00:00.000Z'
        });
    });

    it('registers a visitor successfully', async () => {
        registerVisitor.mockResolvedValue({});
        const mockOpenHouses = [
            {
                Id: 'oh1',
                Open_House_Date__c: '2026-07-11T14:00:00.000Z',
                Max_Capacity__c: 15,
                Registered_Visitors__c: 5
            }
        ];

        const element = createElement('c-open-house-scheduler', {
            is: OpenHouseScheduler
        });
        element.recordId = 'prop1';
        document.body.appendChild(element);

        getOpenHouses.emit(mockOpenHouses);
        await flushPromises();

        // Click register button
        const regButton = element.shadowRoot.querySelector('lightning-button[label="Register Visitor"]');
        regButton.click();
        await flushPromises();

        expect(registerVisitor).toHaveBeenCalledWith({ openHouseId: 'oh1' });
    });
});
