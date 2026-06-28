create or replace noneditionable package fbut_method_demo
is


    procedure create_order
    (
        p_id        number,

        p_name      varchar2,

        p_result    out number
    );




    procedure update_order
    (
        p_id        number,

        p_status    out varchar2
    );




    function get_count
    return number;



end fbut_method_demo;
/
create or replace noneditionable package body fbut_method_demo
is



    procedure create_order
    (
        p_id        number,

        p_name      varchar2,

        p_result    out number
    )
    is
    begin


        p_result := 1;


    end create_order;






    procedure update_order
    (
        p_id        number,

        p_status    out varchar2
    )
    is
    begin


        p_status := 'OK';


    end update_order;







    function get_count
    return number

    is
    begin


        return 10;


    end get_count;




end fbut_method_demo;
/
