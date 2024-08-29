public class SyncOutdatedMoviesScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        SyncOutdatedMovieRecs batchJob = new SyncOutdatedMovieRecs();
        Database.executeBatch(batchJob, 100);
    }

    public static void scheduleBatchJob() {
        String cronExpression = '0 30 18 * * ?';
        System.schedule('Daily Sync Outdated Movies', cronExpression, new SyncOutdatedMoviesScheduler());
    }
}