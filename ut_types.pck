create or replace noneditionable package ut_types
is
    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_TYPES
    -- Version : 1.0.0
    --
    -- Internal data model definitions
    ----------------------------------------------------------------------------


    ----------------------------------------------------------------------------
    -- Generic string list
    ----------------------------------------------------------------------------
    type t_string_list is table of varchar2(4000);



    ----------------------------------------------------------------------------
    -- Package information
    ----------------------------------------------------------------------------
    type t_package_info is record
    (
        owner_name          varchar2(128),
        package_name        varchar2(128),
        test_package_name   varchar2(128),

        exists_flag         boolean,
        test_exists_flag    boolean
    );



    ----------------------------------------------------------------------------
    -- Argument metadata
    ----------------------------------------------------------------------------
    type t_argument_info is record
    (
        owner_name          varchar2(128),

        package_name        varchar2(128),

        object_name         varchar2(128),

        subprogram_id       number,

        procedure_name      varchar2(128),

        argument_name       varchar2(128),

        position            number,

        sequence_no         number,


        data_type           varchar2(128),

        data_length         number,

        precision_value     number,

        scale_value         number,


        in_out              varchar2(20),

        defaulted           varchar2(1),

        required_flag       boolean
    );



    ----------------------------------------------------------------------------
    -- Arguments collection
    ----------------------------------------------------------------------------
    type t_argument_list is table of t_argument_info;



    ----------------------------------------------------------------------------
    -- Procedure / Function metadata
    ----------------------------------------------------------------------------
    type t_method_info is record
    (

        owner_name          varchar2(128),

        package_name        varchar2(128),

        method_name         varchar2(128),

        subprogram_id       number,

        object_type         varchar2(30),

        is_function         boolean,

        return_type         varchar2(128),


        arguments           t_argument_list

    );



    ----------------------------------------------------------------------------
    -- Method collection
    ----------------------------------------------------------------------------
    type t_method_list is table of t_method_info;



    ----------------------------------------------------------------------------
    -- Generated source
    ----------------------------------------------------------------------------
    type t_source_info is record
    (
        object_name varchar2(128),

        source_type varchar2(30),

        source_text clob
    );



    ----------------------------------------------------------------------------
    -- Source collection
    ----------------------------------------------------------------------------
    type t_source_list is table of t_source_info;



    ----------------------------------------------------------------------------
    -- Generator configuration
    ----------------------------------------------------------------------------
    type t_generator_config is record
    (

        generate_assert       boolean,

        generate_setup        boolean,

        generate_teardown     boolean,

        generate_negative     boolean,

        compile_after_generate boolean,

        output_mode           varchar2(20)

    );



    ----------------------------------------------------------------------------
    -- Constructors
    ----------------------------------------------------------------------------

    function default_config
    return t_generator_config;



    function empty_package
    return t_package_info;



end ut_types;
/
create or replace noneditionable package body ut_types
is

    ----------------------------------------------------------------------------
    -- Version
    ----------------------------------------------------------------------------

    g_version constant varchar2(20) := '1.0.0';



    ----------------------------------------------------------------------------
    -- Default generator configuration
    ----------------------------------------------------------------------------

    function default_config
    return t_generator_config
    is

        l_cfg t_generator_config;

    begin

        l_cfg.generate_assert :=
            true;


        l_cfg.generate_setup :=
            true;


        l_cfg.generate_teardown :=
            true;


        l_cfg.generate_negative :=
            true;


        l_cfg.compile_after_generate :=
            true;


        l_cfg.output_mode :=
            ut_constants.c_mode_compile;



        return l_cfg;


    end default_config;




    ----------------------------------------------------------------------------
    -- Empty package object
    ----------------------------------------------------------------------------

    function empty_package
    return t_package_info
    is

        l_pkg t_package_info;


    begin

        l_pkg.owner_name :=
            null;


        l_pkg.package_name :=
            null;


        l_pkg.test_package_name :=
            null;


        l_pkg.exists_flag :=
            false;


        l_pkg.test_exists_flag :=
            false;



        return l_pkg;


    end empty_package;



end ut_types;
/
