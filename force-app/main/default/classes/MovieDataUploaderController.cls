public with sharing class MovieDataUploaderController {
    @AuraEnabled
    public static UploadResult uploadFile(Id documentId) {
        UploadResult result = new UploadResult();
        try {
            // Retrieve the file content
            ContentVersion contentVersion = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :documentId LIMIT 1];
            Blob fileContent = contentVersion.VersionData;

            // Parse JSON and process data
            String jsonContent = fileContent.toString();
            List<ConvertOldFormat.MovieData> movieList = (List<ConvertOldFormat.MovieData>) JSON.deserialize(jsonContent, List<ConvertOldFormat.MovieData>.class);
            
            // Check for duplicates before importing
            Set<String> tmdbIds = new Set<String>();
            
            for (ConvertOldFormat.MovieData movieData : movieList) {
                if (movieData.tmdb_id != null) {
                    tmdbIds.add(movieData.tmdb_id);
                }
            }
            
            // Query existing Movie__c records to check for duplicates
            Map<String, Movie__c> existingMoviesByTMDBId = new Map<String, Movie__c>();

            if (!tmdbIds.isEmpty()) {
                for (Movie__c movie : [SELECT Id, TMDB_movie_Id__c, LegacyId__c FROM Movie__c WHERE TMDB_movie_Id__c IN :tmdbIds]) {
                    existingMoviesByTMDBId.put(movie.TMDB_movie_Id__c, movie);
                }
            }
            
            // Filter out movies that already exist
            List<ConvertOldFormat.MovieData> moviesToImport = new List<ConvertOldFormat.MovieData>();
            for (ConvertOldFormat.MovieData movieData : movieList) {
                if ((movieData.tmdb_id != null && !existingMoviesByTMDBId.containsKey(movieData.tmdb_id)))  {
                    moviesToImport.add(movieData);
                }
            }
              
            Integer recordsCreated = ConvertOldFormat.ParseJson(JSON.serialize(moviesToImport));

            result.success = true;
            result.message = 'File processed successfully. ' + recordsCreated + ' records loaded to Salesforce.';
        } catch (Exception e) {
            result.success = false;
            result.message = 'An error occurred: ' + e.getMessage();
        }
        return result;
    }

    public class UploadResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String message;

        public UploadResult() {
            this.success = false;
        }
    }
}