USE normalization1;
DROP TABLE IF EXISTS interests;
DROP TABLE IF EXISTS personInterests;

ALTER TABLE my_contacts
    ADD COLUMN interest1 VARCHAR(25),
    ADD COLUMN interest2 VARCHAR(25),
    ADD COLUMN interest3 VARCHAR(25),
    ADD COLUMN first2Interests VARCHAR(50);

UPDATE my_contacts
    SET interest1 = (SELECT DISTINCT (SUBSTRING_INDEX(interests,',',1))),
    first2Interests = (SELECT DISTINCT (SUBSTRING_INDEX(interests,',',2))),
    interest2 = (SELECT DISTINCT TRIM(SUBSTRING_INDEX(first2Interests,',',-1))),
    interest3 = (SELECT DISTINCT TRIM(SUBSTRING_INDEX(interests,',',-1)));

ALTER TABLE my_contacts
    DROP first2Interests;

CREATE TABLE interests(
    interest_id INT(11) NOT NULL AUTO_INCREMENT,
    interests VARCHAR(25),
    PRIMARY KEY (interest_id)
) AS
    SELECT DISTINCT interest1 AS interests FROM my_contacts
    WHERE interest1 IS NOT NULL
    UNION
    SELECT DISTINCT interest2 FROM my_contacts
    WHERE interest2 IS NOT NULL
    UNION
    SELECT DISTINCT interest3 FROM my_contacts
    WHERE interest3 IS NOT NULL;

CREATE TABLE personInterests AS
SELECT my_contacts.Person_ID,
       interests.interest_id
FROM my_contacts
INNER JOIN interests
ON my_contacts.interest1 = interests.interests
OR (my_contacts.interest2 = interests.interests)
OR (my_contacts.interest3 = interests.interests);

ALTER TABLE my_contacts
  DROP COLUMN interests,
  DROP COLUMN interest1,
  DROP COLUMN interest2,
  DROP COLUMN interest3;

SELECT pi.Person_ID,mc.first_name, mc.last_name, it.interests
    FROM interests AS it
    LEFT JOIN personinterests as pi
    ON it.interest_id = pi.interest_id
    LEFT JOIN my_contacts as mc
    ON pi.Person_ID = mc.Person_ID;


