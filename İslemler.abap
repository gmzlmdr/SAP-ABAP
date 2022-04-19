REPORT ZGA_CALISMA_1.

Data :gv_num1 type i ,
      gv_num2 type i ,
      gv_toplam type string,
      gv_fark type string,
      gv_sonuc type i.


gv_num1 = 64.
gv_num2 = 36.

gv_sonuc = gv_num1 + gv_num2 .
 Write : 'Toplam:',  gv_sonuc .

 gv_sonuc = gv_num1 - gv_num2.
 Write : / 'Fark : ', gv_sonuc.

 gv_sonuc = gv_num1 * gv_num2.
 Write : / 'Carpım : ', gv_sonuc.

 gv_sonuc = gv_num1 / gv_num2.
 Write : / 'Bolum : ', gv_sonuc.