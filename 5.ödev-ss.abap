SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-000.

PARAMETERS:

  p_bukrs  TYPE bkpf-bukrs,
  p_gjahr TYPE bkpf-gjahr.

SELECT-OPTIONS:
     s_monat FOR bkpf-monat,
     s_lifnr FOR bseg-lifnr.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001.

SELECTION-SCREEN PUSHBUTTON 1(25) p_but1 USER-COMMAND but1.
SELECTION-SCREEN PUSHBUTTON 30(25) p_but2 USER-COMMAND but2.


SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN.
 CASE sscrfields.
    WHEN 'BUT1'.
      CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
        EXPORTING
** S -> DİSPLAY: SADECE GÖRÜNTÜLEME
          action    = 'S'
          view_name = 'ZGA_T_ODEV6'.
    WHEN 'BUT2'.
      CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
        EXPORTING
** U -> CHANGE:  DEĞİŞTİRİLEBİLİR TABLO
          action    = 'U'
          view_name = 'ZGA_T_ODEV6'.
  ENDCASE.

  AT SELECTION-SCREEN OUTPUT.

  CONCATENATE icon_display 'Tabloyu Görüntüle' INTO p_but1 SEPARATED BY space.
  CONCATENATE icon_change 'Tabloyu Değiştir' INTO p_but2 SEPARATED BY space.