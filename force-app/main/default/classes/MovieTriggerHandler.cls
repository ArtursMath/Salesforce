public with sharing class MovieTriggerHandler {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public MovieTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = IsExecuting;
        BatchSize = size;
        }

        public void onAfterInsert(List<Movie__c> movies) {
            List<String> movieIds = new List<Id>();
            for (Movie__c movie : movies) {
                movieIds.add(movie.Id);   
            }
                
            Queueable movieQueueable = new MovieQueueable(movieIds);
            System.enqueueJob(movieQueueable);
    }
}