*** Settings ***
Documentation  API Testing parametrization within tests

Library  RequestsLibrary
Library  ../../Libs/MyKeyWords.py


*** Variables ***
${JSONPLACEHOLDER}  https://jsonplaceholder.typicode.com


*** Test Cases ***
Posts Handler
    [Template]  Passing Id To Posts Handler
    1  1  200
    100  100  200
    1000  EMPTY  404
    0   EMPTY  404


Comments Handler
    [Template]  Test Comments Get Handle
    1  1  200
    2  2  200
    100  100  200
    0  EMPTY  200
    1000  EMPTY  200


*** Keywords ***
Passing Id To Posts Handler
    [Arguments]  ${user_id}  ${expected_id}  ${status}
    Create Session  json_place  url=${JSONPLACEHOLDER}  disable_warnings=1
    ${resp} =  Get Request  json_place  /posts/${user_id}
    Status Should Be  ${status}  ${resp}
    ${resp_json} =  Set Variable  ${resp.json()}
    Dictionary Should Contain Value  ${resp_json}  ${expected_id}


Test Comments Get Handle
    [Arguments]  ${post_id}  ${expected_id}  ${status}
    Create Session  json_place  url=${JSONPLACEHOLDER}  disable_warnings=1
    ${resp} =  Get Request  json_place  /posts/${post_id}/comments
    Status Should Be  ${status}  ${resp}
    ${resp_json} =  Set Variable  ${resp.json()}
    FOR  ${item}  IN  @{resp_json}
        Dictionary Should Contain Value  ${item}  ${post_id}
    END
