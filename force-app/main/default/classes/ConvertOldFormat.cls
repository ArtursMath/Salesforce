public with sharing class ConvertOldFormat {

    public class MovieData {
        public String id;
        public String name;
        public String tmdb_id;
        public String genre;
        public Decimal rating;
        public Decimal budget;
        public Decimal actual_budget;
        public Decimal revenue;
        public ScriptData script;
        public String release_date;
        public String status;
    }

    public class ScriptData {
        public String id;
        public String name;
        public String description;
    }

    public static Integer ParseJson(String jsonString) {
        List<MovieData> movieList = (List<MovieData>) JSON.deserialize(jsonString, List<MovieData>.class);

        List<Movie__c> moviesToInsert = new List<Movie__c>();
        List<Script__c> scriptsToInsert = new List<Script__c>();

        for (MovieData movieData : movieList) {
            Movie__c movie = new Movie__c();
            movie.LegacyId__c = (String)movieData.id;
            movie.Title__c = movieData.name;
            movie.TMDB_movie_Id__c = (String)movieData.tmdb_id;
            movie.Genre__c = movieData.genre;
            movie.Rating__c = movieData.rating;
            movie.Budget__c = movieData.budget;
            movie.actual_budget__c = movieData.actual_budget;
            movie.Revenue__c = movieData.revenue;
            if (movieData.release_date != null) {
            movie.Release_Date__c = MovieDataImportUtilityHelper.formatDate(movieData.release_date);
            }
            if (movieData.status != null) {
            movie.Status__c = movieData.status;
            }
            moviesToInsert.add(movie);

            if (movieData.script != null) {
                Script__c script = new Script__c();
                script.LegacyId__c = movieData.script.id;
                script.Title__c = movieData.script.name;
                script.Description__c = movieData.script.description;

                scriptsToInsert.add(script);
            }
        }

        if (!scriptsToInsert.isEmpty()) {
            insert scriptsToInsert;
        }

        // Create a map of Script__c records with LegacyId__c as the key
        Map<String, Id> scriptMap = new Map<String, Id>();

        for (Script__c script : [SELECT Id, LegacyId__c FROM Script__c WHERE LegacyId__c != null]) {
            scriptMap.put(script.LegacyId__c, script.Id);
        }

        for (Movie__c movie : moviesToInsert) {
            if (scriptMap.containsKey(movie.LegacyId__c)) {
                movie.Script__c = scriptMap.get(movie.LegacyId__c);
            }
        }

        if (!moviesToInsert.isEmpty()) {
            insert moviesToInsert;
        }

        return moviesToInsert.size();
    }
}
