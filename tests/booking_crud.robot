*** Settings ***
Documentation     End-to-end CRUD tests for bookings: create, read, update, patch and delete.
Resource          ../resources/booking_keywords.resource
Suite Setup       Create API Session
Test Tags         api    booking

*** Test Cases ***
Health Check Returns 201
    [Tags]    smoke
    GET On Session    booker    /ping    expected_status=201

Create Booking With Valid Data
    [Tags]    smoke    positive
    ${body}=    Build Booking Body
    ${id}=    Create Booking    ${body}
    ${resp}=    Get Booking    ${id}
    Booking Should Match    ${resp.json()}    ${body}

List Bookings Returns Booking Ids
    [Tags]    positive
    ${resp}=    GET On Session    booker    /booking    expected_status=200
    Should Not Be Empty    ${resp.json()}
    Dictionary Should Contain Key    ${resp.json()}[0]    bookingid

Filter Bookings By Name
    [Tags]    positive
    ${body}=    Build Booking Body    firstname=Filter    lastname=Check
    ${id}=    Create Booking    ${body}
    ${params}=    Create Dictionary    firstname=Filter    lastname=Check
    ${resp}=    GET On Session    booker    /booking    params=${params}    expected_status=200
    ${ids}=    Evaluate    [b['bookingid'] for b in $resp.json()]
    Should Contain    ${ids}    ${id}

Full Update Replaces All Fields
    [Tags]    positive
    ${original}=    Build Booking Body
    ${id}=    Create Booking    ${original}
    ${token}=    Get Auth Token
    ${headers}=    Auth Headers    ${token}
    ${updated}=    Build Booking Body    firstname=Updated    lastname=Name    totalprice=${300}    depositpaid=${False}
    ${resp}=    PUT On Session    booker    /booking/${id}    json=${updated}    headers=${headers}    expected_status=200
    Booking Should Match    ${resp.json()}    ${updated}

Partial Update Changes Only Given Fields
    [Tags]    positive
    ${original}=    Build Booking Body
    ${id}=    Create Booking    ${original}
    ${token}=    Get Auth Token
    ${headers}=    Auth Headers    ${token}
    ${patch}=    Create Dictionary    firstname=Patched
    ${resp}=    PATCH On Session    booker    /booking/${id}    json=${patch}    headers=${headers}    expected_status=200
    Should Be Equal    ${resp.json()}[firstname]    Patched
    Should Be Equal    ${resp.json()}[lastname]     ${original}[lastname]

Delete Booking Removes It
    [Tags]    positive
    ${body}=    Build Booking Body
    ${id}=    Create Booking    ${body}
    ${token}=    Get Auth Token
    ${headers}=    Auth Headers    ${token}
    DELETE On Session    booker    /booking/${id}    headers=${headers}    expected_status=201
    Get Booking    ${id}    expected_status=404
