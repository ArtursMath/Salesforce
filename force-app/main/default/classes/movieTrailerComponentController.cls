public with sharing class movieTrailerComponentController {

    @AuraEnabled(cacheable=true)
    public static String getVideoKey(String movieId) {
        String videoKey = '';

        try {
            List<Movie__c> movieRecord = [SELECT Id, TMDB_movie_Id__c FROM Movie__c WHERE Id = :movieId LIMIT 1];

            TmdbGetMovieDetailsResponse resultData = tmdb.getMovieVideoDetails(movieRecord[0].TMDB_movie_Id__c);

            if (resultData == null) {
                System.debug('API response is null for TMDB Movie Id: ' + movieRecord[0].TMDB_movie_Id__c);
                return '';
            }

            if (resultData.videos == null || resultData.videos.results.isEmpty()) {
                System.debug('No video results found in API response for TMDB Movie Id: ' + movieRecord[0].TMDB_movie_Id__c);
                return '';
            }

            videoKey = resultData.videos.results[0].key;

        } catch (Exception e) {
            System.debug('Error retrieving video key: ' + e.getMessage());
        }

        return videoKey;
    }
}


