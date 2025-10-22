/* ============================================================================================
   🎵 Chinook Music Store Project
   Author: Nur Aisyah Roslan
-- ============================================================================================*/


/* ============================================================================================
   SALES & REVENUE ANALYSIS
-- ============================================================================================*/


-- 1️. Total Revenue
-- Objective: Compute total revenue of the music store
	SELECT 
		ROUND(SUM(Total),2) AS TotalRevenue
	FROM Invoice;


-- 2. Total Revenue By Country 
-- Objective: Aggregate total invoice revenue by billing country to indentify top markets
	SELECT 
		BillingCountry AS Country, 
		SUM(Total) AS TotalRevenue,
		COUNT(InvoiceId) AS NumberofInvoice
	FROM Invoice
	GROUP BY BillingCountry 
	ORDER BY TotalRevenue DESC

	
-- 3. Monthly Revenue Trend
-- Objective: Summarize revenue by month to detect seasonality and trends
	SELECT 
	 strftime('%Y-%m', InvoiceDate) AS Month,
	 SUM(Total)As MonthlyRevenue,
	 COUNT(InvoiceId) AS NumberofInvoice
	FROM Invoice
	GROUP BY Month
	ORDER BY Month ASC	
	
	
-- 4. Revenue by Genre
-- Objective: Aggregrate revenue per genre to identify top-earning music categories
	SELECT 
		g.Name AS Genre,
		SUM(il.UnitPrice*il.Quantity) AS Revenue
	FROM InvoiceLine il
	JOIN Track t ON il.TrackId = t.TrackId 
	JOIN Genre g ON t.GenreId = g.GenreId 
	GROUP BY g.GenreId
	ORDER BY Revenue DESC 
	

-- 5. Top 10 Revenue-Contributing Album
-- Objective: Identify albums contributing most to revenue (album-level product performance)
	SELECT 
		al.Title AS AlbumTitle,
		ar.Name AS Artist,
		SUM(il.UnitPrice*il.Quantity) AS Revenue
	FROM InvoiceLine il 
	JOIN Track t ON il.TrackId = t.TrackId 
	JOIN Album al ON t.AlbumId = al.AlbumId 
	JOIN Artist ar ON al.ArtistId = ar.ArtistId 
	GROUP BY al.Title
	ORDER BY Revenue DESC
	LIMIT 10
	
	
/* ============================================================
   CUSTOMER INSIGHTS
-- ============================================================*/	
	
-- 6. Total Sales Per Customer
-- Objective: Compute lifetime spend per customer to indetify high-value customer
	SELECT 
		c.FirstName ||" "|| c.LastName AS CustomerName,
		i.Total AS TotalSpend,
		i.InvoiceId AS NumberInvoice
	FROM Customer c
	JOIN Invoice i ON c.CustomerId = i.CustomerId 
	GROUP BY c.CustomerId
	ORDER BY TotalSpend DESC
	
	
-- 7. Customer Lifetime Value (CLV) Segments
-- Objective: Segment customers into tiers based in lifetime spend for targeting
	SELECT 
		c.CustomerId,
		c.FirstName ||" "|| c.LastName AS CustomerName,
		i.Total AS TotalSpend,
		i.InvoiceId AS NumberInvoice,
		CASE
			WHEN i.Total >= 100 THEN 'Platinum'
			WHEN i.Total >= 50 THEN 'Gold'
			WHEN i.Total >= 20 THEN 'Silver'
			ELSE 'Bronze'
		END AS SpendTier
	FROM Customer c
	JOIN Invoice i ON i.CustomerId = c.CustomerId
	ORDER BY i.Total DESC
	
	
-- 8. Repeat Purchase Behavior (Repeat vs One-time)
-- Objective: Identify what portion of customers are repeat buyers (purchase frequency)
   WITH CustFreq AS(
   	SELECT 
   		CustomerId,
   		COUNT (InvoiceId) AS PurchaseCount
   	FROM Invoice
   	GROUP BY CustomerId
   	)
   	
   	SELECT 
   		CASE WHEN PurchaseCount= 1 THEN 'One-Time' ELSE 'Repeat' END AS CustomerType,
   		COUNT(*) AS NumCustomer
   	FROM CustFreq
   	GROUP BY CustomerType 
   		
	
-- 9. Customer Purchase Frequency (Top)
-- Objective: Find customers with highest purchase counts (loyalty indicator)
   SELECT 
   	CustomerId,
   	COUNT(InvoiceId) AS PurchaseCount,
   	SUM(Total) AS TotalSpent
   FROM Invoice
   GROUP BY CustomerId
   ORDER BY PurchaseCount DESC, TotalSpent DESC
   LIMIT 10
   
   
-- 10. Average Invoice Value by Customer Tier
-- Objective: Compare average invoice value accross spend tiers to inform pricing
	WITH CustAvgInvoice AS (
		SELECT 
			CustomerId,
			SUM(Total) AS TotalSpent,
			AVG(Total) AS AvgInvoice
		FROM Invoice
		GROUP BY CustomerId
		) 
   
	SELECT 
		CASE 
			WHEN TotalSpent >=100 THEN 'Platinium'
			WHEN TotalSpent >=50 THEN 'Gold'
			WHEN TotalSpent >=20 THEN 'Silver'
			ELSE 'Bronze'
		END AS SpendTier,
		ROUND(AVG(AvgInvoice),2) AS AvgInvoiceValue,
		COUNT(*) AS NumCustomer
	FROM CustAvgInvoice
	GROUP BY SpendTier
	ORDER BY AvgInvoiceValue DESC
	

/* ============================================================================================
   PRODUCT & GENRE PERFORMANCE
-- ============================================================================================*/


-- 11. Top-Selling Tracks by Quantity
-- Objective: Rank tracks by total quantity sold to find product winners
	SELECT 
		t.TrackId,
		t.Name AS TrackName,
		COUNT(il.InvoiceLineId) AS SalesCount,
		ROUND(SUM(il.UnitPrice*il.Quantity),2) AS Revenue
	FROM InvoiceLine il
	JOIN Track t ON il.TrackId = t.TrackId 
	GROUP BY t.TrackId
	ORDER BY SalesCount DESC, Revenue DESC
	LIMIT 10


-- 12. Tracks Never Sold
-- Objective: Identify tracks that have never been purchased (catalog underperformers).
	SELECT 
		t.TrackId,
		t.Name TrackName,
		al.Title AS AlbumTitle,
		ar.Name AS Artist
	FROM Track t
	LEFT JOIN InvoiceLine il ON t.TrackId = il.TrackId 
	LEFT JOIN Album al ON t.AlbumId = al.AlbumId 
	LEFT JOIN Artist ar ON al.ArtistId = ar.ArtistId 
	WHERE il.InvoiceLineId IS NULL
	GROUP BY t.TrackId


-- 13. Genre Cross-Sell Pairs (Co-purchase)
-- Objective: Identify genre pairs frequently bought together to support bundling/recommendations.
	WITH cust_genre AS(
		SELECT DISTINCT i.InvoiceId, i.CustomerId , g.GenreId, g.Name AS GenreName
		FROM Invoice i
	  	JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
	  	JOIN Track t ON il.TrackId = t.TrackId
	  	JOIN Genre g ON t.GenreId = g.GenreId
	)
	
	SELECT
		g1.GenreName AS GenreA,
		g2.GenreName AS GenreB,
		COUNT(*) AS CoPurchaseCount
	FROM cust_genre g1
	JOIN cust_genre g2 ON g1.InvoiceId=g2.InvoiceId AND g1.GenreId < g2.GenreId
	GROUP BY g1.GenreId, g2.GenreId
	ORDER BY CoPurchaseCount DESC
	LIMIT 15


-- 14. Average Price per Track by Genre
-- Objective: Compare average unit price per genre to inform pricing decisions.
	SELECT
		g.Name AS Genre,
		AVG(t.UnitPrice) AS AvgUnitPrice,
		COUNT(t.TrackId) AS NumTrack
	FROM Track t 
	JOIN Genre g ON t.GenreId = g.GenreId
	GROUP BY t.GenreId
	ORDER by AvgUnitPrice DESC


-- 15. Revenue Contribution by Top 10 Tracks
-- Objective: Show how much top tracks contribute to overall revenue (concentration analysis).
	WITH track_rev AS(
		SELECT 
		t.TrackId,
		t.Name AS TrackName,
		SUM(il.UnitPrice*il.Quantity) AS Revenue
	FROM InvoiceLine il
	JOIN Track t ON il.TrackId = t.TrackId 
	GROUP BY t.TrackId 
	)
	
	SELECT 
		TrackId,
		TrackName,
		ROUND(Revenue,2) AS Revenue,
		ROUND(Revenue*100/(SELECT SUM(Revenue) FROM track_rev),2) AS PercentOfTrackRevenue
	FROM track_rev
	ORDER BY Revenue DESC 
	LIMIT 10

	
/* ============================================================================================
   EMPLOYEE & SALES AGENT PERFORMANCE
-- ============================================================================================*/

-- 16. Employee Revenue Contribution
-- Objective: Calculate total revenue attributable to each sales rep (support rep -> customer -> invoices).
	SELECT
		e.EmployeeId,
		e.FirstName ||" "|| e.LastName AS EmployeeName,
		SUM(i.Total) AS TotalRevenue,
		COUNT(DISTINCT c.CustomerId) AS CustomersManaged
	FROM Invoice i 
	JOIN Customer c ON i.CustomerId = c.CustomerId 
	JOIN Employee e ON c.SupportRepId = e.EmployeeId  
	GROUP BY e.EmployeeId
	ORDER BY TotalRevenue DESC

	
-- 17. Employee Average Revenue per Customer
-- Objective: For each employee, compute average revenue generated per assigned customer.
	WITH cust_rev AS(
		SELECT
		c.SupportRepId,
		c.CustomerId,
		SUM(i.Total) AS TotalRevenue
		FROM Invoice i 
		JOIN Customer c ON i.CustomerId = c.CustomerId 
		GROUP BY c.SupportRepId, c.CustomerId 
	)
	
	SELECT
		e.EmployeeId,
		e.FirstName ||" "|| e.LastName AS EmployeeName,
		ROUND(AVG(cr.TotalRevenue),2) AS AverageRevenuePerCustomer
	FROM Employee e
	JOIN cust_rev cr ON e.EmployeeId = cr. SupportRepId
	GROUP BY e.EmployeeId
	ORDER BY AverageRevenuePerCustomer DESC
	
	
-- 18. Top 5 Employees by Revenue
-- Objective: Identify the top-performing 5 sales agents by total revenue.
	SELECT
		e.EmployeeId,
		e.FirstName ||" "|| e.LastName AS EmployeeName,
		SUM(i.Total) AS TotalRevenue,
		COUNT(DISTINCT c.CustomerId) AS CustomersManaged
	FROM Invoice i 
	JOIN Customer c ON i.CustomerId = c.CustomerId 
	JOIN Employee e ON c.SupportRepId = e.EmployeeId  
	GROUP BY e.EmployeeId
	ORDER BY TotalRevenue DESC
	LIMIT 5
	
	
/* ============================================================================================
   REGIONAL / COUNTRY ANALYSIS
-- ============================================================================================*/
	
-- 19. Average Invoice Value by Country
-- Objective: Compare average invoice (purchase) size between countries to guide pricing/marketing.
	SELECT
	  BillingCountry AS Country,
	  ROUND(AVG(Total), 2) AS AvgInvoiceValue,
	  COUNT(InvoiceId) AS InvoiceCount
	FROM Invoice
	GROUP BY BillingCountry
	ORDER BY AvgInvoiceValue DESC;


-- 20. Revenue Contribution by Top Countries (Top 10)
-- Objective: Identify top countries that contribute the majority of revenue (market focus).
	SELECT 
		BillingCountry AS Country, 
		COUNT(InvoiceId) AS NumberofInvoice,
		SUM(Total) AS TotalRevenue,
		ROUND(SUM(Total)*100.00/(SELECT SUM(Total) FROM Invoice),2) AS PercentOfTotalRevenue
	FROM Invoice
	GROUP BY BillingCountry 
	ORDER BY TotalRevenue DESC
	LIMIT 10
	

