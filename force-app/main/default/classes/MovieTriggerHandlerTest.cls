@isTest
public with sharing class MovieTriggerHandlerTest {
    @isTest
    static void testMovieTitleFromCallout() {
        String tmdbId = '718821';
        // Set up the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Create and insert a Movie__c record
        Movie__c testMovie = new Movie__c(
            TMDB_Movie_Id__c = tmdbId
        );
        
        Test.startTest();
        insert testMovie;
        Test.stopTest();
        
        // Retrieve the inserted Movie__c record
        Movie__c insertedMovie = [SELECT Title__c FROM Movie__c WHERE TMDB_Movie_Id__c = :tmdbId LIMIT 1];
        
        // Assert that the Title__c field matches the mocked title
        System.assertEquals('Twisters', insertedMovie.Title__c);
    }
}


   /* @isTest
    public static void testMovieTitle() {
        Movie__c movie = new Movie__c(TMDB_Movie_Id__c ='718821') ;
        Test.startTest();
        insert movie;
        Test.stopTest();
        
        String movieTitle = null;
        List<Movie__c> movies = [SELECT Title__c FROM Movie__c WHERE TMDB_Movie_Id__c ='718821'];
        for (Movie__c testMovie : movies) {
            movieTitle = testMovie.Title__c;
        }
        System.assertEquals('Twisters', movieTitle);
    }
} */