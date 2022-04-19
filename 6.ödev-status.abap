*----------------------------------------------------------------------*
***INCLUDE ZGA_ODEV_6_STATUS_0100O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module MOD OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'GUI_STATUS'.
* SET TITLEBAR 'xxx'.

  PERFORM fieldsname.
  PERFORM append_alv.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  REFRESH : gt_message[].
  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12'.
      LEAVE TO SCREEN 0.
    WHEN '&KAYDET'.
      PERFORM kaydet.

      IF gt_message[] IS NOT INITIAL.
        CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
          EXPORTING
            it_message = gt_message.
      ENDIF.


  ENDCASE.

ENDMODULE.