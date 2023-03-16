--raw death data 1&2 SQL

SELECT *
FROM owid_covid_data_Death x
where continent is not null
order by 3,4;


SELECT Location, date, total_cases, new_cases, total_deaths, population
where continent is not null
FROM owid_covid_data_Death x
order by 1,2;


--looking at Total Cases vs Total Deaths
--Showing how likely you are to get Covid in your area

SELECT Location, date, total_cases, total_deaths, 
	(cast(total_deaths as float)/total_cases)*100 as DeathPercentage
FROM owid_covid_data_Death x
WHERE location like '%States%'
	and continent is not null
order by 1,2;


--looking at total cases vs population
--shows what percentage of population that got covid

SELECT Location, date, population, total_cases, 
	(cast(total_cases  as float)/population)*100 as DeathPercentage
FROM owid_covid_data_Death x
WHERE location like '%States%'
	and continent is not null
order by 1,2;


--Looking at countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) as HighestInfectionCount,
	(cast(MAX(total_cases) as float)/population)*100 as PopulationInfected
FROM owid_covid_data_Death x
where continent is not null
group by location, population
order by PopulationInfected desc;


--Looking at countries with highest death count per population

SELECT Location, MAX(cast(total_deaths as int)) as totalDeathCount
FROM owid_covid_data_Death x
where continent is not null
group by location
order by totalDeathCount desc;


--Looking at each continent and their total deaths

SELECT continent, MAX(cast(total_deaths as int)) as totalDeathCount
FROM owid_covid_data_Death x
where continent is not null
group by continent  
order by totalDeathCount desc;


--GLOBAL NUMBERS
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as float)) as total_deaths,
--Death Percentage equation
--multiplying by 1.0 makes the cases a float (just a shorter and cleaner way of doing it)
	SUM(total_deaths)/SUM(total_cases*1.0)*100 as DeathPercentage
from owid_covid_data_Death x
where continent is not null 
order by 1,2;


--NOW LOOKING AT VACCINATION DATA!!!
--First off, the raw data

Select *
From owid_covid_data_Vaccine x
order by 3,4;


--Total population vs vaccinations

with PopvsVac (Continent, location, Date, Population, New_vaccinations, Rollingpplvac)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpplvac
from owid_covid_data_Death dea
	join owid_covid_data_vaccine vac
		on dea.location = vac.location
		and dea.date = vac.date
where dea.continent is not null and dea.continent != '' 
	and dea.continent not in ('Africa', 'Asia','Asia')
order by 2,3
)
select*, (rollingpplvac/population)*100
from PopvsVac;


--Temp Table

drop table if exists PercentPopulationVaccinated;
create table PercentPopulationVaccinated(
continent varchar(255),
location varchar(255),
date timestamp,
population numeric,
new_vaccinations numeric,
rollingpplvac numeric,
percent numeric
);
insert into PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpplvac,
(sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)/population)*100 as Percent
from owid_covid_data_Death dea
	join owid_covid_data_vaccine vac
		on dea.location = vac.location
		and dea.date = vac.date;		
select*, (rollingpplvac/population)*100 as Percent
from PercentPopulationVaccinated;


--Creating View to store data for later visualization

create view PercentofPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpplvac,
(sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)/population)*100 as Percent
from owid_covid_data_Death dea
join owid_covid_data_vaccine vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null