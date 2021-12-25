-- Covid 19 Data Exploration  from 24-2-2020->20-12-2021--
----source: https://ourworldindata.org/covid-deaths---
--Use database
use Covid_19
go
-- Select two table in database
Select *
From CovidDeaths$
Where continent is not null 
order by 3,4
--------------------
select * from CovidVaccine$

-- 1.select Data that we are going to be exploring withs
Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths$
Where continent is not null 
order by 1,2

--2.Total Cases vs Total Deaths and percentage by Location
---- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$_FilterDatabase
order by 1,2

--3.Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  
round(Max((total_cases/population)),4)*100 as PercentPopulationInfected
From CovidDeaths$_FilterDatabase
Group by Location, Population
order by PercentPopulationInfected desc

--4. Countries with Highest Death Count per Population

Select Location,Population, max(cast(Total_deaths as int)) as TotalDeathCount
,round(Max((Total_deaths/population)),4)*100 as percentage_deaths
From CovidDeaths$
Group by Location,Population
order by TotalDeathCount desc

--5. Showing contintents with the highest death count per population
Select continent, sum(new_cases) as TotalDeathCount,sum(new_cases)/sum(population)*100 as Percen_newcase_on_Population
From CovidDeaths$_FilterDatabase a
where continent is not null
Group by continent

-- 6.New cases on Global
Select SUM(new_cases) as Total_cases, SUM(new_deaths ) as Total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths$_FilterDatabase
where continent is not null 
--Group By date

---7.Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$_FilterDatabase
Where continent is not null 
Group by Location
order by TotalDeathCount desc
-- 8. Total case, deaths and percentage on global
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths$
where continent is not null 
order by 1,2

-- Total Population vs Vaccinations---
-- 9.Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as numeric(12,0)))  OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated 
From CovidDeaths$ dea
Join CovidVaccine$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 5 desc
--Create View to store --
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as numeric(12,0)))  OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated 
From CovidDeaths$ dea
Join CovidVaccine$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 5 desc


