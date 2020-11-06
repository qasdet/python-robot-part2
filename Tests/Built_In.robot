*** Settings ***
Library  SeleniumLibrary
Documentation  Checking out the built-in library

# Many ways to run:
# robot -d results/built-in tests/Built_in.robot
# robot -d results/built-in -i BuiltIn tests
# robot -d results tests


*** Variables ***
${GLOBAL1} =  I am global variable 1
${SOME_GLOBAL_DATA}


*** Test Cases ***
Declare and set variables
    # Доступно только внутри текущего теста
    ${some_test_data} =  Set Variable  This is only available within this test
    Set Test Variable  ${more_test_data}  This is also only available within this test
    # Доступно внутри текущего сьюта
    Set Suite Variable  ${some_suite_data}  This is available within all tests in this suite
    # Доступно внутри везде
    Set Global Variable  ${SOME_GLOBAL_DATA}  This available everywhere
