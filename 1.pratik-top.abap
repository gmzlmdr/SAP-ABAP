TABLES: ekko, ekpo.
TYPES: BEGIN OF gty_list,
         ebeln TYPE ebeln,
         ebelp TYPE ebelp,
         bstyp TYPE ebstyp,
         bsart TYPE esart,
         matnr TYPE matnr,
         menge TYPE bstmg,
         meins TYPE meins,
       END OF gty_list.

DATA : gt_list TYPE TABLE OF gty_list,   "6 KOLONU OLAN BİR İNTERNAL TABLE .
       gs_list TYPE gty_list.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv.
"internal table ı doldurabilmek için herzaman bir structure a ihtiyacımız vardır.

DATA: gs_layout TYPE slis_layout_alv.
"layout bir structure olduğu için internal table oluşturmıycaz.