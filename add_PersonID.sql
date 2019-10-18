USE normalization1;

ALTER TABLE my_contacts
    ADD COLUMN Person_ID INT(11) primary key NOT NULL auto_increment;

SELECT * FROM my_contacts;