--delete from ITEM_2_5_test where YEAR(ext_CreatedDate)<2015
--Insert into  ITEM_test select * from EXT_ITEM
--select * from HISTORY_MASTER_2_6_test
--drop table ITEM_LEDGER_ENTRY_3_1_test

--SET IDENTITY_INSERT HISTORY_MASTER_test ON
--insert into HISTORY_MASTER_test (ext_Unit, ext_ShopNo, ext_TerminalNo, ext_DocumentType, ext_PaymentType, ext_DocumentNo, ext_EntryNo, ext_AppliesToDocumentNo, ext_AppliesToDocumentType, ext_CertificateCode, ext_PaymentCode, ext_OrderNo, ext_OrderTypeCode, ext_PostingDate, ext_Type, ext_SubType, ext_No, ext_BatchNo, ext_Description, ext_SupplierNo, ext_SelltoCustomerNo, ext_SelltoCustomerName, ext_CountryCode, ext_UnitOfMeasureCode, ext_BaseColorCode, ext_ColourCode, ext_SizeCode, ext_LengthCode, ext_SalespersonCode, ext_Quantity, ext_UnitPrice, ext_VAT, ext_LineDiscount, ext_LineDiscountAmount, ext_InvoiceDiscount, ext_InvoiceDiscountAmount, ext_InvoiceDiscountAmountIncludingVAT, ext_Amount, ext_AmountIncludingVat, ext_AmountLCY, ext_AmountLCYIncludingVAT, ext_CostAmount, ext_CurrencyCode, ext_CurrencyRate, ext_AccountNo, ext_BalanceAccountNo, ext_Collection, ext_ItemGroupCode, ext_LocationCode, ext_ItemCategoryCode, ext_ProductGroupCode, ext_ProgramCode, ext_Gender, ext_ItemCompositionId, ext_GlobalDimension1Code, ext_GlobalDimension2Code, ext_CustomerGroupCode, ext_ReturnType, ext_ReturnReason, ext_DiscountCode, ext_PChangeCode, ext_UserId, ext_Compiled, ext_PostingSetupKey, ext_DelChangeReasonCode, ext_NoBonus, ext_BonusBatchId, ext_Source, ext_CounterUnit, ext_ItemLedgerEntryNo, ext_CustomerLedgerEntryNo, ext_SupplierLedgerEntryNo, sync_created, sync_updated, sync_createdby, sync_updatedby, ext_PaymentTransactionId, ext_VariantId, ext_ActualCostAmount, ext_InvoiceDiscountCode) select * from EXT_HISTORY_MASTER
--SET IDENTITY_INSERT HISTORY_MASTER_test OFF

/*select name + ', ' as [text()] 
from sys.columns 
where object_id = object_id('ext_history_master') 
for xml path('')*/