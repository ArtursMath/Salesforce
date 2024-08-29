@isTest
public with sharing class MovieDataImportUtilityHelperTest {
    @isTest
    static void validDateTest() {
        Date expectedDate = Date.newInstance(2009, 4, 13);
        Date validDate = MovieDataImportUtilityHelper.formatDate('13/04/2009');
        System.assertEquals(expectedDate, validDate);
    }

    @isTest
    static void wrongDateTest() {
        Date wrongFormatDate = MovieDataImportUtilityHelper.formatDate('13.12.27');
        System.assertEquals(null, wrongFormatDate);
    }

    @isTest
    static void invalidDateTest() {
        Date invalidDate = MovieDataImportUtilityHelper.formatDate('32/05/2021');
        System.assertEquals(null, invalidDate);
    }
}