create or replace noneditionable package ut_method_generator
is


    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_METHOD_GENERATOR
    -- Version : 1.0.0
    --
    -- Generates executable unit test methods
    ----------------------------------------------------------------------------



    ----------------------------------------------------------------------------
    -- Generate complete test method
    ----------------------------------------------------------------------------

    function generate_method_test
    (
        p_owner          varchar2,

        p_package_name   varchar2,

        p_method_name    varchar2,

        p_subprogram_id  number
    )
    return clob;





    ----------------------------------------------------------------------------
    -- Generate procedure call block
    ----------------------------------------------------------------------------

    function generate_procedure_call
    (
        p_owner          varchar2,

        p_package_name   varchar2,

        p_method_name    varchar2,

        p_subprogram_id  number
    )
    return clob;





    ----------------------------------------------------------------------------
    -- Generate function call block
    ----------------------------------------------------------------------------

    function generate_function_call
    (
        p_owner          varchar2,

        p_package_name   varchar2,

        p_method_name    varchar2,

        p_subprogram_id  number
    )
    return clob;





    ----------------------------------------------------------------------------
    -- Generate local variable declarations
    ----------------------------------------------------------------------------

    function generate_variables
    (
        p_owner          varchar2,

        p_package_name   varchar2,

        p_method_name    varchar2,

        p_subprogram_id  number
    )
    return clob;





    ----------------------------------------------------------------------------
    -- Resolve variable name for OUT parameters
    ----------------------------------------------------------------------------

    function variable_name
    (
        p_argument_name varchar2
    )
    return varchar2;





    ----------------------------------------------------------------------------
    -- Clear cache
    ----------------------------------------------------------------------------

    procedure clear;



end ut_method_generator;
/
create or replace noneditionable package body ut_method_generator
is


    ----------------------------------------------------------------------------
    -- Clear
    ----------------------------------------------------------------------------

    procedure clear
    is
    begin

        null;

    end clear;

    ----------------------------------------------------------------------------
    -- Variable name
    ----------------------------------------------------------------------------

    function variable_name
    (
        p_argument_name varchar2
    )
    return varchar2

    is
    begin

        return
            'l_' ||
            lower(p_argument_name);

    end variable_name;

    ----------------------------------------------------------------------------
    -- Variables
    ----------------------------------------------------------------------------

    function generate_variables
    (
        p_owner          varchar2,
        p_package_name   varchar2,
        p_method_name    varchar2,
        p_subprogram_id  number
    )
    return clob

    is

    begin


        return null;


    end generate_variables;



    ----------------------------------------------------------------------------
    -- Procedure call
    ----------------------------------------------------------------------------

    function generate_procedure_call
    (
        p_owner          varchar2,
        p_package_name   varchar2,
        p_method_name    varchar2,
        p_subprogram_id  number
    )
    return clob

    is
        l_sql clob;
    begin


        l_sql :=
            '    '
            ||
            lower(p_package_name)
            ||
            '.'
            ||
            lower(p_method_name)
            ||
            ';';

        return l_sql;

    end generate_procedure_call;


    ----------------------------------------------------------------------------
    -- Function call
    ----------------------------------------------------------------------------

    function generate_function_call
    (
        p_owner          varchar2,
        p_package_name   varchar2,
        p_method_name    varchar2,
        p_subprogram_id  number
    )
    return clob

    is

        l_sql clob;


    begin


        l_sql :=
            '    null;';



        return l_sql;


    end generate_function_call;


    ----------------------------------------------------------------------------
    -- Generate test method
    ----------------------------------------------------------------------------

    function generate_method_test
    (
        p_owner          varchar2,
        p_package_name   varchar2,
        p_method_name    varchar2,
        p_subprogram_id  number
    )
    return clob

    is
        l_sql clob;
    begin

        l_sql :=
        chr(9) || '-- Test_' || initcap(p_method_name) || chr(10) ||
        chr(9) || 'Procedure Test_' || initcap(p_method_name) ||
        ' is begin' || chr(10) ||
        chr(9) || chr(9) || chr(9) || initcap(p_package_name) || '.' || initcap(p_method_name) || ';' || chr(10) ||
        chr(9) || 'End Test_' || initcap(p_method_name) || ';';

        return l_sql;

    end generate_method_test;

end ut_method_generator;
/
