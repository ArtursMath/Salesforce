public with sharing class MockHttpResponseGenerator implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        // Create a mock response that simulates the external service's JSON response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Title__c": "Twisters"}'); // Mock JSON response with the title
        response.setStatusCode(200);
        return response;
    }
}
