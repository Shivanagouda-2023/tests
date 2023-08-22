Feature: It is to test OD Matrix - Journey Wise Volumes API
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
Given I set APIGW-Tracking-Header header to ODMatrixJourneyWiseVolume
And I set bearer token
Given I set time now
When I GET /journey-volumes?date_from=<from>&date_to=<to>&limit=<lim>
Given find response time
Given I Set Timeout for 4500 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be od-matrix-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
# And response body path $.pagination_metadata.first_page_full_path should be /v1/origin-destination-matrices/journey-volumes?date_from=<from>&date_to=<to>&limit=<lim>&page=1
And response body path $.pagination_metadata.is_last_page should be true
Then dump request {"URL":"/journey-volumes?date_from=<from>&date_to=<to>&limit=<lim>"}
Then dump response all

Examples:
| from | to | lim | 
| 2023-05-17 | 2023-05-17 | 10 | 

@Positive 
Scenario Outline: TC_02 Successfully retrieves data by its ORIGIN AND DESTINATION STATION when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to ODMatrixJourneyWiseVolume
And I set bearer token
Given I set time now
When I GET /journey-volumes?origin_station=<origin>&destination_station=<destination>&agg=<agg>&limit=<lim>
Given find response time
Given I Set Timeout for 4000 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be od-matrix-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
And response body path $.data[0].origin_station_code should be <origin>
And response body path $.data[0].destination_station_code should be <destination>
Then dump request {"URL":"/journey-volumes?origin_station=<origin>&destination_station=<destination>&agg=<agg>&limit=<lim>"}
Then dump response all

Examples:
| origin | destination | agg | lim |
| MAN | LIV | origin_station_code,destination_station_code | 10 |
| MYB | BAN | origin_station_code,destination_station_code | 10 |

@Positive 
Scenario Outline: TC_03 Successfully retrieves data when valid AGG value is passed with the request. 
Given I set APIGW-Tracking-Header header to ODMatrixJourneyWiseVolume
And I set bearer token
Given I set time now
When I GET /journey-volumes?date=<date>&agg=<agg>&limit=10
Given find response time
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be od-matrix-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
# And response body field $.data[0].<agg> should be of type string
Then dump request {"URL":"/journey-volumes?date=<date>&agg=<agg>&limit=10"}
Then dump response all

Examples:
| date | agg |
| 2023-05-17 | hour, day_of_week, origin_station_code, origin_station_name, destination_station_code, destination_station_name, direct_flag, station_string |

