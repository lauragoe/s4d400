*&---------------------------------------------------------------------*
*& Report z04_itab
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_itab.
DATA: g_connections    TYPE z04_t_connections, "2)
      g_flights        TYPE d400_t_flights, "5)
      g_percentage TYPE d400_t_percentage. "6)

g_connections = VALUE #(
    ( carrid = 'LH' connid = '400')
    ( carrid = 'LH' connid = '402')
 ).

CALL FUNCTION 'Z_04_GET_CONNECTIONS' "5)
   EXPORTING
        it_connections = g_connections
   IMPORTING
        et_flights = g_flights.

g_percentage = CORRESPONDING #( g_flights ). "7)

WRITE: `Carrier`, AT 10 `Conn.`, AT 20 `Date`, AT 35 `Occupied`, AT 45 `Max.`, AT 55 `Percentage`.

LOOP AT g_percentage REFERENCE INTO DATA(g_percentage_ref).
    IF g_percentage_ref->seatsmax <> 0.
        g_percentage_ref->percentage = g_percentage_ref->seatsocc / g_percentage_ref->seatsmax * 100.
    ENDIF.
    WRITE: / g_percentage_ref->carrid, AT 10 g_percentage_ref->connid, AT 20
            g_percentage_ref->fldate, AT 35 g_percentage_ref->seatsocc, At 45
            g_percentage_ref->seatsmax, AT 55 g_percentage_ref->percentage.
ENDLOOP.
