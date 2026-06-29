CREATE OR REPLACE NONEDITIONABLE PACKAGE ut_code_generator IS

    PROCEDURE generate_plsql_block(
        p_package_name    IN VARCHAR2,
        p_object_name     IN VARCHAR2,
        o_declare_block   OUT CLOB,
        o_executable_block OUT CLOB
    );

END ut_code_generator;
/
CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY ut_code_generator IS

    ----------------------------------------------------------------------
    FUNCTION is_scalar(p_type VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN UPPER(p_type) IN (
            'VARCHAR2','CHAR','NUMBER','DATE',
            'TIMESTAMP','TIMESTAMP WITH TIME ZONE',
            'TIMESTAMP WITH LOCAL TIME ZONE',
            'CLOB','BLOB'
        );
    END;

    ----------------------------------------------------------------------
    FUNCTION default_value(p_type VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        CASE UPPER(p_type)
            WHEN 'VARCHAR2' THEN RETURN '''123''';
            WHEN 'CHAR' THEN RETURN '''A''';
            WHEN 'NUMBER' THEN RETURN '0';
            WHEN 'DATE' THEN RETURN 'SYSDATE';
            ELSE RETURN 'NULL';
        END CASE;
    END;

    ----------------------------------------------------------------------
    FUNCTION resolve_type(r ALL_ARGUMENTS%ROWTYPE) RETURN VARCHAR2 IS
    BEGIN
        IF r.TYPE_OWNER IS NOT NULL THEN
            RETURN LOWER(r.TYPE_OWNER || '.' || r.TYPE_NAME);

        ELSIF UPPER(r.DATA_TYPE) = 'VARCHAR2' THEN
            RETURN 'varchar2(' || NVL(r.DATA_LENGTH,4000) || ')';

        ELSIF UPPER(r.DATA_TYPE) = 'NUMBER' THEN
            RETURN 'number';

        ELSE
            RETURN LOWER(r.DATA_TYPE);
        END IF;
    END;

    ----------------------------------------------------------------------
    FUNCTION build_var_name(p_name VARCHAR2, p_in_out VARCHAR2)
    RETURN VARCHAR2 IS
    BEGIN
        IF p_in_out = 'IN' THEN
            RETURN 'i_' || LOWER(p_name);
        ELSIF p_in_out = 'OUT' THEN
            RETURN 'o_' || LOWER(p_name);
        ELSE
            RETURN 'io_' || LOWER(p_name);
        END IF;
    END;

    ----------------------------------------------------------------------
    FUNCTION get_object_type(
        p_package VARCHAR2,
        p_object  VARCHAR2
    ) RETURN VARCHAR2 IS
        l_type VARCHAR2(30);
    BEGIN
        SELECT object_type
        INTO l_type
        FROM all_objects
        WHERE owner = USER
          AND object_name = UPPER(p_object)
          AND ROWNUM = 1;

        RETURN l_type;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'PROCEDURE';
    END;

    ----------------------------------------------------------------------
    PROCEDURE generate_plsql_block(
        p_package_name    IN VARCHAR2,
        p_object_name     IN VARCHAR2,
        o_declare_block   OUT CLOB,
        o_executable_block OUT CLOB
    ) IS

        l_decl   CLOB := '';
        l_exec   CLOB := '';
        l_call   CLOB := '';
        l_assert CLOB := CHR(10) || '    -- Assert' || CHR(10);

        l_first BOOLEAN := TRUE;
        l_var   VARCHAR2(4000);

        l_obj_type VARCHAR2(30);
        l_is_function BOOLEAN := FALSE;

        l_return_var VARCHAR2(4000) := 'o_result';

    BEGIN

        ------------------------------------------------------------------
        -- detect object type
        ------------------------------------------------------------------
        l_obj_type := get_object_type(p_package_name, p_object_name);

        IF l_obj_type = 'FUNCTION' THEN
            l_is_function := TRUE;

            -- FUNCTION return variable ALWAYS declared
            l_decl := l_decl ||
                '    ' || l_return_var || ' varchar2(4000);' || CHR(10);
        END IF;

        ------------------------------------------------------------------
        -- ARRANGE
        ------------------------------------------------------------------
        l_exec := l_exec || '    -- Arrange' || CHR(10);

        ------------------------------------------------------------------
        -- ACT start
        ------------------------------------------------------------------
        l_call := '    -- Act' || CHR(10) || '    ibs.';

        IF l_is_function THEN
            l_call := l_call || l_return_var || ' := ';
        END IF;

        l_call := l_call ||
            initcap(p_package_name) || '.' || initcap(p_object_name) || '(';

        ------------------------------------------------------------------
        -- arguments
        ------------------------------------------------------------------
        FOR r IN (
            SELECT *
            FROM all_arguments
            WHERE owner = USER
              AND package_name = UPPER(p_package_name)
              AND object_name = UPPER(p_object_name)
              AND argument_name IS NOT NULL
            ORDER BY position, sequence
        )
        LOOP

            l_var := build_var_name(r.argument_name, r.IN_OUT);

            ------------------------------------------------------------------
            -- DECLARE (ALL params)
            ------------------------------------------------------------------
            l_decl := l_decl ||
                '    ' || l_var || ' ' || resolve_type(r) || ';' || CHR(10);

            ------------------------------------------------------------------
            -- ARRANGE (only IN)
            ------------------------------------------------------------------
            IF r.IN_OUT = 'IN' THEN
                l_exec := l_exec ||
                    '    ' || l_var || ' := ' ||
                    default_value(r.DATA_TYPE) || ';' || CHR(10);
            END IF;

            ------------------------------------------------------------------
            -- CALL
            ------------------------------------------------------------------
            IF l_first THEN
                l_first := FALSE;
            ELSE
                l_call := l_call || ',' || CHR(10) || '        ';
            END IF;

            l_call := l_call ||
                r.argument_name || ' => ' || l_var;

            ------------------------------------------------------------------
            -- ASSERT
            ------------------------------------------------------------------
            IF r.IN_OUT IN ('OUT','IN/OUT') THEN
                l_assert := l_assert ||
                    '    ut3.ut.expect(' || l_var || ').to_be_not_null();' || CHR(10);
            END IF;

        END LOOP;

        ------------------------------------------------------------------
        -- close call
        ------------------------------------------------------------------
        l_call := l_call || ');';

        ------------------------------------------------------------------
        -- FUNCTION ASSERT (return value)
        ------------------------------------------------------------------
        IF l_is_function THEN
            l_assert := l_assert ||
                '    ut3.ut.expect(' || l_return_var || ').to_be_not_null();' || CHR(10);
        END IF;

        ------------------------------------------------------------------
        -- OUTPUT
        ------------------------------------------------------------------
        o_declare_block := l_decl;

        o_executable_block :=
            l_exec || CHR(10) ||
            l_call || CHR(10) ||
            l_assert;

    END generate_plsql_block;

END ut_code_generator;
/
