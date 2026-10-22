select *
From portfolioproject1..CovidDeaths
order by 3,4
----select *
----From portfolioproject1..CovidVaccination
----order by 3,4
-- selcet data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths,population
FROM portfolioproject1..CovidDeaths
order by 1,2
--Looking at total cases Vs total deaths
SELECT location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
FROM portfolioproject1..CovidDeaths
Where location like '%state%'
order by 1,2
--Looking at total cases vs population
--show what percentage of population got covid?
SELECT location, date, total_cases,population,(total_cases/population)*100 as covid_Percentage
FROM portfolioproject1..CovidDeaths
--Where location like '%state%'
order by 1,2
--Looking at countries with highest infection rates
SELECT location,population, Max(total_cases) as Highestinfectioncount,Max(total_cases/population)*100 as Countries_Highest_Infection_rate
FROM portfolioproject1..CovidDeaths
--Where location = 'Pakistan'
Group by location,population
order by Countries_Highest_Infection_rate desc
--Where location like '%state%'
--Showing countries with highest and lowest death count per population
SELECT location,population,Max(total_deaths) as Highestdeathcount,Max(total_deaths/population)*100 as Countries_Highest_death_rate,
MIN(total_deaths) as Lowestdeathcount,MIN(total_deaths/population)*100 as Countries_Lowest_death_rate
FROM portfolioproject1..CovidDeaths
Where continent is not null
Group by location,population
order by Countries_Highest_death_rate desc

SELECT location,MAX(cast(total_deaths as int)) as highestdeathcount
FROM portfolioproject1..CovidDeaths
Where continent is null
AND total_deaths is not null
Group by location
order by highestdeathcount desc

--Breaking down  in continents
--Showing continents with the highest death count per population
select continent,max(cast(total_deaths as int)) as highestdeathcount
From portfolioproject1..CovidDeaths
group by continent
order by highestdeathcount desc

--Global numbering
select sum(cast(new_cases as int)),sum(cast(new_deaths as int)),(sum(cast(new_cases as int))/sum(cast(new_deaths as int))) as newdeathcount
From portfolioproject1..CovidDeaths
group by continent
order by newdeathcount desc

--Joining two tables
select *
From portfolioproject1..CovidVaccination vac
join portfolioproject1..CovidDeaths dea
on vac.location = dea. location
 and vac.date = dea.date

--looking at total population vs vaccination
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
FROM portfolioproject1..CovidDeaths dea
JOIN portfolioproject1..CovidVaccination vac
    ON vac.location = dea.location
    AND vac.date = dea.date
WHERE dea.location like '%States%'
order by 2,3

--usimg CTE( common table expression)
 WITH popvsvac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CONVERT(INT, vac.new_vaccinations)) OVER (
            PARTITION BY dea.location 
            ORDER BY dea.location, dea.date
        ) AS rollingpeoplevaccinated
    FROM portfolioproject1..CovidDeaths dea
    JOIN portfolioproject1..CovidVaccination vac
        ON vac.location = dea.location
        AND vac.date = dea.date
    WHERE dea.location LIKE '%States%'
)
SELECT 
    *, 
    (rollingpeoplevaccinated / population) * 100 AS VaccinationPercentage
FROM popvsvac
ORDER BY 2, 3;

--Temp Table
  --NVARCHAR(255) Breakdown:
  -- N (National): Unicode (UTF-16) for multilingual support; takes 2 bytes/char.
  --ARCHAR: Variable-length storage (only uses space for actual characters used).
  --(255): Maximum character length allowed for the column.
DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated (
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccination NUMERIC,
    Rollingpeoplevaccinated NUMERIC
);
WITH popvsvac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CONVERT(INT, vac.new_vaccinations)) OVER (
            PARTITION BY dea.location 
            ORDER BY dea.location, dea.date
        ) AS rollingpeoplevaccinated
    FROM portfolioproject1..CovidDeaths dea
    JOIN portfolioproject1..CovidVaccination vac
        ON vac.location = dea.location
        AND vac.date = dea.date
)
INSERT INTO #PercentPopulationVaccinated
SELECT * FROM popvsvac;
SELECT *, (Rollingpeoplevaccinated / population) * 100 
FROM #PercentPopulationVaccinated;

-- Creating View to store data for later visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(INT, vac.new_vaccinations)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.location, dea.date
    ) AS rollingpeoplevaccinated
FROM portfolioproject1..CovidDeaths dea
JOIN portfolioproject1..CovidVaccination vac
    ON vac.location = dea.location
    AND vac.date = dea.date;