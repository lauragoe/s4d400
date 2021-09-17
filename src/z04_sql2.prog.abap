*&---------------------------------------------------------------------*
*& Report z04_sql2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_sql2.

DATA: gt_flights TYPE d400_t_flights,
      g_airline TYPE s_carr_id,
      g_flight_number TYPE s_conn_id.

cl_s4d_input=>get_connection(
  IMPORTING
    ev_airline   = g_airline
    ev_flight_no =  g_flight_number
).

SELECT FROM sflight
FIELDS carrid, connid, fldate, planetype, seatsmax, seatsocc
WHERE carrid = @g_airline AND connid = @g_flight_number
INTO TABLE @gt_flights.

cl_s4d_output=>display_table( it_table = gt_flights ).
