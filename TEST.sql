begin
  -----------------------------------------------------------------
  begin
    execute immediate 'DROP PACKAGE FBUT_PKG_DEMO_FBUT';
  exception
      when others then
          null;
  end;
  -----------------------------------------------------------------
  ut_package_generator.generate(p_owner => user,
                                p_package_name => 'FBUT_PKG_DEMO');
  -----------------------------------------------------------------
end;
