*&---------------------------------------------------------------------*
*& Report z04_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_class.

CLASS lcl_airplane DEFINITION. "2)
PUBLIC SECTION.
    TYPES: BEGIN OF ty_attribute, "4)
                   attribute TYPE string,
                   value TYPE string,
                   END OF ty_attribute.

    TYPES ty_attributes TYPE STANDARD TABLE OF ty_attribute "5)
                    WITH NON-UNIQUE KEY attribute.
    CLASS-DATA gt_planetypes TYPE STANDARD TABLE OF saplane
        WITH NON-UNIQUE KEY planetype.

    CLASS-METHODS class_constructor.

    METHODS constructor
        IMPORTING i_name TYPE string
                  i_planetype TYPE saplane-planetype
        RAISING cx_s4d400_wrong_plane.


    METHODS get_attributes
        EXPORTING e_attributes TYPE ty_attributes.

    CLASS-METHODS get_n_o_airplanes
        EXPORTING e_number TYPE i.

PROTECTED SECTION.
     DATA: name TYPE string,
          planetype TYPE saplane-planetype.

PRIVATE SECTION. "3)
    CLASS-DATA gv_n_o_airplanes TYPE i.
ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.
   METHOD get_attributes.
   e_attributes = VALUE #(
    ( attribute = 'NAME' value = name )
    ( attribute = 'PLANETYPE' value = planetype )
   ).
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    e_number = gv_n_o_airplanes.
  ENDMETHOD.

  METHOD constructor.
       IF NOT line_exists( gt_planetypes[ planetype = i_planetype ] ).
        RAISE EXCEPTION TYPE cx_s4d400_wrong_plane.
       ENDIF.

       name = i_name.
       planetype = i_planetype.
       gv_n_o_airplanes = gv_n_o_airplanes + 1.
  ENDMETHOD.

  METHOD class_constructor.
    SELECT FROM saplane
    FIELDS *
    INTO TABLE @gt_planetypes.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_cargo_plane DEFINITION
    INHERITING FROM lcl_airplane.
    PUBLIC SECTION.
    METHODS constructor
        IMPORTING i_name TYPE string
                  i_planetype TYPE saplane-planetype
                  i_weight TYPE i
        RAISING cx_s4d400_wrong_plane.
    METHODS get_attributes REDEFINITION.

    METHODS get_weight
    RETURNING VALUE(rv_weight) TYPE i.

    PRIVATE SECTION.
    DATA weight TYPE i.
ENDCLASS.

CLASS lcl_cargo_plane IMPLEMENTATION.
  METHOD constructor.

    super->constructor( i_name = i_name i_planetype = i_planetype ).
    weight = i_weight.

  ENDMETHOD.

  METHOD get_attributes.
    e_attributes = VALUE #(
    ( attribute = 'NAME' value = name )
    ( attribute = 'PLANETYPE' value = planetype )
    ( attribute = 'WEIGHT' value = weight )
   ).
  ENDMETHOD.

  METHOD get_weight.
     rv_weight = weight.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_passenger_plane DEFINITION
    INHERITING FROM lcl_airplane.
    PUBLIC SECTION.
    METHODS get_attributes REDEFINITION.
    METHODS constructor
        IMPORTING
            i_name TYPE string
            i_planetype TYPE saplane-planetype
            i_seats TYPE i
         RAISING cx_s4d400_wrong_plane.

    PRIVATE SECTION.
    DATA seats TYPE i.

ENDCLASS.
CLASS lcl_passenger_plane IMPLEMENTATION.
  METHOD constructor.

    super->constructor( i_name = i_name i_planetype = i_planetype ).
    seats = i_seats.

  ENDMETHOD.

  METHOD get_attributes.
        super->get_attributes(
          IMPORTING
            e_attributes = e_attributes
        ).
        e_attributes = VALUE #( BASE e_attributes ( attribute = 'SEATS' value = seats ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_carrier DEFINITION.
PUBLIC SECTION.
TYPES tt_planetab TYPE STANDARD TABLE OF REF TO lcl_airplane WITH EMPTY KEY.

METHODS add_plane
    IMPORTING
        i_plane TYPE REF TO lcl_airplane.

*METHODS get_planes
*    RETURNING VALUE(r_planes) TYPE tt_planetab.

METHODS get_highest_cargo_weight
    RETURNING VALUE(r_weight) TYPE i.

PRIVATE SECTION.
DATA planes TYPE tt_planetab.

ENDCLASS.




CLASS lcl_carrier IMPLEMENTATION.

  METHOD add_plane.
    IF i_plane IS NOT INITIAL.
        planes = VALUE #( BASE planes ( i_plane ) ).
    ENDIF.
  ENDMETHOD.

*  METHOD get_planes.
*    r_planes = planes.
*  ENDMETHOD.

  METHOD get_highest_cargo_weight.
    DATA l_plane TYPE REF TO lcl_airplane.
    DATA l_cargo_plane TYPE REF TO lcl_cargo_plane.
    DATA l_weight TYPE i.

    LOOP AT planes INTO l_plane.
        IF l_plane IS INSTANCE OF lcl_cargo_plane.
            l_cargo_plane = CAST #( l_plane ).
            l_weight = l_cargo_plane->get_weight( ).
            IF l_weight > r_weight.
                r_weight = l_weight.
            ENDIF.
        ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.


DATA g_passenger TYPE REF TO lcl_passenger_plane.
DATA g_carrier TYPE REF TO lcl_carrier.
DATA g_cargo TYPE REF TO lcl_cargo_plane.

START-OF-SELECTION.
DATA go_airplane TYPE REF TO lcl_airplane.
DATA gt_airplanes TYPE TABLE OF
                  REF TO lcl_airplane.

g_carrier = NEW #(  ).

TRY.
go_airplane = NEW #(
    i_name      = 'Plane 1'
    i_planetype = '747-400'
).
g_carrier->add_plane( go_airplane ).

CATCH cx_s4d400_wrong_plane.
ENDTRY.

TRY.
g_passenger = NEW #(
    i_name      = 'Passenger'
    i_planetype = '747-400'
    i_seats = 400
).
g_carrier->add_plane( g_passenger ).

TRY.
g_cargo = NEW #(
    i_name      = 'Cargo'
    i_planetype = 'A380-800'
    i_weight = 100
).
g_carrier->add_plane( g_cargo ).

CATCH cx_s4d400_wrong_plane.
ENDTRY.
CATCH cx_s4d400_wrong_plane.
ENDTRY.

TRY.
go_airplane = NEW #(
    i_name      = 'Plane 1'
    i_planetype = 'XXX'
).
gt_airplanes = VALUE #( BASE gt_airplanes
                      ( go_airplane )
                      ).
CATCH cx_s4d400_wrong_plane.
ENDTRY.

TRY.
go_airplane = NEW #(
    i_name      = 'Plane 2'
    i_planetype = 'A340-600'
).
gt_airplanes = VALUE #( BASE gt_airplanes
                      ( go_airplane )
                      ).
CATCH cx_s4d400_wrong_plane.
ENDTRY.

TRY.
go_airplane = NEW #(
    i_name      = 'Plane 3'
    i_planetype = 'A380-800'
).
gt_airplanes = VALUE #( BASE gt_airplanes
                      ( go_airplane )
                      ).
CATCH cx_s4d400_wrong_plane.
ENDTRY.

DATA gt_attributes TYPE lcl_airplane=>ty_attributes.
DATA gt_output TYPE lcl_airplane=>ty_attributes.

*gt_airplanes = g_carrier->get_planes( ).

LOOP AT gt_airplanes INTO go_airplane.
    go_airplane->get_attributes(
      IMPORTING
        e_attributes = gt_attributes
    ).
    gt_output = CORRESPONDING #( BASE ( gt_output ) gt_attributes ).
ENDLOOP.

cl_s4d_output=>display_table( gt_output ).

DATA g_weight TYPE i.
DATA g_output TYPE string.
g_weight = g_carrier->get_highest_cargo_weight( ).
g_output = g_weight.
cl_s4d_output=>display_line( g_output ).
