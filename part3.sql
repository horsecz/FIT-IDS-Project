-- SQL skript pro vytvoreni zakladnich schemat databaze a s nekolika dotazy SELECT
-- Filip Bartoník   xbarto98@stud.fit.vutbr.cz
-- Dominik Horký 	xhorky32@stud.fit.vutbr.cz	

----------------------------------
---Dropování tabulek, vycisteni---
----------------------------------

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
        CHECK(regexp_like("email", '^[A-za-z0-9.]+@[A-za-z0-9.]+$'))
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
--------Inserty do tabulek--------
----------------------------------

INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (10000001, 'Josef', 'Novak', 'Usti nad Labem', 'Cerna', '23', '23011', 'josef.novak@seznam.cz');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (10000002, 'Josef', 'Kovar', 'Sokolov', 'Tresnickova', '523', '70912', 'jozko.kovar@gmail.com');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (10000003, 'Marian', 'Janik', 'Trebon', 'Hanackova', '563', '52101', 'marian.novak09@seznam.cz');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (10000004, 'Zdibrich', 'Kadik', 'Praha', 'Karlova', '453', '42300', 'zdibrnovak@email.cz');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (10000005, 'Josef', 'Nikdo', 'Brno', 'Vaclavska', '223', '60301', 'pepa.nikdo@gmail.com');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (10000006, 'Bohuslav', 'Rajce', 'Praha', 'Realna', '127', '43221', 'bohuslav.rajce@seznam.cz');
INSERT INTO klient ("OP", "jmeno", "prijmeni", "mesto", "ulice", "cp", "psc", "email")
VALUES (10000007, 'Adam', 'Linda', 'Brno', 'Trivialni', '100', '60202', 'linda420@gmail.com');

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

----------------------------------
-------------SELECT---------------
----------------------------------

-- GROUP BY:
--  -> vypise kolikrat byla operace daneho typu provedena
SELECT "typ_operace",
COUNT(*) pocet_operaci 
FROM operace 
GROUP BY "typ_operace";

-- GROUP BY:
--  -> zjisti pocet klientu se jmenem Josef
SELECT "jmeno", COUNT(*) AS pocet_klientu
FROM klient
WHERE "jmeno" = 'Josef'
GROUP BY "jmeno";

-- SPOJENI 2 TABULEK
--  -> vypise jmena klientu, data a typy operaci ktere kdy provedli
SELECT "Z"."jmeno", "Z"."prijmeni", "P"."typ_operace" as typ_operace, "P"."datum_operace" as datum_operace
FROM klient "Z", operace "P"
WHERE "P"."zadavatel_klient_id" = "Z"."OP";

-- SPOJENI 2 TABULEK
--  -> vypis klientu, kteri maji na svem uctu zustatek vetsi jak 5000 Kc
SELECT "K"."jmeno", "K"."prijmeni", "U"."zustatek"
FROM klient "K", ucet "U"
WHERE "U"."zustatek" > 5000 AND "U"."cislo_uctu" = ("K"."OP" - 10000000);

-- SPOJENI 3 TABULEK
--  -> vypis toho, kdo zadal operaci, kdo ji provedl, castky a typ operace
SELECT 
    "K"."jmeno" AS "jmeno_klienta",
	"K"."prijmeni" AS "prijmeni_klienta",
	"B"."jmeno" AS "jmeno_bankere",
	"B"."prijmeni" AS "prijmeni_bankere",
    "O"."typ_operace" AS "typ_operace",
    "O"."castka" AS "castka"
FROM
    klient "K", banker "B", operace "O"
WHERE
    "O"."proveditel_banker_id" = "B"."id" AND "K"."OP" = "O"."zadavatel_klient_id";

-- predikat EXIST 
--  -> vypise vsechny klienty, kteri neprovedli zadnou bankovni operaci se svym uctem
SELECT "K"."jmeno", "K"."prijmeni"
FROM klient "K"
WHERE NOT EXISTS (
    SELECT "O"."zadavatel_klient_id"
    FROM operace "O"
    WHERE "O"."zadavatel_klient_id" = "K"."OP"
);

-- predikat IN s vnorenym SELECT
--  -> vypise klienty, kteri bydli ve stejnem meste jako bankeri
SELECT concat("K"."jmeno", concat(' ',"K"."prijmeni")) as klient, concat("B"."jmeno", concat(' ', "B"."prijmeni")) as banker,"K"."mesto" AS mesto
FROM klient "K", banker "B"
WHERE "K"."mesto" IN (SELECT "mesto" FROM banker);

----------------------------------
------Vypisy obsahu tabulek-------
----------------------------------

--select * from klient;
--select * from banker;
--select * from operace;
--select * from ucet;

--select * from vklad;
--select * from vyber;
--select * from prevod;