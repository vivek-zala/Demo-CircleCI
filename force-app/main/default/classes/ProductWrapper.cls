public with sharing class ProductWrapper {

    public Boolean isSelect {get;set;}
    public PricebookEntry product {get;set;}

    public ProductWrapper(Boolean isSelect, PricebookEntry product) {
        this.isSelect = isSelect;
        this.product = product;
    }
}