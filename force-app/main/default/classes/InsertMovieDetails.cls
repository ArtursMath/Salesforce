public with sharing class InsertMovieDetails {
    
    @future(callout=true)
    public static void insertMovieData(String tmdbMovieId) {
        List<Movie__c> movies = new List<Movie__c>();
        //tmdb tmdbClass = new tmdb();
        TmdbGetMovieDetailsResponse resultData = tmdb.getMovieDetails(tmdbMovieId);
        Movie__c movie = new Movie__c();
        movie.Rating__c = resultData.vote_average;
        movie.Description__c = resultData.overview;
        movie.Poster_URL__c = resultData.poster_path;
        movie.Title__c = resultData.original_title;
        movie.Budget__c = resultData.budget;
        movie.Revenue__c = resultData.revenue;
        movies.add(movie);
        
        if (movies.size() > 0) {
            update movies;
        }

    }
}