Feature: It is to test Modal Share API
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
Given I set APIGW-Tracking-Header header to ModalShare
And I set bearer token
Given I set time now
When I GET ?date_from=<from>&date_to=<to>&limit=<lim>
Given find response time
Given I Set Timeout for 1000 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be modal-share-api
And response body field $.api_name should be of type string
And response body path $.version should be 2.0
# And response body path $.pagination_metadata.first_page_full_path should be /v2/modal-share?date_from=<from>&date_to=<to>&limit=<lim>&page=1
And response body path $.pagination_metadata.is_last_page should be true
Then dump request {"URL":"?date_from=<from>&date_to=<to>&limit=<lim>"}
Then dump response all

Examples:
| from | to | lim |
| 2023-03-05 | 2023-03-05 | 10 |


@Positive 
Scenario Outline: TC_02 Successfully retrieves data by its OUTPUT AREA TYPE , ORIGIN AND DESTINATION when Oauth token is passed with the request. 
Given I set APIGW-Tracking-Header header to ModalShare
And I set bearer token 
Given I set time now
When I GET ?output_area_type=<output_area_type>&origin=<origin>&destination=<destination>&agg=<agg>&limit=<lim>
Given find response time
Given I Set Timeout for 1000 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be modal-share-api
And response body field $.api_name should be of type string
And response body path $.version should be 2.0
And response body path $.data[0].origin_<output_area_type> should be <origin>
And response body path $.data[0].destination_<output_area_type> should be <destination>
Then dump request {"URL":"?output_area_type=<output_area_type>&origin=<origin>&destination=<destination>&agg=<agg>&limit=<lim>"}
Then dump response all

Examples:
| output_area_type | origin | destination | agg | lim |
| lsoa | 95XX03S1 | E01000262 | origin_lsoa,destination_lsoa | 10 |
| msoa | E02000001 | E02000040 | origin_msoa,destination_msoa | 10 |
| lad | E09000002 | E09000003 | origin_lad,destination_lad | 10 |

@Positive 
Scenario Outline: TC_03 Successfully retrieves data when valid AGG values are passed with the request. 
Given I set APIGW-Tracking-Header header to ModalShare
And I set bearer token
Given I set time now
When I GET ?date_from=<from>&date_to=<to>&agg=<agg>&limit=<lim>
Given find response time
Given I Set Timeout for 2000 milliseconds
Then response code should be 200
And response header Content-Type should be application/json
And response body should be valid json
And response body path $.api_name should be modal-share-api
And response body field $.api_name should be of type string
And response body path $.version should be 2.0
Then dump request {"URL":"?date_from=<from>&date_to=<to>&agg=<agg>&limit=<lim>"}
Then dump response all

Examples:
| from | to | agg | lim |
| 2023-03-05 | 2023-03-05 | weekend_flag, time_period | 10 |
| 2023-03-05 | 2023-03-05 | origin_lsoa, origin_msoa, origin_lad, destination_lsoa, destination_msoa, destination_lad | 10 |
| 2023-03-05 | 2023-03-05 | mode_of_transport, mode_of_transport_string, journey_time_band | 10 |


@Negative 
Scenario Outline: TC_04 Error displayed for invalid LSOA/MSOA/LAD value is passed with the request. 
Given I set APIGW-Tracking-Header header to ModalShare
And I set bearer token 
Given I set time now
When I GET ?output_area_type=<output_area_type>&origin=<origin>&destination=<destination>&limit=<lim>
Given find response time
Then response code should be 400
And response header Content-Type should be application/json
And response body should be valid json
# Then response body typed field error should be "Invalid Output Area Code(s) - [';;;'].",        "Invalid Output Area Code(s) - [';;;']."
Then dump request {"URL":"?output_area_type=<output_area_type>&origin=<origin>&destination=<destination>&limit=<lim>"}
Then dump response all

Examples:
| output_area_type | origin | destination | lim |
| lsoa | ;;; | ;;; | 10 |
| msoa | ;;; | ;;; | 10 |
| lad | ;;; | ;;; | 10 |