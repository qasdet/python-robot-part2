*** Settings ***
Library  SeleniumLibrary
Library  DatabaseLibrary


*** Variables ***
${LOGIN_FORM}  css=form
${USERNAME_INPUT}  css=#input-username
${PASSWORD_INPUT}  css=#input-password
${SUBMIT_BUTTON}  css=button[type='submit']
${MENU_CATALOG}  css=#menu-catalog
${CATALOG_ITEMS}  css=#collapse1 > li > a
${ADD_NEW_PRODUCT}  xpath=//a[@data-original-title='Add New']
${SAVE_NEW_PRODUCT}  xpath=//button[@data-original-title='Save']
${DELETE_PRODUCT}  xpath=//button[@data-original-title='Delete']
${PRODUCT_NAME_INPUT}  css=#input-name1
${PRODUCT_META_INPUT}  css=#input-meta-title1
${DATA_PRODUCT_TAB}  Data
${PRODUCT_MODEL_INPUT}  css=#input-model
${PRODUCT_DB}  oc_product
${PRODUCT_DESCRIPTION_DB}  oc_product_description
${INPUT_FILTER_PRODUCT_NAME}  css=#input-name
${FILTER_SUBMIT_BUTTON}  css=#button-filter


*** Keywords ***
Login With
    [Arguments]  ${user_data}
    Wait Until Element Is Visible  ${LOGIN_FORM}
    Input Text  ${USERNAME_INPUT}  ${user_data}[0]
    Input Text  ${PASSWORD_INPUT}  ${user_data}[1]
    Submit Form  ${LOGIN_FORM}


Open Catalog Products
    Click Element  ${MENU_CATALOG}
    ${catalog_items} =  Get Webelements  ${CATALOG_ITEMS}
    BuiltIn.Wait Until Keyword Succeeds  3 sec  1 sec  Click Element  ${catalog_items}[1]
    Wait Until Page Contains Element  xpath=//h1[text()='Products']


Add Product To Catalog
    [Arguments]  ${product_name}  ${product_meta}  ${product_model}
    Open Catalog Products
    Click Element  ${ADD_NEW_PRODUCT}
    Input Text  ${PRODUCT_NAME_INPUT}  ${product_name}
    Input Text  ${PRODUCT_META_INPUT}  ${product_meta}
    Click Link  ${DATA_PRODUCT_TAB}
    Input Text  ${PRODUCT_MODEL_INPUT}  ${product_model}
    Click Element  ${SAVE_NEW_PRODUCT}


Remove Product From Catalog With Filter
    [Arguments]  ${product_name}
    Open Catalog Products
    Input Text  ${INPUT_FILTER_PRODUCT_NAME}  ${product_name}
    Click Button  ${FILTER_SUBMIT_BUTTON}
    Select First Product In Products
    Click Element  ${DELETE_PRODUCT}
    Handle Alert  ACCEPT  2 sec


Select First Product In Products
    Click Element  css=tbody td:first-child input


Check Product In Database
    [Arguments]  ${value}
    Check If Exists In Database  select model from ${PRODUCT_DB} where model = '${value}'
    Check If Exists In Database  select name from ${PRODUCT_DESCRIPTION_DB} where name = '${value}'


Check Product Not In Database
    [Arguments]  ${product_name}
    Check If Not Exists In Database  select model from ${PRODUCT_DB} where model = '${product_name}'


Add Product To Catalog With Database
    [Arguments]  ${product_name}
    Execute Sql String  insert into ${PRODUCT_DB} (model, sku, upc, ean, jan, isbn, mpn, location, stock_status_id, manufacturer_id, tax_class_id, date_added, date_modified, quantity, date_available) VALUES ('${product_name}', 'sku', 'upc', 'ean', 'jan', 'isbn', 'mnp', 'test_location', 6, 6, 6, NOW(), NOW(), 1, '2009-02-03')
    ${product_id}  QUERY  select product_id from ${PRODUCT_DB} where model = '${product_name}'
    Execute Sql String  insert into ${PRODUCT_DESCRIPTION_DB} (product_id, name, language_id, description, tag, meta_title, meta_description, meta_keyword) VALUES ('${product_id}[0][0]', '${product_name}', 1, 'test_description', 'tag', 'meta_title', 'meta_description', 'meta_keyword')
