public with sharing class MovieActionHelper {
    public static List<Movie__c> getIdsfromMovies(List<Id> movieIds) {
        List<Movie__c> movies = [SELECT Id, TMDB_Movie_Id__c FROM Movie__c WHERE Id IN :movieIds];
        if(movies.size() > 0) {
            return movies;
        } else {
            System.debug('List is empty');
            return null;
        }
    }
}