SELECT *
FROM dbo.CovidDeaths
ORDER BY 3,4

SELECT *
FROM dbo.CovidVaccinations
ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population 
FROM dbo.CovidDeaths
WHERE continent is not null 
ORDER BY 1,2

-- Looking at total cases vs total deaths
-- Shows the likelihood of death due to Covid by country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM dbo.CovidDeaths
WHERE location like '%state%'
AND WHERE continent is not null 
ORDER BY 1,2 

-- Looking at total cases vs population
-- Shows the percentage of population that was diagnosed with Covid 
SELECT location, date, population, total_cases, (total_cases/population)*100 AS percentage_population_infected
FROM dbo.CovidDeaths
-- WHERE location like '%state%'
WHERE continent is not null 
ORDER BY 1,2 

-- Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percentage_population_infected
FROM dbo.CovidDeaths
-- WHERE location like '%state%'
WHERE continent is not null 
GROUP BY location, population
ORDER BY percentage_population_infected DESC


-- Showing the countries with the highest death count per population
SELECT location, MAX(cast(total_deaths as int)) AS total_death_count
FROM dbo.CovidDeaths
-- WHERE location like '%state%'
WHERE continent is not null 
GROUP BY location
ORDER BY total_death_count DESC

-- Showing the continents with the highest death count per population
SELECT continent, MAX(cast(total_deaths as int)) AS total_death_count
FROM dbo.CovidDeaths
-- WHERE location like '%state%'
WHERE continent is not null 
GROUP BY continent
ORDER BY total_death_count DESC

-- Global numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS death_percentage
FROM dbo.CovidDeaths
-- WHERE location like '%state%'
WHERE continent is not null 
GROUP BY DATE 
ORDER BY 1,2 

-- Shows the total cases recorded across the world and the percentage of cases that led to death

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS death_percentage
FROM dbo.CovidDeaths
-- WHERE location like '%state%'
WHERE continent is not null 
ORDER BY 1,2 

-- Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (rolling_people_vaccinated/population)*100
FROM dbo.CovidDeaths AS dea
JOIN dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3

-- USING CTE
WITH pops_vac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (rolling_people_vaccinated/population)*100
FROM dbo.CovidDeaths AS dea
JOIN dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
-- ORDER BY 2, 3
)

SELECT *
FROM pops_vac


SELECT *, (rolling_people_vaccinated/population)*100
FROM pops_vac

-- TEMP table 

DROP TABLE IF exists #percentage_population_vaccinated 
CREATE TABLE #percentage_population_vaccinated 
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric 
)

INSERT INTO #percentage_population_vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (rolling_people_vaccinated/population)*100
FROM dbo.CovidDeaths AS dea
JOIN dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
-- WHERE dea.continent is not null
-- ORDER BY 2, 3

SELECT *, (rolling_people_vaccinated/population)*100
FROM #percentage_population_vaccinated
 
 -- Creating View to store data for data visualisations
 
 CREATE VIEW percentage_population_vaccinated AS
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (rolling_people_vaccinated/population)*100
FROM dbo.CovidDeaths AS dea
JOIN dbo.CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3

SELECT *
FROM percentage_population_vaccinated 