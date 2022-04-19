REPORT ZGA_ODEV_4.

TYPES: BEGIN OF ty_test.
TYPES  bukrs   TYPE t001-bukrs.
TYPES  waers   TYPE t001-waers.
INCLUDE TYPE spflı.
TYPES END OF ty_test.

TYPES tt_test TYPE TABLE OF ty_test.

DATA:
  lv_spflı  TYPE TABLE OF spflı,
  gs_spflı  TYPE spflı,
*Range of ifadesi bir veritabanı seçme ifadesi gerçekleştirirken
*verilerin alınmasını kısıtlamanıza izin veriri
  gr_carrid TYPE RANGE OF spflı-carrid,
  gs_carrid LIKE LINE OF gr_carrid.

DATA: wa_test  TYPE  ty_test,
      it_test  LIKE TABLE OF wa_test,
      it_test2 TYPE tt_test,
      it_test3 TYPE TABLE OF ty_test.

RANGES: gr_connid FOR spflı-connid.

SELECTION-SCREEN BEGIN OF BLOCK b1.

SELECT-OPTIONS: airline FOR gs_spfli-carrid,
                flight_n FOR gs_spfli-connid,
                dep FOR gs_spfli-cityfrom,
                country FOR gs_spfli-countryto.

PARAMETERS: p_ch  AS CHECKBOX,
            p_ch1 AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b1.

FORM start_of_selection .

  IF p_ch = 'X'.
    gr_connid-sign = 'I'.
    gr_connid-option = 'BT'.
    gr_connid-low = 0 .
    gr_connid-high = 1000.
    APPEND gr_connid .
  ELSEIF p_ch1 = 'X'.
    gs_carrid-sign = 'I'.
    gs_carrid-option = 'BT'.
    gs_carrid-high = 'DZ'.
    gs_carrid-low = 'AA'.
    APPEND gs_carrid TO gr_carrid.

  ENDIF.

  SELECT * FROM spflı INTO TABLE lv_spfli
    WHERE carrid IN airline
    AND carrid IN gr_carrid
    AND connid IN flight_n
    AND connid IN gr_connid
    AND cityfrom IN dep
  AND countryto IN country.
ENDFORM.

FORM fonksiyon_yazdir.

  CALL FUNCTION  'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
*   I_CALLBACK_PROGRAM                = ' '
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
   I_STRUCTURE_NAME                  = 'SPFLI'
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
*   IT_FIELDCAT                       =
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
*   O_PREVIOUS_SRAL_HANDLER           =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = lv_spfli
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

ENDFORM.

START-OF-SELECTION.

  PERFORM start_of_selection.

END-OF-SELECTION.

  PERFORM fonksiyon_yazdır.