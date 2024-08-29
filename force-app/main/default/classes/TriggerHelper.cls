public with sharing class TriggerHelper {
    public static void onAfterInsert(List<Movie__c> movies) {
        List<String> movieIds = new List<Id>();
        for (Movie__c movie : movies) {
            movieIds.add(movie.Id);
            
        }
        MovieActions.updateMovieData(movieIds);
    }


}