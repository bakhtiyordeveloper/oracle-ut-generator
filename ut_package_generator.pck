create or replace noneditionable package ut_package_generator
is


    ----------------------------------------------------------------------------
    -- FBUT Framework
    -- Package : UT_PACKAGE_GENERATOR
    -- Version : 1.0.0
    --
    -- Full test package generator
    ----------------------------------------------------------------------------




    ----------------------------------------------------------------------------
    -- Generate complete test package
    ----------------------------------------------------------------------------

    procedure generate
    (
        p_owner          varchar2,

        p_package_name   varchar2
    );







    ----------------------------------------------------------------------------
    -- Preview generated source
    ----------------------------------------------------------------------------

    function preview
    (
        p_owner          varchar2,

        p_package_name   varchar2
    )
    return clob;







    ----------------------------------------------------------------------------
    -- Compile generated package
    ----------------------------------------------------------------------------

    procedure compile_package
    (
        p_owner             varchar2,

        p_test_package_name varchar2
    );







    ----------------------------------------------------------------------------
    -- Return last generated source
    ----------------------------------------------------------------------------

    function get_last_source
    return clob;







    ----------------------------------------------------------------------------
    -- Check generated package exists
    ----------------------------------------------------------------------------

    function exists_test_package
    (
        p_owner             varchar2,

        p_test_package_name varchar2
    )
    return boolean;







    ----------------------------------------------------------------------------
    -- Clear internal cache
    ----------------------------------------------------------------------------

    procedure clear;




end ut_package_generator;
/
create or replace noneditionable package body ut_package_generator is

  g_last_source clob;

  ----------------------------------------------------------------------------
  -- Normalize SQL
  ----------------------------------------------------------------------------

  function normalize_sql(p_sql clob) return clob
  
   is
  
    l_sql clob;
  
  begin
  
    l_sql := p_sql;
  
    l_sql := replace(l_sql, chr(13), '');
  
    l_sql := replace(l_sql, chr(10) || '/' || chr(10), chr(10));
  
    return trim(l_sql);
  
  end normalize_sql;

  ----------------------------------------------------------------------------
  -- Execute generated source
  ----------------------------------------------------------------------------

  procedure execute_clob(p_sql clob) is
  
    l_sql clob;
  
    l_head varchar2(200);
  
  begin
  
    l_sql := normalize_sql(p_sql);
  
    l_head := upper(dbms_lob.substr(l_sql, 200, 1));
  
    if instr(l_head, upper('Create or replace package')) <> 1
    
     then
    
      raise_application_error(-20030,
                              'Invalid generated source' || chr(10) ||
                              dbms_lob.substr(l_sql, 1000, 1));
    
    end if;
  
    execute immediate l_sql;
  
  end execute_clob;

  ----------------------------------------------------------------------------
  -- Check package exists
  ----------------------------------------------------------------------------

  function exists_test_package(p_owner varchar2,
                               p_test_package_name varchar2) return boolean is
    l_count number;
  begin
  
    select count(*)
    
      into l_count
    
      from all_objects
    
     where owner = upper(p_owner)
          
       and object_name = upper(p_test_package_name)
          
       and object_type = 'PACKAGE';
  
    return l_count > 0;
  
  end exists_test_package;

  ----------------------------------------------------------------------------
  -- Build SPEC
  ----------------------------------------------------------------------------

  function build_spec(p_owner varchar2,
                      
                      p_package_name varchar2
                      
                      ) return clob
  
   is
  
    l_methods ut_types.t_method_list;
  
    l_test_name varchar2(200);
  
  begin
  
    l_test_name := ut_config.get_test_package_name(p_package_name);
  
    ut_builder.clear;
  
    ut_builder.append_line('Create or replace package ' || INITCAP(l_test_name) || ' is', false);
  
    ut_builder.new_line;
  
    ut_builder.append_line('-- %suite (' || INITCAP(p_package_name) ||
                           ' tests)');
  
    ut_builder.new_line;
  
    ut_builder.append_line('-------------------------------------------------------------------------------------------------------------');
  
    ut_builder.append_line('--%beforeeach (Create savepoint)');
  
    ut_builder.append_line('Procedure Create_Savepoint;');
    
    ut_builder.append_line('-------------------------------------------------------------------------------------------------------------');
  
    ut_builder.append_line('--%aftereach (Rollback to savepoint)');
  
    ut_builder.append_line('Procedure Rollback_to_Savepoint;');
  
    ut_builder.append_line('-------------------------------------------------------------------------------------------------------------');
  
    l_methods := ut_metadata.load_methods(p_owner, p_package_name);
  
    for i in 1 .. l_methods.count
    
     loop
    
      if l_methods(i).method_name is not null
      
       then
      
        ut_builder.append_line('-- %test(' ||
                               INITCAP(l_methods(i).method_name) || ')');
      
        ut_builder.append_line('Procedure Test_' ||
                               INITCAP(l_methods(i).method_name) || ';');

        ut_builder.append_line('-------------------------------------------------------------------------------------------------------------');
      
      end if;
    
    end loop;
    
    ut_builder.new_line;
  
    ut_builder.append_line('end ' || INITCAP(l_test_name) || ';', false);
  
    return ut_builder.get_clob;
  
  end build_spec;

  ----------------------------------------------------------------------------
  -- Build BODY
  ----------------------------------------------------------------------------

  function build_body(p_owner varchar2,
                      
                      p_package_name varchar2
                      
                      ) return clob
  
   is
  
    l_methods ut_types.t_method_list;
  
    l_test_name varchar2(200);
  
  begin
  
    l_test_name := ut_config.get_test_package_name(p_package_name);
  
    ut_builder.clear;
  
    ut_builder.append_line('Create or replace package body ' || l_test_name || ' is', false);
    
    ut_builder.new_line;
    
    ut_builder.append_line('-------------------------------------------------------------------------------------------------------------');
    
    ut_builder.append_line('-- Create savepoint');
    
    ut_builder.append_line('Procedure Create_Savepoint is begin');
    
    ut_builder.append_line(chr(9) || chr(9) || 'Savepoint ut_test_sp;');
    
    ut_builder.append_line('end;');
  
    ut_builder.append_line('-------------------------------------------------------------------------------------------------------------');
    
    ut_builder.append_line('-- Rollback to savepoint');
    
    ut_builder.append_line('Procedure Rollback_to_Savepoint is begin');
    
    ut_builder.append_line(chr(9) || chr(9) || 'Rollback to ut_test_sp;');
    
    ut_builder.append_line('end;');
  
    ut_builder.append_line('-------------------------------------------------------------------------------------------------------------');
  
    l_methods := ut_metadata.load_methods(p_owner, p_package_name);
  
    for i in 1 .. l_methods.count
     loop
    
      if l_methods(i).method_name is not null then
      
        ut_builder.append_clob(ut_method_generator.generate_method_test(p_owner,
                                                                        
                                                                        p_package_name,
                                                                        
                                                                        l_methods(i).method_name,
                                                                        
                                                                        l_methods(i).subprogram_id));
      
        ut_builder.new_line;
        ut_builder.append_line('-------------------------------------------------------------------------------------------------------------');
      
      end if;
    
    end loop;
  
    ut_builder.append_line('end ' || INITCAP(l_test_name) || ';', false);
  
    return ut_builder.get_clob;
  
  end build_body;

  ----------------------------------------------------------------------------
  -- Preview
  ----------------------------------------------------------------------------

  function preview(p_owner varchar2,
                   
                   p_package_name varchar2
                   
                   ) return clob
  
   is
  
    l_spec clob;
  
    l_body clob;
  
  begin
  
    l_spec := build_spec(p_owner, p_package_name);
  
    l_body := build_body(p_owner, p_package_name);
  
    return l_spec || chr(10) || l_body;
  
  end preview;

  ----------------------------------------------------------------------------
  -- Generate
  ----------------------------------------------------------------------------

  procedure generate(p_owner varchar2,
                     
                     p_package_name varchar2
                     
                     ) is
  
    l_name varchar2(200);
  
    l_spec clob;
  
    l_body clob;
  
  begin
  
    l_name := ut_config.get_test_package_name(p_package_name);
  
    if exists_test_package(p_owner,
                           
                           l_name)
    
     then
    
      raise_application_error(-20010,
                              
                              'Package already exists: ' || l_name);
    
    end if;
  
    l_spec := build_spec(p_owner, p_package_name);
  
    l_body := build_body(p_owner, p_package_name);
  
    execute_clob(l_spec);
  
    execute_clob(l_body);
  
    g_last_source := l_spec || chr(10) || l_body;
  
  end generate;

  ----------------------------------------------------------------------------
  -- Compile package
  ----------------------------------------------------------------------------

  procedure compile_package(p_owner varchar2,
                            p_test_package_name varchar2) is
  
  begin
  
    execute immediate
    
     'alter package ' || upper(p_owner) || '.' ||
     INITCAP(p_test_package_name) || ' compile body';
  
  end compile_package;

  ----------------------------------------------------------------------------
  -- Get source
  ----------------------------------------------------------------------------

  function get_last_source return clob is
  begin
  
    return g_last_source;
  
  end;

  ----------------------------------------------------------------------------
  -- Clear
  ----------------------------------------------------------------------------

  procedure clear is
  begin
  
    g_last_source := null;
  
    ut_builder.clear;
  
  end;

end ut_package_generator;
/
