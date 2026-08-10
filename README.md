# YearlyBudgetUploading

YearlyBudgetUploading provides a single SQL view (GLBudgetYearlyView) that normalizes and expands multi-year GL budget data from several expense-category tables (CapitalBudget, ItemBudget, UtilitiesBudget, TravelBudget, OtherBudget) together with the FinBudget header and a fiscal calendar. The view is intended as a ready data source for reporting tools such as Power BI or Excel where budgets are analyzed year-by-year.

## What this does
- Unions multiple category-specific budget tables into one canonical dataset.
- Calculates a BudgetIniciationYear per budget and expands each budget across fiscal years using a FiscalCalendarYear table.
- For each (budget, year) row the view returns the applicable Rate, Quantity, BudgetRevision and BudgetGranted columns for that year.

## Key tables (schema inferred from GLBudgetYearlyView.SQL)
- FinBudget
  - BudgetID (PK) — budget header
  - BudgetStartDt (DATE)
  - BudgetEndDt (DATE)
  - (other header fields...)

- CapitalBudget, ItemBudget, UtilitiesBudget, TravelBudget, OtherBudget (one table per expense category)
  - BudgetID (FK -> FinBudget.BudgetID)
  - Line
  - GL
  - ItemCode
  - RateOfYear1, QuantityOfYear1, BudgetRevisionOfYear1, BudgetGrantedOfYear1
  - RateOfYear2, QuantityOfYear2, ...
  - ...
  - RateOfYearN, QuantityOfYearN, BudgetRevisionOfYearN, BudgetGrantedOfYearN

- FiscalCalendarYear
  - Name (INT or YEAR) — used to join and produce one row per fiscal year

Notes
- The SQL view uses a parameter N to indicate how many consecutive year columns (Year1..YearN) are present on each expense-category table. The view logic maps Calendar.Name - BudgetIniciationYear = K to the corresponding RateOfYear(K+1)/QuantityOfYear(K+1)/... columns.

## How GLBudgetYearlyView works (summary)
1. For each expense-category table the view selects the category's rows and computes a BudgetIniciationYear based on FinBudget's start/end dates and N.
2. It unions those selects into one derived table (BUDGET).
3. It left-joins FiscalCalendarYear (Calendar) to expand each budget into multiple year rows between BudgetIniciationYear and BudgetIniciationYear + N.
4. CASE expressions map the appropriate Year# column (RateOfYearX, QuantityOfYearX, BudgetRevisionOfYearX, BudgetGrantedOfYearX) into normalized columns RateOfYear, QuantityOfYear, BudgetRevisionOfYear, BudgetGrantedOfYear based on Calendar.Name - BudgetIniciationYear.

This results in a view with columns such as:
- ExpenseCategoryName, BudgetIniciationYear, BudgetID, Line, GL, ItemCode, RateOfYear, QuantityOfYear, BudgetRevisionOfYear, BudgetGrantedOfYear

## Schema relationship sketch (ER-style ASCII)

FinBudget (1) ── (N) ExpenseCategory tables (CapitalBudget / ItemBudget / UtilitiesBudget / TravelBudget / OtherBudget)
  FinBudget.BudgetID PK
      |
      |-- BudgetID FK on each ExpenseCategory table

Each ExpenseCategory table contains repeated Year columns (RateOfYear1..N, QuantityOfYear1..N, BudgetRevisionOfYear1..N, BudgetGrantedOfYear1..N)

FiscalCalendarYear
  - Name (year)

Join/expansion logic
  ExpenseCategory.*  JOIN FinBudget ON ExpenseCategory.BudgetID = FinBudget.BudgetID
      → compute BudgetInitiationYear (based on BudgetStartDt, BudgetEndDt and N)
  LEFT JOIN FiscalCalendarYear Calendar ON Calendar.Name BETWEEN BudgetInitiationYear AND (BudgetIniciationYear + N)

Resulting view row: (ExpenseCategoryName, BudgetIniciationYear, BudgetID, Line, GL, ItemCode, RateOfYear, QuantityOfYear, BudgetRevisionOfYear, BudgetGrantedOfYear) per calendar year

## Diagram (simple)

  FinBudget
     | BudgetID (PK)
     |
     +--> CapitalBudget (BudgetID FK)
     +--> ItemBudget (BudgetID FK)
     +--> UtilitiesBudget (BudgetID FK)
     +--> TravelBudget (BudgetID FK)
     +--> OtherBudget (BudgetID FK)

  FiscalCalendarYear
     | Name (year value)
     |
     +-- joined to the UNIONed budget rows to expand them across years

## Recommendations / next steps
- Make N an explicit constant (or a view-per-N) or use a table-driven long format for budgets (one row per budget-year) to avoid CASE proliferation and repeated columns for each year.
- Add indexes on FinBudget.BudgetID and on FiscalCalendarYear.Name to improve JOIN performance.
- Document the columns for each expense-category table (RateOfYear1..N etc.) in the repository so downstream users know the maximum supported N.

## How to use in Power BI / Excel
- Point Power BI to the GLBudgetYearlyView; you will get one row per budget+year with the normalized Rate/Quantity/Revision/Granted columns.
- Use Calendar.Name as Year in visuals and aggregate RateOfYear * QuantityOfYear (if appropriate) to get amounts.

## Files
- GLBudgetYearlyView.SQL — the view definition (see repository)

---

Author: Syfur Rahaman Shohag
Updated: 2026-08-10
