*&---------------------------------------------------------------------*
*& Report z04_string
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_string.

PARAMETERS g_string TYPE string.
DATA anfang TYPE c.
anfang = substring( val = g_string off = 0 len = 1 ).
CASE anfang.
    WHEN 'A'.
        WRITE to_lower( g_string ).
    WHEN 'Z'.
        WRITE reverse( g_string ).
    WHEN OTHERS.
        WHILE g_string <> ' '.
            WRITE: substring( val = g_string off = 0 len = 1 ), sy-index.
           " WRITE sy-index.
            WRITE /.
            g_string = substring( val = g_string off = 1 len = strlen( g_string ) - 1 ).
        ENDWHILE.
ENDCASE.
