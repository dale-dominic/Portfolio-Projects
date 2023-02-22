-- Data on COVID-19 taken from Our World in Data. Exploration done in BigQuery -- 


-- Cases & Deaths Over Time --
SELECT 
  location, date, population, new_cases,total_cases,(total_cases/population)*100 AS infection_rate,
  new_deaths, total_deaths, (total_deaths/total_cases)*100 AS case_fatality_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total` 
WHERE 
  continent IS NOT null
ORDER BY 
  location, date;


-- Total Cases vs Total Deaths --
SELECT 
  location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS case_fatality_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total` 
WHERE 
  continent IS NOT null
ORDER BY 
  location, date;


-- Total Cases vs Total Population (Philippines) --
SELECT 
  location, date, population, total_cases,(total_cases/population)*100 AS infection_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total` 
WHERE 
  location = 'Philippines' 
ORDER BY 
  location, date;


-- Order by Infection Rate --
SELECT 
  location, population, 
  MAX(total_cases) as total_cases, 
  (MAX(total_cases)/population)*100 AS infection_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total`
WHERE 
  continent IS NOT null
GROUP BY 
  location, population
ORDER BY
  infection_rate DESC;


-- Order by Case Fatality Rate --
SELECT 
  location, population, 
  MAX(total_deaths) as total_deaths, MAX(total_cases) as total_cases,
  (MAX(total_deaths)/MAX(total_cases))*100 AS case_fatality_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total` 
WHERE 
  continent IS NOT null
GROUP BY 
  location, population
ORDER BY 
  case_fatality_rate DESC;


-- Order by Death Count --
SELECT 
  location, population, 
  MAX(total_deaths) as total_deaths, 
  (MAX(total_deaths)/MAX(total_cases))*100 AS case_fatality_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total` 
WHERE 
  continent IS NOT null
GROUP BY 
  location, population
ORDER BY 
  total_deaths DESC;


-- Continent Overview --
SELECT 
  continent, MAX(population) as population, 
  MAX(total_cases) AS total_cases,(MAX(total_cases)/MAX(population))*100 AS  infection_rate,
  MAX(total_deaths) as total_deaths, 
  (MAX(total_deaths)/MAX(total_cases))*100 AS case_fatality_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total` 
WHERE 
  continent IS NOT NULL
GROUP BY 
  continent
ORDER BY 
  total_deaths DESC;

-- Countries Overview --
SELECT 
  location, MAX(population) as population, 
  MAX(total_cases) AS total_cases,(MAX(total_cases)/MAX(population))*100 AS  infection_rate,
  MAX(total_deaths) as total_deaths, 
  (MAX(total_deaths)/MAX(total_cases))*100 AS case_fatality_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total` 
GROUP BY 
  location
ORDER BY 
  location;


-- Global Overview -- 
SELECT 
  MAX(total_cases) AS total_cases, MAX(total_deaths) as total_deaths, 
  (MAX(total_cases)/MAX(population))*100 AS  infection_rate, 
  (MAX(total_deaths)/MAX(total_cases))*100 AS case_fatality_rate
FROM 
  `personal-portfolio-377910.Coronavirus.covid_total`;


-- Vaccination Over Time by Country --
SELECT 
  location, date, population, new_vaccinations, total_vaccinations, people_vaccinated,
  LAST_VALUE(people_vaccinated/population*100 IGNORE NULLS) OVER (PARTITION BY location ORDER BY date) AS vaccination_rate
FROM
  `personal-portfolio-377910.Coronavirus.covid_total`
WHERE
  continent IS NOT NULL
ORDER BY
  location, date;


-- Rolling Headline Figures (Infections, Deaths, Vacctinations, and Corresponding Rates) by Country --
SELECT 
  location, date, population,
  new_cases,total_cases,(total_cases/population)*100 AS infection_rate,
  new_deaths, total_deaths, (total_deaths/total_cases)*100 AS case_fatality_rate, 
  new_vaccinations, people_vaccinated,
  LAST_VALUE(people_vaccinated/population*100 IGNORE NULLS) OVER (PARTITION BY location ORDER BY date) AS vaccination_rate
FROM
  `personal-portfolio-377910.Coronavirus.covid_total`
WHERE
  continent IS NOT NULL
ORDER BY
  location, date;


-- Creating a View for Headline Figures --
CREATE VIEW Coronavirus.covid_headline_stats AS
SELECT 
  location, date, population,
  new_cases,total_cases,(total_cases/population)*100 AS infection_rate,
  new_deaths, total_deaths, (total_deaths/total_cases)*100 AS case_fatality_rate, 
  new_vaccinations, people_vaccinated,
  LAST_VALUE(people_vaccinated/population*100 IGNORE NULLS) OVER (PARTITION BY location ORDER BY date) AS vaccination_rate
FROM
  `personal-portfolio-377910.Coronavirus.covid_total`
WHERE
  continent IS NOT NULL
ORDER BY
  location, date;
