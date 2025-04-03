REPORT ZE_INVOICE_INPUT.

TABLES: ZINVOICES_ZE.

PARAMETERS:
  p_inv_id    TYPE zinvoices_ze-invoice_id,
  p_supp      TYPE zinvoices_ze-supplier,
  p_amt       TYPE zinvoices_ze-amount,
  p_date      TYPE zinvoices_ze-invoice_date DEFAULT sy-datum,
  p_due       TYPE zinvoices_ze-due_date,
  p_status    TYPE zinvoices_ze-status.



DATA: wa_invoice  TYPE zinvoices_ze.

START-OF-SELECTION.

SELECT SINGLE * FROM zinvoices_ze INTO wa_invoice
  WHERE invoice_id = p_inv_id.

IF sy-subrc = 0.
  MESSAGE 'This invoice already exists.' TYPE 'E'.
ENDIF.

wa_invoice-invoice_id   = p_inv_id.
  wa_invoice-supplier     = p_supp.
  wa_invoice-amount       = p_amt.
  wa_invoice-invoice_date = p_date.
  wa_invoice-due_date     = p_due.
  wa_invoice-status       = p_status.

  INSERT zinvoices_ze FROM wa_invoice.

  IF sy-subrc = 0.
    MESSAGE 'Invoice saved successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error while saving invoice!' TYPE 'E'.
  ENDIF.
