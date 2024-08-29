public class MovieQueueable implements Queueable, Database.AllowsCallouts {
    private List<String> movieIds;

    public MovieQueueable(List<String> movieIds) {
        this.movieIds = movieIds;
    }

    public void execute(QueueableContext context) {
        Integer batchSize = 50;

        // Get the first batch of records
        List<String> currentBatch = new List<String>();
        Integer processedSize = Math.min(batchSize, movieIds.size());
        for (Integer i = 0; i < processedSize; i++) {
            currentBatch.add(movieIds[i]);
        }

        MovieActions.updateMovieData(currentBatch);

        if (movieIds.size() > batchSize) {
            List<String> remainingIds = new List<String>();
            for (Integer i = batchSize; i < movieIds.size(); i++) {
                remainingIds.add(movieIds[i]);
            }

            System.enqueueJob(new MovieQueueable(remainingIds));
        }
    }
}