REPORT ZGA_ODEV_5.

INCLUDE ZGA_ODEV_5_TOP.
INCLUDE ZGA_ODEV_5_SS.
INCLUDE ZGA_ODEV_5_FRM.

start-OF-SELECTION.

perform  get_data.
perform  set_fieldcat.
perform  set_layout.
perform  display_alv.