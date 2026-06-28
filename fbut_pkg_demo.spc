create or replace noneditionable package fbut_pkg_demo
is



    procedure create_customer
    (
        p_id        number,

        p_name      varchar2,

        p_result    out number
    );




    procedure delete_customer
    (
        p_id        number
    );




    function customer_count
    return number;



end fbut_pkg_demo;
/
