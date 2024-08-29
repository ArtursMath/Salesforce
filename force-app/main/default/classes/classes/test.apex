tmdb tmdbClass = new tmdb();
String tmdb_id = '929590';
TmdbGetMovieDetailsResponse searchResults = tmdbClass.getMovieDetails(tmdb_id);
System.debug('TMDB movie_id "' + tmdb_id + '" original_title ::: ' + searchResults.original_title);
System.debug('TMDB movie_id "' + tmdb_id + '" overview ::: ' + searchResults.overview);
System.debug('TMDB movie_id "' + tmdb_id + '" vote_average ::: ' + searchResults.vote_average);
System.debug('TMDB movie_id "' + tmdb_id + '" revenue ::: ' + searchResults.revenue);
System.debug('TMDB movie_id "' + tmdb_id + '" poster_path ::: ' + searchResults.poster_path);
System.debug('TMDB movie_id "' + tmdb_id + '" budget ::: ' + searchResults.budget);