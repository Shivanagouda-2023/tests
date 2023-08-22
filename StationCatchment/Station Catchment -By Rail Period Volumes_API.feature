Feature: It is to test Station Catchment Details - Rail Period Volumes API
API Resource: GET /userprofiles/   /reports/{reportId}

@OAuth
Scenario: GET OAuth token
Given I have basic authentication credentials G4z3xlNpu6M5tOtSlvGtjm3fUzoV1lQd and NHKs6tdeKT0MHH0m
And I set Accept header to application/json
When I GET /accesstoken?grant_type=client_credentials
Then response code should be 200
And I store the value of body path $.accessToken as access token

@Positive 
Scenario Outline: TC_01 Successfully retrieves a data by its DATE when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to StationCatchmentByRailPeriodVolumes
And I set bearer token
Given I set time now
When I GET /rail-period-volumes?date_from=<from>&date_to=<to>&limit=<lim>
Given find response time
Given I Set Timeout for 4500 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be station-catchment-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
# And response body path $.pagination_metadata.first_page_full_path should be v2/passenger-volumes/critical-loads?date_from=<from>&date_to=<to>&limit=<lim>&page=1
And response body path $.pagination_metadata.is_last_page should be true
Then dump request {"URL":"/rail-period-volumes?date_from=<from>&date_to=<to>&limit=<lim>"}
Then dump response all

Examples:
| from | to | lim |
| 2023-03-05 | 2023-03-05 | 10 |

@Positive 
Scenario Outline: TC_02 Successfully retrieves data by its STATION CODE when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to StationCatchmentByRailPeriodVolumes
And I set bearer token
Given I set time now
When I GET /rail-period-volumes?station_code=<station_code>&mode=<mode>&limit=<lim>
Given find response time
Given I Set Timeout for 4000 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be station-catchment-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
And response body path $.data[0].station_code should be <station_code>
And response body path $.data[0].mode_of_transport should be <mode>
Then dump request {"URL":"/rail-period-volumes?station_code=<station_code>&mode=<mode>&limit=<lim>"}
Then dump response all

Examples:
| station_code | mode | lim |
| MAN | AIRPLANE | 10 |
| LIV | WALKING | 10 |

@Positive 
Scenario Outline: TC_03 Successfully retrieves data when valid MILE value is passed with the request. 
Given I set APIGW-Tracking-Header header to StationCatchmentByRailPeriodVolumes
And I set bearer token
Given I set time now
When I GET /rail-period-volumes?date=<date>&weekend=<weekend>&mile=<mile>&limit=10
Given find response time
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be station-catchment-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
# And response body path $.data[0].<agg> should be of type string
Then dump request {"URL":"/rail-period-volumes?date=<date>&weekend=<weekend>&mile=<mile>&limit=10"}
Then dump response all

Examples:
| date | weekend | mile |
| 2023-03-05 | true | first |
| 2023-03-05 | false | last |