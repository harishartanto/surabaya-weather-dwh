# Surabaya Weather Data Warehouse
This project involves the development of a comprehensive data warehouse system designed to monitor and analyze daily weather data across 31 districts in Surabaya City from January 2000 to November 2024. The project leverages an ETL (Extract, Transform, Load) pipeline built with Pentaho Data Integration (PDI) to process and organize data efficiently. The processed data is stored in MySQL databases using both OLTP (Online Transaction Processing) and OLAP (Online Analytical Processing) schemas, enabling robust data management and analysis. Additionally, in this project, a Tableau dashboard was created to visualize the historical weather data, providing insights into weather patterns, conditions, and trends in Surabaya City.

## Technology Used
- **ETL Tools**: Pentaho Data Integration (PDI) Deveoper Edition 9.4.0.0-343
- **Database**: MySQL (Community Server) 8.4.3 
- **Visualization**: Tableau Desktop 2024.3
- **Data Source**: [OpenMeteo](https://open-meteo.com/); [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page); [kodewilayah.id](https://kodewilayah.id/); [CEDA Artefacts Service](https://artefacts.ceda.ac.uk/); [Badan Meteorologi, Klimatologi, dan Geofisika (BMKG) Indonesia](https://www.bmkg.go.id/)

## Data Sources
- **Administrative and Geographical Data**: 
    - District and city names were extracted from and Wikidata (via web scraping) and validated using data from kodewilayah.id, based on [Peraturan Menteri Dalam Negeri (Permendagri) No. 72/2019](https://peraturan.go.id/id/permendagri-no-72-tahun-2019).
    - District and city codes were sourced from kodewilayah.id.
    - District and city latitude and longitude data were sourced from Wikidata (via web scraping), based on [Geographic Names Server](https://geonames.nga.mil/geonames/GNSHome/index.html) (GNS).
    - District and city elevation data were extracted from OpenMeteo (via [Historical Weather API](https://open-meteo.com/en/docs/historical-weather-api)).
- **Weather Data**: Extracted from OpenMeteo (via [Elevation API](https://open-meteo.com/en/docs/elevation-api)) 
- **Weather Condition Codes**: Descriptions of weather codes (WMO Code 4677) were scraped from [WMO Meteorological codes](https://artefacts.ceda.ac.uk/badc_datadocs/surface/code.html) pages in the CEDA Artefacts Service.
- **Rainfall Intensity**: Rainfall intensity criteria were sourced from BMKG.

## Project Workflow
1. Prepare OLTP and OLAP Databases:
    - Import the database schemas using the `*_db-dump.sql` files provided in the `data/mysql_db` directory.
    - Use the OLTP and OLAP SQL files to set up the databases.
2. Extract Data:
    - Run the PDI transformations to extract data from various sources.
        - get_districts.ktr: Extracts administrative area data.
        - get_weather-historical.ktr: Extracts historical weather data from OpenMeteo.
        - get_wmo_code.ktr: Extracts weather condition codes (WMO Code 4677) from the CEDA Artefacts Service.
3. Initialize Dimension Tables:
    - Run the following transformations in PDI:
        - insert_dim_time.ktr: Initializes data for time dimension table (dim_time).
        - insert_dim_rainfall.ktr: Initializes data for rainfall intensity dimension table (dim_rainfall) based on BMKG criteria.
4. Transform and Load Data:
    - Run the weather_transform.kjb job in PDI to load data from the OLTP to the OLAP schema. This job focuses on transforming and loading data for the following tables:
        - dim_location
        - dim_weather_condition
        - fact_weather

## Tableau Dashboard
The interactive Tableau dashboard for this project was built using Tableau Desktop with data sourced directly from the OLAP schema in MySQL. The final dashboard is available on Tableau Public: [Surabaya Historical Weather Analytics Dashboard](https://public.tableau.com/app/profile/angela.lisanthoni/viz/HistoricalWeatherAnalytics/Dashboard1)

## Project Report
For a detailed explanation of the project, including methodologies, results, and diagrams, refer to the [Project Deck](https://www.canva.com/design/DAGZKwUAyv0/LtfSvrZqweu3FvXN99QeXg/view?utm_content=DAGZKwUAyv0&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=h1b04c1925b) or [Project Report](./others/Project%20Report.pdf) in the `others` directory.