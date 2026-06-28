create or replace noneditionable package ut_constants
is
    ----------------------------------------------------------------------------
    -- Framework information
    ----------------------------------------------------------------------------
    c_framework_name constant varchar2(100) := 'FBUT Framework';

    c_framework_version constant varchar2(20) := '1.0.0';

    c_framework_author constant varchar2(100) := 'ChatGPT + User';

    ----------------------------------------------------------------------------
    -- Naming
    ----------------------------------------------------------------------------
    c_test_package_suffix constant varchar2(20) := '_FBUT';

    ----------------------------------------------------------------------------
    -- Builder
    ----------------------------------------------------------------------------
    c_indent_size constant pls_integer := 4;

    c_new_line constant varchar2(2) := chr(10);

    ----------------------------------------------------------------------------
    -- Modes
    ----------------------------------------------------------------------------
    c_mode_preview constant varchar2(20) := 'PREVIEW';

    c_mode_compile constant varchar2(20) := 'COMPILE';

    ----------------------------------------------------------------------------
    -- Data Types
    ----------------------------------------------------------------------------
    c_type_number constant varchar2(30) := 'NUMBER';

    c_type_varchar2 constant varchar2(30) := 'VARCHAR2';

    c_type_date constant varchar2(30) := 'DATE';

    c_type_timestamp constant varchar2(30) := 'TIMESTAMP';

    c_type_boolean constant varchar2(30) := 'BOOLEAN';

    c_type_clob constant varchar2(30) := 'CLOB';

    c_type_blob constant varchar2(30) := 'BLOB';

    c_type_raw constant varchar2(30) := 'RAW';

    c_type_xmltype constant varchar2(30) := 'XMLTYPE';

    c_type_json constant varchar2(30) := 'JSON';

    ----------------------------------------------------------------------------
    -- Metadata
    ----------------------------------------------------------------------------
    c_in constant varchar2(10) := 'IN';

    c_out constant varchar2(10) := 'OUT';

    c_in_out constant varchar2(10) := 'IN/OUT';

    ----------------------------------------------------------------------------
    -- Status
    ----------------------------------------------------------------------------
    c_success constant varchar2(20) := 'SUCCESS';

    c_failed constant varchar2(20) := 'FAILED';

end ut_constants;
/
create or replace noneditionable package body ut_constants
is

    g_version constant varchar2(20) := '1.0.0';

begin
    null;
end ut_constants;
/
