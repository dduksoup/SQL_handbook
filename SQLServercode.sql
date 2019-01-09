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
