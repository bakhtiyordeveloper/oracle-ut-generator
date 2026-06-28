create or replace noneditionable package ut_logger
is


    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_LOGGER
    -- Version : 1.0.0
    --
    -- Execution logging module
    ----------------------------------------------------------------------------







    ----------------------------------------------------------------------------
    -- Start test execution
    ----------------------------------------------------------------------------

    function start_test
    (
        p_owner             varchar2,

        p_test_package_name varchar2,

        p_method_name       varchar2

    )
    return number;









    ----------------------------------------------------------------------------
    -- Finish test successfully
    ----------------------------------------------------------------------------

    procedure finish_success
    (
        p_log_id number
    );









    ----------------------------------------------------------------------------
    -- Finish test with error
    ----------------------------------------------------------------------------

    procedure finish_error
    (
        p_log_id        number,

        p_error_message varchar2
    );









    ----------------------------------------------------------------------------
    -- Get last log id
    ----------------------------------------------------------------------------

    function get_last_log_id

    return number;









    ----------------------------------------------------------------------------
    -- Clear logger state
    ----------------------------------------------------------------------------

    procedure clear;






end ut_logger;
/
create or replace noneditionable package body ut_logger
is


    ----------------------------------------------------------------------------
    -- Internal state
    ----------------------------------------------------------------------------

    g_enabled boolean := true;



    ----------------------------------------------------------------------------
    -- Enable
    ----------------------------------------------------------------------------

    procedure enable
    is
    begin

        g_enabled := true;

    end;



    ----------------------------------------------------------------------------
    -- Disable
    ----------------------------------------------------------------------------

    procedure disable
    is
    begin

        g_enabled := false;

    end;




    ----------------------------------------------------------------------------
    -- Internal writer
    ----------------------------------------------------------------------------

    procedure write_log
    (
        p_level   varchar2,

        p_message varchar2
    )
    is

    begin


        if g_enabled then


            dbms_output.put_line
            (

                '['
                ||
                p_level
                ||
                '] '
                ||
                to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')
                ||
                ' - '
                ||
                p_message

            );


        end if;



    end;




    ----------------------------------------------------------------------------
    -- INFO
    ----------------------------------------------------------------------------

    procedure info
    (
        p_message varchar2
    )
    is
    begin

        write_log
        (
            c_info,
            p_message
        );


    end;




    ----------------------------------------------------------------------------
    -- WARNING
    ----------------------------------------------------------------------------

    procedure warning
    (
        p_message varchar2
    )
    is
    begin

        write_log
        (
            c_warning,
            p_message
        );


    end;




    ----------------------------------------------------------------------------
    -- ERROR
    ----------------------------------------------------------------------------

    procedure error
    (
        p_message varchar2
    )
    is
    begin

        write_log
        (
            c_error,
            p_message
        );


    end;




    ----------------------------------------------------------------------------
    -- DEBUG
    ----------------------------------------------------------------------------

    procedure debug
    (
        p_message varchar2
    )
    is
    begin

        write_log
        (
            c_debug,
            p_message
        );


    end;




    ----------------------------------------------------------------------------
    -- Exception logger
    ----------------------------------------------------------------------------

    procedure log_exception
    (
        p_context varchar2
    )
    is

    begin


        write_log
        (
            c_error,

            p_context
            ||
            ' : '
            ||
            sqlerrm

        );


    end;




    ----------------------------------------------------------------------------
    -- Status
    ----------------------------------------------------------------------------

    function is_enabled
    return boolean
    is
    begin

        return g_enabled;

    end;




end ut_logger;
/
