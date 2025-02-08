# ST207 Group Project - AT2024

## Group name

AGOODTEAM

## Topic (database application)

Public Transport Optimization Using London Transit Data

The database application focuses on managing and analyzing data related to London’s public transportation network. It aims to optimize route planning, monitor delays, estimate carbon emissions, analyze commercial usage, and assess the impact of weather on transportation. The system will integrate structured data (e.g., schedules, delays, passenger counts) and spatial data (e.g., route maps) to deliver actionable insights for policymakers, transport operators, and commuters.

## Data sources

* Transport for London (TfL) Open Data, URL: https://tfl.gov.uk/info-for/open-data-user
* OpenStreetMap (OSM), URL: https://www.openstreetmap.org/
* TfL Live Updates API, URL: TfL API
* UK Department for Transport (DfT), URL: https://www.gov.uk/government/organisations/department-for-transport
* Carbon Trust, URL: https://www.carbontrust.com/
* TfL Ridership Data: URL: TfL Ridership Data
* OpenWeather API https://openweathermap.org/api
* UK Met Office https://www.metoffice.gov.uk/services/data"

## Proposed use cases and queries

Use Case 1: Optimize Routes

Goal: Provide commuters and operators with the most efficient routes based on delays, traffic, and passenger load.

Query1: ""Find the fastest route between two locations, considering current delays and traffic conditions.""
Query2: ""Identify routes with the highest passenger volume during peak hours.""

Use Case 2: Monitor delays.

Goal: Track delays in public transport and identify frequent bottlenecks to improve service reliability.

Query1: ""List all active delays on bus and train routes in London.""
Query2: ""Identify routes with the most frequent delays over the last month.""

Use Case 3: Spatial Analysis of Traffic and Carbon Emissions

Goal: Estimate carbon emissions for different transportation modes and analyze their environmental impact.

Query 1:calculate the carbon emissions for a specific route based on passenger load and vehicle type                                        
Query 2: generate heatmaps of carbon emissions across different areas of London, correlating with traffic flow and transport usage

Use Case 4: Commercial Usage Analysis

Goal: Understand passenger behavior and identify commercial opportunities, such as ad placements or service expansions.

Query1: ""Identify the stations with the highest footfall during weekends.""
Query2: ""Find routes with high passenger volume and long travel times, ideal for in-vehicle advertising.""

Use Case 5: Weather Impact Assessment

Goal: Assess how weather conditions affect delays, passenger volume, and carbon emissions in public transport.

Query 1: Calculate the percentage of delays on each bus route at different rainfall levels
Query 2: Show the passenger volume for each route at each temperature level.

PS: We'd like to know whether the project requires 5 use cases or 5 queries."

## Feedback

The proposed database is relevant and close to a real scenario. My general advice is for you to prioritise data that allows for more analytical queries, such as patterns, evolution of a given attribute over time, any groups or clusterings that allow for window functions or similar, and other "dynamic" aspects of the database. You should avoid any static queries, such as retrieving basic information from tables. In this sense, it seems that most of your queries focus on dynamic aspects of the transportation system to provide advice/insights.

Some points to revise/clarify:
* the form asks for 5 use cases or queries, assuming that each use query will have at least one query. In this context, your 5 use cases are really interesting and may require more than one query to, for instance, build views from multiple tables, explore analytical operators (such as window functions), and present results.
* you may consider an overlapping between use cases 1 and 2 in terms of delay analysis. Passenger volumes are, somewhat, static; i.e., for a given route, after some time, it is possible to assume a known passenger volume. Unless you plan to keep track of this in real time, this would be a static information that you can use to provide recommendations.
* the delay analysis, in general, is an interesting query if you are able to capture and process real-time data about traffic and transportation means (for instance, bus or train). In use case 1, I would suggest concentrating on query 1 ("Find the fastest route between two locations, considering current delays and traffic conditions.") only, as this also accounts for monitoring delays.
* use case 2 could, perhaps, look at the relation between passenger volume vs delay, in the sense of anticipating delays given volume. TfL calls this "station businesses" and try to infer how busy a station would be given peak hours or specific events in nearby locations.
* use case 3 is fine and you should address both problems: calculate carbon emissions and visualise them as heat maps.
* use case 4 is fine and partially builds from use case 2. I would suggest designing some views to aggregate the data necessary for both use cases, and then exploring the specific queries of each use case.
* use case 5 could be incorporated in the other use cases, as one specific scenario for analysis. I don't see a huge difference here, so it would be better to add weather conditions to the other scenarios. In this case, you don't need a new use case 4. The set and complexity of your queries will be sufficient.
* one important aspect is to consider the complexity of all data sources involved and how to capture, clean, and harmonise them.

## Decision: approved

The project is fine. You don't need to resubmit but make sure to provide a sound explanation of your final use cases, considering these suggestions, in the final report.
