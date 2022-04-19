TABLES: bkpf, bseg, sscrfields , zga_t_odev6.

DATA:
  gt_list TYPE TABLE OF zga_s_rapor,
  gs_list TYPE zga_s_rapor.

DATA:
  gt_fieldcat TYPE slis_t_fieldcat_alv,
  gs_fieldcat TYPE slis_fieldcat_alv,
  gs_layout TYPE slis_layout_alv,
  d_text TYPE char40.

DATA: gt_popup type table of zga_s_rapor2,
      gs_popup type  zga_s_rapor2.

DATA:
  gt_fieldcatpp TYPE slis_t_fieldcat_alv,
  gs_fieldcatpp TYPE slis_fieldcat_alv,
  gs_layoutpp TYPE slis_layout_alv,
  d_text2 TYPE char40.