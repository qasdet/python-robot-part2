*** Settings ***
Documentation  These are some web tests

Library  Dialogs
Library  SeleniumLibrary

Resource  ../Resources/PageObjects/OpenCart/MainPage.robot


*** Variables ***
${BROWSER} =  chrome


*** Test Cases ***
Logged out user can search for products
    [Tags]  Web
    ${new_browser} =  Get Selection From User  Which browser?  chrome  firefox  opera
    Set Global Variable  ${BROWSER}  ${new_browser}
    Open Browser  http://localhost/  ${BROWSER}
    Search And Submit Product
    Sleep  2
    Close Browser
