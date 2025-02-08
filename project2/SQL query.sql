Query 1:
WITH DailyDelays AS (
    SELECT 
        s.StationID, 
        s.StationName, 
        DATE(d.TimeStamp) AS DelayDate, 
        SUM(d.DelayDuration) AS Total_Delay
    FROM 
        Station s
    JOIN 
        Delay d ON s.StationID = d.StationID
    GROUP BY 
        s.StationID, s.StationName, DATE(d.TimeStamp)
),
StationDelayStats AS (
    SELECT 
        dd.StationID, 
        dd.StationName, 
        ROUND(AVG(dd.Total_Delay),2) AS Avg_Daily_Delay, 
        COUNT(d.DelayID) AS Total_Delay_Occurrences 
    FROM 
        DailyDelays dd
    JOIN 
        Delay d ON dd.StationID = d.StationID
    GROUP BY 
        dd.StationID, dd.StationName
)
SELECT 
    StationName, 
    Avg_Daily_Delay, 
    Total_Delay_Occurrences,
    RANK() OVER (ORDER BY Total_Delay_Occurrences DESC) AS Delay_Rank 
FROM 
    StationDelayStats
WHERE 
    Avg_Daily_Delay > 30 
ORDER BY 
    Total_Delay_Occurrences DESC
LIMIT 5;


Query 2:
WITH LinePassengerStats AS (
    SELECT 
        l.LineID, 
        l.LineName, 
        cs.StationID, 
		s.StationName,
        ROUND(SUM(pc.PassengerCount),2) AS Station_Passenger_Count
    FROM 
        Line l
    JOIN 
        Contains_Station cs ON l.LineID = cs.LineID
    JOIN 
        Passenger_Counts pc ON cs.StationID = pc.StationID
	JOIN
		Station s ON s.StationID = cs.StationID
    GROUP BY 
        l.LineID, l.LineName, cs.StationID
),
LineAverage AS (
    SELECT 
        LineID, 
        ROUND(AVG(Station_Passenger_Count),2) AS Line_Avg_Passenger
    FROM 
        LinePassengerStats
    GROUP BY 
        LineID
)
SELECT 
    lps.LineName, 
    lps.StationID, 
	lps.StationName,
    lps.Station_Passenger_Count, 
    la.Line_Avg_Passenger
FROM 
    LinePassengerStats lps
JOIN 
    LineAverage la ON lps.LineID = la.LineID
WHERE 
    lps.Station_Passenger_Count < la.Line_Avg_Passenger * 0.25
ORDER BY 
    lps.LineName, lps.Station_Passenger_Count ASC;



Query 3:
SELECT 
    r.RouteName,
    ce.TotalCarbonEmissions_kg,
    ce.TotalDistance_km,
    ROUND(ce.TotalCarbonEmissions_kg / NULLIF(ce.TotalDistance_km, 0), 2) AS Emissions_Per_Km,
    RANK() OVER (ORDER BY ROUND(ce.TotalCarbonEmissions_kg / NULLIF(ce.TotalDistance_km, 0), 2) ASC) AS Emissions_Rank
FROM 
    Route r
JOIN 
    Carbon_Emission ce ON r.EmissionID = ce.EmissionID
ORDER BY 
    Emissions_Rank ASC;

Query 4:
WITH TimeFilteredCounts AS (
    SELECT 
        PC.StationID,
        PC.TimeInterval,
        SUM(PC.PassengerCount) AS TotalPassengerCount,
        CAST(SUBSTR(PC.TimeInterval, 1, 2) AS INTEGER) * 60 + CAST(SUBSTR(PC.TimeInterval, 3, 2) AS INTEGER) AS StartTime,
        CAST(SUBSTR(PC.TimeInterval, 6, 2) AS INTEGER) * 60 + CAST(SUBSTR(PC.TimeInterval, 7, 2) AS INTEGER) AS EndTime
    FROM Passenger_Counts PC
    GROUP BY PC.StationID, PC.TimeInterval
),
FilteredDelays AS (
    
    SELECT DISTINCT
        D.DelayID,
        D.StationID,
        D.DelayDuration,
        (CAST(STRFTIME('%H', D.Timestamp) AS INTEGER) * 60 + CAST(STRFTIME('%M', D.Timestamp) AS INTEGER)) AS EventTime
    FROM Delay D
),
MatchedIntervals AS (
    
    SELECT 
        TFC.StationID,
        TFC.TimeInterval,
        TFC.TotalPassengerCount,
        MIN(FD.DelayID) AS MatchedDelayID 
    FROM TimeFilteredCounts TFC
    LEFT JOIN FilteredDelays FD
    ON TFC.StationID = FD.StationID
    AND FD.EventTime BETWEEN TFC.StartTime AND TFC.EndTime
    GROUP BY TFC.StationID, TFC.TimeInterval, TFC.TotalPassengerCount
),
UniquePassengerCounts AS (
    
    SELECT 
        StationID,
        SUM(TotalPassengerCount) AS TotalPassengerCount
    FROM MatchedIntervals
    GROUP BY StationID
)

SELECT 
    S.StationName,
    S.Is_interchange,
    UPC.TotalPassengerCount AS TotalPassengerCount, 
    COUNT(DISTINCT FD.DelayID) AS TotalDelayOccurrences,
    ROUND(AVG(FD.DelayDuration), 2) AS AvgDelayDuration, 
    CASE 
        WHEN S.Is_interchange = 1 THEN 'Interchange Station'
        ELSE 'Regular Station'
    END AS StationType
FROM Station S
LEFT JOIN UniquePassengerCounts UPC 
    ON S.StationID = UPC.StationID
LEFT JOIN FilteredDelays FD 
    ON S.StationID = FD.StationID
GROUP BY S.StationID, S.StationName, S.Is_interchange, UPC.TotalPassengerCount
ORDER BY TotalPassengerCount DESC, TotalDelayOccurrences DESC, AvgDelayDuration DESC;

Query 5:
WITH DelayTypeCounts AS (
    -- Step 1: Count delays for each type
    SELECT 
        D.DelayType,
        COUNT(*) AS DelayCount
    FROM Delay D
    GROUP BY D.DelayType
),
TotalDelays AS (
    -- Step 2: Calculate total delay count
    SELECT 
        COUNT(*) AS TotalDelayCount
    FROM Delay
)
-- Step 3: Calculate percentage for each delay type
SELECT 
    DTC.DelayType,
    DTC.DelayCount,
    TD.TotalDelayCount,
    ROUND((DTC.DelayCount * 100.0 / TD.TotalDelayCount), 2) AS DelayPercentage
FROM DelayTypeCounts DTC
CROSS JOIN TotalDelays TD
ORDER BY DelayPercentage DESC;