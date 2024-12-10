import { LightningElement, api, track} from 'lwc';
import extendedCostLabel from "@salesforce/label/c.ExtendedCostLabel";
import directSellPriceLabel from "@salesforce/label/c.DirectSellPrice";
import buyResellAndPTPrice from "@salesforce/label/c.BuyResellAndPtPrice";
import buyResellAndPTMarginPercent from "@salesforce/label/c.BuyResellAndPtMarginPercent";
import buyResellAndPTMargin from "@salesforce/label/c.BuyResellAndPtMargin";
import commissionAndRebates from "@salesforce/label/c.CommissionAndRebates";
import projectMarginPercent from "@salesforce/label/c.ProjectMarginPercent";
import projectMargin from "@salesforce/label/c.ProjectMargin";
import sellPrice from "@salesforce/label/c.SellPrice";

/**
 * QuoteFooter Component
 * This component displays the footer section of a Quote with various financial details.
 */

export default class QuoteFooter extends LightningElement {  
    // Tracks whether quote details should be displayed
    @track quoteDetails = true;

    // Labels for UI fields, imported from custom labels in Salesforce
    label = {extendedCostLabel,
        directSellPriceLabel,
        buyResellAndPTPrice,
        buyResellAndPTMarginPercent,
        buyResellAndPTMargin,
        commissionAndRebates,
        projectMarginPercent,
        projectMargin,
        sellPrice
    };
}