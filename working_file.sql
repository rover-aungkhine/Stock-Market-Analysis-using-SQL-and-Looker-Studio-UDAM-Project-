-- Which Company Offers the Highest Growth Potential in 2023?
SELECT ticker, PEG_ratio, max(EPS) as Max_EPS
FROM financial_metrics
WHERE PEG_ratio > 1 AND Financial_Year = 2023
GROUP BY ticker, PEG_ratio
;

-- 2. Which Company is the Most Profitable?
SELECT Financial_Year, Ticker, Net_Profit_Margin_Percent, ROE_Percent
FROM financial_metrics
WHERE (Financial_Year, Net_Profit_Margin_Percent) IN (
		SELECT Financial_Year, MAX(Net_Profit_Margin_Percent)
        FROM financial_metrics
        GROUP BY Financial_Year)
ORDER BY Financial_Year DESC;

-- 3. Which Company is the Best for Long-Term Stability?
SELECT Ticker, MAX(Market_Cap_Billion_USD) AS max_market_cap
FROM financial_metrics
GROUP BY Ticker
ORDER BY max_market_cap DESC
;

-- 4. Which Company is the Most Efficient in Managing Its Assets? (ROA, Operating_Margin)
SELECT Financial_Year, Ticker, ROA_Percent, Operating_Margin_Percent
FROM financial_metrics
WHERE (Financial_Year, ROA_Percent) IN (
		SELECT Financial_Year, MAX(ROA_Percent)
        FROM financial_metrics
        GROUP BY Financial_Year)
ORDER BY Financial_Year DESC;

SELECT Ticker, MAX(ROA_Percent) AS max_ROA
FROM financial_metrics
GROUP BY Ticker
ORDER BY max_ROA DESC
;

-- 5. Which Company is the Best for Value Investing? (PE Ratio, PB Ratio) - Lower better (minus is not good)
SELECT Ticker, Min(PE_Ratio) AS Lowest_PE, min(PB_Ratio) AS Lowest_PB
FROM financial_metrics
GROUP BY Ticker
ORDER BY Lowest_PE;

-- 6. Which Company Has the Best Financial Health? (Current Ratio high, Debt to Equity low = good stock)
SELECT Ticker, Current_Ratio, Debt_to_Equity_Ratio
FROM financial_metrics as fm
WHERE Current_Ratio = (
		SELECT max(Current_Ratio) 
        FROM financial_metrics
        WHERE Ticker = fm.Ticker
)
AND
Debt_to_Equity_Ratio = (
		SELECT min(Debt_to_Equity_Ratio)
        FROM financial_metrics
        WHERE Ticker = fm.Ticker
)

ORDER BY Ticker;

SELECT Ticker, Current_Ratio, Debt_to_Equity_Ratio
FROM financial_metrics
WHERE (Ticker, Current_Ratio, Debt_to_Equity_Ratio) IN (
		SELECT Ticker, MAX(Current_Ratio), MIN(Debt_to_Equity_Ratio)
        FROM financial_metrics
        GROUP BY Ticker)
ORDER BY Ticker DESC;


-- 7. Which Company is Best Positioned for Economic Downturns? (Quick Ratio and Interest Coverage Ratio) 
SELECT Ticker, max(Quick_Ratio) As max_quick_ratio, max(Interest_Coverage_Ratio) AS max_interest_coverage
FROM financial_metrics
GROUP BY Ticker
ORDER BY max_quick_ratio DESC;

-- 8. Which Company is Most Cost-Effective in Generating Revenue? (Gross_Profit)
SELECT Financial_Year, Ticker, Gross_Profit_Margin_Percent
FROM financial_metrics
WHERE (Financial_Year, Gross_Profit_Margin_Percent) IN (
		SELECT Financial_Year, MAX(Gross_Profit_Margin_Percent)
        FROM financial_metrics
        GROUP BY Financial_Year)
ORDER BY Financial_Year DESC;

-- 9. Which Company is the Most Volatile (High-Risk, High-Reward)?

-- 10. Which Company is the Low Volatile (Low-Risk, Low-Reward)?

-- Criteria 
-- P/E ratio = 1-20 
-- Debt to equity ratio: 0–1
-- Market Cap (Small, Mid, Large)
-- P/B ratio = Less than 10 
-- ROE = Abov 20%
-- Operating Profit Margin = Above 12% and keep improving
-- Net Profit Margin = Above 12% and keep improving
-- PEG ratio between 0.5 to 1
-- Calculation of Fair Value (Fair Value = P/E * EPS(u have to predict the eps as per the growth of stock for setting the target price) 
-- If the Stock Price > Fair Value than the stock is overvalued else it is undervalued
-- Beta (Less than 1 = low risk, Greater than 1 = high risk)
 
 -- Criteria checking
SELECT * 
FROM financial_metrics
WHERE PE_Ratio between 1 and 20 AND
Debt_to_Equity_Ratio between 0 and 1 AND
PB_Ratio < 10 AND
ROE_Percent > 20 AND
Operating_Margin_Percent >= 12 AND
Net_Profit_Margin_Percent >= 12
;


-- Calculation of Fair Value
SELECT fm.Ticker, Financial_Year, (PE_Ratio * EPS) AS Fair_Value,
(CASE WHEN fm.Financial_Year = 2023  THEN 
(SELECT ph.Close_Price
FROM price_history ph
WHERE ph.Ticker = fm.Ticker AND Price_Date = '2023-12-29') 
WHEN fm.Financial_Year = 2021 THEN 
            (SELECT ph.Close_Price 
             FROM price_history ph 
             WHERE ph.Ticker = fm.Ticker AND ph.Price_Date = '2021-12-31')
        WHEN fm.Financial_Year = 2020 THEN 
            (SELECT ph.Close_Price 
             FROM price_history ph 
             WHERE ph.Ticker = fm.Ticker AND ph.Price_Date = '2020-12-31')
        WHEN fm.Financial_Year = 2019 THEN 
            (SELECT ph.Close_Price 
             FROM price_history ph 
             WHERE ph.Ticker = fm.Ticker AND ph.Price_Date = '2019-12-31')
		WHEN fm.Financial_Year = 2022 THEN 
            (SELECT ph.Close_Price 
             FROM price_history ph 
             WHERE ph.Ticker = fm.Ticker AND ph.Price_Date = '2022-12-30')
END) AS year_close_price,
(CASE WHEN (PE_Ratio * EPS) > 
(CASE WHEN fm.Financial_Year = 2023  THEN 
(SELECT ph.Close_Price
FROM price_history ph
WHERE ph.Ticker = fm.Ticker AND Price_Date = '2023-12-29') 
WHEN fm.Financial_Year = 2021 THEN 
            (SELECT ph.Close_Price 
             FROM price_history ph 
             WHERE ph.Ticker = fm.Ticker AND ph.Price_Date = '2021-12-31')
        WHEN fm.Financial_Year = 2020 THEN 
            (SELECT ph.Close_Price 
             FROM price_history ph 
             WHERE ph.Ticker = fm.Ticker AND ph.Price_Date = '2020-12-31')
        WHEN fm.Financial_Year = 2019 THEN 
            (SELECT ph.Close_Price 
             FROM price_history ph 
             WHERE ph.Ticker = fm.Ticker AND ph.Price_Date = '2019-12-31')
		WHEN fm.Financial_Year = 2022 THEN 
            (SELECT ph.Close_Price 
             FROM price_history ph 
             WHERE ph.Ticker = fm.Ticker AND ph.Price_Date = '2022-12-30') END)
	THEN 'Under Valued'
    ELSE 'OVER Valued' END) As Under_Over_Value
FROM financial_metrics fm
;
-- 2022-12-30
-- 2021-12-31
-- 2020-12-31
-- 2019-12-31

SELECT Close_Price
FROM price_history
WHERE Price_Date = '2023-12-29'
;

