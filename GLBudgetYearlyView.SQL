/*
# Author: Syfur Rahaman Shohag
# GL Budget All Components Union View
# Yearly Budget Uploading for GL
# Date: 12-04-2026
*/

USE AXDB;

GO
-- DECLARE @N INTEGER = 5;
-- N indicates the number of consecutive year columns visibility 
-- From Year1,...,YearN in GL Budget Categories
-- You can convert it to functions for reusbaility, 
-- View can be directly used for Power BI or Excel Datasource

CREATE VIEW GLBudgetYearlyView AS

    SELECT     
    Budget.ExpenseCategoryName, 
    Budget.BudgetIniciationYear, 
    Budget.BudgetID, 
    Budget.Line, 
    Budget.GL, 
    Budget.ItemCode,
    
    CASE 
    	WHEN Calendar.Name - BudgetIniciationYear = 0 THEN Budget.RateOfYear1 
    	WHEN Calendar.Name - BudgetIniciationYear = 1 THEN Budget.RateOfYear2 
    	WHEN Calendar.Name - BudgetIniciationYear = 2 THEN Budget.RateOfYear3 
    	-- .
    	-- .
    	-- .
    	WHEN Calendar.Name - BudgetIniciationYear = (N-1) THEN Budget.RateOfYearN
    	ELSE 0 
    END AS RateOfYear, 
    
    CASE	
    	WHEN Calendar.Name - BudgetIniciationYear = 0 THEN Budget.QuantityOfYear1 
    	WHEN Calendar.Name - BudgetIniciationYear = 1 THEN Budget.QuantityOfYear2 
    	WHEN Calendar.Name - BudgetIniciationYear = 2 THEN Budget.QuantityOfYear3 
    	-- .
    	-- .
    	-- .
    	WHEN Calendar.Name - BudgetIniciationYear = (N-1) THEN Budget.QuantityOfYearN
    	ELSE 0 
    END AS QuantityOfYear,
    
    CASE	
    	WHEN Calendar.Name - BudgetIniciationYear = 0 THEN Budget.BudgetRevisionOfYear1 
    	WHEN Calendar.Name - BudgetIniciationYear = 1 THEN Budget.BudgetRevisionOfYear2 
    	WHEN Calendar.Name - BudgetIniciationYear = 2 THEN Budget.BudgetRevisionOfYear3 
    	-- .
    	-- .
    	-- .
    	WHEN Calendar.Name - BudgetIniciationYear = (N-1) THEN Budget.BudgetRevisionOfYearN
    	ELSE 0
    END AS BudgetRevisionOfYear,
    
    CASE	
    	WHEN Calendar.Name - BudgetIniciationYear = 0 THEN Budget.BudgetGrantedOfYear1 
    	WHEN Calendar.Name - BudgetIniciationYear = 1 THEN Budget.BudgetGrantedOfYear2 
    	WHEN Calendar.Name - BudgetIniciationYear = 2 THEN Budget.BudgetGrantedOfYear3 
    	-- .
    	-- .
    	-- .
    	WHEN Calendar.Name - BudgetIniciationYear = (N-1) THEN Budget.BudgetGrantedOfYearN
    	ELSE 0
    END AS BudgetGrantedOfYear,
    
    				   
    FROM        
    (
    		SELECT 
    		'CapitalBudget' AS ExpenseCategoryName, 
    		CASE 
    			WHEN (YEAR(Budget.BudgetEndDt) - YEAR(Budget.BudgetStartDt)) <= N 
    				 THEN YEAR(Budget.BudgetStartDt) 
    			ELSE (YEAR(Budget.BudgetEndDt) - N) 
    		END AS BudgetIniciationYear,
    		
    		 ExpenseCategory.BudgetID, 
    		 ExpenseCategory.Line, 
    		 ExpenseCategory.GL, 
    		 ExpenseCategory.ItemCode, 
    		  
    		 ExpenseCategory.RateOfYear1, 
    		 ExpenseCategory.QuantityOfYear1, 
    		 ExpenseCategory.BudgetRevisionOfYear1, 
    		 ExpenseCategory.BudgetGrantedOfYear1,
    		 
    		 ExpenseCategory.RateOfYear2, 
    		 ExpenseCategory.QuantityOfYear2, 
    		 ExpenseCategory.BudgetRevisionOfYear2, 
    		 ExpenseCategory.BudgetGrantedOfYear2,
         -- .
         -- .
         -- .
    		 ExpenseCategory.RateOfYearN, 
    		 ExpenseCategory.QuantityOfYearN, 
    		 ExpenseCategory.BudgetRevisionOfYearN, 
    		 ExpenseCategory.BudgetGrantedOfYearN
    		 
    	   FROM CapitalBudget AS ExpenseCategory 
    	   INNER JOIN FinBudget AS Budget ON Budget.BudgetID = ExpenseCategory.BudgetID
    						 
    	   UNION
    	   
    	   SELECT 
    		'ItemBudget' AS ExpenseCategoryName, 
    		CASE 
    			WHEN (YEAR(Budget.BudgetEndDt) - YEAR(Budget.BudgetStartDt)) <= N 
    				 THEN YEAR(Budget.BudgetStartDt) 
    			ELSE (YEAR(Budget.BudgetEndDt) - N) 
    		END AS BudgetIniciationYear,
    		
    		 ExpenseCategory.BudgetID, 
    		 ExpenseCategory.Line, 
    		 ExpenseCategory.GL, 
    		 ExpenseCategory.ItemCode, 
    		  
    		 ExpenseCategory.RateOfYear1, 
    		 ExpenseCategory.QuantityOfYear1, 
    		 ExpenseCategory.BudgetRevisionOfYear1, 
    		 ExpenseCategory.BudgetGrantedOfYear1,
    		 
    		 ExpenseCategory.RateOfYear2, 
    		 ExpenseCategory.QuantityOfYear2, 
    		 ExpenseCategory.BudgetRevisionOfYear2, 
    		 ExpenseCategory.BudgetGrantedOfYear2,
         -- .
         -- .
         -- .
    		 ExpenseCategory.RateOfYearN, 
    		 ExpenseCategory.QuantityOfYearN, 
    		 ExpenseCategory.BudgetRevisionOfYearN, 
    		 ExpenseCategory.BudgetGrantedOfYearN
    		 
    	   FROM ItemBudget AS ExpenseCategory 
    	   INNER JOIN FinBudget AS Budget ON Budget.BudgetID = ExpenseCategory.BudgetID
    
    	   UNION
    	   
    	   SELECT 
    		'UtilitiesBudget' AS ExpenseCategoryName, 
    		CASE 
    			WHEN (YEAR(Budget.BudgetEndDt) - YEAR(Budget.BudgetStartDt)) <= N 
    				 THEN YEAR(Budget.BudgetStartDt) 
    			ELSE (YEAR(Budget.BudgetEndDt) - N) 
    		END AS BudgetIniciationYear,
    		
    		 ExpenseCategory.BudgetID, 
    		 ExpenseCategory.Line, 
    		 ExpenseCategory.GL, 
    		 ExpenseCategory.ItemCode, 
    		  
    		 ExpenseCategory.RateOfYear1, 
    		 ExpenseCategory.QuantityOfYear1, 
    		 ExpenseCategory.BudgetRevisionOfYear1, 
    		 ExpenseCategory.BudgetGrantedOfYear1,
    		 
    		 ExpenseCategory.RateOfYear2, 
    		 ExpenseCategory.QuantityOfYear2, 
    		 ExpenseCategory.BudgetRevisionOfYear2, 
    		 ExpenseCategory.BudgetGrantedOfYear2,
         -- .
         -- .
         -- .
    		 ExpenseCategory.RateOfYearN, 
    		 ExpenseCategory.QuantityOfYearN, 
    		 ExpenseCategory.BudgetRevisionOfYearN, 
    		 ExpenseCategory.BudgetGrantedOfYearN
    		 
    	   FROM UtilitiesBudget AS ExpenseCategory 
    	   INNER JOIN FinBudget AS Budget ON Budget.BudgetID = ExpenseCategory.BudgetID
    	   
    	   UNION
    	   
    	   SELECT 
    		'TravelBudget' AS ExpenseCategoryName, 
    		CASE 
    			WHEN (YEAR(Budget.BudgetEndDt) - YEAR(Budget.BudgetStartDt)) <= N 
    				 THEN YEAR(Budget.BudgetStartDt) 
    			ELSE (YEAR(Budget.BudgetEndDt) - N) 
    		END AS BudgetIniciationYear,
    		
    		 ExpenseCategory.BudgetID, 
    		 ExpenseCategory.Line, 
    		 ExpenseCategory.GL, 
    		 ExpenseCategory.ItemCode, 
    		  
    		 ExpenseCategory.RateOfYear1, 
    		 ExpenseCategory.QuantityOfYear1, 
    		 ExpenseCategory.BudgetRevisionOfYear1, 
    		 ExpenseCategory.BudgetGrantedOfYear1,
    		 
    		 ExpenseCategory.RateOfYear2, 
    		 ExpenseCategory.QuantityOfYear2, 
    		 ExpenseCategory.BudgetRevisionOfYear2, 
    		 ExpenseCategory.BudgetGrantedOfYear2,
         -- .
         -- .
         -- .
    		 ExpenseCategory.RateOfYearN, 
    		 ExpenseCategory.QuantityOfYearN, 
    		 ExpenseCategory.BudgetRevisionOfYearN, 
    		 ExpenseCategory.BudgetGrantedOfYearN
    		 
    	   FROM TravelBudget AS ExpenseCategory 
    	   INNER JOIN FinBudget AS Budget ON Budget.BudgetID = ExpenseCategory.BudgetID
    					 
    	   UNION
    	   
    	   SELECT 
    		'OtherBudget' AS ExpenseCategoryName, 
    		CASE 
    			WHEN (YEAR(Budget.BudgetEndDt) - YEAR(Budget.BudgetStartDt)) <= N 
    				 THEN YEAR(Budget.BudgetStartDt) 
    			ELSE (YEAR(Budget.BudgetEndDt) - N) 
    		END AS BudgetIniciationYear,
    		
    		 ExpenseCategory.BudgetID, 
    		 ExpenseCategory.Line, 
    		 ExpenseCategory.GL, 
    		 ExpenseCategory.ItemCode, 
    		  
    		 ExpenseCategory.RateOfYear1, 
    		 ExpenseCategory.QuantityOfYear1, 
    		 ExpenseCategory.BudgetRevisionOfYear1, 
    		 ExpenseCategory.BudgetGrantedOfYear1,
    		 
    		 ExpenseCategory.RateOfYear2, 
    		 ExpenseCategory.QuantityOfYear2, 
    		 ExpenseCategory.BudgetRevisionOfYear2, 
    		 ExpenseCategory.BudgetGrantedOfYear2,
         -- .
         -- .
         -- .
    		 ExpenseCategory.RateOfYearN, 
    		 ExpenseCategory.QuantityOfYearN, 
    		 ExpenseCategory.BudgetRevisionOfYearN, 
    		 ExpenseCategory.BudgetGrantedOfYearN
    		 
    	   FROM OtherBudget AS ExpenseCategory 
    	   INNER JOIN FinBudget AS Budget ON Budget.BudgetID = ExpenseCategory.BudgetID		  
    ) AS BUDGET 
    LEFT JOIN FiscalCalendarYear AS Calendar ON Calendar.Name BETWEEN Budget.BudgetIniciationYear AND (Budget.BudgetIniciationYear + N)
