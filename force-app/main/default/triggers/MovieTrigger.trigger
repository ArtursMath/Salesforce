trigger MovieTrigger on Movie__c (after insert) {
    MovieTriggerHandler handler = new MovieTriggerHandler(Trigger.isExecuting, Trigger.size);
        handler.onAfterInsert(Trigger.new);
}