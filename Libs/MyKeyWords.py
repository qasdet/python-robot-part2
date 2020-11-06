from robot.api import logger


def dictionary_should_contain_value(dic, value):
    """
    Dictionary should contain given value on the first level of keys
    """
    if value.lower() == "empty":
        value = []

    values = list(dic.values())

    logger.info("Target dict is: " + str(dic))
    logger.info("Target values are: " + str(values))
    logger.info("Target value is: " + str(value))

    try:
        assert str(value) in str(values)
    except AssertionError:
        raise AssertionError("{} не содержит {}".format(dic.values(), value))
