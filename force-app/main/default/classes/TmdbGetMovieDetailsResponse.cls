public with sharing class TmdbGetMovieDetailsResponse {
            public String overview;
            public String original_title;
            public Long revenue;
            public Double vote_average;
            public String poster_path;
            public Integer budget;
            public VideoResults videos;

    public class VideoResults {
        public List<Video> results;
     }

        public class Video {
                public String key;
                public String name;
                public String site;
                public String type;
    }
}