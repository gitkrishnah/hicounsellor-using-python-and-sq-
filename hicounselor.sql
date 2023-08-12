--Select *
--from olympics_history_noc_regions

--Select *
--from olympics_history_cleaned_data

--how many olympics games have been held

Select COunt(Distinct(Games)) as total_olympic_games
from olympics_history_cleaned_data

--List down all Olympics games held so far. Order the result by year.
Select Distinct(Games),City,Year
from olympics_history_cleaned_data
order by Year ASC

--Mention the total no of nations who participated in each olympics game?. Order the results by games.
Select Count(Distinct(b.region)),Season,Year
from olympics_history_cleaned_data as a
Join olympics_history_noc_regions as b
on a.NOC = b.NOC
Group by Season,Year
order by Year

--Which nation has participated in all of the olympic games? and order the output by first column which is fetched
Select region,COUNT(distinct(games))
from olympics_history_cleaned_data as a 
Join olympics_history_noc_regions as b
on a.NOC = b.NOC
group by region
Having Count(distinct(games))>= 51
-- as we know that from 1st query the total olympics held were 51 so i have used 51 as filter to know which countries have played in all olympics

--5 How many unique athletes have won a gold medal in the Olympics?

Select Name,Count(Medal)
from olympics_history_cleaned_data
where Medal = 'Gold'
group by Name

--6 Which Sports were just played only once in the olympics? and Order the output by Sports. output should include number of games and games.
With CTE AS
(
Select Count(Distinct(Games)) as total_games,Sport
from olympics_history_cleaned_data
group by Sport
)

Select total_games,Sport
from CTE
where total_games = 1

--Fetch the total no of sports played in each olympic games. Order by no of sports by descending.
select COUNT(Distinct(Sport)),Games
from olympics_history_cleaned_data
group by Games
order by COUNT(Distinct(Sport)) Desc

--Fetch oldest athletes to win a gold medal
WITH CTE AS(
Select Age, Medal, DENSE_RANK() OVER(ORDER BY AGE DESC) as rnk
from olympics_history_cleaned_data
where Medal = 'GOLD' 
)
SELECT AGE
From CTE
where rnk =1
--Top 5 athletes who have won the most gold medals. Order the results by gold medals in descending.
WITH CTE AS(
Select Name, COUNT(Medal) as gold_medal_Count, DENSE_RANK() over(order by Count(Medal) DESC) as top_5
from olympics_history_cleaned_data
where Medal = 'Gold'
group by Name
--order by COUNT(Medal) DESC
)

Select Name, gold_medal_Count, top_5
from CTE
where top_5 in(1,2,3,4,5)

--Top 5 athletes who have won the most medals (gold/silver/bronze). Order the results by medals in descending

Select TOP 5 Name,COUNT(Medal)
from olympics_history_cleaned_data
where Medal in('Gold','Silver','Bronze')
Group by Name
order by COUNT(Medal) DESC

--Top 5 most successful countries in olympics. Success is defined by no of medals won
Select TOP 5 b.region, Sum(case when a.Medal IN ('Gold','Silver','Bronze') Then 1 else 0 END) as top_countries
from olympics_history_cleaned_data as a
join olympics_history_noc_regions as b
on a.NOC = b.NOC
group by region
order by top_countries DESC
--in which Sport/event, India has won highest medals.
Select Sport,Count(Medal),Medal
from olympics_history_cleaned_data
where Medal in ('Gold','Silver','Bronze') and NOC = 'IND'
group by Sport,Medal
--Break down all olympic games where india won medal for Hockey and how many medals in each olympic games and order the result by no of medals in descending.
Select Games,COUNT(medal),NOC
from olympics_history_cleaned_data
where Medal in ('Gold','Silver','Bronze') and NOC = 'IND' and Sport ='Hockey'
group by Games,NOC
order by COUNT(Medal) DESC