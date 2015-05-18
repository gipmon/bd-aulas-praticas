use p4g5;

go
-- ex a)
CREATE PROCEDURE company.sp_remove_employee
	@Ssn int
WITH ENCRYPTION
AS
	BEGIN TRANSACTION;

	BEGIN TRY
		DELETE FROM company.dependent WHERE dependent.Essn = @Ssn;
		DELETE FROM company.works_on WHERE works_on.Essn = @Ssn;
		DELETE FROM company.employee WHERE employee.Ssn = @Ssn;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		RAISERROR ('An error occurred when removing the employee!', 14, 1)
		ROLLBACK TRANSACTION;
	END CATCH;

go
EXEC company.sp_remove_employee @Ssn = null;

go
-- ex b)