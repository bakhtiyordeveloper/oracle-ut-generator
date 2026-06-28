create or replace noneditionable package ut_metadata
is

    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_METADATA
    -- Version : 1.0.0
    --
    -- Oracle Dictionary Metadata Reader
    --
    -- Responsibilities:
    --  - Validate source package
    --  - Validate generated package name
    --  - Read procedures/functions
    --  - Read arguments
    --  - Support overload
    ----------------------------------------------------------------------------



    ----------------------------------------------------------------------------
    -- Check original package exists
    ----------------------------------------------------------------------------

    function package_exists
    (
        p_owner        varchar2,
        p_package_name varchar2
    )
    return boolean;



    ----------------------------------------------------------------------------
    -- Check generated FBUT package exists
    ----------------------------------------------------------------------------

    function test_package_exists
    (
        p_owner        varchar2,
        p_package_name varchar2
    )
    return boolean;



    ----------------------------------------------------------------------------
    -- Load complete package metadata
    ----------------------------------------------------------------------------

    function load_package
    (
        p_owner        varchar2,
        p_package_name varchar2
    )
    return ut_types.t_package_info;



    ----------------------------------------------------------------------------
    -- Load package methods
    ----------------------------------------------------------------------------

    function load_methods
    (
        p_owner        varchar2,
        p_package_name varchar2
    )
    return ut_types.t_method_list;



    ----------------------------------------------------------------------------
    -- Load method arguments
    ----------------------------------------------------------------------------

    function load_arguments
    (
        p_owner          varchar2,
        p_package_name   varchar2,
        p_method_name    varchar2,
        p_subprogram_id  number
    )
    return ut_types.t_argument_list;



    ----------------------------------------------------------------------------
    -- Get cached package info
    ----------------------------------------------------------------------------

    function get_package_info
    return ut_types.t_package_info;



    ----------------------------------------------------------------------------
    -- Get cached methods
    ----------------------------------------------------------------------------

    function get_methods
    return ut_types.t_method_list;



    ----------------------------------------------------------------------------
    -- Clear metadata cache
    ----------------------------------------------------------------------------

    procedure clear;



end ut_metadata;
/
create or replace noneditionable package body ut_metadata
is


    ----------------------------------------------------------------------------
    -- Version
    ----------------------------------------------------------------------------

    g_version constant varchar2(20) := '1.0.0';



    ----------------------------------------------------------------------------
    -- Cache
    ----------------------------------------------------------------------------

    g_package_info ut_types.t_package_info;

    g_methods      ut_types.t_method_list;



    ----------------------------------------------------------------------------
    -- Check original package
    ----------------------------------------------------------------------------

    function package_exists
    (
        p_owner        varchar2,
        p_package_name varchar2
    )
    return boolean
    is

        l_count number;

    begin

        select count(*)
        into l_count
        from all_objects
        where owner = upper(p_owner)
        and object_name = upper(p_package_name)
        and object_type = 'PACKAGE';


        return l_count > 0;


    end package_exists;



    ----------------------------------------------------------------------------
    -- Check generated package
    ----------------------------------------------------------------------------

    function test_package_exists
    (
        p_owner        varchar2,
        p_package_name varchar2
    )
    return boolean
    is

        l_test_name varchar2(200);

    begin

        l_test_name :=
            ut_config.get_test_package_name
            (
                p_package_name
            );


        return package_exists
        (
            p_owner,
            l_test_name
        );


    end test_package_exists;



    ----------------------------------------------------------------------------
    -- Load package info
    ----------------------------------------------------------------------------

    function load_package
    (
        p_owner        varchar2,
        p_package_name varchar2
    )
    return ut_types.t_package_info
    is

        l_result ut_types.t_package_info;

    begin

        l_result :=
            ut_types.empty_package;


        l_result.owner_name :=
            upper(p_owner);


        l_result.package_name :=
            upper(p_package_name);


        l_result.test_package_name :=
            ut_config.get_test_package_name
            (
                p_package_name
            );


        l_result.exists_flag :=
            package_exists
            (
                p_owner,
                p_package_name
            );


        l_result.test_exists_flag :=
            test_package_exists
            (
                p_owner,
                p_package_name
            );


        g_package_info :=
            l_result;


        return l_result;


    end load_package;



    ----------------------------------------------------------------------------
    -- Load methods
    ----------------------------------------------------------------------------

    function load_methods
    (
        p_owner        varchar2,
        p_package_name varchar2
    )
    return ut_types.t_method_list
    is

        l_result ut_types.t_method_list :=
            ut_types.t_method_list();


    begin


        for r in
        (
            select
                owner,
                object_name,
                procedure_name,
                subprogram_id,

                case
                    when object_type = 'FUNCTION'
                    then 1
                    else 0
                end is_function

            from all_procedures

            where owner =
                upper(p_owner)

            and object_name =
                upper(p_package_name)

            and procedure_name is not null

            order by subprogram_id
        )

        loop


            l_result.extend;


            l_result(l_result.count).owner_name :=
                r.owner;


            l_result(l_result.count).package_name :=
                r.object_name;


            l_result(l_result.count).method_name :=
                r.procedure_name;


            l_result(l_result.count).subprogram_id :=
                r.subprogram_id;


            l_result(l_result.count).is_function :=
                case
                    when r.is_function = 1
                    then true
                    else false
                end;


            l_result(l_result.count).arguments :=
                ut_types.t_argument_list();



        end loop;



        g_methods :=
            l_result;


        return l_result;



    end load_methods;



    ----------------------------------------------------------------------------
    -- Load arguments
    ----------------------------------------------------------------------------

    function load_arguments
    (
        p_owner          varchar2,
        p_package_name   varchar2,
        p_method_name    varchar2,
        p_subprogram_id  number
    )
    return ut_types.t_argument_list
    is

        l_result ut_types.t_argument_list :=
            ut_types.t_argument_list();


    begin


        for r in
        (
            select

                owner,
                package_name,
                object_name,
                argument_name,
                position,
                sequence,
                data_type,
                data_length,
                data_precision,
                data_scale,
                in_out,
                defaulted

            from all_arguments

            where owner =
                upper(p_owner)

            and package_name =
                upper(p_package_name)

            and object_name =
                upper(p_method_name)

            and subprogram_id =
                p_subprogram_id

            order by sequence
        )

        loop


            l_result.extend;


            l_result(l_result.count).owner_name :=
                r.owner;


            l_result(l_result.count).package_name :=
                r.package_name;


            l_result(l_result.count).object_name :=
                r.object_name;


            l_result(l_result.count).argument_name :=
                r.argument_name;


            l_result(l_result.count).position :=
                r.position;


            l_result(l_result.count).sequence_no :=
                r.sequence;


            l_result(l_result.count).data_type :=
                r.data_type;


            l_result(l_result.count).data_length :=
                r.data_length;


            l_result(l_result.count).precision_value :=
                r.data_precision;


            l_result(l_result.count).scale_value :=
                r.data_scale;


            l_result(l_result.count).in_out :=
                r.in_out;


            l_result(l_result.count).defaulted :=
                r.defaulted;


            l_result(l_result.count).required_flag :=
                case
                    when r.defaulted = 'N'
                    then true
                    else false
                end;



        end loop;


        return l_result;


    end load_arguments;



    ----------------------------------------------------------------------------
    -- Get cached package
    ----------------------------------------------------------------------------

    function get_package_info
    return ut_types.t_package_info
    is
    begin

        return g_package_info;

    end;



    ----------------------------------------------------------------------------
    -- Get cached methods
    ----------------------------------------------------------------------------

    function get_methods
    return ut_types.t_method_list
    is
    begin

        return g_methods;

    end;



    ----------------------------------------------------------------------------
    -- Clear cache
    ----------------------------------------------------------------------------

    procedure clear
    is
    begin

        g_methods := null;

        g_package_info :=
            ut_types.empty_package;


    end;



end ut_metadata;
/
