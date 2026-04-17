-- Total Cases vs Total Deaths
select location,date,total_cases,new_cases,total_deaths,population,(total_deaths/total_cases)*100 as deathpercentage 
from portfolia.coviddeaths
where location like '%eria%'
order by 1,2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
select location,total_cases,total_deaths,population,(total_cases/population)*100 as Deathpercentage 
from portfolia.coviddeaths
where location like '%afg%'
order by 2,3;
-- Countries with Highest Infection Rate compared to Population
select location,population, max(total_cases) as highestinfected,max(total_cases/population)*100 as percentagepopulation
from portfolia.coviddeaths
#where location like '%afg%'
group by location,population
order by highestinfected desc;
-- Countries with Highest Death Count per Population

select location , max(cast(total_deaths as float)) as highdeathrates
from portfolia.coviddeaths
where continent is not null
group by location
order by highdeathrates desc;
-- Showing contintents with the highest death count per population
select continent ,max(total_deaths/population)*100 as highestdeath from portfolia.coviddeaths
where continent is not null
group by continent;


-- Using Temp Table to perform Calculation on Partition By in previous query
create temporary table sumoftotalperlocation(
	location varchar(100),
	total_cases bigint,
	total_deaths bigint,
	population bigint,
	ok bigint
);
insert into sumoftotalperlocation
select 
	cd.location,
	cast(nullif(cd.total_cases, '') as unsigned),
	cast(nullif(cd.total_deaths, '') as unsigned),
	cast(nullif(cd.population, '') as unsigned),
	sum(cast(nullif(cd.total_cases, '') as unsigned)) 
    over (partition by cd.location order by cd.date ) as ok
from  port.cd cd;
select * from sumoftotalperlocation;
-- Creating View to store data for later visualizations
create view sumoftotalperlocation as
select 
	cd.location,
	cast(nullif(cd.total_cases, '') as unsigned),
	cast(nullif(cd.total_deaths, '') as unsigned),
	cast(nullif(cd.population, '') as unsigned),
	sum(cast(nullif(cd.total_cases, '') as unsigned)) 
    over (partition by cd.location order by cd.date ) as ok
from  port.cd cd;
select * from sumoftotalperlocation;





