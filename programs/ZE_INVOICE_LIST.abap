REPORT ZE_INVOICE_LIST.



TYPE-POOLS: slis.

TYPES: BEGIN OF ty_invoice,
         invoice_id   TYPE zinvoices_ze-invoice_id,
         supplier     TYPE zinvoices_ze-supplier,
         amount       TYPE zinvoices_ze-amount,
         invoice_date TYPE zinvoices_ze-invoice_date,
         due_date     TYPE zinvoices_ze-due_date,
         status       TYPE zinvoices_ze-status,
         color        TYPE c LENGTH 4,
       END OF ty_invoice.

DATA: it_data     TYPE TABLE OF ty_invoice,
      wa_data     TYPE ty_invoice,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv,
      alv_layout  TYPE slis_layout_alv.

START-OF-SELECTION.

  SELECT invoice_id supplier amount invoice_date due_date status
    INTO CORRESPONDING FIELDS OF TABLE it_data
    FROM zinvoices_ze.

  IF it_data IS INITIAL.
    MESSAGE 'No invoices found.' TYPE 'I'.
    EXIT.
  ENDIF.


  LOOP AT it_data INTO wa_data.
    CASE wa_data-status.
      WHEN 'U'. wa_data-color = 'C600'.
      WHEN 'L'. wa_data-color = 'C500'.
      WHEN 'P'. wa_data-color = 'C300'.
    ENDCASE.
    MODIFY it_data FROM wa_data.
  ENDLOOP.

  " Field catalog
  PERFORM build_fieldcat.

  " ALV color
  alv_layout-info_fieldname = 'COLOR'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout   = alv_layout
      it_fieldcat = it_fieldcat
    TABLES
      t_outtab    = it_data.






 FORM build_fieldcat.
  CLEAR it_fieldcat.

  DEFINE add_field.
    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = &1.
    wa_fieldcat-seltext_m = &2.
    wa_fieldcat-col_pos   = &3.
    APPEND wa_fieldcat TO it_fieldcat.
  END-OF-DEFINITION.

  add_field 'INVOICE_ID'    'Invoice ID'     1.
  add_field 'SUPPLIER'      'Supplier'       2.
  add_field 'AMOUNT'        'Amount'         3.
  add_field 'INVOICE_DATE'  'Invoice Date'   4.
  add_field 'DUE_DATE'      'Due Date'       5.
  add_field 'STATUS'        'Status'         6.
ENDFORM.
