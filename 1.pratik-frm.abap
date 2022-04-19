FORM get_data .
  SELECT
      ekko~ebeln   " ~ İŞARETİNE DİKKAT ET .
      ekpo~ebelp
      ekko~bstyp
      ekko~bsart
      ekpo~matnr
      ekpo~menge
      ekpo~meins
      FROM ekko
      INNER JOIN ekpo ON ekpo~ebeln EQ ekko~ebeln
      INTO TABLE gt_list.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FEILDCAT
*&---------------------------------------------------------------------*
FORM set_feildcat .
  PERFORM:  set_fc_sub USING 'EBELN' 'SAS no.' 'SAS no.' 'SAS no.' abap_true '0' ,
    set_fc_sub USING 'EBELP' 'kalem' 'kalem' 'kalem' 'X' '1' ,
    set_fc_sub USING 'BSTYP' 'belge tipi' 'belge tipi' 'belge tipi' abap_false '4' ,
    set_fc_sub USING 'ESART' 'belge türü' 'belge türü' 'belge türü' abap_false '3' ,
    set_fc_sub USING 'MATNR' 'malzeme' 'malzeme' 'malzeme' abap_false '2' ,
    set_fc_sub USING 'MENGE' 'miktar' 'miktar' 'miktar' abap_false '5' ,
   set_fc_sub USING 'MEINS' 'ÖLÇÜ' 'ÖLÇÜ' 'ÖLÇÜ'  abap_false '6' .
* CLEAR: gs_fieldcat.
*  gs_fieldcat-fieldname = 'EBELN'.
*  gs_fieldcat-seltext_s = 'SAS no.'.
*  gs_fieldcat-seltext_m = 'SAS no.'.
*  gs_fieldcat-seltext_l = 'SAS no.'.
*  gs_fieldcat-key = abap_true.
*  gs_fieldcat-col_pos = 0.
**  gs_fieldcat-edit = abap-true.
**  gs_fieldcat-outputlen = 40.
**  gs_fieldcat-hotspot = abap-true.
*  APPEND gs_fieldcat TO gt_fieldcat.

*  CLEAR: gs_fieldcat.
*  gs_fieldcat-fieldname = 'EBELP'.
*  gs_fieldcat-seltext_s = 'kalem'.
*  gs_fieldcat-seltext_m = 'kalem'.
*  gs_fieldcat-seltext_l = 'kalem'.
*  gs_fieldcat-key = abap_true.
*  gs_fieldcat-col_pos = 1.
*  gs_fieldcat-do_sum = abap_true.
*  APPEND gs_fieldcat TO gt_fieldcat.

*  CLEAR: gs_fieldcat.
*  gs_fieldcat-fieldname = 'BSTYP'.
*  gs_fieldcat-seltext_s = 'belge tipi'.
*  gs_fieldcat-seltext_m = 'belge tipi'.
*  gs_fieldcat-seltext_l = 'belge tipi'.
*  gs_fieldcat-col_pos = 4.
*  APPEND gs_fieldcat TO gt_fieldcat.

*  CLEAR: gs_fieldcat.
*  gs_fieldcat-fieldname = 'ESART'.
*  gs_fieldcat-seltext_s = 'belge türü'.
*  gs_fieldcat-seltext_m = 'belge türü'.
*  gs_fieldcat-seltext_l = 'belge türü'.
*  gs_fieldcat-col_pos = 3.
*  APPEND gs_fieldcat TO gt_fieldcat.

*  CLEAR: gs_fieldcat.
*  gs_fieldcat-fieldname = 'MATNR'.
*  gs_fieldcat-seltext_s = 'malzeme'.
*  gs_fieldcat-seltext_m = 'malzeme'.
*  gs_fieldcat-seltext_l = 'malzeme'.
*  gs_fieldcat-col_pos = 2.
*  APPEND gs_fieldcat TO gt_fieldcat.

*  CLEAR: gs_fieldcat.
*  gs_fieldcat-fieldname = 'BSTMG'.
*  gs_fieldcat-seltext_s = 'miktar'.
*  gs_fieldcat-seltext_m = 'miktar'.
*  gs_fieldcat-seltext_l = 'miktar'.
*  gs_fieldcat-col_pos = 5.
*  APPEND gs_fieldcat TO gt_fieldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
FORM set_layout .

  gs_layout-window_titlebar = 'Reuse alv eğitimi'.
  gs_layout-zebra = abap_true.
  gs_layout-colwidth_optimize = abap_true.
  gs_layout-edit = abap_true.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_AVL
*&---------------------------------------------------------------------*
FORM display_avl .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
*     I_CALLBACK_PROGRAM                = ' '
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  =
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT     =
*     IT_FILTER   =
*     IS_SEL_HIDE =
*     I_DEFAULT   = 'X'
*     I_SAVE      = ' '
*     IS_VARIANT  =
*     IT_EVENTS   =
*     IT_EVENT_EXIT                     =
*     IS_PRINT    =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER           =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab    = gt_list
* EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*     OTHERS      = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FC_SUB
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fc_sub USING p_fieldname
                      p_seltext_s
                      p_seltext_m
                      p_seltext_l
                      p_key
                      p_col_pos.
  CLEAR: gs_fieldcat.
  gs_fieldcat-fieldname = p_fieldname.
  gs_fieldcat-seltext_s = p_seltext_s.
  gs_fieldcat-seltext_m = p_seltext_m.
  gs_fieldcat-seltext_l = p_seltext_l.
  gs_fieldcat-key = p_key.
  gs_fieldcat-col_pos = p_col_pos.
  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.