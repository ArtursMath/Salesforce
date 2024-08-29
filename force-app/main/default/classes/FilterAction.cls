public with sharing class FilterAction {
    @InvocableMethod
    public static list<Contact> filterAction(List<Cast__c> cast) {
        List<Contact> results = new List<Contact>();
        results = [select Id, Name from Contact where Id NOT IN (SELECT Id from Cast__c)];
        ];
        return results;
    }
    
}