import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import searchMovies from '@salesforce/apex/movieSearchComponentController.searchMovies';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import MOVIE_TITLE_FIELD from '@salesforce/schema/Movie__c.Title__c';
import TMDB_MOVIE_ID_FIELD from '@salesforce/schema/Movie__c.TMDB_movie_Id__c';

export default class MovieSearchComponent extends LightningElement {
    @api recordId;
    @track movieTitle = '';
    @track movies = [];
    @track showAlreadySynced = false;
    @track movieData;

    @wire(getRecord, { recordId: '$recordId', fields: [MOVIE_TITLE_FIELD, TMDB_MOVIE_ID_FIELD] })
    wiredMovie({ error, data }) {
        if (data) {
            this.movieData = data;
            this.checkIfAlreadySynced();
        } else if (error) {
            console.error('Error retrieving movie data:', error); // Debug log
        }
    }

    checkIfAlreadySynced() {
        console.log('Checking if already synced');
        if (this.movieData) {
            const tmdbMovieId = this.movieData.fields.TMDB_movie_Id__c.value;
            if (tmdbMovieId) {
                this.showAlreadySynced = true;
                this.showToast('Info', 'Data already synced from TheMovieDB', 'info');
            } else {
                this.movieTitle = this.movieData.fields.Title__c.value;
                console.log(`Retrieved Movie Title: ${this.movieTitle}`); 

                if (this.movieTitle) {
                    this.searchMovie();
                } else {
                    this.showToast('Error', 'Movie title is empty', 'error');
                }
            }
        }
    }

    searchMovie() {
        if (this.movieTitle) {
            searchMovies({ movieTitle: this.movieTitle })
                .then((result) => {
                    console.log('Search Result:', result); 
                    
                    if (result && result.length > 0) {
                        this.movies = result;
                    } else {
                        this.movies = [];
                        this.showToast('No Results', `No movies found for the title "${this.movieTitle}"`, 'warning');
                    }
                })
                .catch((error) => {
                    this.showToast('Error', 'Error searching movies', 'error');
                    console.error('Search Error:', error); // Debug log
                });
        } else {
            this.showToast('Error', 'Movie title is empty', 'error');
        }
    }

    selectMovie(event) {
        const movieId = event.target.dataset.id;
        const selectedMovie = this.movies.find(movie => movie.tmdb_id === movieId);

        if (selectedMovie) {
            const fields = {
                Id: this.recordId,
                TMDB_movie_Id__c: selectedMovie.tmdb_id,
                Title__c: selectedMovie.title,
                Description__c: selectedMovie.overview,
                Poster_URL__c: selectedMovie.poster_url,
                TMDBSyncDate__c: new Date().toISOString().split('T')[0]
            };

            updateRecord({ fields })
                .then(() => {
                    this.showToast('Success', 'Movie data copied successfully', 'success');
                    this.showAlreadySynced = true;
                })
                .catch(error => {
                    this.showToast('Error', 'Error updating record', 'error');
                    console.error('Update Error:', error); // Debug log
                });
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}