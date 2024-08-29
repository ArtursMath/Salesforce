import { LightningElement } from 'lwc';
import uploadFile from '@salesforce/apex/MovieDataUploaderController.uploadFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MovieDataUploader extends LightningElement {
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        if (uploadedFiles.length > 0) {
            this.processFile(uploadedFiles[0].documentId);
        }
    }

    processFile(documentId) {
        uploadFile({ documentId: documentId })
            .then((result) => {
                // Extract result properties
                const variant = result.success ? 'success' : 'error';
                const title = result.success ? 'Success' : 'Error';
                const message = result.message;

                // Display the toast message
                this.showToast(title, message, variant);
            })
            .catch((error) => {
                // Handle unexpected errors
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,  // Determines the color of the toast
        });
        this.dispatchEvent(event);
    }
}