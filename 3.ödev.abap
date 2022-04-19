REPORT zga_odev_3.

TABLES sscrfields.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS:
  kare     RADIOBUTTON GROUP g1 USER-COMMAND cmd1 DEFAULT 'X',
  kareknr  TYPE i MODIF ID A.
PARAMETERS:
  ucgen    RADIOBUTTON GROUP g1,
  ucgenknr TYPE i MODIF ID B.
PARAMETERS:
  dikdort  RADIOBUTTON GROUP g1,
  kısaknr  TYPE i MODIF ID C,
  uzunknr  TYPE i MODIF ID C.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS:
  alan  AS CHECKBOX ,
  cevre AS CHECKBOX .
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
PARAMETERS:
  alan_h  TYPE i,
  cevre_h TYPE i.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN:
       PUSHBUTTON /2(40) button1 USER-COMMAND but1.

INITIALIZATION.
  button1 = 'Temizle'.

AT SELECTION-SCREEN OUTPUT.

IF kare = 'X'.
  LOOP AT SCREEN.
    IF screen-group1 = 'B'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
    IF screen-group1 = 'C'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ELSEIF ucgen = 'X'.
  LOOP AT SCREEN.
    IF screen-group1 = 'A'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
    IF screen-group1 = 'C'.
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
    IF screen-group1 = 'B'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDIF.

AT SELECTION-SCREEN .

  IF alan EQ 'X'.

    IF kare = 'X'.
      PERFORM kare_alan.

    ELSEIF ucgen = 'X'.
      PERFORM ucgen_alan.

    ELSEIF dikdort = 'X'.
      PERFORM dikdort_alan.

    ENDIF.

  ENDIF.
  IF cevre EQ 'X'.

    IF kare = 'X'.
      PERFORM kare_cevre.

    ELSEIF ucgen = 'X'.
      PERFORM ucgen_cevre.

    ELSEIF dikdort = 'X'.
      PERFORM dikdort_cevre.

    ENDIF.

  ENDIF.

END-OF-SELECTION.


  FORM kare_alan.

      IF alan_h IS INITIAL.
        alan_h = kareknr * kareknr .
      ELSE.
        CLEAR: alan_h.
      ENDIF.


  ENDFORM.
  FORM ucgen_alan.

     IF alan_h IS INITIAL.
        alan_h = ucgenknr * ucgenknr / 2 .
        ELSE.
        CLEAR: alan_h.
      ENDIF.

  ENDFORM.
  FORM dikdort_alan.

      IF alan_h IS INITIAL.
        alan_h = kısaknr * uzunknr .
        ELSE.
        CLEAR:  alan_h.
      ENDIF.


  ENDFORM.
  FORM kare_cevre.

      IF cevre_h IS INITIAL.
        cevre_h = kareknr * 4 .
        ELSE.
        CLEAR: cevre_h.
      ENDIF.

  ENDFORM.
  FORM ucgen_cevre.

      IF cevre_h IS INITIAL.
        cevre_h = ucgenknr * 3 .
        ELSE.
        CLEAR: cevre_h.
      ENDIF.

  ENDFORM.
  FORM dikdort_cevre.

    IF cevre_h IS INITIAL.
        cevre_h = ( kısaknr * 2 ) + ( uzunknr * 2 ) .
        ELSE.
        CLEAR: cevre_h.
      ENDIF.


  ENDFORM.