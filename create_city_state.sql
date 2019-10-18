USE normalization1;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS state;

UPDATE my_contacts
    SET location = 'San Francisco, CA'
    WHERE location = 'San Fran, CA';

ALTER TABLE my_contacts
    ADD COLUMN city VARCHAR(25),
    ADD COLUMN state VARCHAR(4);

UPDATE my_contacts
    SET city = (SELECT DISTINCT SUBSTR(location,1,LOCATE(',',location)-1)),
    state = (SELECT DISTINCT TRIM(SUBSTR(location,LOCATE(',',location)+1,LENGTH(location))));

CREATE TABLE city (
    city_ID int(11) NOT NULL auto_increment,
    city VARCHAR(25) NOT NULL,
    PRIMARY KEY (city_ID)
) AS
    SELECT DISTINCT city
    FROM my_contacts
    WHERE city IS NOT NULL
    ORDER BY city;

ALTER TABLE my_contacts
    ADD COLUMN city_ID INT(11);

UPDATE my_contacts
    INNER JOIN city
    ON city.city = my_contacts.city
    SET my_contacts.city_ID = city.city_ID
    WHERE city.city IS NOT NULL;

CREATE TABLE state (
    state_ID int(11) NOT NULL auto_increment,
    state VARCHAR(4) NOT NULL,
    PRIMARY KEY (state_ID)
) AS
    SELECT DISTINCT state
    FROM my_contacts
    WHERE state IS NOT NULL
    ORDER BY state;

ALTER TABLE my_contacts
    ADD COLUMN state_ID INT(11);

UPDATE my_contacts
    INNER JOIN state
    ON state.state = my_contacts.state
    SET my_contacts.state_ID = state.state_ID
    WHERE state.state IS NOT NULL;

ALTER TABLE my_contacts
   DROP COLUMN location,
   DROP COLUMN city,
   DROP COLUMN state;

SELECT mc.first_name, mc.last_name, ct.city
    FROM city as ct
    INNER JOIN my_contacts AS mc
    ON ct.city_ID = mc.city_ID;

SELECT mc.first_name, mc.last_name, st.state
    FROM state as st
    INNER JOIN my_contacts AS mc
    ON st.state_ID = mc.state_ID;

