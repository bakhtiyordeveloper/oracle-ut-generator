create or replace noneditionable package My_First_Package is

  -- Author  : USER
  -- Created : 25.06.2026 22:56:27
  -- Purpose : 
  
  ------------------------------------------------------------------------------------------------------------------------
  -- Calc
  Procedure Calc(i_Num1 in number, i_Num2 in number, o_Summ out number);
  ------------------------------------------------------------------------------------------------------------------------
  -- Calc2
  Function Calc2(i_Num1 in number, i_Num2 in number) return number;
  ------------------------------------------------------------------------------------------------------------------------

end My_First_Package;
/
create or replace noneditionable package body My_First_Package is

  ------------------------------------------------------------------------------------------------------------------------
  -- First parocedure
  Procedure Calc(i_Num1 in number, i_Num2 in number, o_Summ out number) is
  begin
    o_Summ := i_Num1 + i_Num2;
  exception
     when others then
        raise;
  end Calc;
  ------------------------------------------------------------------------------------------------------------------------
  -- First function
  Function Calc2(i_Num1 in number, i_Num2 in number) return number is
  begin
    return i_Num1 + i_Num2;
  exception
     when others then
        raise;
  end Calc2;
  ------------------------------------------------------------------------------------------------------------------------
end My_First_Package;
/
