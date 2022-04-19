REPORT zga_odev_1.
TABLES sscrfields.
DATA:gt_student TYPE TABLE OF zga_odev_1,
     gs_student TYPE zga_odev_1,
     final      TYPE i.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

PARAMETERS:
  id       TYPE i OBLIGATORY,
  name     TYPE char10 OBLIGATORY,
  surname  TYPE char10 OBLIGATORY,
  midterm1 TYPE i OBLIGATORY,
  midterm2 TYPE i OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.

gs_student-stuid = id.
gs_student-stuname = name.
gs_student-stusurname = surname.
gs_student-midterm1 = midterm1.
gs_student-midterm2 = midterm2.

final = ( midterm1 + midterm2 ) / 2.

gs_student-final = final.

INITIALIZATION.

LOAD-OF-PROGRAM.

AT SELECTION-SCREEN.


START-OF-SELECTION.
  INSERT zga_odev_1 FROM gs_student.

  WRITE 'Kayıt Başarılı.'.
  WRITE :/'NO       :' , gs_student-stuid.
  WRITE :/'ADI      :' , gs_student-stuname.
  WRITE :/'SOYADI   :' , gs_student-stusurname.
  WRITE :/'MIDTERM-1:' , gs_student-midterm1.
  WRITE :/'MIDTERM-2:' , gs_student-midterm2.
  WRITE :/'FINAL    :' , gs_student-final.
  CLEAR : id , name , surname , midterm1 , midterm2 .


AT SELECTION-SCREEN OUTPUT.



END-OF-SELECTION.