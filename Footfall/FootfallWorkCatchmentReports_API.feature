Feature: It is to test Work Catchment-wise Footfall Report API
API Resource: GET /userprofiles/   /reports/{reportId}

@OAuth
Scenario: GET OAuth token
Given I have basic authentication credentials G4z3xlNpu6M5tOtSlvGtjm3fUzoV1lQd and NHKs6tdeKT0MHH0m
And I set Accept header to application/json
When I GET /accesstoken?grant_type=client_credentials
Then response code should be 200
And I store the value of body path $.accessToken as access token

@Positive 
Scenario Outline: TC_01 Successfully retrieves a data by its LOCATION when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to WorkCatchmentFootfallReports
And I set bearer token 
When I GET /work-catchment?location=<loc>&limit=<lim>
Given I Set Timeout for 4500 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be footfall-reports-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
# And response body path $.pagination_metadata.first_page_full_path should be /v2/alighters-boarders?date_from=<from>&date_to=<to>&limit=<lim>&page=1
# And response body typed field date_to should be <to>
And response body path $.pagination_metadata.is_last_page should be true
And response body path $.data[0].poi_name should be <loc>
Then dump request all
Then dump response all

Examples:
| loc | lim | 
| Aintree | 10 |

@Positive 
Scenario Outline: TC_02 Successfully retrieves a data by its DATE_FROM and DATE_TO when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to WorkCatchmentFootfallReports
And I set bearer token 
When I GET /work-catchment?date_from=<from>&date_to=<to>&limit=<lim>
Given I Set Timeout for 4500 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be footfall-reports-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
# And response body path $.pagination_metadata.first_page_full_path should be /v2/alighters-boarders?date_from=<from>&date_to=<to>&limit=<lim>&page=1
# And response body typed field date_to should be <to>
And response body path $.pagination_metadata.is_last_page should be true
Then dump request all
Then dump response all

Examples:
| from | to | lim |
| 2022-08-15 | 2022-08-15 | 10 |

@Positive 
Scenario Outline: TC_03 Successfully retrieves a data by its DATE when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to WorkCatchmentFootfallReports
And I set bearer token 
When I GET /work-catchment?date=<date>&limit=<lim>
Given I Set Timeout for 4500 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be footfall-reports-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
# And response body path $.pagination_metadata.first_page_full_path should be /v2/alighters-boarders?date_from=<from>&date_to=<to>&limit=<lim>&page=1
# And response body typed field date_to should be <to>
And response body path $.pagination_metadata.is_last_page should be true
Then dump request all
Then dump response all

Examples:
| date | lim |
| 2022-08-15 | 10 |

@Positive 
Scenario Outline: TC_04 Successfully retrieves data by its CLIENT NAME when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to WorkCatchmentFootfallReports
And I set bearer token 
When I GET /work-catchment?client_name=<client_name>&limit=<lim>
Given I Set Timeout for 4000 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be footfall-reports-api
And response body field $.api_name should be of type string
And response body path $.version should be 1.0
And response body path $.data[0].client_name should be <client_name>
Then dump request all
Then dump response all

Examples:
| client_name | lim |
| BT | 10 |
| Signet Jewelers | 10 |