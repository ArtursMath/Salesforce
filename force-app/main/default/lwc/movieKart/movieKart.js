import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getMovies from '@salesforce/apex/MovieController.getMovies';
import getTotalMoviesCount from '@salesforce/apex/MovieController.getTotalMoviesCount';

export default class MovieList extends NavigationMixin(LightningElement) {
    @track movies = [];
    @track selectedGenre = ''; // Empty string represents "All Genres"
    @track userSetLimit = 10;
    @track currentPage = 1;
    @track moviesPerPage = 10;
    @track totalMovies = 0;
    @track totalPages = 1;
    defaultImage = 'https://via.placeholder.com/300x420?text=No+Image+Available'; 

    @wire(getMovies, { userSetLimit: '$userSetLimit', selectedGenre: '$selectedGenre', pageNumber: '$currentPage' })
    wiredMovies(result) {
        if (result.data) {
            this.movies = result.data.map(movie => ({
                id: movie.Id,
                posterUrl: movie.Poster_URL__c === 'https://image.tmdb.org/t/p/originalnull' ? this.defaultImage : movie.Poster_URL__c,
                title: movie.Title__c,
                rating: movie.Rating_Calculated__c,
                genre: movie.Genre__c.trim(),
                isHorror: movie.Genre__c.includes('Horror')
            }));
        } else if (result.error) {
            console.error('Error fetching movies:', result.error);
            this.movies = [];
        }
    }

    @wire(getTotalMoviesCount, { selectedGenre: '$selectedGenre' })
    wiredTotalMoviesCount(result) {
        if (result.data) {
            this.totalMovies = result.data;
            this.calculatePagination();
        } else if (result.error) {
            console.error('Error fetching total movies count:', result.error);
            this.totalMovies = 0;
        }
    }

    handleLimitChange(event) {
        this.userSetLimit = parseInt(event.target.value, 10);
        this.moviesPerPage = this.userSetLimit === 0 ? this.totalMovies : this.userSetLimit;
        this.currentPage = 1;
        this.refreshMovieData(); // Re-fetch data after limit change
    }

    handleGenreChange(event) {
        this.selectedGenre = event.detail.value; // Capture the selected genre from GenreList
        this.currentPage = 1;
        this.refreshMovieData(); // Re-fetch data after genre change
    }

    refreshMovieData() {
        getMovies({
            userSetLimit: this.userSetLimit,
            selectedGenre: this.selectedGenre, // Pass the selected genre
            pageNumber: this.currentPage
        })
        .then((data) => {
            this.movies = data.map(movie => ({
                id: movie.Id,
                posterUrl: movie.Poster_URL__c === 'https://image.tmdb.org/t/p/originalnull' ? this.defaultImage : movie.Poster_URL__c,
                title: movie.Title__c,
                rating: movie.Rating_Calculated__c,
                genre: movie.Genre__c.trim(),
                isHorror: movie.Genre__c.includes('Horror')
            }));
            return getTotalMoviesCount({ selectedGenre: this.selectedGenre });
        })
        .then((count) => {
            this.totalMovies = count;
            this.calculatePagination();
        })
        .catch((error) => {
            console.error('Error fetching movies or total count:', error);
            this.movies = [];
            this.totalMovies = 0;
        });
    }

    calculatePagination() {
        if (this.moviesPerPage > 0) {
            this.totalPages = Math.ceil(this.totalMovies / this.moviesPerPage);
        } else {
            this.totalPages = 1;
        }
    }

    get currentMovies() {
        return this.movies;
    }

    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.refreshMovieData(); // Re-fetch data when navigating pages
        }
    }

    prevPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.refreshMovieData(); // Re-fetch data when navigating pages
        }
    }

    get isPrevDisabled() {
        return this.currentPage <= 1;
    }

    get isNextDisabled() {
        return this.currentPage >= this.totalPages;
    }

    get hasMovies() {
        return this.movies.length > 0;
    }

    get options() {
        return [
            { label: '10', value: '10' },
            { label: '20', value: '20' },
            { label: '50', value: '50' },
            { label: '100', value: '100' },
            { label: 'All', value: '0'}
        ];
    }

    handleDetailsClick(event) {
        const movieId = event.currentTarget.dataset.movieId;
        if (movieId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: movieId,
                    objectApiName: 'Movie__c',
                    actionName: 'view',
                },
            });
        } else {
            console.error('Movie ID is undefined.');
        }
    }
}
