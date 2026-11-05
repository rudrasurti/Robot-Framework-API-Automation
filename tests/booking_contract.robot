*** Settings ***
Documentation     Contract tests: responses must match the JSON Schemas in schemas/.
Resource          ../resources/booking_keywords.resource
Suite Setup       Create API Session
Test Tags         api    booking    contract

*** Test Cases ***
Create Booking Response Matches Schema
    [Tags]    smoke
    ${body}=    Build Booking Body
    ${resp}=    POST On Session    booker    /booking    json=${body}    expected_status=200
    Response Should Match Schema    ${resp.json()}    create_booking_response.json

Get Booking Response Matches Schema
    ${body}=    Build Booking Body
    ${id}=    Create Booking    ${body}
    ${resp}=    Get Booking    ${id}
    Response Should Match Schema    ${resp.json()}    booking.json
