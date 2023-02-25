 SELECT location, population, MAX (total_cases) as HighestInfectionCount, MAX((Total_Cases/Population))*100 as PercentagePopulationInfected 
 FROM CovidDeaths
 WHERE continent is not null
 GROUP BY location, Population 
Order BY PercentagePopulationInfected desc

---Showing countries with Highest Death Count PEr Popultion 

 SELECT location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
 FROM CovidDeaths
 WHERE continent is not null 
 GROUP BY location
Order BY TotalDeathCount desc

--LETS BRING THINGS DOWN BY CONTINENT 
 SELECT location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
 FROM CovidDeaths
 WHERE continent is null 
 GROUP BY location
Order BY TotalDeathCount desc

 SELECT continent, MAX(CAST(Total_deaths as int)) as TotalDeathCount
 FROM CovidDeaths
 WHERE continent is not null 
 GROUP BY continent
Order BY TotalDeathCount desc

--- Showingtyhe continent with highest dearh count 

 SELECT location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
 FROM CovidDeaths
 WHERE continent is not null 
 GROUP BY location
Order BY TotalDeathCount desc

--- Global Numbers 
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like 'Nigeria'
where continent is not null
group by date
order by 1,2 

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like 'Nigeria'
where continent is not null
--group by date
order by 1,2 



--looking at total population vs vaccinnations 


with PopvsVac (continent, location , Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,new_vaccinations)) 
over (partition by dea.location order by dea.location, 
dea.date) 
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 
From PopvsVac

--TEMP TABLE 

Create Table #PercentPopulationVaccinated
( 
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric, 
New_Vaccinations numeric,
RollingPeoplevaccinated numeric)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,new_vaccinations)) 
over (partition by dea.location order by dea.location, 
dea.date) 
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 
From #PercentPopulationVaccinated

--creating view to store data for later visualization 

create view PercentagePopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(convert(int,new_vaccinations)) 
over (partition by dea.location order by dea.location, 
dea.date) 
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

drop view if exists PercentagePopulationVaccinatedd

select * from PercentagePopulationVaccinated