public with sharing class movieSearchComponentController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> searchMovies(String movieTitle) {
        tmdbSearchMovieResponse searchResults = tmdb.searchMovie(movieTitle);

        List<Map<String, Object>> results = new List<Map<String, Object>>();

        for (tmdbSearchMovieResult searchResult : searchResults.results) {
            Map<String, Object> movieDetails = new Map<String, Object>();
            movieDetails.put('tmdb_id', String.valueOf(searchResult.id));
            movieDetails.put('title', searchResult.original_title);
            movieDetails.put('release_date', searchResult.release_date);
            movieDetails.put('overview', searchResult.overview);
            if (searchResult.poster_path != null && String.isNotBlank(searchResult.poster_path)) {
                movieDetails.put('poster_url', 'https://image.tmdb.org/t/p/original' + searchResult.poster_path);
            }

            results.add(movieDetails);
        }

        System.debug(results);

        return results;
    }

    @AuraEnabled
    public static OperationStatus copyMovie(String movieId, String tmdbId) {
     
        List<Movie__c> movies = new List<Movie__c>();

        try {  
            Integer existingMovieCount = [ 
                SELECT COUNT() 
                FROM Movie__c 
                WHERE TMDB_movie_Id__c = :tmdbId 
                AND Id != :movieId
                AND TMDB_movie_Id__c != '0'
            ];

            if (existingMovieCount > 0) {
                return new OperationStatus(false, 'tmdbId ' + tmdbId + ' already exists');
            }

            Movie__c movie = [
                SELECT Id, TMDB_movie_Id__c
                FROM Movie__c
                WHERE Id = :movieId
                LIMIT 1
            ];

            if (movie.TMDB_movie_Id__c != null && movie.TMDB_movie_Id__c != '' && movie.TMDB_movie_Id__c != '0') {
                return new OperationStatus(false, 'Tmdb_id is already populated. No update needed.');
            }

            movie.TMDB_movie_Id__c = tmdbId;

            update movie;

            movies.add(movie);

            List<String> movieIdList = new List<String>{ movieId };

            MovieActions.updateMovieData(movieIdList);

            return new OperationStatus(true, null);

        } catch (Exception e) {
            return new OperationStatus(false, 'Error updating movie: ' + e.getMessage());
        }
    }

    public class OperationStatus {
        @AuraEnabled
        public Boolean success { get; set; }
        @AuraEnabled
        public String errorMessage { get; set; }
    
        public OperationStatus(Boolean success, String errorMessage) {
            this.success = success;
            this.errorMessage = errorMessage;
        }
    }
}