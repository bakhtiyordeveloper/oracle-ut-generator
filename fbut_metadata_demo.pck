create or replace noneditionable package fbut_metadata_demo
is


    procedure add_employee
    (
        p_id number,

        p_name varchar2
    );



    procedure get_employee
    (
        p_id number,

        p_name out varchar2
    );



    function count_employee
    return number;



    procedure save
    (
        p_id number
    );



    procedure save
    (
        p_name varchar2
    );



end fbut_metadata_demo;
/
create or replace noneditionable package body fbut_metadata_demo
is



    procedure add_employee
    (
        p_id number,

        p_name varchar2
    )
    is
    begin

        null;

    end;




    procedure get_employee
    (
        p_id number,

        p_name out varchar2
    )
    is
    begin

        p_name :=
            'TEST';

    end;




    function count_employee
    return number
    is
    begin

        return 1;

    end;




    procedure save
    (
        p_id number
    )
    is
    begin

        null;

    end;




    procedure save
    (
        p_name varchar2
    )
    is
    begin

        null;

    end;



end fbut_metadata_demo;
/
