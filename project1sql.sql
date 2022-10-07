select location,date,total_cases ,new_cases,total_deaths from portfolioProject..coviddeaths$
order by 1,2;




--Looking at total_cases vs total_deaths
select location,date,total_cases ,total_deaths,(total_deaths/total_cases)*100 as death_percentage from portfolioProject..coviddeaths$
where location like '%India'
order by 5 desc;

--Looking at total_cases vs Population
select location,date,population,total_cases  ,(total_cases/population)*100 as affected from portfolioProject..coviddeaths$
where location like '%India'
order by 4 desc;

-----Looking at countries with highest infection rate compared to populations
select location,population ,max(total_cases/population)*100 as InfectionnrateCount from portfolioProject..coviddeaths$
group by location,population
order by 3 desc;

-----Looking at continents with highest death count
select location,max(total_deaths) as max_deaths from portfolioProject..coviddeaths$
where continent is null
group by location
order by 2 desc;

-----------GLOBAL NUMBERS  total cases and total deaths per day 
select date,sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as "death%" from portfolioProject..coviddeaths$
where continent is not null
group by date
order by 1,3  asc 


--------------------total population vs vaccination
With Cvsva (continent
,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population ,vacc.new_vaccinations 
,sum(cast(new_vaccinations as int)) over
(partition by dea.location  order by dea.location,dea.date) as rollingpeoplevaccinated
from portfolioProject..covidvaccine$ vacc join portfolioProject..coviddeaths$  dea 
on  dea.date=vacc.date

where dea.continent is not null
)



select *, (rollingpeoplevaccinated/population)*100 from Cvsva

--temp table

create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
rollingpeoplevaccinated numeric
)

alter table  #percentpopulationvaccinated
add
new_vaccinated numeric

select * from #percentpopulationvaccinated