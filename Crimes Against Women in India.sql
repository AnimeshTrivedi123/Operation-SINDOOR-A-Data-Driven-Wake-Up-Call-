CREATE DATABASE crime;
USE crime;

CREATE TABLE Crimes_Women_India (
    id INT PRIMARY KEY AUTO_INCREMENT,
    State VARCHAR(100),
    Year INT,
    Rape INT,
    K_A INT,
    DD INT,
    AoW INT,
    AoM INT,
    DV INT,
    WT INT
);
#State==	Indian state or union territory
#Year==	Year of data entry
#Rape==	Number of rape cases
#K&A==	Kidnapping & Abduction
#DD==	Dowry Deaths
#AoW==	Assault on Women
#AoM==	Attempt to Outrage Modesty
#DV==	Domestic Violence
#WT==	Women Trafficking

SELECT * FROM Crimes_Women_India;

#Q1. List the total number of crimes reported in each yaer. 
SELECT Year,
sum(Rape + K_A + DD + AoM + AoW + DV + WT) AS Total_Crimes
FROM Crimes_Women_India
GROUP BY year
ORDER BY Year;

#Q2. Top 5 stats with the highest number of rape cases in any year.
SELECT State , Year , Rape 
FROM Crimes_Women_India
ORDER BY Rape DESC
LIMIT 5;

#Q3. Retrieve the number of dowry deaths reported in Bihar across all years. 
SELECT Year, DD AS Dowry_Deaths
FROM Crimes_Women_India
WHERE State='Bihar'
ORDER BY Year;

#Q4. List all distinct states present in the dataset. 
SELECT DISTINCT State From Crimes_Women_India;

#Q5. List highest number total crimes done by each state in each year. 
SELECT Year, State, (Rape + DD + K_A + AoW + AoM + DV + WT) AS Total_Crimes 
FROM Crimes_Women_India
#WHERE Year=2010
ORDER BY Total_Crimes DESC;

#Q6. Display the trend of domestic violence (DV) cases year-wise in Maharashtra. 
SELECT Year, DV AS Domestic_Violence 
FROM Crimes_Women_India
WHERE State='Maharashtra'
ORDER BY
Year ASC;

#Q7. Find the year with the highest number of total crimes across all states. 
SELECT Year,
sum(rape + K_A + DD + AoW + AoM + DV + WT) AS Total_crimes
FROM Crimes_Women_India
GROUP BY year
ORDER BY Total_crimes DESC
limit 1;

#Q8. Calculate the average number of cases per state. 
SELECT State,
ROUND(avg(rape + K_A + DD + AoW + AoM + DV + WT)) AS Total_crimes
FROM Crimes_Women_India
GROUP BY State
ORDER BY Total_crimes DESC;

#Q9. Calculate the average number of kidnapping & abduction (K&A) cases per state.
SELECT State,
ROUND(avg(K_A), 2) AS AVG_K_D_Crimes
FROM Crimes_Women_India
GROUP BY State
ORDER BY AVG_K_D_Crimes DESC;

#Q10. List states where rape cases exceeded 1000 in any year.
SELECT Year, State, Rape
FROM Crimes_Women_India
WHERE Rape>1000
ORDER BY Rape DESC;

#Q11. For each year, show the state with the highest number of dowry deaths.
SELECT Year, State, DD AS Dowry_deaths
FROM Crimes_Women_India AS c
WHERE DD=(SELECT MAX(DD)
		  FROM Crimes_Women_India
          WHERE Year=c.year
          )
ORDER BY Year;

#Q12. Display the trend of domestic violence (DV) cases year-wise in Maharashtra.
SELECT Year, DV AS Domestic_Violence
FROM Crimes_Women_India
WHERE State='Maharashtra'
ORDER BY Year ASC;

#Q13. Create a view that shows total crimes per year (summing all columns).
CREATE VIEW VIEW_CRIME AS 
SELECT YEAR, SUM(Rape + K_A + AoW + AoM + DD +WT + DV) AS Total_Crime
FROM Crimes_Women_India
GROUP BY year
ORDER BY Year;
SELECT * FROM VIEW_CRIME;

#Q14. Write a query to show year-over-year change in domestic violence cases for Delhi.
SELECT Year, DV AS Current_Year_DV,
LAG(DV) OVER (ORDER BY Year) AS Previous_Year_DV,
(DV-LAG(DV) OVER (ORDER BY Year)) AS Yoy_Change
FROM Crimes_Women_India
WHERE State=' Delhi '
ORDER BY Year;

#Q15. Find the cumulative total of crimes per state across all years.
SELECT STATE,
SUM(Rape + DV + Aow + AoM + DD + K_A + WT) AS Total_Crimes
FROM Crimes_Women_India
GROUP BY State
ORDER BY Total_Crimes;

#Q16. Rank states by total number of crimes reported in the year 2021 using a window function.
SELECT State, Year, Rape + K_A + AoW + AoM + DV + DD + WT AS Total_Crimes,
RANK() OVER(ORDER BY Rape + K_A + AoW + AoM + DV + DD + WT DESC)  AS Crime_Rank
FROM Crimes_Women_India
WHERE Year=2021;
 
 ####Updating Some Minor Errors####
 SET SQL_SAFE_UPDATES=0;
 #1. Fixing a Typo in State Name
UPDATE Crimes_Women_India
SET State='ANDHRA PRADESH'
WHERE State= 'ANDRA PRADESH';

#2. Updating Crime values
UPDATE Crimes_Women_India
SET Rape=918
WHERE State='ASSAM' AND Year=2001;

#Setting a Default Vlaue for Missing Data
UPDATE Crimes_Women_India
SET WT=1
WHERE WT IS NULL OR WT=0;

#Updating Multiple Columns
UPDATE Crimes_Women_India
SET Rape= 500, DV=1200
WHERE State='KERALA' AND Year =2005;

##Prepraing Clean Data##
SELECT Year,
SUM(Rape) AS Rape,
SUM(AoW) AS AssaultOnWomen,
SUM(AOM) AS Attempt_to_Outrage_Modesty,
SUM(K_A) AS Kidnapping,
SUM(DV) AS DomesticViolence,
SUM(DD) AS DowryDeaths,
SUM(WT) AS Women_Trafficking
From Crimes_Women_India
GROUP BY year
ORDER BY Year;

