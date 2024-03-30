#Q1 -Display the number of fatal and non-fatal police shooting incidents among those involved. on the basis of unarmed incidents in various cities 

SELECT 
    pk.City,
    COUNT(pk.id) AS Number_of_Police_Incidents,
    SUM(CASE WHEN pk.Manner_of_Death = 'shot' THEN 1 ELSE 0 END) AS Number_of_Fatal_Incidents,
    SUM(CASE WHEN pk.Armed = 'unarmed' THEN 1 ELSE 0 END) AS Number_of_Unarmed_Incidents
FROM policekillingsus pk
GROUP BY pk.City, pk.Body_Camera, pk.Signs_of_Mental_Illness
ORDER BY Number_of_Police_Incidents DESC;

#Q2 - How many fatal police incidents have occurred in each city, broken down by the manner of death, 
# and what are the total incidents for each manner of death across the country?

SELECT 
    City, 
    State, 
    Manner_Of_Death, 
    COUNT(*) AS No_of_Fatal_Incidents
FROM 
    policekillingsus
GROUP BY 
    City, 
    State, 
    Manner_Of_Death
ORDER BY 
    City, 
    No_of_Fatal_Incidents DESC;
    
    
#Q3 - Rank cities based on the number of high school graduates and provide the top 10 cities
SELECT City, Percent_completed_hs,
ROW_NUMBER() OVER (ORDER BY Percent_completed_hs DESC) AS Ranking
FROM percentover25completedhighschool
LIMIT 10;

#Q4 - Which cities have the avg. largest gap between the share of white and black populations?
SELECT City, AVG(share_white - share_black) AS Gap
FROM shareracebycity
GROUP BY City
ORDER BY Gap DESC;


#Q5 - What are the demographics (age and name) of individuals involved in police shootings in cities with above-average poverty rates?
SELECT DISTINCT p.name, p.age
FROM policekillingsus p
JOIN percentagepeoplebelowpovertylevel pb ON p.City = pb.City
WHERE pb.poverty_rate > (SELECT AVG(poverty_rate) FROM percentagepeoplebelowpovertylevel);

#Q6 - What are the top 2 cities with highest average high school completion rates and poverty rates in cities where police killings have occurred?
SELECT 
    pk.City,
    COALESCE(AVG(p25.Percent_completed_hs), 0) AS Avg_HS_Completion,
    COALESCE(AVG(ppb.poverty_rate), 0) AS Avg_Poverty_Rate,
    COUNT(pk.id) AS Number_of_Police_Killings
FROM 
    policekillingsus pk
    LEFT JOIN percentover25completedhighschool p25 ON pk.City = p25.City AND p25.Percent_completed_hs IS NOT NULL
    LEFT JOIN percentagepeoplebelowpovertylevel ppb ON pk.City = ppb.City AND ppb.poverty_rate IS NOT NULL
GROUP BY 
    pk.City
HAVING 
    Number_of_Police_Killings > 0 AND Avg_HS_Completion > 0 AND Avg_Poverty_Rate > 0
ORDER BY 
    Number_of_Police_Killings DESC, Avg_HS_Completion DESC, Avg_Poverty_Rate DESC
LIMIT 2;


#Q7 - What percentage of cities have a poverty rate above the national average?
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM percentagepeoplebelowpovertylevel) AS Percentage_Above_Average
FROM percentagepeoplebelowpovertylevel
WHERE poverty_rate > (SELECT AVG(poverty_rate) FROM percentagepeoplebelowpovertylevel);


#Q8- List cities where the share of the Hispanic population is above average for the state.
SELECT City
FROM ShareRaceByCity src
WHERE src.`share_hispanic` > (
  SELECT AVG(srch.`share_hispanic`)
  FROM ShareRaceByCity srch
  WHERE srch.`Geographic Area` = src.`Geographic Area`
);




























