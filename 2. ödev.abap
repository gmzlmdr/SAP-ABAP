REPORT ZGA_ODEV_2.

DATA: gt_kartislem TYPE TABLE OF ZGA_ODEV_2,
      gs_kartislem TYPE ZGA_ODEV_2.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS:
  svd_kart RADIOBUTTON GROUP g1 USER-COMMAND cmd1 DEFAULT 'X',
  Kartname   TYPE char10 MODIF ID A .

PARAMETERS:
  new_card RADIOBUTTON GROUP g1,
  kartid   TYPE i MODIF ID B,
  kartismi TYPE char10 MODIF ID B,
  sonkt    TYPE sy-datum MODIF ID B,
  kartccv  TYPE i MODIF ID B ,
  3dsecure AS CHECKBOX  MODIF ID B,
  save AS CHECKBOX  MODIF ID B.

SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN OUTPUT.

IF svd_kart = 'X'.
  LOOP AT SCREEN.
    IF screen-group1 = 'B'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ELSE.
  LOOP AT SCREEN.
    IF screen-group1 = 'A'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDIF.


START-OF-SELECTION.

IF svd_kart EQ 'X'.

  IF Kartname IS INITIAL.
    WRITE 'Kart adı giriniz.'.
  ENDIF.
  SELECT SINGLE * FROM ZGA_ODEV_2 INTO gs_kartislem WHERE kartname eq Kartname.

    IF SY-SUBRC = 0.
      WRITE 'Kartınız kayıtlıdır.'.
    ELSE.
      WRITE 'Kartınız kayıtlı değildir.'.
    ENDIF.
ELSE.
  IF save EQ 'X'.
    gs_kartislem-KARTID = kartid.
    gs_kartislem-KARTNAME = kartismi.
    gs_kartislem-SONKT = sonkt.
    gs_kartislem-KARTCCV = kartccv.
    INSERT ZGA_ODEV_2 FROM gs_kartislem.
  ENDIF.
  IF 3dsecure EQ 'X'.
    WRITE 'Telefonunuza mesaj gönderildi.'.
  ENDIF.
ENDIF.