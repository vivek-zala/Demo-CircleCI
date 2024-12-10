public with sharing class QuoteContainerController {

    /**
     * Retrieves Quote details by its ID.
     *
     * @param quoteId The ID of the Quote record to retrieve.
     * @return The Quote record if found.
     * @throws AuraHandledException if the Quote ID is null or the query fails.
     */
    @AuraEnabled
    public static Quote getQuoteDetails(Id quoteId) {
       
        // Validate the input to ensure a non-null Quote ID is provided
        if (quoteId == null) {
            throw new AuraHandledException('Quote ID cannot be null.');
        }

        // Query the Quote record using a helper class
        Quote quote = QuoteQueryHelper.getQuoteById(quoteId);

        // Ensure the retrieved Quote is not null
        if (quote == null) {
            throw new AuraHandledException('No Quote found with the provided ID.');
        }

        return quote;

        
    }
}
