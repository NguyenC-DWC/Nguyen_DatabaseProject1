USE normalization1;
DROP TABLE IF EXISTS profession;

CREATE TABLE profession (
    profession_ID int(11) NOT NULL auto_increment,
    profession VARCHAR(25) NOT NULL,
    PRIMARY KEY (profession_ID)
) AS
    SELECT DISTINCT profession
    FROM my_contacts
    WHERE profession IS NOT NULL
    ORDER BY profession;

ALTER TABLE my_contacts
    ADD COLUMN profession_ID INT(11);

UPDATE my_contacts
    INNER JOIN profession
    ON profession.profession = my_contacts.profession
    SET my_contacts.profession_ID = profession.profession_ID
    WHERE profession.profession IS NOT NULL;

ALTER TABLE my_contacts
  DROP COLUMN profession;

SELECT mc.first_name, mc.last_name, pf.profession
    FROM profession AS pf
    INNER JOIN my_contacts AS mc
    ON pf.profession_ID = mc.profession_ID;