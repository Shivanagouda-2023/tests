Feature: It is to test Passenger Volume API
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
Given I set APIGW-Tracking-Header header to PassengerVolume
And I set bearer token 
# And I set body to {"sessionId": "abc"}
Given I set time now
When I GET ?date_from=<from>&date_to=<to>&limit=<lim>
Given find response time
Given I Set Timeout for 4500 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be passenger-volumes
And response body field $.api_name should be of type string
And response body path $.version should be 2.0
# And response body path $.pagination_metadata.first_page_full_path should be /v2/passenger-volumes?date_from=<from>&date_to=<to>&limit=<lim>&page=1
And response body path $.pagination_metadata.is_last_page should be true
Then dump request {"URL":"?date_from=<from>&date_to=<to>&limit=<lim>"}
Then dump response all

Examples:
| from | to | lim |
| 2023-04-01 | 2023-04-01 | 10 |

@Positive 
Scenario Outline: TC_02 Successfully retrieves data by its ORIGIN AND DESTINATION STATION when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to PassengerVolume
And I set bearer token 
# And I set body to {"sessionId": "abc"}
Given I set time now
When I GET ?origin_station=<origin>&destination_station=<destination>&limit=<lim>
Given find response time
Given I Set Timeout for 4000 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be passenger-volumes
And response body field $.api_name should be of type string
And response body path $.version should be 2.0
And response body path $.data[0].act_service_origin_station_code should be <origin>
And response body path $.data[0].act_service_destination_station_code should be <destination>
Then dump request {"URL":"?origin_station=<origin>&destination_station=<destination>&limit=<lim>"}
Then dump response all

Examples:
| origin | destination | lim |
| MAN | LIV | 10 |
| MYB | BAN | 10 |

@Positive 
Scenario Outline: TC_03 Successfully retrieves data when valid AGG value is passed with the request. 
Given I set APIGW-Tracking-Header header to PassengerVolume
And I set bearer token
Given I set time now
When I GET ?date=<date>&agg=<agg>&limit=10
Given find response time
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be passenger-volumes
And response body field $.api_name should be of type string
And response body path $.version should be 2.0
# And response body field $.data[0].<agg> should be of type string
Then dump request {"URL":"?date=<date>&agg=<agg>&limit=10"}
Then dump response all

Examples:
| date | agg |
| 2023-04-01 | age_band |
| 2023-04-02 | purpose |
| 2023-04-03 | gender |

@Positive 
Scenario Outline: TC_03 Successfully retrieves data when valid RID value is passed with the request. 
Given I set APIGW-Tracking-Header header to PassengerVolume
And I set bearer token
Given I set time now
When I GET ?date=<date>&rid=<rid>&limit=10
Given find response time
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be passenger-volumes
And response body field $.api_name should be of type string
And response body path $.version should be 2.0
And response body path $.data[0].rid should be <rid>
Then dump request {"URL":?date=<date>&rid=<rid>&limit=10"}
Then dump response all

Examples:
| date | rid |
| 2023-04-01 | 202304016447369 |
| 2023-04-01 | 202304016447445 |

@Positive 
Scenario Outline: TC_03 Successfully retrieves data when valid TRAIN_ID value is passed with the request. 
Given I set APIGW-Tracking-Header header to PassengerVolume
And I set bearer token
Given I set time now
When I GET ?date=<date>&uid=<uid>&limit=10
Given find response time
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be passenger-volumes
And response body field $.api_name should be of type string
And response body path $.version should be 2.0
And response body path $.data[0].uid should be <uid>
Then dump request {"URL":?date=<date>&uid=<uid>&limit=10"}
Then dump response all

Examples:
| date | uid |
| 2023-04-01 | 47369 |
| 2023-04-01 | 47445 |



