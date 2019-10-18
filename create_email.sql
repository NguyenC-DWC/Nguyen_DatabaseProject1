USE normalization1;
DROP TABLE IF EXISTS email;
DROP TABLE IF EXISTS personEmail;

CREATE TABLE email(
    person_id int(11) NOT NULL,
    email varchar(50) NOT NULL
) AS
    SELECT DISTINCT person_id,email
    from my_contacts
    where email IS NOT NULL;

ALTER TABLE my_contacts
  DROP COLUMN email;

SELECT mc.first_name, mc.last_name, em.email
    FROM email AS em
    LEFT JOIN my_contacts as mc
    ON em.Person_ID = mc.Person_ID;

