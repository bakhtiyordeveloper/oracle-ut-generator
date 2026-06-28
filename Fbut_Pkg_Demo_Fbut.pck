create or replace noneditionable package Fbut_Pkg_Demo_Fbut is
	
	-- %suite (Fbut_Pkg_Demo tests)
	
	-------------------------------------------------------------------------------------------------------------
	--%beforeeach (Create savepoint)
	Procedure Create_Savepoint;
	-------------------------------------------------------------------------------------------------------------
	--%aftereach (Rollback to savepoint)
	Procedure Rollback_to_Savepoint;
	-------------------------------------------------------------------------------------------------------------
	-- %test(Create_Customer)
	Procedure Test_Create_Customer;
	-------------------------------------------------------------------------------------------------------------
	-- %test(Delete_Customer)
	Procedure Test_Delete_Customer;
	-------------------------------------------------------------------------------------------------------------
	-- %test(Customer_Count)
	Procedure Test_Customer_Count;
	-------------------------------------------------------------------------------------------------------------
	
end Fbut_Pkg_Demo_Fbut;
/
create or replace noneditionable package body FBUT_PKG_DEMO_FBUT is
	
	-------------------------------------------------------------------------------------------------------------
	-- Create savepoint
	Procedure Create_Savepoint is begin
			Savepoint ut_test_sp;
	end;
	-------------------------------------------------------------------------------------------------------------
	-- Rollback to savepoint
	Procedure Rollback_to_Savepoint is begin
			Rollback to ut_test_sp;
	end;
	-------------------------------------------------------------------------------------------------------------
	-- Test_Create_Customer
	Procedure Test_Create_Customer is begin
			Fbut_Pkg_Demo.Create_Customer;
	End Test_Create_Customer;	
	-------------------------------------------------------------------------------------------------------------
	-- Test_Delete_Customer
	Procedure Test_Delete_Customer is begin
			Fbut_Pkg_Demo.Delete_Customer;
	End Test_Delete_Customer;	
	-------------------------------------------------------------------------------------------------------------
	-- Test_Customer_Count
	Procedure Test_Customer_Count is begin
			Fbut_Pkg_Demo.Customer_Count;
	End Test_Customer_Count;	
	-------------------------------------------------------------------------------------------------------------
end Fbut_Pkg_Demo_Fbut;
/
