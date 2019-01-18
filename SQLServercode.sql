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
