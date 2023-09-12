import { LightningElement ,api,track} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
export default class CompensatoryProductCmp extends LightningElement {

@api recordId;
@track btnLabel='compensatoryProduct';
closeModalHandler(){
    console.log('OUTPUT :closeModalHandler ');
    this.dispatchEvent(new CloseActionScreenEvent());
            // refresh the standard related list
            this.dispatchEvent(new RefreshEvent());
}
}