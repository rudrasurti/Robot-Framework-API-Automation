*** Settings ***
Documentation     Authentication tests for the Restful-booker API.
Resource          ../resources/booking_keywords.resource
Suite Setup       Create API Session
Test Tags         api    auth

*** Test Cases ***
Valid Credentials Return A Token
    [Tags]    smoke    positive
    ${token}=    Get Auth Token
    Should Not Be Empty    ${token}

Invalid Credentials Are Rejected
    [Tags]    negative    security
    ${body}=    Create Dictionary    username=${ADMIN_USER}    password=wrong-password
    ${resp}=    POST On Session    booker    /auth    json=${body}    expected_status=200
    Dictionary Should Not Contain Key    ${resp.json()}    token
    Should Be Equal    ${resp.json()}[reason]    Bad credentials
