*&---------------------------------------------------------------------*
*& Report z04_sql1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_sql1.

DATA: gs_flight TYPE d400_s_flight,
      g_airline TYPE s_carr_id,
      g_flight_number TYPE s_conn_id,
      g_flight_date TYPE s_date.

cl_s4d_input=>get_flight(
  IMPORTING
    ev_airline   = g_airline
    ev_flight_no = g_flight_number
    ev_date      = g_flight_date
).

SELECT SINGLE FROM sflight
FIELDS carrid, connid, fldate, planetype, seatsmax, seatsocc
WHERE carrid = @g_airline AND connid = @g_flight_number AND fldate = @g_flight_date
INTO @gs_flight.

cl_s4d_output=>display_structure( iv_structure = gs_flight ).
