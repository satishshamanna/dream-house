import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getOpenHouses from '@salesforce/apex/OpenHouseController.getOpenHouses';
import scheduleOpenHouse from '@salesforce/apex/OpenHouseController.scheduleOpenHouse';
import registerVisitor from '@salesforce/apex/OpenHouseController.registerVisitor';

export default class OpenHouseScheduler extends LightningElement {
    @api recordId;
    @track selectedDateTime = '';
    @track isLoading = false;
    wiredOpenHousesResult;
    openHousesList = [];

    @wire(getOpenHouses, { propertyId: '$recordId' })
    wiredOpenHouses(result) {
        this.wiredOpenHousesResult = result;
        if (result.data) {
            this.openHousesList = result.data.map(event => {
                const isFull = event.Registered_Visitors__c >= event.Max_Capacity__c;
                return {
                    ...event,
                    isFull: isFull,
                    badgeClass: isFull ? 'slds-badge slds-theme_error' : 'slds-badge slds-theme_success',
                    badgeLabel: isFull ? 'Full' : `${event.Registered_Visitors__c} / ${event.Max_Capacity__c} Spots`
                };
            });
        } else if (result.error) {
            this.showToast('Error', 'Failed to retrieve open houses: ' + result.error.body.message, 'error');
        }
    }

    handleDateTimeChange(event) {
        this.selectedDateTime = event.target.value;
    }

    async handleScheduleOpenHouse() {
        if (!this.selectedDateTime) {
            this.showToast('Validation Error', 'Please select a date and time.', 'error');
            return;
        }

        this.isLoading = true;
        try {
            await scheduleOpenHouse({
                propertyId: this.recordId,
                openHouseDateTime: this.selectedDateTime
            });
            this.showToast('Success', 'Open house scheduled successfully.', 'success');
            this.selectedDateTime = '';
            // Clear input field manually by querying the DOM
            const dateInput = this.template.querySelector('lightning-input');
            if (dateInput) {
                dateInput.value = '';
            }
            await refreshApex(this.wiredOpenHousesResult);
        } catch (error) {
            this.showToast('Error', error.body.message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    async handleRegisterVisitor(event) {
        const openHouseId = event.target.dataset.id;
        this.isLoading = true;
        try {
            await registerVisitor({ openHouseId: openHouseId });
            this.showToast('Success', 'Visitor registered successfully.', 'success');
            await refreshApex(this.wiredOpenHousesResult);
        } catch (error) {
            this.showToast('Error', error.body.message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}
