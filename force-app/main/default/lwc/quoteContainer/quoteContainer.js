import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

/**
 * QuoteContainer Component
 * Handles navigation and displays key states for the Quote page.
 */
export default class QuoteContainer extends LightningElement {
    // Tracks the record ID retrieved from the page reference
    @track recordId;

    // State variables to manage UI visibility
    @track cartWrapper = true; // Controls visibility of the cart section
    @track showDesignQuoteDetail = true; // Controls visibility of the design quote details

    /**
     * Wire adapter to get the current page reference and extract the record ID.
     * This method is reactive and will update `recordId` when the page state changes.
     */
    @wire(CurrentPageReference)
    getPageReference(currentPageReference) {
        try {
            if (currentPageReference && currentPageReference.state.c__recordID) {
                this.recordId = currentPageReference.state.c__recordID;
                console.log(`Record ID successfully retrieved: ${this.recordId}`);
            } else {
                console.warn("Page reference does not contain a valid c__recordID.");
            }
        } catch (error) {
            console.error("Error retrieving record ID from page reference:", error);
        }
    }
}
