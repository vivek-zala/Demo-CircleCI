import { api, track } from "lwc";
import { LightningElement } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getQuoteDetails from "@salesforce/apex/QuoteContainerController.getQuoteDetails";

/**
 * QuoteHeader Component
 * This component fetches and displays quote details (Quote Name and Quote Number)
 * based on the provided Quote ID.
 */
export default class QuoteHeader extends NavigationMixin(LightningElement) {
    @api quoteId; // Public property to accept Quote ID from the parent component
    @track quoteName; // Holds the name of the quote
    @track quoteNumber; // Holds the number of the quote

    /**
     * Lifecycle hook - called when the component is inserted into the DOM.
     * Fetches quote details based on the Quote ID.
     */
    async connectedCallback() {
        try {
            // Validate if quoteId is provided
            if (!this.quoteId) {
                console.error("Quote ID is missing. Unable to fetch quote details.");
                return;
            }

            // Fetch quote details from the Apex method
            const quoteDetails = await getQuoteDetails({ quoteId: this.quoteId });

            // Check if the response contains the necessary data
            if (quoteDetails) {
                this.quoteName = quoteDetails.Name;
                this.quoteNumber = quoteDetails.QuoteNumber;
                console.log(`Quote Details: Name - ${this.quoteName}, Number - ${this.quoteNumber}`);
            } else {
                console.warn("Quote details are empty. Verify the provided Quote ID.");
            }
        } catch (error) {
            // Handle any errors that occur during the Apex call
            console.error("Error fetching quote details:", error);
        }
    }
}
