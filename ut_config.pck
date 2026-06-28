create or replace noneditionable package ut_config
is

    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_CONFIG
    -- Version : 1.0.0
    --
    -- Global configuration manager
    ----------------------------------------------------------------------------


    ----------------------------------------------------------------------------
    -- Get current configuration
    ----------------------------------------------------------------------------
    function get_config
    return ut_types.t_generator_config;



    ----------------------------------------------------------------------------
    -- Change settings
    ----------------------------------------------------------------------------

    procedure set_generate_assert
    (
        p_value boolean
    );



    procedure set_generate_setup
    (
        p_value boolean
    );



    procedure set_generate_teardown
    (
        p_value boolean
    );



    procedure set_generate_negative
    (
        p_value boolean
    );



    procedure set_compile_after_generate
    (
        p_value boolean
    );



    procedure set_output_mode
    (
        p_value varchar2
    );



    ----------------------------------------------------------------------------
    -- Package name builder
    ----------------------------------------------------------------------------

    function get_test_package_name
    (
        p_package_name varchar2
    )
    return varchar2;



    ----------------------------------------------------------------------------
    -- Reset all settings
    ----------------------------------------------------------------------------

    procedure reset;



end ut_config;
/
create or replace noneditionable package body ut_config
is


    ----------------------------------------------------------------------------
    -- Internal configuration
    ----------------------------------------------------------------------------

    g_config ut_types.t_generator_config;



    ----------------------------------------------------------------------------
    -- Initialize defaults
    ----------------------------------------------------------------------------

    procedure initialize
    is
    begin

        g_config :=
            ut_types.default_config;


    end initialize;



    ----------------------------------------------------------------------------
    -- Getter
    ----------------------------------------------------------------------------

    function get_config
    return ut_types.t_generator_config
    is

    begin

        return g_config;

    end get_config;




    ----------------------------------------------------------------------------
    -- Setters
    ----------------------------------------------------------------------------

    procedure set_generate_assert
    (
        p_value boolean
    )
    is
    begin

        g_config.generate_assert :=
            p_value;

    end;




    procedure set_generate_setup
    (
        p_value boolean
    )
    is
    begin

        g_config.generate_setup :=
            p_value;

    end;




    procedure set_generate_teardown
    (
        p_value boolean
    )
    is
    begin

        g_config.generate_teardown :=
            p_value;

    end;




    procedure set_generate_negative
    (
        p_value boolean
    )
    is
    begin

        g_config.generate_negative :=
            p_value;

    end;




    procedure set_compile_after_generate
    (
        p_value boolean
    )
    is
    begin

        g_config.compile_after_generate :=
            p_value;

    end;




    procedure set_output_mode
    (
        p_value varchar2
    )
    is
    begin

        g_config.output_mode :=
            upper(p_value);


    end;




    ----------------------------------------------------------------------------
    -- Test package name
    ----------------------------------------------------------------------------

    function get_test_package_name
    (
        p_package_name varchar2
    )
    return varchar2
    is
    begin


        return upper(p_package_name)
               ||
               ut_constants.c_test_package_suffix;



    end;




    ----------------------------------------------------------------------------
    -- Reset
    ----------------------------------------------------------------------------

    procedure reset
    is
    begin

        initialize;


    end;




begin

    initialize;


end ut_config;
/
