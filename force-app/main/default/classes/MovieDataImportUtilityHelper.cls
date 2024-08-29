public with sharing class MovieDataImportUtilityHelper {
    public static Date formatDate(String dateStr) {
        try {
        List<String> dateParts = dateStr.split('/');
        if (dateParts.size() == 3) {
            String day = dateParts[0];
            String month = dateParts[1];
            String year = dateParts[2];
            
            String formattedDate = year + '-' + month + '-' + day;
            return Date.valueOf(formattedDate);
        } 

    }
        catch (System.TypeException e) {
            System.debug('Exception caught while parsing date: ' + e.getMessage());
        } 
            return null;
     }
}