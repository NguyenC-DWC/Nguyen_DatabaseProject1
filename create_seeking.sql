USE normalization1;
DROP TABLE IF EXISTS seeking;
DROP TABLE IF EXISTS personSeeking;

ALTER TABLE my_contacts
    ADD COLUMN seeking1 VARCHAR(50),
    ADD COLUMN seeking2 VARCHAR(50);

UPDATE my_contacts
    SET seeking1 = (SELECT DISTINCT (SUBSTRING_INDEX(seeking,',',1))),
    seeking2 = (SELECT DISTINCT TRIM(SUBSTRING_INDEX(seeking,',',-1)));

CREATE TABLE seeking(
    seeking_id INT(11) NOT NULL AUTO_INCREMENT,
    seeking VARCHAR(50),
    PRIMARY KEY (seeking_id)
) AS
    SELECT DISTINCT seeking1 AS seeking FROM my_contacts
    WHERE seeking1 IS NOT NULL
    UNION
    SELECT DISTINCT seeking2 FROM my_contacts
    WHERE seeking2 IS NOT NULL;

CREATE TABLE personSeeking AS
SELECT my_contacts.Person_ID,
       seeking.seeking_id
FROM my_contacts
INNER JOIN seeking
ON my_contacts.seeking1 = seeking.seeking
OR (my_contacts.seeking2 = seeking.seeking);

ALTER TABLE my_contacts
DROP COLUMN seeking1,
DROP COLUMN seeking2,
DROP COLUMN seeking;

SELECT ps.Person_ID,mc.first_name, mc.last_name, sk.seeking
    FROM seeking AS sk
    LEFT JOIN personseeking as ps
    ON sk.seeking_id = ps.seeking_id
    LEFT JOIN my_contacts as mc
    ON ps.Person_ID = mc.Person_ID;