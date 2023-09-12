import { LightningElement, wire, track,api } from 'lwc';
import retrieveProducts from '@salesforce/apex/ProductSearchController.retrieveProducts';
import createProduct from '@salesforce/apex/ProductSearchController.createProduct';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Product Family', fieldName: 'Family' },
    { label: 'Brand', fieldName: 'Brand__c' },
    { label: 'ProductCode', fieldName: 'ProductCode' },
];

export default class ProductSearchComponent extends LightningElement {
    @track data;
    @track error;
    @track columns = columns;
    @track searchString;
    @track initialRecords;
    @track selectedRows = [];
    @api recordId;
    @api btnLabel;
    @wire(retrieveProducts)
    wiredAccount({ error, data }) {
        if (data) {
            console.log(data);
            this.data = data;
            this.initialRecords = data;
            this.error = undefined;
        } else if (error) {
            this.error = JSON.stringify(error);
            this.data = undefined;
        }
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();

        if (searchKey) {
            this.data = this.initialRecords;

            if (this.data) {
                let searchRecords = [];

                for (let record of this.data) {
                    let valuesArray = Object.values(record);

                    for (let val of valuesArray) {
                        console.log('val is ' + val);
                        let strVal = String(val);

                        if (strVal) {

                            if (strVal.toLowerCase().includes(searchKey)) {
                                searchRecords.push(record);
                                break;
                            }
                        }
                    }
                }

                console.log('Matched Accounts are ' + JSON.stringify(searchRecords));
                this.data = searchRecords;
            }
        } else {
            this.data = this.initialRecords;
        }

        this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRows;
    }

    handleRowSelection(event) {
        let updatedItemsSet = new Set();
        // List of selected items we maintain.
        let selectedItemsSet = new Set(this.selectedRows);
        // List of items currently loaded for the current view.
        let loadedItemsSet = new Set();

        this.data.map((ele) => {
            loadedItemsSet.add(ele.Id);
        });

        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((ele) => {
                updatedItemsSet.add(ele.Id);
            });

            // Add any new items to the selectedRows list
            updatedItemsSet.forEach((id) => {
                if (!selectedItemsSet.has(id)) {
                    selectedItemsSet.add(id);
                }
            });
        }

        loadedItemsSet.forEach((id) => {
            if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                // Remove any items that were unselected.
                selectedItemsSet.delete(id);
            }
        });

        this.selectedRows = [...selectedItemsSet];
        console.log('selectedRows==> ' + JSON.stringify(this.selectedRows));
    }
    handleClick(){
        console.log('OUTPUT :recordId ', this.recordId);
        console.log('OUTPUT : btnLabel',this.btnLabel);
        console.log('selectedRows==>2221233232 ' + JSON.stringify(this.selectedRows));
        createProduct({ recordId: this.recordId, selectedProductIds:this.selectedRows,btnLabel:this.btnLabel})
		.then(result => {
			console.log('OUTPUT :result ',result);
            this.showToast();
            var closemodal = new CustomEvent('closemodal');
            // Dispatches the event.
            this.dispatchEvent(closemodal);

            this.dispatchEvent(new CloseActionScreenEvent());
            // refresh the standard related list
            this.dispatchEvent(new RefreshEvent());
		})
		.catch(error => {
			this.error = error;
			this.accounts = undefined;
		})
    }
    showToast() {
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Product Created Successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}