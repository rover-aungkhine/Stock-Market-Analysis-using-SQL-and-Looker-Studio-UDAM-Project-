CREATE TABLE financial_metrics (
	Sector VARCHAR(50),
    Ticker VARCHAR(10),
    Company_Name VARCHAR(100),
    Financial_Year INT, 
    Market_Cap_Billion_USD DECIMAL (15, 2),
    EPS DECIMAL (5, 2),
    PE_Ratio DECIMAL (5, 2),
    PEG_Ratio DECIMAL (5, 2),
    PB_Ratio DECIMAL (5, 2),
    PS_Ratio DECIMAL (5, 2),
    ROE_Percent DECIMAL (5, 2),
    ROA_Percent DECIMAL (5, 2),
    Gross_Profit_Margin_Percent DECIMAL (5, 2),
    Operating_Margin_Percent DECIMAL (5, 2),
    Net_Profit_Margin_Percent DECIMAL (5, 2),
    Current_Ratio DECIMAL (5, 2),
    Quick_Ratio DECIMAL (5, 2),
    Debt_to_Equity_Ratio DECIMAL (5, 2),
    Interest_Coverage_Ratio DECIMAL (5, 2),
    Free_Cash_Flow_Billion_USD DECIMAL (5, 2),
    Beta DECIMAL (5, 2)
);

CREATE TABLE company_profile (
	Sector VARCHAR(50),
    Ticker VARCHAR(10), 
    Company_Name VARCHAR(100)
);

CREATE TABLE price_history (
	Ticker VARCHAR(10), 
    Company_Name VARCHAR(100),
    Price_Date DATE, 
    Close_Price DECIMAL (5, 2),
    Open_Price DECIMAL (5, 2),
    High DECIMAL (5, 2),
    Low DECIMAL (5, 2),
    Volume BIGINT
);

UPDATE financial_metrics
SET Current_Ratio = 1.54
WHERE Ticker = 'AAPL' AND
Financial_Year = 2019;

