@isTest
public class ProductSearchControllerTest {

    @isTest
    static void testRetrieveProducts() {
        // Add test data for Product2 records
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < 10; i++) {
            products.add(new Product2(Name = 'Product ' + i, Brand__c = 'Hyphen'));
        }
        insert products;

        // Call the retrieveProducts method
        List<Product2> retrievedProducts = ProductSearchController.retrieveProducts();
    }

    @isTest
    static void testCreateProduct() {
        // Create a test Case record
        Case testCase = new Case(Brand__c = 'Hyphen');
        insert testCase;

        // Add test data for Product2 records
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < 5; i++) {
            products.add(new Product2(Name = 'Product ' + i, Brand__c = 'mCaffeine'));
        }
        insert products;

        // Call the createProduct method
        List<String> selectedProductIds = new List<String>();
        for (Product2 p : products) {
            selectedProductIds.add(p.Id);
        }
        ProductSearchController.createProduct(testCase.Id, selectedProductIds, 'Product');
    }
     @isTest
    static void testCreateProductSecond() {
        // Create a test Case record
        Case testCase = new Case(Brand__c = 'Hyphen');
        insert testCase;

        // Add test data for Product2 records
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < 5; i++) {
            products.add(new Product2(Name = 'Product ' + i, Brand__c = 'Hyphen'));
        }
        insert products;

        // Call the createProduct method
        List<String> selectedProductIds = new List<String>();
        for (Product2 p : products) {
            selectedProductIds.add(p.Id);
        }
        ProductSearchController.createProduct(testCase.Id, selectedProductIds, 'compensatoryProduct');
    }
}