TABLES: acdoca, bseg, bkpf.
TYPE-POOLS : vrm .


DATA: name  TYPE vrm_id,                    "listbox için gerekli datalar.
      list  TYPE vrm_values,
      value LIKE LINE OF list.

DATA: lv_lenght    TYPE i,                   "guı download
      lv_filename1 TYPE  string,
      lv_path      TYPE string,
      lv_fullpath  TYPE string.


DATA: go_alv  TYPE REF TO cl_gui_alv_grid,           "alv
      go_cust TYPE REF TO cl_gui_custom_container,
      gt_fc   TYPE lvc_t_fcat,
      gs_fc   TYPE lvc_s_fcat,
      gs_lay  TYPE lvc_s_layo.

DATA  :gt_message TYPE TABLE OF bapiret2,
       gs_message LIKE LINE OF gt_message.

TYPES: BEGIN OF ty_alvlist,

         rbukrs  TYPE acdoca-rbukrs,           "giriş ekranı
         kzwrs   TYPE bkpf-kzwrs,
         kursf   TYPE bkpf-kursf,
         blart   TYPE acdoca-blart,
         budat   TYPE acdoca-budat,
         bldat   TYPE acdoca-bldat,
         sgtxt   TYPE acdoca-sgtxt,
         xblnr   TYPE bkpf-xblnr,
         bschlf   TYPE acdoca-bschl,           "ilk kalem için atılacak bilgiler
         racctf   TYPE acdoca-racct,
         mwskzf   TYPE acdoca-mwskz,
         kostlf   TYPE acdoca-ukostl,
         prctrf   TYPE acdoca-prctr,
         aufnrf   TYPE acdoca-aufnr,
         zuonrf   TYPE acdoca-zuonr,
         sgtxtf   TYPE bseg-sgtxt,
         vkorg   TYPE acdoca-vkorg,
         vtweg   TYPE acdoca-vtweg,
         spart   TYPE acdoca-spart,
         matnr   TYPE acdoca-matnr,
         werks   TYPE acdoca-werks,
         kunnr   TYPE acdoca-kunnr,          "tablolarda kndnr yoktu kunnr yi aldım.
         bschls  TYPE bseg-bschl,          "ikinci kalem için atılacak olanlar
         raccts  TYPE acdoca-racct,
         mwskzs  TYPE bseg-mwskz,
         kostls  TYPE bseg-kostl,
         prctrs  TYPE bseg-prctr,
         aufnrs  TYPE bseg-aufnr,
         zuonrs  TYPE bseg-zuonr,
         sgtxts  type bseg-sgtxt,
         hsl     TYPE acdoca-hsl,

       END OF ty_alvlist.

TYPES:

  tv_data(256) TYPE c,

  BEGIN OF ty_excellist,
    bschlf   TYPE tv_data,           "ilk kalem için atılacak bilgiler
    racctf   TYPE tv_data,
    mwskzf   TYPE tv_data,
    kostlf   TYPE tv_data,
    prctrf   TYPE tv_data,
    aufnrf   TYPE tv_data,
    zuonrf   TYPE tv_data,
    sgtxtf   TYPE tv_data,
    vkorg   TYPE tv_data,
    vtweg   TYPE tv_data,
    spart   TYPE tv_data,
    matnr   TYPE tv_data,
    werks   TYPE tv_data,
    kunnr   TYPE tv_data,
    bschls  TYPE tv_data,          "ikinci kalem için atılacak olanlar
    raccts  TYPE tv_data,
    mwskzs  TYPE tv_data,
    kostls  TYPE tv_data,
    prctrs  TYPE tv_data,
    aufnrs  TYPE tv_data,
    zuonrs  TYPE tv_data,
    sgtxts  TYPE tv_data,
    hsl     TYPE tv_data,

  END OF ty_excellist,

  tt_data     TYPE TABLE OF ty_excellist,
  tv_index(4) TYPE n.

DATA: gt_alist TYPE STANDARD TABLE OF ZGA_S_ODEV7_2,
      gr_alist TYPE REF TO ZGA_S_ODEV7_2,
      gs_alist TYPE ZGA_S_ODEV7_2,
      gt_data  TYPE TABLE OF ty_excellist,
      gs_data type ty_excellist.



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SKIP 10.

SELECTION-SCREEN:
BEGIN OF LINE,
PUSHBUTTON 37(25) TEXT-002 USER-COMMAND but1  ,
END OF LINE.
SKIP 5.

SELECTION-SCREEN:
BEGIN OF LINE,
COMMENT   45(25) TEXT-003,
END OF LINE.
SELECTION-SCREEN ULINE /1(79).

SELECTION-SCREEN: BEGIN OF LINE .
SELECTION-SCREEN POSITION 30.
PARAMETERS: r_button RADIOBUTTON GROUP g1 USER-COMMAND cmd1 DEFAULT 'X' .
SELECTION-SCREEN COMMENT   33(16) TEXT-004.
SELECTION-SCREEN POSITION 60.
PARAMETERS: r_but RADIOBUTTON GROUP g1.
SELECTION-SCREEN COMMENT   63(16) TEXT-005.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN:
BEGIN OF LINE,
COMMENT   45(15) TEXT-006,
END OF LINE.
SELECTION-SCREEN ULINE /1(79).

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT  5(10) TEXT-006.
PARAMETERS k_turu AS LISTBOX VISIBLE LENGTH 20.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN:
BEGIN OF LINE,
COMMENT   45(15) TEXT-007,
END OF LINE.
SELECTION-SCREEN ULINE /1(79).


PARAMETERS: p_rbukrs TYPE acdoca-rbukrs,
            p_kzwrs  TYPE bkpf-kzwrs,   "acdoca da yoktu bkpf den çekildi
            p_kursf  TYPE bkpf-kursf,   "acdoca da yoktu bkpf den çekildi
            p_blart  TYPE acdoca-blart,
            p_budat  TYPE acdoca-budat,
            p_bldat  TYPE acdoca-bldat,
            p_sgtxt  TYPE acdoca-sgtxt,
            p_xblnr  TYPE bkpf-xblnr.

SELECTION-SCREEN:
 BEGIN OF LINE,
         COMMENT   45(15) TEXT-008 FOR FIELD p_dosya,
 END OF LINE.
SELECTION-SCREEN ULINE /1(79).

PARAMETERS p_dosya TYPE RLGRAP-FILENAME OBLIGATORY LOWER CASE MEMORY ID fnm.

SELECTION-SCREEN END OF BLOCK b1.