#*********QUERIES USED FOR TABLEAU PROJECT**********#
#1.
select sum(cast(nullif(new_cases,'') as Decimal(15,2))) as total_cases , 
sum(cast(nullif(new_deaths,'') as Decimal(15,2))) as total_deaths,
sum(cast(nullif(new_deaths,'') as Decimal(15,2)))/sum(new_cases)*100 as Deathpercentage
from portfolioproject.covidd
where continent is not null;

#2. Europe union part of Europe
select location,sum(cast(nullif(new_deaths,'') as decimal(15,2))) as TotalDeathCount
from portfolioproject.covidd
where continent is not null and location not in('world','european union','international')
group by location
order by TotalDeathCount desc;

#3.
select 
location,
population,
max(cast(nullif(total_cases,'') as decimal(15,2))) as HighestInfectedCases,
max(cast(nullif(total_cases,'') as decimal(15,2)))/population*100 as PercentagePopulatedInfected
from portfolioproject.covidd
group by population,location
order by PercentagePopulatedInfected desc;

#4.
select 
location,
max(population) as Highestpopulation,
max(cast(nullif(total_cases,'') as decimal(15,2))) as HighestInfectedCases,
max(cast(nullif(total_cases,'') as decimal(15,2)))/max(population)*100 as PercentagePopulatedInfected
from portfolioproject.covidd
group by location
order by PercentagePopulatedInfected desc;

#5.
select 
location,
population,
date,
max(cast(nullif(new_cases,'') as decimal(15,2))) as Highestinfectedcount,
max(total_cases*1.0/nullif(population,0.0))*100 as Percentagepopulationinfected
from portfolioproject.covidd
group by location,population,date
order by Percentagepopulationinfected desc;

