import { LightningElement, api, wire } from 'lwc';
import getVipBuyers from '@salesforce/apex/VIPBuyerController.getVipBuyers';

export default class VipBuyerMatcher extends LightningElement {
    @api recordId;

    buyers = [];
    error;
    loading = true;

    @wire(getVipBuyers, { propertyId: '$recordId' })
    wiredBuyers({ error, data }) {
        this.loading = false;
        if (data) {
            this.buyers = data.map(buyer => ({
                ...buyer,
                MailtoHref: buyer.Email ? `mailto:${buyer.Email}` : ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.buyers = [];
        }
    }

    get hasRecords() {
        return !this.loading && !this.error && this.buyers.length > 0;
    }

    get noRecordsFound() {
        return !this.loading && !this.error && this.buyers.length === 0;
    }

    get errorMessage() {
        if (this.error) {
            return this.error.body ? this.error.body.message : 'Unknown error loading matches.';
        }
        return '';
    }
}
