*** Settings ***
Documentation     Negative and security tests: missing data, unknown ids and missing auth.
Resource          ../resources/booking_keywords.resource
Suite Setup       Create API Session
Test Tags         api    booking    negative

*** Test Cases ***
Unknown Booking Id Returns 404
    Get Booking    999999999    expected_status=404

Create Booking Without Required Fields Fails
    ${body}=    Create Dictionary    firstname=OnlyName
    POST On Session    booker    /booking    json=${body}    expected_status=500

Update Without Token Is Forbidden
    [Tags]    security
    ${body}=    Build Booking Body
    ${id}=    Create Booking    ${body}
    PUT On Session    booker    /booking/${id}    json=${body}    expected_status=403

Update With Invalid Token Is Forbidden
    [Tags]    security
    ${body}=    Build Booking Body
    ${id}=    Create Booking    ${body}
    ${headers}=    Auth Headers    not-a-real-token
    PUT On Session    booker    /booking/${id}    json=${body}    headers=${headers}    expected_status=403

Delete Without Token Is Forbidden
    [Tags]    security
    ${body}=    Build Booking Body
    ${id}=    Create Booking    ${body}
    DELETE On Session    booker    /booking/${id}    expected_status=403
