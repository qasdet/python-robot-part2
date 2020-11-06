*** Settings ***
Library  SeleniumLibrary
Library  DatabaseLibrary
Library  String

Resource  ../../Resources/PageObjects/OpenCart/AdminPage.robot

Suite Setup  Connect To Database  pymysql  ${DBName}  ${DBUser}  ${DBPass}  ${DBHost}  ${DBPort}
Suite Teardown  Disconnect From Database

Test Setup  Open Browser  browser=chrome  options=add_argument("--ignore-certificate-errors")
Test Teardown  Close Browser


*** Variables ***
${DBName}  bitnami_opencart
${DBUser}  bn_opencart
${DBPass}
${DBHost}  127.0.0.1
${DBPort}  3306
@{OPENCART_ADMIN} =  user  bitnami1
${BASE_URL}  localhost
${TEST_PRODUCT_NAME}  TestProduct


*** Test Cases ***
Add Product To Catalog With Db Validation
    [Documentation]  Add product to catalog with ui and validate precence in database
    [Tags]  DB  AddProduct
    [Teardown]  Run Keywords  Execute Sql String  delete from ${PRODUCT_DB} where model = '${TEST_PRODUCT_NAME}'
    ...  AND  Execute Sql String  delete from ${PRODUCT_DESCRIPTION_DB} where name = '${TEST_PRODUCT_NAME}'
    ...  AND  Close Browser
    Go To  http://${BASE_URL}/admin/
    AdminPage.Login With  ${OPENCART_ADMIN}
    AdminPage.Add Product To Catalog  ${TEST_PRODUCT_NAME}  TestMeta  ${TEST_PRODUCT_NAME}
    Wait Until Keyword Succeeds  3 sec  1 sec  AdminPage.Check Product In Database  ${TEST_PRODUCT_NAME}


Remove Product To Catalog With Db Validation
    [Documentation]  Remove product from catalog with ui and validate absence in database
    [Tags]  DB  RemoveProduct
    ${product_name} =  String.Generate Random String  10  [LETTERS]
    Add Product To Catalog With Database  ${product_name}
    Go To  http://${BASE_URL}/admin/
    AdminPage.Login With  ${OPENCART_ADMIN}
    AdminPage.Remove Product From Catalog With Filter  ${product_name}
    Wait Until Keyword Succeeds  3 sec  1 sec  AdminPage.Check Product Not In Database  ${product_name}
