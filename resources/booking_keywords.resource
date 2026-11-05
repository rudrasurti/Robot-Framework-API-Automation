*** Settings ***
Documentation     Reusable keywords for the Restful-booker API.
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Resource          variables.resource

*** Keywords ***
Create API Session
    [Documentation]    Opens a session that every test reuses.
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    Create Session    booker    ${BASE_URL}    headers=${headers}    verify=${True}

Get Auth Token
    [Documentation]    Logs in as admin and returns an auth token.
    ${body}=    Create Dictionary    username=${ADMIN_USER}    password=${ADMIN_PASSWORD}
    ${resp}=    POST On Session    booker    /auth    json=${body}    expected_status=200
    Dictionary Should Contain Key    ${resp.json()}    token
    RETURN    ${resp.json()}[token]

Build Booking Body
    [Documentation]    Returns a valid booking payload. Override any field with named arguments.
    [Arguments]    ${firstname}=${FIRSTNAME}    ${lastname}=${LASTNAME}    ${totalprice}=${TOTAL_PRICE}
    ...    ${depositpaid}=${True}    ${checkin}=${CHECKIN}    ${checkout}=${CHECKOUT}    ${needs}=${NEEDS}
    ${dates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${body}=    Create Dictionary    firstname=${firstname}    lastname=${lastname}    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}    bookingdates=${dates}    additionalneeds=${needs}
    RETURN    ${body}

Create Booking
    [Documentation]    Creates a booking and returns its id.
    [Arguments]    ${body}
    ${resp}=    POST On Session    booker    /booking    json=${body}    expected_status=200
    Dictionary Should Contain Key    ${resp.json()}    bookingid
    RETURN    ${resp.json()}[bookingid]

Get Booking
    [Arguments]    ${booking_id}    ${expected_status}=200
    ${resp}=    GET On Session    booker    /booking/${booking_id}    expected_status=${expected_status}
    RETURN    ${resp}

Auth Headers
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    RETURN    ${headers}

Booking Should Match
    [Documentation]    Verifies every field of a booking response against the expected body.
    [Arguments]    ${actual}    ${expected}
    Should Be Equal    ${actual}[firstname]       ${expected}[firstname]
    Should Be Equal    ${actual}[lastname]        ${expected}[lastname]
    Should Be Equal As Integers    ${actual}[totalprice]    ${expected}[totalprice]
    Should Be Equal    ${actual}[depositpaid]     ${expected}[depositpaid]
    Should Be Equal    ${actual}[bookingdates][checkin]     ${expected}[bookingdates][checkin]
    Should Be Equal    ${actual}[bookingdates][checkout]    ${expected}[bookingdates][checkout]

Response Should Match Schema
    [Documentation]    Validates a JSON response body against a JSON Schema file in schemas/.
    [Arguments]    ${body}    ${schema_file}
    ${path}=    Normalize Path    ${CURDIR}/../schemas/${schema_file}
    ${schema}=    Evaluate    json.load(open($path))    modules=json
    Evaluate    jsonschema.validate(instance=$body, schema=$schema)    modules=jsonschema
