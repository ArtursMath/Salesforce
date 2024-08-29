import { LightningElement, track, wire } from 'lwc';
import getGenrePicklistValues from '@salesforce/apex/MovieController.getGenrePicklistValues';

export default class GenreList extends LightningElement {
    @track genreOptions = [];
    @track selectedGenre = '';

    @wire(getGenrePicklistValues)
    wiredGenrePicklist({ error, data }) {
        if (data) {
            this.genreOptions = [{ label: 'All Genres', value: '' }, ...data.map(genre => ({ label: genre, value: genre }))];
        } else if (error) {
            console.error('Error fetching genres:', error);
        }
    }

    handleGenreChange(event) {
        this.selectedGenre = event.detail.value;
        const genreChangeEvent = new CustomEvent('genrechange', {
            detail: { value: this.selectedGenre }
        });
        this.dispatchEvent(genreChangeEvent);
    }
}
