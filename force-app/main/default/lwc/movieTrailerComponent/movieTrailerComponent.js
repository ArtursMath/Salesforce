import { LightningElement, api, wire } from 'lwc';
import getVideoKey from '@salesforce/apex/movieTrailerComponentController.getVideoKey';

export default class MovieTrailerCard extends LightningElement {
    @api recordId; // The current record ID
    @api videoTitle;
    @api videoWidth;
    @api videoHeight;

    videoKey; // State variable to hold the video key
    error;   // State variable to hold any errors

    @wire(getVideoKey, { movieId: '$recordId' }) // Pass the recordId as movieId to the Apex method
    wiredVideoKey({ error, data }) {
        if (data) {
            this.videoKey = data; // Assign the video key returned from Apex
            this.error = undefined;
        } else if (error) {
            this.error = error; // Handle the error appropriately
            this.videoKey = undefined;
        }
    }

    get videoUrl() {
        return `https://www.youtube.com/embed/${this.videoKey}`;
    }

    get isVideoReady() {
        return this.videoKey !== undefined;
    }
}
