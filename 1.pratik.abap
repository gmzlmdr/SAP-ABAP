REPORT zga_pratik_1.

INCLUDE zga_pratik_1_top.
INCLUDE zga_pratik_1_frm.


START-OF-SELECTION.
PERFORM get_data.
PERFORM set_feildcat.
PERFORM set_layout.
PERFORM display_avl.