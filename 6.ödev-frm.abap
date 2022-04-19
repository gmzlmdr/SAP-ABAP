FORM dropdown .       "listbox
  name = 'k_turu'.
  value-key = '1'.
  value-text = '(40-50) Anahtarı İle Kayıt Atma'.
  APPEND value TO list.

  name = 'k_turu'.
  value-key = '1'.
  value-text = '(01-50) Müşteri Borç Virman'.
  APPEND value TO list.

  name = 'k_turu'.
  value-key = '1'.
  value-text = '(15-40) Müşteri Alacak Virman'.
  APPEND value TO list.

  name = 'k_turu'.
  value-key = '1'.
  value-text = '(25-50) Satıcı Borç Virman'.
  APPEND value TO list.

  name = 'k_turu'.
  value-key = '1'.
  value-text = '(31-40) Satıcı Alacak Virman'.
  APPEND value TO list.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = name
      values = list.

ENDFORM.


FORM download_to_excel.

  CONCATENATE 'customer open ıtems' sy-datum sy-uzeit INTO lv_filename1 SEPARATED BY '_'.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title      = 'Enter file Name'                 " Window Title
      default_extension = 'XLSX'                 " Default Extension
      default_file_name = lv_filename1                 " Default File Name
    CHANGING
      filename          = lv_filename1                 " File Name to Save
      path              = lv_path                 " Path to File
      fullpath          = lv_fullpath.                 " Path + File Name

  IF lv_fullpath IS NOT INITIAL.

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        bin_filesize            = lv_lenght
        filename                = lv_fullpath
        filetype                = 'BIN'
      TABLES
        data_tab                = gt_data
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        OTHERS                  = 22.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.

      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          document               = lv_fullpath       " Path+Name to Document
*         application            =                  " Path and Name of Application
*         parameter              =                  " Parameter for Application
*         default_directory      =                  " Default Directory
*         maximized              =                  " Show Window Maximized
*         minimized              =                  " Show Window Minimized
*         synchronous            =                  " When 'X': Runs the Application in Synchronous Mode
*         operation              = 'OPEN'           " Reserved: Verb for ShellExecute
        EXCEPTIONS
          cntl_error             = 1                " Control error
          error_no_gui           = 2                " No GUI available
          bad_parameter          = 3                " Incorrect parameter combination
          file_not_found         = 4                " File not found
          path_not_found         = 5                " Path not found
          file_extension_unknown = 6                " Could not find application for specified extension
          error_execute_failed   = 7                " Could not execute application or document
          synchronous_failed     = 8                " Cannot Call Application Synchronously
          not_supported_by_gui   = 9                " GUI does not support this
          OTHERS                 = 10.
      IF sy-subrc <> 0.
*         MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

    ENDIF.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  excel_read1
*&---------------------------------------------------------------------*
FORM excel_read CHANGING pt_data TYPE tt_data.

  DATA:
*    lt_excel TYPE STANDARD TABLE OF alsmex_tabline,
*    ls_excel TYPE alsmex_tabline,
*    lv_data  TYPE tv_data,
*    lv_error TYPE string,
    it_raw   TYPE truxs_t_text_data.


  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = it_raw
      i_filename           = p_dosya
    TABLES
      i_tab_converted_data = gt_data
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Dosya Açılamadı' TYPE 'E'.
  ENDIF.

  LOOP AT gt_data INTO gs_data.
*    lv_data = gs_data-value.
*    PERFORM itab_insert_value USING ls_excel-col ls_excel-row lv_data
*                              CHANGING pt_data.

    MOVE-CORRESPONDING gs_data TO gs_alist .

    gs_alist-rbukrs = p_rbukrs .
    gs_alist-kzwrs  = p_kzwrs .
    gs_alist-kursf  = p_kursf .
    gs_alist-blart  = p_blart .
    gs_alist-budat  = p_budat .
    gs_alist-bldat  = p_bldat .
    gs_alist-sgtxt  = p_sgtxt .
    gs_alist-xblnr  = p_xblnr .


    APPEND  gs_alist TO gt_alist.
  ENDLOOP.


ENDFORM.


FORM append_alv.

  CREATE OBJECT go_cust
    EXPORTING
*     parent                      =                  " Parent container
      container_name              = 'ALV'                 " Name of the Screen CustCtrl Name to Link Container To
*     style                       =                  " Windows Style Attributes Applied to this Container
*     lifetime                    = lifetime_default " Lifetime
*     repid                       =                  " Screen to Which this Container is Linked
*     dynnr                       =                  " Report To Which this Container is Linked
*     no_autodef_progid_dynnr     =                  " Don't Autodefined Progid and Dynnr?
    EXCEPTIONS
      cntl_error                  = 1                " CNTL_ERROR
      cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
      create_error                = 3                " CREATE_ERROR
      lifetime_error              = 4                " LIFETIME_ERROR
      lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CREATE OBJECT go_alv
    EXPORTING
*     i_shellstyle      = 0                " Control Style
*     i_lifetime        =                  " Lifetime
      i_parent          = go_cust          " Parent Container
*     i_appl_events     = space            " Register Events as Application Events
*     i_parentdbg       =                  " Internal, Do not Use
*     i_applogparent    =                  " Container for Application Log
*     i_graphicsparent  =                  " Container for Graphics
*     i_name            =                  " Name
*     i_fcat_complete   = space            " Boolean Variable (X=True, Space=False)
*     o_previous_sral_handler =
    EXCEPTIONS
      error_cntl_create = 1                " Error when creating the control
      error_cntl_init   = 2                " Error While Initializing Control
      error_cntl_link   = 3                " Error While Linking Control
      error_dp_create   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  PERFORM set_layout.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      i_buffer_active               = ' '                " Buffering Active
      i_bypassing_buffer            = 'X'                " Switch Off Buffer
*     i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*     i_structure_name              =                  " Internal Output Table Structure Name
*     is_variant                    =                  " Layout
      i_save                        = 'U'               " Save Layout
*     i_default                     = 'X'              " Default Display Variant
      is_layout                     = gs_lay                 " Layout
*     is_print                      =                  " Print Control
*     it_special_groups             =                  " Field Groups
*     it_toolbar_excluding          =                  " Excluded Toolbar Standard Functions
*     it_hyperlink                  =                  " Hyperlinks
*     it_alv_graphics               =                  " Table of Structure DTC_S_TC
*     it_except_qinfo               =                  " Table for Exception Tooltip
*     ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                     = gt_alist[]                " Output Table
      it_fieldcatalog               = gt_fc                 " Field Catalog
*     it_sort                       =                  " Sort Criteria
*     it_filter                     =                  " Filter Criteria
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.

FORM fieldsname .

  CLEAR: gs_fc.
  REFRESH: gt_fc.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = 'ZGA_S_ODEV7_2'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_BYPASSING_BUFFER     =
*     I_INTERNAL_TABNAME     = 'GT_ALIST'
    CHANGING
      ct_fieldcat            = gt_fc
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form KAYDET
*&---------------------------------------------------------------------*
FORM kaydet .

  DATA : lt_row_no TYPE   lvc_t_row,
         ls_row_no LIKE LINE OF lt_row_no.

  DATA: docheader      TYPE bapiache09,
        lt_accountgl   TYPE TABLE OF bapiacgl09,
        ls_accountgl   TYPE bapiacgl09,
        lt_accountrec  TYPE TABLE OF bapiacar09,
        ls_accountrec  TYPE bapiacar09,
        lt_accountpay  TYPE TABLE OF bapiacap09,
        ls_accountpay  TYPE bapiacap09,
        lt_accounttax  TYPE TABLE OF bapiactx09,
        ls_accounttax  TYPE bapiactx09,
        lt_currencyamo TYPE TABLE OF bapiaccr09,
        ls_currencyamo TYPE bapiaccr09,
        lt_return      TYPE TABLE OF bapiret2,
        ls_return      TYPE bapiret2 ,
        lt_extension2  TYPE TABLE OF bapiparex,
        ls_extension2  TYPE bapiparex,
        lt_criteria    TYPE TABLE OF bapiackec9,
        ls_criteria    TYPE bapiackec9,
        lv_index       TYPE i.

  CALL METHOD go_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_row_no.

  LOOP AT lt_row_no INTO ls_row_no.

    CLEAR: lt_accountgl[], lt_criteria[], lt_return[], lt_currencyamo[],docheader.

    READ TABLE gt_alist REFERENCE INTO gr_alist INDEX ls_row_no-index.
    IF sy-subrc IS INITIAL.

      docheader-bus_act    = 'RFBU'.
      docheader-username   = sy-uname.
      docheader-comp_code  = gr_alist->rbukrs.
      docheader-doc_type   = gr_alist->blart.
      docheader-doc_date   = gr_alist->bldat.
      docheader-pstng_date = gr_alist->budat.
      docheader-header_txt = gr_alist->sgtxt.

      lv_index = 1.

      CLEAR ls_accountgl.
      ls_accountgl-comp_code           = gr_alist->rbukrs.
      ls_accountgl-itemno_acc          = lv_index.
      ls_accountgl-gl_account          = gr_alist->racctf.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'       "Alan LIFNR'sinin dahili formatını almak için kullanılır,
        EXPORTING
          input  = ls_accountgl-gl_account
        IMPORTING
          output = ls_accountgl-gl_account.
      ls_accountgl-costcenter          = gr_alist->kostlf.
      ls_accountgl-profit_ctr          = gr_alist->prctrf.
      ls_accountgl-orderid             = gr_alist->aufnrf.
      ls_accountgl-alloc_nmbr          = gr_alist->zuonrf.

      APPEND ls_accountgl TO lt_accountgl.

      CLEAR ls_currencyamo.
      ls_currencyamo-itemno_acc       = lv_index.
      ls_currencyamo-curr_type        = '00' .

      ls_currencyamo-currency         = gr_alist->kzwrs.
      ls_currencyamo-amt_doccur       = gr_alist->hsl.
      APPEND ls_currencyamo TO lt_currencyamo.

      ADD 1 TO lv_index.

      CLEAR ls_accountgl.
      ls_accountgl-comp_code           = gr_alist->rbukrs.
      ls_accountgl-itemno_acc          = lv_index.
      ls_accountgl-gl_account          = gr_alist->raccts.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'       "Alan LIFNR'sinin dahili formatını almak için kullanılır,
        EXPORTING
          input  = ls_accountgl-gl_account
        IMPORTING
          output = ls_accountgl-gl_account.
      ls_accountgl-item_text           = gr_alist->sgtxts.
      ls_accountgl-tax_code            = gr_alist->mwskzs.
      ls_accountgl-costcenter          = gr_alist->kostls.
      ls_accountgl-profit_ctr          = gr_alist->prctrs.
      ls_accountgl-orderid             = gr_alist->aufnrs.
      ls_accountgl-alloc_nmbr          = gr_alist->zuonrs.
      APPEND ls_accountgl TO lt_accountgl.

      CLEAR ls_currencyamo.
      ls_currencyamo-itemno_acc       = lv_index.
      ls_currencyamo-curr_type        = '00' .
      ls_currencyamo-currency         = gr_alist->kzwrs.
      ls_currencyamo-amt_doccur       = ( gr_alist->hsl * ( -1 ) ).
      APPEND ls_currencyamo TO lt_currencyamo.

      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING
          documentheader = docheader
*         CUSTOMERCPD    =
*         CONTRACTHEADER =
        IMPORTING
          obj_type       = docheader-obj_type
          obj_key        = docheader-obj_key
          obj_sys        = docheader-obj_sys
        TABLES
          accountgl      = lt_accountgl
*         ACCOUNTRECEIVABLE       =
*         ACCOUNTPAYABLE =
*         ACCOUNTTAX     =
          currencyamount = lt_currencyamo
          criteria       = lt_criteria
*         VALUEFIELD     =
*         EXTENSION1     =
          return         = lt_return
*         PAYMENTCARD    =
*         CONTRACTITEM   =
*         EXTENSION2     =
*         REALESTATE     =
*         ACCOUNTWT      =
        .
      LOOP AT lt_return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
        EXIT.
      ENDLOOP.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK' .

      LOOP AT lt_return INTO ls_return WHERE TYPE CA 'AEX'.
          MOVE-CORRESPONDING ls_return TO gs_message.
          APPEND gs_message TO gt_message.
        ENDLOOP.

      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
        gr_alist->belgeno = docheader-obj_key(10).
      ENDIF.

    ENDIF.

  ENDLOOP.

  CALL METHOD go_alv->refresh_table_display
    EXPORTING
      i_soft_refresh = ''.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_lay-box_fname = 'SELKZ'.
  gs_lay-col_opt = 'X'.
  gs_lay-zebra = 'X'.
  gs_lay-detailinit = 'X'.
ENDFORM.