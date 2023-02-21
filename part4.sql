-- SQL skript pro vytvoření pokročilých objektů schématu databáze.
-- Filip Bartoník   xbarto98@stud.fit.vutbr.cz
-- Dominik Horký 	xhorky32@stud.fit.vutbr.cz	

----------------------------------
---Dropování tabulek, vycisteni---
----------------------------------
DROP SEQUENCE "klient_OP_seq";
DROP MATERIALIZED VIEW matView;
DROP INDEX i;

DROP TABLE ucet;
DROP TABLE operace CASCADE CONSTRAINTS;
DROP TABLE klient;
DROP TABLE banker;

DROP TABLE vklad;
DROP TABLE vyber;
DROP TABLE prevod;

----------------------------------
---------Vytvareni tabulek--------
----------------------------------

create table klient (
    "OP" INT NOT NULL PRIMARY KEY,
    "jmeno" VARCHAR(60) NOT NULL
        CHECK(regexp_like("jmeno", '^[A-Za-z]+$')),
    "prijmeni" VARCHAR(60) NOT NULL
        CHECK(regexp_like("prijmeni", '^[A-Za-z]+$')),
    "mesto" varchar(50) NOT NULL
        CHECK(regexp_like("mesto", '^[A-Za-z -]+$')),
    "ulice" varchar(50) NOT NULL
        CHECK(regexp_like("ulice", '^[A-Za-z -]+$')),
    "cp" INT NOT NULL
        CHECK("cp" > 0),
    "psc" INT NOT NULL
        CHECK(regexp_like("psc", '^[0-9][0-9][0-9][0-9][0-9]$')),
    "email" VARCHAR(255) NOT NULL
        CHECK(regexp_like("email", '^[A-za-z0-9.]+@[A-za-z0-9.]+$')),
    "kod" INT NOT NULL
);

create table banker (
    "id" INT NOT NULL PRIMARY KEY,
    "jmeno" VARCHAR(60) NOT NULL
        CHECK(regexp_like("jmeno", '^[A-Za-z]+$')),
    "prijmeni" VARCHAR(60) NOT NULL
        CHECK(regexp_like("prijmeni", '^[A-Za-z]+$')),
    "mesto" varchar(50) NOT NULL
        CHECK(regexp_like("mesto", '^[A-Za-z -]+$')),
    "ulice" varchar(50) NOT NULL
        CHECK(regexp_like("ulice", '^[A-Za-z -]+$')),
    "cp" INT NOT NULL
        CHECK("cp" > 0),
    "psc" INT NOT NULL   
        CHECK(regexp_like("psc", '^[0-9][0-9][0-9][0-9][0-9]$')),
    "email" VARCHAR(255) NOT NULL
        CHECK(regexp_like("email", '^[A-za-z0-9.]+@[A-za-z0-9.]+$'))
);

create table operace (
    "id" INT NOT NULL PRIMARY KEY,
    "typ_operace" VARCHAR(50) NOT NULL
        CHECK(regexp_like("typ_operace", 'vklad|vyber|prevod')),
    "castka" NUMBER(8,2) DEFAULT 0
         CHECK("castka" > 0),
    "datum_operace" DATE,
    "proveditel_banker_id" INT NOT NULL,
    "zadavatel_klient_id" INT NOT NULL,
    CONSTRAINT "proveditel_banker_id"
		FOREIGN KEY ("proveditel_banker_id") REFERENCES banker ("id"),
    CONSTRAINT "zadavatel_klient_id"
        FOREIGN KEY ("zadavatel_klient_id") REFERENCES klient ("OP")
);
create table ucet (
    "cislo_uctu" INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    "zustatek" NUMBER(8,2) DEFAULT 0
        CHECK("zustatek" >= 0),
    "datum_zalozeni" DATE,
    "typ_uctu" VARCHAR(40) NOT NULL
        CHECK(regexp_like("typ_uctu", 'bezny|cizi'))
);

create table vklad(
    "operaceID" INT NOT NULL PRIMARY KEY,
    FOREIGN KEY ("operaceID") REFERENCES operace ("id")
);

create table vyber (
    "operaceID" INT NOT NULL PRIMARY KEY,
    FOREIGN KEY ("operaceID") REFERENCES operace ("id")
);

create table prevod (
    "operaceID" INT NOT NULL PRIMARY KEY,
    FOREIGN KEY ("operaceID") REFERENCES operace ("id")
);

----------------------------------
----------- triggery -------------
----------------------------------
-- pokud bude ID NULL, automaticky se generuje
CREATE SEQUENCE "klient_OP_seq" START WITH 10000001 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER "klient_OP"
    BEFORE INSERT ON klient FOR EACH ROW
BEGIN
    IF :NEW."OP" IS NULL THEN
        :NEW."OP" := "klient_OP_seq".NEXTVAL;
    END IF;
END;
/

-- automaticke generovani klice pro klienta (pristupove heslo napr. do bankovnictvi)
CREATE OR REPLACE TRIGGER "generatorKodu"
    BEFORE INSERT ON klient FOR EACH ROW
BEGIN
    IF :NEW."kod" IS NULL THEN
        :NEW."kod" := ( ( :NEW."OP" * ( length(:NEW."prijmeni") + length(:NEW."ulice") ) / length(:NEW."jmeno") + length(:NEW."prijmeni") ) + length(:NEW."mesto") ) * 123456 * ( length(:NEW."prijmeni") + length(:NEW."email") ) / 498712;
    END IF;
END;
/

----------------------------------
--------Inserty do tabulek--------
----------------------------------

INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ("klient_OP_seq".NEXTVAL, 'Josef', 'Novak', 'Usti nad Labem', 'Cerna', '23', '23011', 'josef.novak@seznam.cz');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ("klient_OP_seq".NEXTVAL, 'Josef', 'Kovar', 'Sokolov', 'Tresnickova', '523', '70912', 'jozko.kovar@gmail.com');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ("klient_OP_seq".NEXTVAL, 'Marian', 'Janik', 'Trebon', 'Hanackova', '563', '52101', 'marian.novak09@seznam.cz');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ("klient_OP_seq".NEXTVAL, 'Zdibrich', 'Kadik', 'Praha', 'Karlova', '453', '42300', 'zdibrnovak@email.cz');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ("klient_OP_seq".NEXTVAL, 'Josef', 'Nikdo', 'Brno', 'Vaclavska', '223', '60301', 'pepa.nikdo@gmail.com');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ("klient_OP_seq".NEXTVAL, 'Bohuslav', 'Rajce', 'Praha', 'Realna', '127', '43221', 'bohuslav.rajce@seznam.cz');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ("klient_OP_seq".NEXTVAL, 'Adam', 'Linda', 'Brno', 'Trivialni', '100', '60202', 'linda420@gmail.com');

INSERT INTO banker ("id", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (20000001, 'Martin', 'Kolarik', 'Praha', 'Prazska', '163', '43211', 'martinek009@gmail.com');
INSERT INTO banker ("id", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (20000002, 'Jana', 'Novotna', 'Brno', 'Lidska', '323', '60201', 'jana.novotna.mladsi@email.cz');
INSERT INTO banker ("id", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (20000003, 'Petr', 'Guchs', 'Praha', 'Maskovana ulice', '49', '42302', 'maskfree.life@gmail.com');

INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000001, 'vklad', 2000, '1.3.2021', 20000001, 10000003);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000002, 'vyber', 1000, '5.3.2021', 20000002, 10000003);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000003, 'vyber', 500, '7.3.2021', 20000001, 10000003);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000004, 'vklad', 10000, '7.3.2021', 20000003, 10000001);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000005, 'vklad', 30000, '7.3.2021', 20000001, 10000002);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000006, 'vklad', 25000, '13.3.2021', 20000003, 10000005);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000007, 'prevod', 16000, '20.3.2021', 20000002, 10000005);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000008, 'vyber', 200, '24.3.2021', 20000001, 10000001);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000009, 'vklad', 4000, '25.3.2021', 20000002, 10000006);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000010, 'prevod', 1000, '29.3.2021', 20000001, 10000002);
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000011, 'prevod', 3500, '30.3.2021', 20000003, 10000005);

INSERT INTO ucet ("zustatek", "datum_zalozeni", "typ_uctu")
VALUES (2500, '25.2.2021', 'bezny');
INSERT INTO ucet ("zustatek", "datum_zalozeni", "typ_uctu")
VALUES (9800, '1.3.2021', 'bezny');
INSERT INTO ucet ("zustatek", "datum_zalozeni", "typ_uctu")
VALUES (29000, '5.3.2021', 'bezny');
INSERT INTO ucet ("datum_zalozeni", "typ_uctu")
VALUES ('31.3.2021', 'bezny');
INSERT INTO ucet ("zustatek", "datum_zalozeni", "typ_uctu")
VALUES (5500, '8.3.2021', 'bezny');
INSERT INTO ucet ("zustatek", "datum_zalozeni", "typ_uctu")
VALUES (4000, '15.3.2021', 'bezny');
INSERT INTO ucet ("zustatek", "datum_zalozeni", "typ_uctu")
VALUES (0, '31.3.2021', 'bezny');

INSERT INTO vklad ("operaceID")
VALUES (300000001);
INSERT INTO vklad ("operaceID")
VALUES (300000004);
INSERT INTO vklad ("operaceID")
VALUES (300000005);
INSERT INTO vklad ("operaceID")
VALUES (300000006);
INSERT INTO vklad ("operaceID")
VALUES (300000009);

INSERT INTO vyber ("operaceID")
VALUES (300000002);
INSERT INTO vyber ("operaceID")
VALUES (300000003);
INSERT INTO vyber ("operaceID")
VALUES (300000008);

INSERT INTO prevod ("operaceID")
VALUES (300000007);
INSERT INTO prevod ("operaceID")
VALUES (300000009);
INSERT INTO prevod ("operaceID")
VALUES (300000011);

---------------------------------
----- pokrocile objekty db ------
---------------------------------

---- procedury
SET serveroutput ON;
CREATE OR REPLACE PROCEDURE prumernyVklad
IS
    cursor vklady IS SELECT * FROM operace WHERE operace."typ_operace" = 'vklad';
    hodnota INTEGER;
    hodnota_cnt INTEGER;
    prumer INTEGER;
    radek operace%ROWTYPE;
    found BOOLEAN;
BEGIN
    hodnota := 0;
    hodnota_cnt := 0;
    found := false;
    OPEN vklady;
    loop
        fetch vklady into radek;
        exit WHEN vklady%NOTFOUND;
        found := true;
        hodnota := hodnota + radek."castka";
        hodnota_cnt := hodnota_cnt + 1;
    END loop;
    IF found THEN
        prumer := hodnota / hodnota_cnt;
        DBMS_OUTPUT.PUT_LINE('Prumerna hodnota vkladu je ' || prumer || ' Kc.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nebyly provedeny zadne vklady.');
    END IF;
END;
/

SET serveroutput ON;
CREATE OR REPLACE PROCEDURE nejbohatsiKlient
IS
    cursor ucty IS SELECT * FROM ucet WHERE ucet."zustatek" >= 0;
    cursor klienti IS SELECT * FROM klient WHERE klient."OP" >= 0;
    zustatek INTEGER;
    nejvetsi INTEGER;
    ucet_id INTEGER;
    jmeno VARCHAR(100);
    prijmeni VARCHAR(100);
    radek ucet%ROWTYPE;
    radek2 klienti%ROWTYPE;
    found BOOLEAN;
    found_ucty BOOLEAN;
BEGIN
    zustatek := 0;
    nejvetsi := 0;
    found := false;
    found_ucty := false;
    OPEN ucty;
    OPEN klienti;
    loop
        fetch ucty into radek;
        exit WHEN ucty%NOTFOUND;
        zustatek := radek."zustatek";
        IF zustatek > nejvetsi THEN
            nejvetsi := zustatek;
            ucet_id := radek."cislo_uctu";
            found_ucty := true;
        END IF;
    END loop;
    loop
        fetch klienti into radek2;
        exit WHEN klienti%NOTFOUND;
        IF radek2."OP" = 10000000 + ucet_id THEN
            jmeno := radek2."jmeno";
            prijmeni := radek2."prijmeni";
            found := true;
            exit;
        END IF;
    END loop;
    IF found_ucty THEN
        IF found THEN 
            DBMS_OUTPUT.PUT_LINE('Nejbohatsim klientem je '|| jmeno ||' '|| prijmeni ||'. Na uctu ma '|| nejvetsi || ' Kc.'); 
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nejbohatsi klient v bance ma na uctu '|| nejvetsi ||' Kc. Jeho identita vsak nebyla nalezena.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Banka nema zadne klienty.');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE printExample(text IN VARCHAR)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    DBMS_OUTPUT.PUT_LINE('---------- PRIKLAD / DEMONSTRACE');
    DBMS_OUTPUT.PUT_LINE('---------- '|| text);
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
END;
/

EXECUTE printExample('volani procedur');
EXECUTE prumernyVklad;
EXECUTE nejbohatsiKlient;

---- materializovany pohled
CREATE MATERIALIZED VIEW LOG ON operace WITH PRIMARY KEY, ROWID("typ_operace") INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW matView
ENABLE QUERY REWRITE
AS
SELECT operace."typ_operace", count(operace."typ_operace") as pocet
FROM operace
GROUP BY operace."typ_operace";

EXECUTE printExample('materializovany pohled (data se nezmeni)');
SELECT * FROM matView;
INSERT INTO operace ("id", "typ_operace", "castka", "datum_operace", "proveditel_banker_id", "zadavatel_klient_id")
VALUES (300000012, 'vklad', 1500, '15.4.2021', 20000001, 10000005);
SELECT * FROM matView;

---- explain plan + index
EXECUTE printExample('explain plan s indexem (rychlejsi)');
EXPLAIN PLAN FOR
SELECT "mesto" FROM klient NATURAL JOIN banker
GROUP BY "mesto";
SELECT * FROM TABLE(DBMS_XPLAN.display);

CREATE INDEX i ON klient("jmeno");

EXECUTE printExample('explain plan bez indexu');
EXPLAIN PLAN FOR
SELECT "mesto" FROM klient NATURAL JOIN banker
GROUP BY "mesto";
SELECT * FROM TABLE(DBMS_XPLAN.display);

---- prava pro druheho uzivatele
EXECUTE printExample('prava pro druheho clena tymu (vidi tabulky po prihlaseni do SQLdev)');
GRANT ALL ON klient TO XBARTO98;
GRANT ALL ON banker TO XBARTO98;
GRANT ALL ON operace TO XBARTO98;
GRANT ALL ON ucet TO XBARTO98;
GRANT ALL ON vyber TO XBARTO98;
GRANT ALL ON vklad TO XBARTO98;
GRANT ALL ON prevod TO XBARTO98;

GRANT ALL ON matView TO XBARTO98;

---- priklady vyuziti triggeru
EXECUTE printExample('trigger (pridan klient Roman Prymula bez ID)');
INSERT INTO klient ("jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ('Roman', 'Prymula', 'Praha', 'ulice Jana Lockdowna', '10', '42011', 'romca.prymula@seznam.cz');
SELECT "OP", "jmeno", "prijmeni" FROM klient ORDER BY "OP";

EXECUTE printExample('trigger (generovani kodu)');
INSERT INTO klient ("jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES ('Jan', 'Blatny', 'Praha', 'Psi ulice', '5', '42011', 'hoznik.blatny@mzcr.cz');
SELECT "OP", "jmeno", "prijmeni", "kod" FROM klient ORDER BY "OP";
