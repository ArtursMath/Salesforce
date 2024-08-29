public with sharing class MovieActions {
    
    //@future(callout=true)
    public static void updateMovieData(List<Id> movieIds) {
        List<Movie__c> movies = MovieActionHelper.getIdsfromMovies(movieIds);
        List<Movie__c> moviesForUpdate = new List<Movie__c>();
        //tmdb tmdbClass = new tmdb();
        for (Movie__c movie : movies) {
            
        TmdbGetMovieDetailsResponse resultData = tmdb.getMovieDetails(movie.TMDB_Movie_Id__c);
        Movie__c updatedMovie = new Movie__c();
        updatedMovie.Id = movie.Id;
        updatedMovie.TMDBSyncDate__c = Date.today();
        updatedMovie.Rating__c = resultData.vote_average;
        updatedMovie.Description__c = resultData.overview;
        updatedMovie.Poster_URL__c = 'https://image.tmdb.org/t/p/original' + resultData.poster_path;
        updatedMovie.Title__c = resultData.original_title;
        updatedMovie.Budget__c = resultData.budget;
        updatedMovie.Revenue__c = resultData.revenue;
        moviesForUpdate.add(updatedMovie);  
        }

        if (moviesForUpdate.size() > 0) {
            update moviesForUpdate;
        }
    }
}