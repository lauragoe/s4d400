*&---------------------------------------------------------------------*
*& Report z04_calculator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_calculator.

PARAMETERS: gv_int1 TYPE i, gv_int2 TYPE i, gv_op TYPE c LENGTH 1.
DATA result TYPE p LENGTH 16 DECIMALS 2.
DATA gv_output TYPE String.


CASE gv_op.
WHEN '+'.
    result = gv_int1 + gv_int2.
    gv_output = result.
WHEN '-'.
    result = gv_int1 - gv_int2.
    gv_output = result.
WHEN '*'.
    result = gv_int1 * gv_int2.
    gv_output = result.
WHEN '/'.
    IF gv_int2 = 0.
        gv_output = 'Division durch 0 nicht möglich.'.
    ELSE.
        result = gv_int1 / gv_int2.
        gv_output = result.
    ENDIF.
WHEN OTHERS.
    gv_output = 'Falscher Rechenoperator wurde eingegeben.'.
ENDCASE.

WRITE gv_output.
