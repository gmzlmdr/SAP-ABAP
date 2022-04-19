REPORT zga_odev_6.

INCLUDE zga_odev_6_top.
INCLUDE zga_odev_6_frm.

INITIALIZATION.

  PERFORM dropdown.

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.

  PERFORM excel_read CHANGING gt_data.

call SCREEN 100.

AT SELECTION-SCREEN .

  IF sy-ucomm = 'BUT1'.
    PERFORM download_to_excel.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dosya .
  CALL FUNCTION 'F4_FILENAME'
*   EXPORTING
*     PROGRAM_NAME        = SYST-CPROG
*     DYNPRO_NUMBER       = SYST-DYNNR
*     FIELD_NAME          = ' '
    IMPORTING
      file_name = p_dosya.

INCLUDE zga_odev_6_status_0100o01.