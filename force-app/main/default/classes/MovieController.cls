public with sharing class MovieController {
    
    @AuraEnabled(cacheable=true)
    public static List<Movie__c> getMovies(Integer userSetLimit, String selectedGenre, Integer pageNumber) {
        Integer offset = (pageNumber - 1) * (userSetLimit != null ? userSetLimit : 0);

        String query = 'SELECT Id, Name, Genre__c, Poster_URL__c, Title__c, Rating_Calculated__c FROM Movie__c';

        if (String.isNotBlank(selectedGenre)) {
            query += ' WHERE Genre__c INCLUDES (:selectedGenre)';
        }

        if (userSetLimit != null && userSetLimit > 0) {
            query += ' LIMIT :userSetLimit OFFSET :offset';
        }

        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalMoviesCount(String selectedGenre) {
        String query = 'SELECT COUNT() FROM Movie__c';

        if (String.isNotBlank(selectedGenre)) {
            query += ' WHERE Genre__c INCLUDES (:selectedGenre)';
        }

        return Database.countQuery(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getGenrePicklistValues() {
        try {
            Schema.DescribeFieldResult fieldResult = Movie__c.Genre__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            List<String> genres = new List<String>();
            genres.add('All Genres');  
            for (Schema.PicklistEntry entry : picklistEntries) {
                genres.add(entry.getLabel());
            }
            return genres;
        } catch (Exception ex) {
            System.debug('Error fetching genre picklist values: ' + ex.getMessage());
            return new List<String>();
        }
    }
}