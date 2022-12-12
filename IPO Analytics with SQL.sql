-- creating table schemas for CSV's: IPO_train, IPO_test, SPX_quarterly, SPX_monthly, SPX_weekly, Macro
CREATE TABLE IPO_train( Deal_id NUMERIC,
						Issue_date DATE NOT NULL,
						Issuer_name VARCHAR,
					    Issue_type VARCHAR,
					    Transaction_status VARCHAR,
					    Nation VARCHAR,
					    Filing_date DATE NOT NULL,
					    Offer_price NUMERIC,
					    Stock_1D NUMERIC,
					    Stock_1W NUMERIC,
					    Stock_1M NUMERIC,
						IPO_proceeds NUMERIC NOT NULL,
					    Market_value_before NUMERIC,
					    Market_value_after NUMERIC,
					    Exchange VARCHAR,
					    Security_type VARCHAR,
					    Technique VARCHAR,
					    Spread NUMERIC,
					    Sub_region VARCHAR,
					    Region VARCHAR,
						Economic_sector VARCHAR,
						Business_sector VARCHAR,
						Bookrunner VARCHAR,
						Target_market VARCHAR
					   );
					   
CREATE TABLE IPO_test( Deal_id NUMERIC,
						Issue_date DATE NOT NULL,
						Issuer_name VARCHAR,
					    Issue_type VARCHAR,
					    Transaction_status VARCHAR,
					    Nation VARCHAR,
					    Filing_date DATE NOT NULL,
					    Offer_price NUMERIC,
					    Stock_1D NUMERIC,
					    Stock_1W NUMERIC,
					    Stock_1M NUMERIC,
						IPO_proceeds NUMERIC NOT NULL,
					    Market_value_before NUMERIC,
					    Market_value_after NUMERIC,
					    Exchange VARCHAR,
					    Security_type VARCHAR,
					    Technique VARCHAR,
					    Spread NUMERIC,
					    Sub_region VARCHAR,
					    Region VARCHAR,
						Economic_sector VARCHAR,
						Business_sector VARCHAR,
						Bookrunner VARCHAR,
						Target_market VARCHAR
					   );
					   
CREATE TABLE SPX_quarterly(
						Exchange_date DATE NOT NULL,
						Close_point NUMERIC,
					    Net_change NUMERIC,
					    Percentage_change NUMERIC,
					    Open_point NUMERIC,
					    Low_point NUMERIC,
					    High_point NUMERIC);
						
CREATE TABLE SPX_monthly(
						Exchange_date DATE NOT NULL,
						Close_point NUMERIC,
					    Net_change NUMERIC,
					    Percentage_change NUMERIC,
					    Open_point NUMERIC,
					    Low_point NUMERIC,
					    High_point NUMERIC);
						
CREATE TABLE SPX_weekly(
						Exchange_date DATE NOT NULL,
						Close_point NUMERIC,
					    Net_change NUMERIC,
					    Percentage_change NUMERIC,
					    Open_point NUMERIC,
					    Low_point NUMERIC,
					    High_point NUMERIC);
						
CREATE TABLE Macro(
						Macro_date DATE NOT NULL,
						CPI NUMERIC,
					    CPI_lag NUMERIC,
					    M2 NUMERIC,
					    M2_lag NUMERIC,
					    House_price NUMERIC,
					    House_price_lag NUMERIC,
					    Unemployment NUMERIC,
						Unemployment_lag NUMERIC);

CREATE TABLE IPO_Index(
						Effective_date DATE NOT NULL,
						IPO_Index NUMERIC);
						
CREATE TABLE IPO_Index_monthly(
						Effective_date DATE NOT NULL,
						IPO_Index NUMERIC,
						Pct_Chng NUMERIC);
						
CREATE TABLE IPO_Index_quarterly(
						Effective_date DATE NOT NULL,
						IPO_Index NUMERIC,
						Pct_Chng NUMERIC);
						
CREATE TABLE All_IPOs( Deal_id NUMERIC,
						Issue_date DATE NOT NULL,
						Issuer_name VARCHAR,
					    Issue_type VARCHAR,
					    Transaction_status VARCHAR,
					    Nation VARCHAR,
					    Filing_date DATE NOT NULL,
					    Offer_price NUMERIC,
					    Stock_1D NUMERIC,
					    Stock_1W NUMERIC,
					    Stock_1M NUMERIC,
						IPO_proceeds NUMERIC NOT NULL,
					    Market_value_before NUMERIC,
					    Market_value_after NUMERIC,
					    Exchange VARCHAR,
					    Security_type VARCHAR,
					    Technique VARCHAR,
					    Spread NUMERIC,
					    Sub_region VARCHAR,
					    Region VARCHAR,
						Economic_sector VARCHAR,
						Business_sector VARCHAR,
						Bookrunner VARCHAR,
						Target_market VARCHAR
					   );
					   

SELECT 	date_trunc('quarter', Issue_date) IPO_quarter, 
		AVG(Offer_price) AS offer_price, AVG(Stock_1D) AS stock_1d, AVG(Stock_1W) AS stock_1w, AVG(Stock_1M) AS stock_1m
FROM All_IPOs 
GROUP BY IPO_quarter
ORDER BY IPO_quarter;
-- Next, import the CSV files into the appropriate table schema


-- IPO_train is a TIMESERIES dataset (time frame: November 2015 - August 2022)

-- extracting and summarizing by time unit
-- the date_part function extracts the time unit from values in 'Issue_date' column
-- this query groups rows by year 2015-2022
SELECT 	date_part('year', Issue_date) AS IPO_year, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_offerings
FROM IPO_train
GROUP BY IPO_year 
ORDER BY IPO_year;

-- this query groups rows by quarter 1-4
SELECT 	date_part('quarter', Issue_date) AS IPO_quarter, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_offerings
FROM IPO_train
GROUP BY IPO_quarter 
ORDER BY IPO_quarter;

-- this query groups rows by month 1-12
SELECT 	date_part('month', Issue_date) AS IPO_month, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_offerings
FROM IPO_train
GROUP BY IPO_month 
ORDER BY IPO_month;

-- this query groups rows by week 1-52
SELECT 	date_part('week', Issue_date) AS IPO_week, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_offerings
FROM IPO_train
GROUP BY IPO_week 
ORDER BY IPO_week;

-- Now, we can visualize the distribution of IPO Proceeds and No. of Deals per time unit using other tools


-- truncate to keep larger units: quarters, months, weeks in a year
-- the date_trunc function keeps the months in the Issue_date and cuts of smaller units: 2015-12-29 -> 2015-12-01
-- this will be useful when we join the result with data containing macroeconomic indices and S&P500 price history
CREATE TABLE Quarterly_IPOs AS
SELECT 	date_trunc('quarter', Issue_date) AS IPO_quarter, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_offerings
FROM IPO_train 
GROUP BY IPO_quarter 
ORDER BY IPO_quarter;

CREATE TABLE Monthly_IPOs AS
SELECT 	date_trunc('month', Issue_date) AS IPO_month, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_deals
FROM IPO_train 
GROUP BY IPO_month 
ORDER BY IPO_month;

CREATE TABLE Weekly_IPOs AS
SELECT 	date_trunc('week', Issue_date) AS IPO_week, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_deals
FROM IPO_train 
GROUP BY IPO_week 
ORDER BY IPO_week;

-- truncate SPX by different time units
CREATE TABLE SPX_Q AS
SELECT 	date_trunc('quarter', Exchange_date) AS SPX_quarter, 
		Close_point, Net_change, Percentage_change
FROM SPX_quarterly 
ORDER BY SPX_quarter;

CREATE TABLE SPX_M AS
SELECT 	date_trunc('month', Exchange_date) AS SPX_month, 
		Close_point, Net_change, Percentage_change
FROM SPX_monthly 
ORDER BY SPX_month;

CREATE TABLE SPX_W AS
SELECT 	date_trunc('week', Exchange_date) AS SPX_week, 
		Close_point, Net_change, Percentage_change
FROM SPX_weekly 
ORDER BY SPX_week;


-- Join IPOs with S&P500 and Macro indices for each time unit and print derived tables
SELECT * FROM Quarterly_IPOs JOIN SPX_Q
ON Quarterly_IPOs.IPO_quarter=SPX_Q.SPX_quarter;

SELECT * FROM Monthly_IPOs JOIN SPX_M
ON Monthly_IPOs.IPO_month=SPX_M.SPX_month;

SELECT * FROM Monthly_IPOs JOIN Macro
ON Monthly_IPOs.IPO_month=Macro.Macro_date;

SELECT * FROM Weekly_IPOs JOIN SPX_W
ON Weekly_IPOs.IPO_week=SPX_W.SPX_week;

-- With our new datasets, we can now visualize the correlation and covariance between changes in IPO proceeds and deals and changes in SPX using Excel Charting tool
-- Next, we will explore autocorrelation and seasonality in IPO data in R Studio.
-- Hence, we will combine datasets to include to visualize the comparison of the model forecast to the actual IPO values in Q4 2022.

SELECT * FROM (
SELECT 	date_trunc('month', Issue_date) AS IPO_month, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_deals
FROM (SELECT * FROM IPO_train UNION SELECT * FROM IPO_test) AS All_IPOs_M
GROUP BY IPO_month ORDER BY IPO_month DESC) AS All_IPOs_M
JOIN SPX_M ON All_IPOs_M.IPO_month = SPX_M.SPX_month;

SELECT * FROM (
SELECT 	date_trunc('quarter', Issue_date) AS IPO_quarter, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_deals
FROM (SELECT * FROM IPO_train UNION SELECT * FROM IPO_test) AS All_IPOs_Q
GROUP BY IPO_quarter ORDER BY IPO_quarter DESC) AS All_IPOs_Q 
JOIN SPX_Q ON All_IPOs_Q.IPO_quarter = SPX_Q.SPX_quarter;


-- IPO Index aggregating by time unit -> export -> calculate percentage changes -> import

SELECT 	date_trunc('month', Effective_date) AS IPO_month, 
AVG(IPO_Index) AS AVG_Index
FROM IPO_Index GROUP BY IPO_month ORDER BY IPO_month;

SELECT 	date_trunc('quarter', Effective_date) AS IPO_quarter, 
AVG(IPO_Index) AS AVG_Index
FROM IPO_Index GROUP BY IPO_quarter ORDER BY IPO_quarter;


SELECT * FROM (
SELECT 	date_trunc('quarter', Issue_date) AS IPO_quarter, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_deals
FROM (SELECT * FROM IPO_train UNION SELECT * FROM IPO_test) AS All_IPOs_Q
GROUP BY IPO_quarter ORDER BY IPO_quarter DESC) AS All_IPOs_Q 
JOIN IPO_Index_quarterly ON All_IPOs_Q.IPO_quarter = IPO_Index_quarterly.Effective_date;

SELECT * FROM (
SELECT 	date_trunc('month', Issue_date) AS IPO_month, 
		SUM(IPO_proceeds) AS total_proceeds,
		COUNT(Deal_id) AS number_of_deals
FROM (SELECT * FROM IPO_train UNION SELECT * FROM IPO_test) AS All_IPOs_M
GROUP BY IPO_month ORDER BY IPO_month DESC) AS All_IPOs_M
JOIN IPO_Index_monthly ON All_IPOs_M.IPO_month = IPO_Index_monthly.Effective_date;