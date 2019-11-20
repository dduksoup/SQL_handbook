-- Creating and storing global variable

DECLARE @PRM_ALLOC_LEVEL AS INT
SET @PRM_ALLOC_LEVEL = 500000

DECLARE @VAL_M AS INT
DECLARE @VAL_Y AS INT
SET @VAL_M = (SELECT MONTH(END_DATE) FROM Val_Date)
SET @VAL_Y = (SELECT YEAR(END_DATE) FROM Val_Date)


DECLARE @SWITCH_ROUNDING AS INT
SET @SWITCH_ROUNDING = 1

-- Unpivoting a table
-- See below link for more info (pivot and unpivot functions in SQL Server)
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/from-using-pivot-and-unpivot?view=sql-server-2017

SELECT VendorID, Employee, Orders  
FROM   
   (SELECT VendorID, Emp1, Emp2, Emp3, Emp4, Emp5  
   FROM pvt) p  
UNPIVOT  
   (Orders FOR Employee IN   
      (Emp1, Emp2, Emp3, Emp4, Emp5)  
)AS unpvt;  
GO  

-- Calculate difference in time between two dates
-- See below link on more info on the required parameters, etc
-- https://www.w3schools.com/sql/func_sqlserver_datediff.asp

DATEDIFF(interval, date1, date2)

-- Cross apply
-- The APPLY operator is similar to the JOIN operator, but the difference is that the right-hand side operator of APPLY can reference columns from the left-hand side. Here are two very quick examples:
-- As you in the examples there are both CROSS APPLY and OUTER APPLY. The difference between these two is what happens when the right-hand side returns no rows. With OUTER APPLY, the row from the left-hand side is retained, showing NULLs in all columns from the right-hand side. With CROSS APPLY, the row on the left-hand side is removed from the result set.

SELECT a.col, b.resultcol
FROM     dbo.tbl a
CROSS    APPLY dbo.mytblfunc(a.somecol) AS b
That is, you call a table-valued function where the parameters comes from the table.

SELECT C.CustomerName, O.*
FROM     Customers C
OUTER    APPLY (SELECT TOP 1 *
                            FROM     Orders O
                            WHERE    C.CustomerID = O.CustomerID
                            ORDER    BY O.OrderDate DESC, O.OrderID DESC) AS O

-- Return top n rows for each category

WITH TOPTEN AS (
    SELECT *, ROW_NUMBER() 
    over (
        PARTITION BY [group_by_field] 
        order by [prioritise_field]
    ) AS RowNo 
    FROM [table_name]
)
SELECT * FROM TOPTEN WHERE RowNo <= 10

-- UserDefinedFunction: Return the greater of two float parameters

CREATE FUNCTION [DBO].[GREATER] (
	@val1 float
	, @val2 float
	)
	RETURNS float

BEGIN
	DECLARE @returnval float;

	set @returnval = (SELECT CASE
			WHEN @val1 >= @val2
				THEN @val1
			WHEN @VAL1 < @val2
				THEN @val2
			ELSE NULL
			END AS RETVAL)
	RETURN @RETURNVAL
END;

SELECT DBO.[GREATER](5+5, 4)


-- sys.columns and object id
	    
	    

select quotename(name)
from sys.columns
where [object_id] = object_id(N'dbo.[struc_ul]')

select object_id(N'dbo.[struc_ul]'), quotename(name)
from sys.columns
where [object_id] = object_id(N'dbo.[struc_ul]')

-- Return rows with a NULL value in any of its columns

-- Construct custom procedure
DECLARE @TB NVARCHAR(512) = N'DBO.[_UL_NULLvalues]';

DECLARE @SQL NVARCHAR(MAX) = N'SELECT * FROM ' + @TB
    + ' WHERE 1 = 0';

SELECT @SQL += N' OR ' + QUOTENAME(NAME) + ' IS NULL'
    FROM SYS.COLUMNS 
    WHERE [OBJECT_ID] = OBJECT_ID(@TB);

-- Run procedure
EXEC SYS.SP_EXECUTESQL @SQL;
	    
-- Create custom procedure
	    
Create function dbo.[MakeISODate] 
	(@inputdate numeric) 
	RETURNS date
	BEGIN
		Declare @returndate date;

		Set @returndate = convert(date, convert(nvarchar, convert(numeric, @inputdate)))

		Return @returndate
	END;
	
select dbo.[makedate](20191205.0555)

-- Extract 5 digit substring
	    
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION GetFiveDigits 
(
	@src varchar(255)
)
RETURNS varchar(5)
AS
BEGIN
	DECLARE @retVal varchar(5)
	declare @srcLen int
    declare @curPos int

    if @src is null 
          return null

	select @srcLen = datalength(@src), @curPos = 1, @retVal=''
    While @curPos <= @srcLen
	begin
		if substring(@src,@curpos,1) like '[0-9]'
			select @retVal=@retVal + substring(@src,@curpos,1)
		else
			select @retVal=''
		if datalength(@retVal)=5
			return @retVal
		Select @curPos = @curPos + 1
	end
		if datalength(@retVal)=5
			return @retVal
		--else 
			return null
END
GO

-- user defined function for calculating age nearest birthday
	    
use ACT_DATA_201903
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAgeNB] (@BirthDate numeric, @CompDate numeric)
RETURNS INT
AS
BEGIN
	DECLARE @Bd int set @Bd = cast(right(@BirthDate, 2) as int)
	DECLARE @Bm int set @Bm = cast(left(right(@BirthDate, 4), 2) as int)
	DECLARE @By int set @By = cast(left(@BirthDate, 4) as int)
	DECLARE @Cd int set @Cd = cast(right(@CompDate, 2) as int)
	DECLARE @Cm int set @Cm = cast(left(right(@CompDate, 4), 2) as int)
	DECLARE @Cy int set	@Cy = cast(left(@CompDate, 4) as int)
	
	DECLARE @Result Int
	Set @Result = (CASE
		WHEN @Bm < @Cm THEN (CASE
			WHEN @CM - @BM < 6 THEN @CY - @BY
			WHEN @CM - @BM = 6 THEN (CASE
				WHEN @BD <= @CD THEN @CY - @BY + 1
				ELSE @CY - @BY
				END)
			ELSE @CY - @BY + 1
			END)
		WHEN @BM = @CM THEN @CY - @BY
		ELSE (CASE
			WHEN @BM - @CM < 6 THEN @CY - @BY
			WHEN @BM - @CM = 6 THEN (CASE
				WHEN @BD > @CD THEN @CY - @BY - 1
				ELSE @CY - @BY
				END)
			ELSE @CY - @BY - 1
			END)
		END)

	RETURN @RESULT
END
		
-- UDF: Policy month calculator 
	

CREATE FUNCTION [dbo].[PolMonth] (@DateA DATE, @DateB DATE)

RETURNS INT 
as

BEGIN
	-- Declare variables
	Declare @Result		INT
	Declare @DateX		Date --starting date
	Declare @DateY		Date --ending date
	
	Set @Datex = @DateA
	Set @Datey = @DateB

	SET @Result = (
		SELECT DATEDIFF(MONTH, @datex, @datey)
			+ (CASE
				when datepart(DAY, @datex) < datepart(DAY, @datey) then 1
				else 0
				end)
		)

	RETURN @Result
END
GO

