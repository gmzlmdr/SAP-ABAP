FORM get_data .

  SELECT
    b~bukrs,
    b~gjahr,
    b~monat,
    b~belnr,
    a~buzei,
    a~lifnr,
    zga_t_odev6~isko,
    a~wrbtr
    FROM bkpf AS b
    INNER JOIN  bseg AS a ON b~bukrs = a~bukrs
    INNER JOIN zga_t_odev6 ON zga_t_odev6~satici EQ a~lifnr AND zga_t_odev6~satici NE ''
    INTO CORRESPONDING FIELDS OF TABLE @gt_list
    WHERE b~bukrs = @p_bukrs AND
          b~gjahr = @p_gjahr AND
          b~monat IN @s_monat AND
          a~lifnr IN @s_lifnr.

  LOOP AT gt_list INTO gs_list.

    gs_list-wrbtr = gs_list-wrbtr - ( gs_list-wrbtr * gs_list-isko ) / 100 .
    MODIFY gt_list FROM gs_list.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCAT
*&---------------------------------------------------------------------*
FORM set_fieldcat .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name   = sy-repid
      i_structure_name = 'ZGA_S_RAPOR'
      i_inclname       = sy-repid
    CHANGING
      ct_fieldcat      = gt_fieldcat.

  LOOP AT gt_fieldcat INTO gs_fieldcat.
    CASE gs_fieldcat-fieldname.
      WHEN 'BUKRS'.
        d_text = 'Sirket Kodu'.
      WHEN 'GJAHR'.
        d_text = 'Mali Yıl'.
      WHEN 'MONAT'.
        d_text = 'Dönem'.
      WHEN 'BELNR'.
        d_text = 'Belge Numarası'.
        gs_fieldcat-hotspot = abap_true.
      WHEN 'BUZEI'.
        d_text = 'Belge Kalemi'.
      WHEN 'LIFNR'.
        d_text = 'satici'.
      WHEN 'ISKO'.
        d_text = 'Iskonto'.
        gs_fieldcat-edit = abap_true.
      WHEN 'WRBTR'.
        d_text = 'Ilk Tutar'.
    ENDCASE.

    IF d_text NE space.
      MOVE d_text TO: gs_fieldcat-seltext_l,
                      gs_fieldcat-seltext_m,
                      gs_fieldcat-seltext_s,
                      gs_fieldcat-reptext_ddic.
    ENDIF.
    MODIFY gt_fieldcat FROM gs_fieldcat.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT
*&---------------------------------------------------------------------*
FORM set_layout.
  gs_layout-box_fieldname = 'SELKZ' .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'STATUS_SET'
      i_callback_user_command  = 'USER_COMMAND'
      is_layout                = gs_layout
      it_fieldcat              = gt_fieldcat[]
    TABLES
      t_outtab                 = gt_list[].
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.



*&---------------------------------------------------------------------*
*& Form PF_STATUS_SET
*&---------------------------------------------------------------------*
FORM status_set USING p_extab TYPE slis_t_extab .
  SET PF-STATUS '0100'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form USER_COMMAND
*&---------------------------------------------------------------------*
FORM user_command USING p_ucomm TYPE sy-ucomm
                        ps_selfield TYPE slis_selfield.

  DATA: lv_ind TYPE numc2.

  CASE p_ucomm.
    WHEN '&IC1' OR '&ETA'.
      CASE ps_selfield-fieldname.
        WHEN 'BELNR'.
          SET PARAMETER ID 'BLN' FIELD ps_selfield-value.
          SET PARAMETER ID 'BUK' FIELD p_bukrs.
          SET PARAMETER ID 'GJR' FIELD p_gjahr.
          CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDCASE.

    WHEN '&MSG'.
      CLEAR: lv_ind.
      LOOP AT gt_list INTO gs_list WHERE selkz = 'X'.
        lv_ind = lv_ind + 1.
      ENDLOOP.
      IF lv_ind EQ 0.
        MESSAGE 'satır seciniz!!' TYPE 'I'.
      ELSEIF lv_ind EQ 1.

      PERFORM get_popup_data.

      CALL FUNCTION 'ZGA_FM_POPUP_ALV'
       EXPORTING
         I_START_COLUMN       = 25
         I_START_LINE         = 6
         I_END_COLUMN         = 150
         I_END_LINE           = 15
         I_TITLE              = 'Detay'
         I_POPUP              = 'X'
         IT_ALV               = gt_popup
                .


      ELSEIF lv_ind > 0.
        MESSAGE 'birden fazla satır secemezsiniz!!' TYPE 'I'.

      ENDIF.

  ENDCASE.

ENDFORM.


FORM get_popup_data .


  SELECT
       r~bukrs,
       r~gjahr,
       r~belnr,
       b~buzei,
       b~sgtxt,
       b~gsber,
       b~shkzg,
       b~wrbtr
       FROM @gt_list AS r
       INNER JOIN  bseg AS b ON  b~bukrs EQ r~bukrs
                             AND b~gjahr EQ r~gjahr
                             AND b~belnr EQ r~belnr
                             AND b~buzei EQ r~buzei
                             AND b~wrbtr EQ r~wrbtr
       INTO CORRESPONDING FIELDS OF TABLE @gt_popup.


  LOOP AT gt_list INTO gs_list WHERE selkz = 'X'.

    LOOP AT gt_popup INTO gs_popup WHERE bukrs = gs_popup-bukrs
                                        AND belnr = gs_popup-belnr
                                        AND gjahr = gs_popup-gjahr
                                        AND buzei = gs_popup-buzei
                                        AND wrbtr = gs_popup-wrbtr.

      APPEND gs_popup TO gt_popup.
    ENDLOOP.

  ENDLOOP.
ENDFORM.


FORM set_popup_fieldcat .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name   = sy-repid
      i_structure_name = 'ZGA_S_RAPOR2'
      i_inclname       = sy-repid
    CHANGING
      ct_fieldcat      = gt_fieldcatpp.


  LOOP AT gt_fieldcatpp INTO gs_fieldcatpp.
    CASE gs_fieldcatpp-fieldname.
      WHEN 'BUKRS' .
        d_text2 = 'Sirket Kodu'.
      WHEN 'GJAHR'.
        d_text2 = 'Mali Yıl'.
      WHEN 'BELNR'.
        d_text2 = 'Belge Numarası'.
        gs_fieldcat-hotspot = abap_true.
      WHEN 'BUZEI' .
        d_text2 = 'Belge Kalemi'.
      WHEN 'SGTXT' .
        d_text2 = 'Kalem Metni'.
      WHEN 'GSBER'.
        d_text2 = 'İş Alanı'.
      WHEN 'SHKZG' .
        d_text2 = 'Borç Alacak Göstergesi'.
      WHEN 'WRBTR'.
        d_text2 = 'Tutarı'.
    ENDCASE.

    IF d_text2 NE space.
      MOVE d_text2 TO: gs_fieldcatpp-seltext_l,
                      gs_fieldcatpp-seltext_m,
                      gs_fieldcatpp-seltext_s,
                      gs_fieldcatpp-reptext_ddic.
    ENDIF.
    MODIFY gt_fieldcatpp FROM gs_fieldcatpp.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_POPUP_LAYOUT
*&---------------------------------------------------------------------*

FORM set_popup_layout .
  gs_layoutpp-box_fieldname = 'SELKZ'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_POPUP_LAYOUT
*&---------------------------------------------------------------------*
FORM display_popup_alv.



*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_callback_program       = sy-repid
*      i_callback_pf_status_set = 'PF_STATUS'
*      i_callback_user_command  = 'USER_COMMAND_200'
*      is_layout                = gs_layoutpp
*      it_fieldcat              = gt_fieldcatpp[]
*      i_screen_start_column    = 10
*      i_screen_start_line      = 1
*      i_screen_end_column      = 150
*      i_screen_end_line        = 10
*    TABLES
*      t_outtab                 = gt_popup[].
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

ENDFORM.

FORM pf_status USING p_extab TYPE slis_t_extab .
  SET PF-STATUS '0200'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  PERFORM get_popup_data.
  PERFORM set_popup_fieldcat.
  PERFORM set_popup_layout.
  PERFORM display_popup_alv.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.