public with sharing class MovieDataImportUtility {
    public static void importMoviesFromStaticResource() {
        // Get the content of the JSON file from the Static Resource
        String jsonContent;
        try {
            jsonContent = [SELECT Body FROM StaticResource WHERE Name = 'Movies99'].Body.toString();
        } catch (Exception e) {
            System.debug('Error retrieving static resource: ' + e.getMessage());
            return;
        }

        if (jsonContent != null) {
            
            jsonContent = jsonContent.replace('\n', ' '); // Replace newline characters with a space
            jsonContent = jsonContent.replace('\r', ' ');
            
            // Convert the JSON string into a list of MovieData objects
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
            
            if (!moviesToImport.isEmpty()) {
                // Convert and insert movies
                ConvertOldFormat.ParseJson(JSON.serialize(moviesToImport));
            } else {
                System.debug('No new movies to import. All movies in the JSON file already exist.');
            }
            
        } else {
            System.debug('No JSON content found in Static Resource.');
        }
    }
}