*** Settings ***
Documentation     Data-driven tests: one template, many booking variations.
Resource          ../resources/booking_keywords.resource
Suite Setup       Create API Session
Test Template     Booking Round Trip Should Succeed
Test Tags         api    booking    data-driven

*** Test Cases ***                      FIRSTNAME    LASTNAME     PRICE      DEPOSIT     NEEDS
Standard Booking                        Rudra        Surti        ${150}     ${True}     Breakfast
No Deposit Booking                      Asha         Patel        ${80}      ${False}    None
Zero Price Booking                      Free         Stay         ${0}       ${True}     Late checkout
Large Price Booking                     Big          Spender      ${99999}   ${True}     Airport transfer
Unicode Name Booking                    José         Müller       ${120}     ${False}    Vegetarian

*** Keywords ***
Booking Round Trip Should Succeed
    [Arguments]    ${firstname}    ${lastname}    ${price}    ${deposit}    ${needs}
    ${body}=    Build Booking Body    firstname=${firstname}    lastname=${lastname}
    ...    totalprice=${price}    depositpaid=${deposit}    needs=${needs}
    ${id}=    Create Booking    ${body}
    ${resp}=    Get Booking    ${id}
    Booking Should Match    ${resp.json()}    ${body}
    Response Should Match Schema    ${resp.json()}    booking.json
