create or replace noneditionable package ut_value_factory
is

    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_VALUE_FACTORY
    -- Version : 1.0.0
    --
    -- Purpose:
    --   Generates default values for procedure/function parameters
    --
    -- Responsibilities:
    --   - Resolve datatype
    --   - Return safe test values
    --   - Support override strategies (future)
    ----------------------------------------------------------------------------


    ----------------------------------------------------------------------------
    -- Resolve simple datatype and return default value expression
    ----------------------------------------------------------------------------

    function get_value
    (
        p_data_type varchar2
    )
    return varchar2;



    ----------------------------------------------------------------------------
    -- Resolve value with context (future extension point)
    ----------------------------------------------------------------------------

    function get_value
    (
        p_data_type   varchar2,
        p_param_name  varchar2,
        p_owner       varchar2 default null,
        p_package     varchar2 default null,
        p_method      varchar2 default null
    )
    return varchar2;



    ----------------------------------------------------------------------------
    -- Check if datatype is supported
    ----------------------------------------------------------------------------

    function is_supported
    (
        p_data_type varchar2
    )
    return boolean;



    ----------------------------------------------------------------------------
    -- Return NULL-safe value (used when generator cannot decide)
    ----------------------------------------------------------------------------

    function null_value
    (
        p_data_type varchar2
    )
    return varchar2;



    ----------------------------------------------------------------------------
    -- Normalize datatype (VARCHAR2(100) -> VARCHAR2)
    ----------------------------------------------------------------------------

    function normalize_type
    (
        p_data_type varchar2
    )
    return varchar2;



    ----------------------------------------------------------------------------
    -- Main dispatcher (internal use, but exposed for debugging)
    ----------------------------------------------------------------------------

    function dispatch_value
    (
        p_data_type varchar2
    )
    return varchar2;



end ut_value_factory;
/
create or replace noneditionable package body ut_value_factory
is


    ----------------------------------------------------------------------------
    -- Version
    ----------------------------------------------------------------------------

    g_version constant varchar2(20) := '1.0.0';




    ----------------------------------------------------------------------------
    -- Normalize datatype
    ----------------------------------------------------------------------------

    function normalize_type
    (
        p_data_type varchar2
    )
    return varchar2
    is

        l_type varchar2(200);

    begin


        l_type :=
            upper(trim(p_data_type));



        if instr(l_type,'(') > 0 then

            l_type :=
                substr
                (
                    l_type,
                    1,
                    instr(l_type,'(')-1
                );

        end if;



        return l_type;


    end normalize_type;




    ----------------------------------------------------------------------------
    -- Check support
    ----------------------------------------------------------------------------

    function is_supported
    (
        p_data_type varchar2
    )
    return boolean
    is

        l_type varchar2(100);


    begin


        l_type :=
            normalize_type(p_data_type);



        return
        (
            l_type in
            (
                'NUMBER',
                'INTEGER',
                'FLOAT',
                'VARCHAR2',
                'VARCHAR',
                'CHAR',
                'NCHAR',
                'DATE',
                'TIMESTAMP',
                'BOOLEAN',
                'CLOB',
                'RAW',
                'XMLTYPE',
                'JSON'
            )
        );



    end is_supported;





    ----------------------------------------------------------------------------
    -- NULL value
    ----------------------------------------------------------------------------

    function null_value
    (
        p_data_type varchar2
    )
    return varchar2
    is
    begin


        return 'NULL';



    end null_value;





    ----------------------------------------------------------------------------
    -- Main dispatcher
    ----------------------------------------------------------------------------

    function dispatch_value
    (
        p_data_type varchar2
    )
    return varchar2
    is

        l_type varchar2(100);

    begin


        l_type :=
            normalize_type
            (
                p_data_type
            );



        case l_type



            when 'NUMBER'
            then
                return '1';



            when 'INTEGER'
            then
                return '1';



            when 'FLOAT'
            then
                return '1.0';



            when 'VARCHAR2'
            then
                return '''TEST''';



            when 'VARCHAR'
            then
                return '''TEST''';



            when 'CHAR'
            then
                return '''X''';



            when 'NCHAR'
            then
                return '''X''';



            when 'DATE'
            then
                return 'SYSDATE';



            when 'TIMESTAMP'
            then
                return 'SYSTIMESTAMP';



            when 'BOOLEAN'
            then
                return 'TRUE';



            when 'CLOB'
            then
                return 'TO_CLOB(''TEST'')';



            when 'RAW'
            then
                return 'NULL';



            when 'XMLTYPE'
            then
                return
                'XMLTYPE(''<root>TEST</root>'')';



            when 'JSON'
            then
                return
                'JSON_OBJECT(''VALUE'' VALUE ''TEST'')';



            else

                return 'NULL';



        end case;



    end dispatch_value;






    ----------------------------------------------------------------------------
    -- Public get_value
    ----------------------------------------------------------------------------

    function get_value
    (
        p_data_type varchar2
    )
    return varchar2
    is
    begin



        if is_supported(p_data_type)
        then


            return
            dispatch_value
            (
                p_data_type
            );


        else


            return null_value
            (
                p_data_type
            );


        end if;



    end get_value;






    ----------------------------------------------------------------------------
    -- Context overload
    ----------------------------------------------------------------------------

    function get_value
    (
        p_data_type   varchar2,
        p_param_name  varchar2,
        p_owner       varchar2 default null,
        p_package     varchar2 default null,
        p_method      varchar2 default null
    )
    return varchar2
    is
    begin



        /*
            Future extension point:

            Example:

            P_STATUS -> 'ACTIVE'

            P_EMAIL  -> 'test@test.com'

            P_DATE_FROM -> SYSDATE-30

        */



        return
            get_value
            (
                p_data_type
            );



    end get_value;




end ut_value_factory;
/
