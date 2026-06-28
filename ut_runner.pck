create or replace noneditionable package ut_runner
is


    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_RUNNER
    -- Version : 1.0.0
    --
    -- Executes generated unit test packages
    ----------------------------------------------------------------------------





    ----------------------------------------------------------------------------
    -- Run all tests from generated package
    ----------------------------------------------------------------------------

    procedure run_package
    (
        p_owner             varchar2,

        p_test_package_name varchar2
    );







    ----------------------------------------------------------------------------
    -- Run single test method
    ----------------------------------------------------------------------------

    procedure run_method
    (
        p_owner             varchar2,

        p_test_package_name varchar2,

        p_method_name       varchar2
    );







    ----------------------------------------------------------------------------
    -- Validate generated test package
    ----------------------------------------------------------------------------

    function validate_package
    (
        p_owner             varchar2,

        p_test_package_name varchar2

    )
    return boolean;







    ----------------------------------------------------------------------------
    -- Get last execution status
    ----------------------------------------------------------------------------

    function get_last_status

    return varchar2;







    ----------------------------------------------------------------------------
    -- Clear runner state
    ----------------------------------------------------------------------------

    procedure clear;




end ut_runner;
/
create or replace noneditionable package body ut_runner
is


    g_last_status varchar2(4000);







    ----------------------------------------------------------------------------
    -- Clear
    ----------------------------------------------------------------------------

    procedure clear
    is

    begin

        g_last_status := null;

    end clear;









    ----------------------------------------------------------------------------
    -- Validate generated package
    ----------------------------------------------------------------------------

    function validate_package
    (
        p_owner             varchar2,

        p_test_package_name varchar2

    )
    return boolean

    is


        l_count number;


    begin



        select count(*)

        into l_count

        from all_objects

        where owner =
              upper(p_owner)

        and object_name =
              upper(p_test_package_name)

        and object_type =
              'PACKAGE';




        return l_count > 0;



    exception


        when others then


            return false;



    end validate_package;









    ----------------------------------------------------------------------------
    -- Run single test method
    ----------------------------------------------------------------------------

    procedure run_method
    (
        p_owner             varchar2,

        p_test_package_name varchar2,

        p_method_name       varchar2

    )

    is


        l_sql varchar2(4000);



    begin



        clear;




        if not validate_package
        (
            p_owner,

            p_test_package_name
        )

        then


            raise_application_error
            (
                -20001,

                'Test package not found: '
                ||
                p_test_package_name
            );


        end if;





        l_sql :=
            'begin '
            ||
            upper(p_owner)
            ||
            '.'
            ||
            upper(p_test_package_name)
            ||
            '.'
            ||
            lower(p_method_name)
            ||
            '; end;';





        execute immediate l_sql;





        g_last_status :=
            'SUCCESS: '
            ||
            p_test_package_name
            ||
            '.'
            ||
            p_method_name;





    exception


        when others then



            g_last_status :=
                'FAILED: '
                ||
                sqlerrm;



            raise;



    end run_method;









    ----------------------------------------------------------------------------
    -- Run all tests
    ----------------------------------------------------------------------------

    procedure run_package
    (
        p_owner             varchar2,

        p_test_package_name varchar2

    )

    is


        l_method_name varchar2(200);



    begin



        clear;





        if not validate_package
        (
            p_owner,

            p_test_package_name
        )

        then


            raise_application_error
            (
                -20002,

                'Test package not found: '
                ||
                p_test_package_name
            );


        end if;






        /*
          Oracle package ichidagi procedurelarni olish

        */

        for r in
        (
            select procedure_name

            from all_procedures

            where owner =
                  upper(p_owner)

            and object_name =
                  upper(p_test_package_name)

            and procedure_name is not null

            order by subprogram_id
        )

        loop



            l_method_name :=
                r.procedure_name;



            run_method
            (
                p_owner,

                p_test_package_name,

                l_method_name
            );



        end loop;





        g_last_status :=
            'PACKAGE SUCCESS: '
            ||
            p_test_package_name;





    exception


        when others then



            g_last_status :=
                'PACKAGE FAILED: '
                ||
                sqlerrm;



            raise;



    end run_package;









    ----------------------------------------------------------------------------
    -- Last status
    ----------------------------------------------------------------------------

    function get_last_status

    return varchar2

    is

    begin


        return g_last_status;



    end get_last_status;






end ut_runner;
/
