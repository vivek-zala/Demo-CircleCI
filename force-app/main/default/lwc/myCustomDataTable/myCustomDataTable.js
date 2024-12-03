import LightningDatatable from "lightning/datatable";
import richTextColumnType from "./richTextColumnType.html";
import longTextColumnType from "./longText.html";
import picklistColumn from './picklistColumn.html';
import pickliststatic from './picklistStatic.html'

export default class MyCustomDatatable extends LightningDatatable {
    static customTypes={
        // custom type definition
        richText: {
            template: richTextColumnType,
            standardCellLayout: true
        },
        longText: {
            template: longTextColumnType,
            standardCellLayout: true
        },
        picklistColumn: {
            template: pickliststatic,
            editTemplate: picklistColumn,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value', 'context', 'variant','name']
        }
    }

}