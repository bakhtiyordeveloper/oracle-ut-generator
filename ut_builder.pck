create or replace noneditionable package ut_builder
is


    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_BUILDER
    ----------------------------------------------------------------------------



    procedure clear;



    procedure append_line
    (
        p_text varchar2,
        
        p_tab  boolean default true
    );



    procedure append_clob
    (
        p_text clob
    );



    procedure new_line;



    procedure indent;



    procedure outdent;



    procedure add_comment
    (
        p_text varchar2
    );



    function get_clob
    return clob;



end ut_builder;
/
create or replace noneditionable package body ut_builder
is


    g_buffer clob;


    g_indent_level number := 0;


    g_indent_space constant varchar2(10) := '    ';



    ----------------------------------------------------------------------------
    -- Clear
    ----------------------------------------------------------------------------

    procedure clear
    is
    begin


        if dbms_lob.istemporary(g_buffer)=1
        then

            dbms_lob.freetemporary(g_buffer);

        end if;



        dbms_lob.createtemporary
        (
            g_buffer,

            true,

            dbms_lob.call
        );



        g_indent_level := 0;



    end clear;







    ----------------------------------------------------------------------------
    -- Append line
    ----------------------------------------------------------------------------

    procedure append_line
    (
        p_text varchar2,
        
        p_tab  boolean default true
    )
    is

        l_text varchar2(32767);
        v_text varchar2(32767);

    begin
        
        if p_tab then
           v_text := chr(9) || p_text;
        else 
           v_text := p_text;
        end if;

        if g_buffer is null
        then

            clear;

        end if;




        l_text :=
            rpad
            (
                ' ',
                g_indent_level *
                length(g_indent_space)
            )
            ||
            nvl(v_text,'');



        dbms_lob.writeappend
        (
            g_buffer,

            length(l_text || chr(10)),

            l_text || chr(10)
        );



    end append_line;








    ----------------------------------------------------------------------------
    -- Append clob
    ----------------------------------------------------------------------------

    procedure append_clob
    (
        p_text clob
    )
    is
        l_offset number := 1;

        l_chunk varchar2(8000);

        l_length number;

    begin

        if p_text is null
        then

            return;

        end if;



        if g_buffer is null
        then

            clear;

        end if;


        l_length :=
            dbms_lob.getlength(p_text);




        while l_offset <= l_length

        loop

            l_chunk :=
                dbms_lob.substr
                (
                    p_text,

                    8000,

                    l_offset
                );



            dbms_lob.writeappend
            (
                g_buffer,

                length(l_chunk),

                l_chunk
            );



            l_offset :=
                l_offset
                +
                length(l_chunk);



        end loop;

    end append_clob;

    procedure new_line
    is
    begin

        append_line(null);

    end new_line;


    procedure indent
    is
    begin

        g_indent_level :=
            g_indent_level + 1;

    end indent;


    procedure outdent
    is
    begin


        if g_indent_level > 0
        then

            g_indent_level :=
                g_indent_level - 1;

        end if;


    end outdent;







    procedure add_comment
    (
        p_text varchar2
    )
    is
    begin


        append_line
        (
            '-- '
            ||
            p_text
        );


    end add_comment;








    function get_clob
    return clob

    is
    begin

        return g_buffer;

    end get_clob;





end ut_builder;
/
