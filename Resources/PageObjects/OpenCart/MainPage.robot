*** Settings ***
Library  SeleniumLibrary
Library  Dialogs


*** Variables ***
${SEARCH_INPUT}  css=#search input
${SEARCH_BUTTON}  css=#search button


*** Keywords ***
Search And Submit Product
    ${request} =  Get Value From User  Input request
    Input Text  ${SEARCH_INPUT}  ${request}
    Click Button  ${SEARCH_BUTTON}
    Wait Until Page Contains Element  xpath=//h1[text()='Search - ${request}']
