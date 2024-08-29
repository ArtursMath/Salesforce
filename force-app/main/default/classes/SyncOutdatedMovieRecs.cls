public with sharing class SyncOutdatedMovieRecs implements Database.Batchable<sObject>, Database.AllowsCallouts {

public Database.QueryLocator start(Database.BatchableContext bc) {
    Date oneMonthAgo = System.today().addMonths(-1);
    return Database.getQueryLocator('SELECT Id, TMDBSyncDate__c, TMDB_Movie_Id__c FROM Movie__c ' +
            'WHERE (TMDBSyncDate__c = NULL OR TMDBSyncDate__c < :oneMonthAgo) ' +
            'AND TMDB_Movie_Id__c != NULL');
}

    public void execute(Database.BatchableContext bc, List<Movie__c> scope) {
        List<Movie__c> moviesToUpdate = new List<Movie__c>();
        
        for (Movie__c movie : scope) {
            TmdbGetMovieDetailsResponse resultData = tmdb.getMovieDetails(movie.TMDB_Movie_Id__c);
                
                movie.TMDBSyncDate__c = Date.today();
                movie.Rating__c = resultData.vote_average;
                movie.Revenue__c = resultData.revenue;
                    
                    moviesToUpdate.add(movie);
                }
                    update moviesToUpdate; 
        }
 
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finished successfully');
    }
}