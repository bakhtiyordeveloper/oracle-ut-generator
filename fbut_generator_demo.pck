create or replace noneditionable package fbut_generator_demo
is


    procedure create_order
    (
        p_id number,

        p_name varchar2
    );



    procedure get_order
    (
        p_id number,

        p_result out varchar2
    );



    function order_count
    return number;



end fbut_generator_demo;
/
create or replace noneditionable package body fbut_generator_demo
is



    procedure create_order
    (
        p_id number,

        p_name varchar2
    )
    is
    begin

        null;

    end;




    procedure get_order
    (
        p_id number,

        p_result out varchar2
    )
    is
    begin

        p_result :=
            'TEST';

    end;




    function order_count
    return number
    is
    begin

        return 1;

    end;



end fbut_generator_demo;
/
