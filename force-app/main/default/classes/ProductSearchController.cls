public with sharing class ProductSearchController {
    @AuraEnabled (cacheable=true)
    public static List<Product2> retrieveProducts(){
        return [SELECT Id, Name,Brand__c,Family,ProductCode
                FROM Product2
                LIMIT 49000];
    }
    @AuraEnabled
    public static void createProduct(String recordId,List<String> selectedProductIds,String btnLabel){
        List<Case> listCase = [SELECT Brand__c FROM Case WHERE ID =: recordId];
        List<Product__c> productList = new List<Product__c>();
        List<Compensatory_Product__c> compensatoryProductList = new List<Compensatory_Product__c>();
        List<Product2> prodList =[SELECT ID,Name FROM Product2 WHERE ID IN:selectedProductIds];
        if(btnLabel=='Product'){
            for(Product2 objProduct : prodList){
                Product__c objSelectedProduct = new Product__c();
                objSelectedProduct.Product__c = objProduct.Id;
                objSelectedProduct.Brand__c = listCase.get(0).Brand__c;
                objSelectedProduct.Case__c = listCase.get(0).Id;
                objSelectedProduct.Name = objProduct.Name;
                productList.add(objSelectedProduct);
            }
        }
        else if(btnLabel=='compensatoryProduct'){
           for(Product2 objProduct : prodList){
            Compensatory_Product__c objSelectedCompensatoryProduct = new Compensatory_Product__c();
            objSelectedCompensatoryProduct.Product__c = objProduct.Id;
            objSelectedCompensatoryProduct.Brand__c = listCase.get(0).Brand__c;
            objSelectedCompensatoryProduct.Case__c = listCase.get(0).Id;
            objSelectedCompensatoryProduct.Name = objProduct.Name;
            compensatoryProductList.add(objSelectedCompensatoryProduct);
        } 
        }
        if(productList.size()>0){
            insert productList;
        }
        if(compensatoryProductList.size()>0){
            insert compensatoryProductList;
        }
    }
}