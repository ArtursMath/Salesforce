import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import POSTER_URL_FIELD from '@salesforce/schema/Movie__c.Poster_URL__c';

export default class MoviePoster extends LightningElement {
    @api recordId;
    posterUrl;

    @wire(getRecord, { recordId: '$recordId', fields: [POSTER_URL_FIELD] })
    loadMovie({ error, data }) {
        if (data) {
            this.posterUrl = data.fields.Poster_URL__c.value;
            console.log('Poster URL:', this.posterUrl); 
        } else if (error) {
            console.error(error);
            this.posterUrl = null;
        }
    }

    get hasPoster() {
        return this.posterUrl;
    }
}