--
--
-- ESIS
--
-- Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA
--
-- Projects contributors : Philippe Le Berre, Thomas Burdairon, Benjamin Baudel,
--                         Benjamin S. Gould, Diego Patinos Ramos, Constantin Cornelie
-- 
-- 
-- This file is part of ESIS.
-- 
-- ESIS is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation version 3 of the License.
-- 
-- ESIS is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with ESIS.  If not, see <http://www.gnu.org/licenses/>.
--
-- $Id: geography_schema.sql 385 2010-04-12 15:56:13Z pleberre $
--
--

--
-- WARNING ! this is a UTF-8 file
--

--
-- contains: report information schema

--
-- some countries are added to this list sometimes
-- sources can be found at http://unstats.un.org/unsd/methods/m49/m49regin.htm
-- and http://en.wikipedia.org/wiki/ISO_3166-1

--
-- Continents
--
CREATE TABLE e_continent (
	continent_iso	integer,
	continent_name	text NOT NULL, 	-- eg. AFRICA
	PRIMARY KEY (continent_iso)
);

INSERT INTO e_continent VALUES (2, 'AFRICA');
INSERT INTO e_continent VALUES (19, 'AMERICAS');
INSERT INTO e_continent VALUES (142, 'ASIA');
INSERT INTO e_continent VALUES (150, 'EUROPE');
INSERT INTO e_continent VALUES (9, 'OCEANIA');

---
--- Sub continents
---
CREATE TABLE e_subcontinent (
	subcontinent_iso	integer,
	subcontinent_name	text NOT NULL,
	continent_iso		integer NOT NULL,
	PRIMARY KEY (subcontinent_iso)

);

INSERT INTO e_subcontinent VALUES (14, 'EASTERN AFRICA', 2);
INSERT INTO e_subcontinent VALUES (17, 'MIDDLE AFRICA', 2);
INSERT INTO e_subcontinent VALUES (15, 'NORTHERN AFRICA', 2);
INSERT INTO e_subcontinent VALUES (18, 'SOUTHERN AFRICA', 2);
INSERT INTO e_subcontinent VALUES (11, 'WESTERN AFRICA', 2);
INSERT INTO e_subcontinent VALUES (29, 'CARIBBEAN', 19);
INSERT INTO e_subcontinent VALUES (13, 'CENTRAL AMERICA', 19);
INSERT INTO e_subcontinent VALUES (5, 'SOUTH AMERICA', 19);
INSERT INTO e_subcontinent VALUES (21, 'NORTHERN AMERICA', 19);
INSERT INTO e_subcontinent VALUES (30, 'EASTERN ASIA', 142);
INSERT INTO e_subcontinent VALUES (62, 'SOUTH-CENTRAL ASIA', 142);
INSERT INTO e_subcontinent VALUES (35, 'SOUTH-EASTERN ASIA', 142);
INSERT INTO e_subcontinent VALUES (145, 'WESTERN ASIA', 142);
INSERT INTO e_subcontinent VALUES (151, 'EASTERN EUROPE', 150);
INSERT INTO e_subcontinent VALUES (154, 'NORTHERN EUROPE', 150);
INSERT INTO e_subcontinent VALUES (39, 'SOUTHERN EUROPE', 150);
INSERT INTO e_subcontinent VALUES (155, 'WESTERN EUROPE', 150);
INSERT INTO e_subcontinent VALUES (53, 'AUSTRALIA AND NEW ZEALAND', 9);
INSERT INTO e_subcontinent VALUES (54, 'MELANESIA', 9);
INSERT INTO e_subcontinent VALUES (57, 'MICRONESIA', 9);
INSERT INTO e_subcontinent VALUES (61, 'POLYNESIA', 9);

--
-- Countries
-- see: http://fr.wikipedia.org/wiki/ISO_3166-1
--
CREATE TABLE e_country (
	country_iso2		text NOT NULL,		
	country_iso3		text NOT NULL,
	country_iso		integer NOT NULL,
	country_shortname 	text NOT NULL,
	continent_id		integer NOT NULL,
	continent_subid		integer NOT NULL
,	PRIMARY KEY (country_iso)
);
CREATE UNIQUE INDEX e_country_shortname  ON e_country (country_shortname);
CREATE UNIQUE INDEX e_country_iso        ON e_country (country_iso);
CREATE UNIQUE INDEX e_country_iso2	 ON e_country (country_iso2);
CREATE UNIQUE INDEX e_country_iso3	 ON e_country (country_iso3);
CREATE INDEX e_country_i_v on e_country(continent_id);
CREATE INDEX e_country_i_s on e_country(continent_subid);

INSERT into e_country VALUES ('BI','BDI',108,'Burundi',2,14);
INSERT into e_country VALUES ('KM','COM',174,'Comoros',2,14);
INSERT into e_country VALUES ('DJ','DJI',262,'Djibouti',2,14);
INSERT into e_country VALUES ('ER','ERI',232,'Eritrea',2,14);
INSERT into e_country VALUES ('ET','ETH',231,'Ethiopia',2,14);
INSERT into e_country VALUES ('KE','KEN',404,'Kenya',2,14);
INSERT into e_country VALUES ('MG','MDG',450,'Madagascar',2,14);
INSERT into e_country VALUES ('MW','MWI',454,'Malawi',2,14);
INSERT into e_country VALUES ('MU','MUS',480,'Mauritius',2,14);
INSERT into e_country VALUES ('YT','MYT',175,'Mayotte',2,14);
INSERT into e_country VALUES ('MZ','MOZ',508,'Mozambique',2,14);
INSERT into e_country VALUES ('RE','REU',638,'Réunion',2,14);
INSERT into e_country VALUES ('RW','RWA',646,'Rwanda',2,14);
INSERT into e_country VALUES ('SC','SYC',690,'Seychelles',2,14);
INSERT into e_country VALUES ('SO','SOM',706,'Somalia',2,14);
INSERT into e_country VALUES ('UG','UGA',800,'Uganda',2,14);
INSERT into e_country VALUES ('TZ','TZA',834,'Tanzania',2,14);
INSERT into e_country VALUES ('ZM','ZMB',894,'Zambia',2,14);
INSERT into e_country VALUES ('ZW','ZWE',716,'Zimbabwe',2,14);
INSERT into e_country VALUES ('AO','AGO',024,'Angola',2,17);
INSERT into e_country VALUES ('CM','CMR',120,'Cameroon',2,17);
INSERT into e_country VALUES ('CF','CAF',140,'Central African Republic',2,17);
INSERT into e_country VALUES ('TD','TCD',148,'Chad',2,17);
INSERT into e_country VALUES ('CG','COG',178,'Congo, People Republic of',2,17);
INSERT into e_country VALUES ('CD','COD',180,'Congo, Democratic Republic of',2,17);
INSERT into e_country VALUES ('GQ','GNQ',226,'Equatorial Guinea',2,17);
INSERT into e_country VALUES ('GA','GAB',266,'Gabon',2,17);
INSERT into e_country VALUES ('ST','STP',678,'Sao Tome and Principe',2,17);
INSERT into e_country VALUES ('DZ','DZA',012,'Algeria',2,15);
INSERT into e_country VALUES ('EG','EGY',818,'Egypt',2,15);
INSERT into e_country VALUES ('LY','LBY',434,'Libyan Arab Jamahiriya',2,15);
INSERT into e_country VALUES ('MA','MAR',504,'Morocco',2,15);
INSERT into e_country VALUES ('SD','SDN',736,'Sudan',2,15);
INSERT into e_country VALUES ('TN','TUN',788,'Tunisia',2,15);
INSERT into e_country VALUES ('EH','ESH',732,'Western Sahara',2,15);
INSERT into e_country VALUES ('BW','BWA',072,'Botswana',2,18);
INSERT into e_country VALUES ('LS','LSO',426,'Lesotho',2,18);
INSERT into e_country VALUES ('NA','NAM',516,'Namibia',2,18);
INSERT into e_country VALUES ('ZA','ZAF',710,'South Africa',2,18);
INSERT into e_country VALUES ('SZ','SWZ',748,'Swaziland',2,18);
INSERT into e_country VALUES ('BJ','BEN',204,'Benin',2,11);
INSERT into e_country VALUES ('BF','BFA',854,'Burkina Faso',2,11);
INSERT into e_country VALUES ('CV','CPV',132,'Cape Verde',2,11);
INSERT into e_country VALUES ('CI','CIV',384,'Côte d\'Ivoire',2,11);
INSERT into e_country VALUES ('GM','GMB',270,'Gambia',2,11);
INSERT into e_country VALUES ('GH','GHA',288,'Ghana',2,11);
INSERT into e_country VALUES ('GN','GIN',324,'Guinea',2,11);
INSERT into e_country VALUES ('GW','GNB',624,'Guinea-Bissau',2,11);
INSERT into e_country VALUES ('LR','LBR',430,'Liberia',2,11);
INSERT into e_country VALUES ('ML','MLI',466,'Mali',2,11);
INSERT into e_country VALUES ('MR','MRT',478,'Mauritania',2,11);
INSERT into e_country VALUES ('NE','NER',562,'Niger',2,11);
INSERT into e_country VALUES ('NG','NGA',566,'Nigeria',2,11);
INSERT into e_country VALUES ('SH','SHN',654,'Saint Helena',2,11);
INSERT into e_country VALUES ('SN','SEN',686,'Senegal',2,11);
INSERT into e_country VALUES ('SL','SLE',694,'Sierra Leone',2,11);
INSERT into e_country VALUES ('TG','TGO',768,'Togo',2,11);
INSERT into e_country VALUES ('AI','AIA',660,'Anguilla',19,29);
INSERT into e_country VALUES ('AG','ATG',028,'Antigua and Barbuda',19,29);
INSERT into e_country VALUES ('AW','ABW',533,'Aruba',19,29);
INSERT into e_country VALUES ('BS','BHS',044,'Bahamas',19,29);
INSERT into e_country VALUES ('BB','BRB',052,'Barbados',19,29);
INSERT into e_country VALUES ('VG','VGB',092,'Virgin Islands',19,29);
INSERT into e_country VALUES ('KY','CYM',136,'Cayman Islands',19,29);
INSERT into e_country VALUES ('CU','CUB',192,'Cuba',19,29);
INSERT into e_country VALUES ('DM','DMA',212,'Dominica',19,29);
INSERT into e_country VALUES ('DO','DOM',214,'Dominican Republic',19,29);
INSERT into e_country VALUES ('GD','GRD',308,'Grenada',19,29);
INSERT into e_country VALUES ('GP','GLP',312,'Guadeloupe',19,29);
INSERT into e_country VALUES ('HT','HTI',332,'Haiti',19,29);
INSERT into e_country VALUES ('JM','JAM',388,'Jamaica',19,29);
INSERT into e_country VALUES ('MQ','MTQ',474,'Martinique',19,29);
INSERT into e_country VALUES ('MS','MSR',500,'Montserrat',19,29);
INSERT into e_country VALUES ('AN','ANT',530,'Netherlands Antilles',19,29);
INSERT into e_country VALUES ('PR','PRI',630,'Puerto Rico',19,29);
INSERT into e_country VALUES ('KN','KNA',659,'Saint Kitts and Nevis',19,29);
INSERT into e_country VALUES ('LC','LCA',662,'Saint Lucia',19,29);
INSERT into e_country VALUES ('VC','VCT',670,'Saint Vincent and the Grenadines',19,29);
INSERT into e_country VALUES ('TT','TTO',780,'Trinidad and Tobago',19,29);
INSERT into e_country VALUES ('TC','TCA',796,'Turks and Caicos Islands',19,29);
INSERT into e_country VALUES ('VI','VIR',850,'United States Virgin Islands',19,29);
INSERT into e_country VALUES ('BZ','BLZ',084,'Belize',19,13);
INSERT into e_country VALUES ('CR','CRI',188,'Costa Rica',19,13);
INSERT into e_country VALUES ('SV','SLV',222,'El Salvador',19,13);
INSERT into e_country VALUES ('GT','GTM',320,'Guatemala',19,13);
INSERT into e_country VALUES ('HN','HND',340,'Honduras',19,13);
INSERT into e_country VALUES ('MX','MEX',484,'Mexico',19,13);
INSERT into e_country VALUES ('NI','NIC',558,'Nicaragua',19,13);
INSERT into e_country VALUES ('PA','PAN',591,'Panama',19,13);
INSERT into e_country VALUES ('AR','ARG',032,'Argentina',19,5);
INSERT into e_country VALUES ('BO','BOL',068,'Bolivia',19,5);
INSERT into e_country VALUES ('BR','BRA',076,'Brazil',19,5);
INSERT into e_country VALUES ('CL','CHL',152,'Chile',19,5);
INSERT into e_country VALUES ('CO','COL',170,'Colombia',19,5);
INSERT into e_country VALUES ('EC','ECU',218,'Ecuador',19,5);
INSERT into e_country VALUES ('FK','FLK',238,'Falkland Islands (Malvinas)',19,5);
INSERT into e_country VALUES ('GF','GUF',254,'French Guiana',19,5);
INSERT into e_country VALUES ('GY','GUY',328,'Guyana',19,5);
INSERT into e_country VALUES ('PY','PRY',600,'Paraguay',19,5);
INSERT into e_country VALUES ('PE','PER',604,'Peru',19,5);
INSERT into e_country VALUES ('SR','SUR',740,'Suriname',19,5);
INSERT into e_country VALUES ('UY','URY',858,'Uruguay',19,5);
INSERT into e_country VALUES ('VE','VEN',862,'Venezuela',19,5);
INSERT into e_country VALUES ('GS','SGS',239,'South Georgia and the South Sandwich Islands',19,5);
INSERT into e_country VALUES ('BM','BMU',060,'Bermuda',19,21);
INSERT into e_country VALUES ('CA','CAN',124,'Canada',19,21);
INSERT into e_country VALUES ('GL','GRL',304,'Greenland',19,21);
INSERT into e_country VALUES ('PM','SPM',666,'Saint Pierre and Miquelon',19,21);
INSERT into e_country VALUES ('US','USA',840,'United States',19,21);
INSERT into e_country VALUES ('CN','CHN',156,'China',142,30);
INSERT into e_country VALUES ('HK','HKG',344,'Hong Kong',142,30);
INSERT into e_country VALUES ('MO','MAC',446,'Macao',142,30);
INSERT into e_country VALUES ('KP','PRK',408,'Democratic Peoples Republic of Korea',142,30);
INSERT into e_country VALUES ('JP','JPN',392,'Japan',142,30);
INSERT into e_country VALUES ('MN','MNG',496,'Mongolia',142,30);
INSERT into e_country VALUES ('KR','KOR',410,'Republic of Korea',142,30);
INSERT into e_country VALUES ('TW','TWN',158,'Taiwan',142,30);
INSERT into e_country VALUES ('AF','AFG',004,'Afghanistan',142,62);
INSERT into e_country VALUES ('BD','BGD',050,'Bangladesh',142,62);
INSERT into e_country VALUES ('BT','BTN',064,'Bhutan',142,62);
INSERT into e_country VALUES ('IN','IND',356,'India',142,62);
INSERT into e_country VALUES ('IR','IRN',364,'Iran',142,62);
INSERT into e_country VALUES ('KZ','KAZ',398,'Kazakstan',142,62);
INSERT into e_country VALUES ('KG','KGZ',417,'Kyrgyzstan',142,62);
INSERT into e_country VALUES ('MV','MDV',462,'Maldives',142,62);
INSERT into e_country VALUES ('NP','NPL',524,'Nepal',142,62);
INSERT into e_country VALUES ('PK','PAK',586,'Pakistan',142,62);
INSERT into e_country VALUES ('LK','LKA',144,'Sri Lanka',142,62);
INSERT into e_country VALUES ('TJ','TJK',762,'Tajikistan',142,62);
INSERT into e_country VALUES ('TM','TKM',795,'Turkmenistan',142,62);
INSERT into e_country VALUES ('UZ','UZB',860,'Uzbekistan',142,62);
INSERT into e_country VALUES ('BN','BRN',096,'Brunei Darussalam',142,35);
INSERT into e_country VALUES ('KH','KHM',116,'Cambodia',142,35);
INSERT into e_country VALUES ('TS','TLS',626,'Timor-Leste (East Timor)',142,35);
INSERT into e_country VALUES ('ID','IDN',360,'Indonesia',142,35);
INSERT into e_country VALUES ('LA','LAO',418,'Lao Peoples Democratic Republic',142,35);
INSERT into e_country VALUES ('MY','MYS',458,'Malaysia',142,35);
INSERT into e_country VALUES ('MM','MMR',104,'Myanmar',142,35);
INSERT into e_country VALUES ('PH','PHL',608,'Philippines',142,35);
INSERT into e_country VALUES ('SG','SGP',702,'Singapore',142,35);
INSERT into e_country VALUES ('TH','THA',764,'Thailand',142,35);
INSERT into e_country VALUES ('VN','VNM',704,'Viet Nam',142,35);
INSERT into e_country VALUES ('AM','ARM',051,'Armenia',142,145);
INSERT into e_country VALUES ('AZ','AZE',031,'Azerbaijan',142,145);
INSERT into e_country VALUES ('BH','BHR',048,'Bahrain',142,145);
INSERT into e_country VALUES ('CY','CYP',196,'Cyprus',142,145);
INSERT into e_country VALUES ('GE','GEO',268,'Georgia',142,145);
INSERT into e_country VALUES ('IQ','IRQ',368,'Iraq',142,145);
INSERT into e_country VALUES ('IL','ISR',376,'Israel',142,145);
INSERT into e_country VALUES ('JO','JOR',400,'Jordan',142,145);
INSERT into e_country VALUES ('KW','KWT',414,'Kuwait',142,145);
INSERT into e_country VALUES ('LB','LBN',422,'Lebanon',142,145);
INSERT into e_country VALUES ('PS','PSE',275,'Occupied Palestinian Territory',142,145);
INSERT into e_country VALUES ('OM','OMN',512,'Oman',142,145);
INSERT into e_country VALUES ('QA','QAT',634,'Qatar',142,145);
INSERT into e_country VALUES ('SA','SAU',682,'Saudi Arabia',142,145);
INSERT into e_country VALUES ('SY','SYR',760,'Syrian Arab Republic',142,145);
INSERT into e_country VALUES ('TR','TUR',792,'Turkey',142,145);
INSERT into e_country VALUES ('AE','ARE',784,'United Arab Emirates',142,145);
INSERT into e_country VALUES ('YE','YEM',887,'Yemen',142,145);
INSERT into e_country VALUES ('BY','BLR',112,'Belarus',150,151);
INSERT into e_country VALUES ('BG','BGR',100,'Bulgaria',150,151);
INSERT into e_country VALUES ('CZ','CZE',203,'Czech Republic',150,151);
INSERT into e_country VALUES ('HU','HUN',348,'Hungary',150,151);
INSERT into e_country VALUES ('PL','POL',616,'Poland',150,151);
INSERT into e_country VALUES ('MD','MDA',498,'Moldova',150,151);
INSERT into e_country VALUES ('RO','ROU',642,'Romania',150,151);
INSERT into e_country VALUES ('RU','RUS',643,'Russian Federation',150,151);
INSERT into e_country VALUES ('SK','SVK',703,'Slovakia',150,151);
INSERT into e_country VALUES ('UA','UKR',804,'Ukraine',150,151);
INSERT into e_country VALUES ('DK','DNK',208,'Denmark',150,154);
INSERT into e_country VALUES ('FO','FRO',234,'Faroe Islands',150,154);
INSERT into e_country VALUES ('EE','EST',233,'Estonia',150,154);
INSERT into e_country VALUES ('FI','FIN',246,'Finland',150,154);
INSERT into e_country VALUES ('IS','ISL',352,'Iceland',150,154);
INSERT into e_country VALUES ('IE','IRL',372,'Ireland',150,154);
INSERT into e_country VALUES ('LV','LVA',428,'Latvia',150,154);
INSERT into e_country VALUES ('LT','LTU',440,'Lithuania',150,154);
INSERT into e_country VALUES ('NO','NOR',578,'Norway',150,154);
INSERT into e_country VALUES ('SJ','SJM',744,'Svalbard and Jan Mayen',150,154);
INSERT into e_country VALUES ('SE','SWE',752,'Sweden',150,154);
INSERT into e_country VALUES ('GB','GBR',826,'United Kingdom',150,154);
INSERT into e_country VALUES ('AL','ALB',008,'Albania',150,39);
INSERT into e_country VALUES ('AD','AND',020,'Andorra',150,39);
INSERT into e_country VALUES ('BA','BIH',070,'Bosnia and Herzegovina',150,39);
INSERT into e_country VALUES ('HR','HRV',191,'Croatia',150,39);
INSERT into e_country VALUES ('GI','GIB',292,'Gibraltar',150,39);
INSERT into e_country VALUES ('GR','GRC',300,'Greece',150,39);
INSERT into e_country VALUES ('VA','VAT',336,'Holy See (Vatican City State)',150,39);
INSERT into e_country VALUES ('IT','ITA',380,'Italy',150,39);
INSERT into e_country VALUES ('MT','MLT',470,'Malta',150,39);
INSERT into e_country VALUES ('PT','PRT',620,'Portugal',150,39);
INSERT into e_country VALUES ('SM','SMR',674,'San Marino',150,39);
INSERT into e_country VALUES ('SI','SVN',705,'Slovenia',150,39);
INSERT into e_country VALUES ('ES','ESP',724,'Spain',150,39);
INSERT into e_country VALUES ('MK','MKD',807,'Macedonia',150,39);
INSERT into e_country VALUES ('YU','YUG',891,'Yugoslavia',150,39);
INSERT into e_country VALUES ('AT','AUT',040,'Austria',150,155);
INSERT into e_country VALUES ('BE','BEL',056,'Belgium',150,155);
INSERT into e_country VALUES ('FR','FRA',250,'France',150,155);
INSERT into e_country VALUES ('FX','FXX',249,'Metropolitan France',150,155);
INSERT into e_country VALUES ('DE','DEU',276,'Germany',150,155);
INSERT into e_country VALUES ('LI','LIE',438,'Liechtenstein',150,155);
INSERT into e_country VALUES ('LU','LUX',442,'Luxembourg',150,155);
INSERT into e_country VALUES ('MC','MCO',492,'Monaco',150,155);
INSERT into e_country VALUES ('NL','NLD',528,'Netherlands',150,155);
INSERT into e_country VALUES ('CH','CHE',756,'Switzerland',150,155);
INSERT into e_country VALUES ('AU','AUS',036,'Australia',9,53);
INSERT into e_country VALUES ('NZ','NZL',554,'New Zealand',9,53);
INSERT into e_country VALUES ('NF','NFK',574,'Norfolk Island',9,53);
INSERT into e_country VALUES ('CC','CCK',166,'Cocos (Keeling) Islands',9,53);
INSERT into e_country VALUES ('CX','CXR',162,'Christmas Island',9,53);
INSERT into e_country VALUES ('TF','ATF',260,'French Southern Territories',9,53);
INSERT into e_country VALUES ('HM','HMD',334,'Heard Island and McDonald Islands',9,53);
INSERT into e_country VALUES ('UM','UMI',581,'United States Minor Outlying Islands',9,53);
INSERT into e_country VALUES ('FJ','FJI',242,'Fiji',9,54);
INSERT into e_country VALUES ('NC','NCL',540,'New Caledonia',9,54);
INSERT into e_country VALUES ('PG','PNG',598,'Papua New Guinea',9,54);
INSERT into e_country VALUES ('SB','SLB',090,'Solomon Islands',9,54);
INSERT into e_country VALUES ('VU','VUT',548,'Vanuatu',9,54);
INSERT into e_country VALUES ('FM','FSM',583,'Micronesia',9,57);
INSERT into e_country VALUES ('GU','GUM',316,'Guam',9,57);
INSERT into e_country VALUES ('KI','KIR',296,'Kiribati',9,57);
INSERT into e_country VALUES ('MH','MHL',584,'Marshall Islands',9,57);
INSERT into e_country VALUES ('NR','NRU',520,'Nauru',9,57);
INSERT into e_country VALUES ('MP','MNP',580,'Northern Mariana Islands',9,57);
INSERT into e_country VALUES ('PW','PLW',585,'Palau',9,57);
INSERT into e_country VALUES ('AS','ASM',016,'American Samoa',9,61);
INSERT into e_country VALUES ('CK','COK',184,'Cook Islands',9,61);
INSERT into e_country VALUES ('PF','PYF',258,'French Polynesia',9,61);
INSERT into e_country VALUES ('NU','NIU',570,'Niue',9,61);
INSERT into e_country VALUES ('PN','PCN',612,'Pitcairn',9,61);
INSERT into e_country VALUES ('WS','WSM',882,'Samoa',9,61);
INSERT into e_country VALUES ('TK','TKL',772,'Tokelau',9,61);
INSERT into e_country VALUES ('TO','TON',776,'Tonga',9,61);
INSERT into e_country VALUES ('TV','TUV',798,'Tuvalu',9,61);
INSERT into e_country VALUES ('WF','WLF',876,'Wallis and Futuna Islands',9,61);
INSERT into e_country VALUES ('AX','ALA',248,'Aland Islands',150,154);
INSERT into e_country VALUES ('GG','GGY',831,'Guernsey',150,154);
INSERT into e_country VALUES ('JE','JEY',832,'Jersey',150,154);
INSERT into e_country VALUES ('IM','IMN',833,'Isle of Man',150,154);
INSERT into e_country VALUES ('ME','MNE',499,'Montenegro',150,039);
INSERT into e_country VALUES ('RS','SRB',688,'Serbia',150,039);

--
-- regions (are related to countries and defined by a sub ISO 3166)
--
CREATE SEQUENCE e_region_serial;
CREATE TABLE e_region (
 	e_region_id 	integer 		DEFAULT nextval('e_region_serial'),
 	name 		text 			NOT NULL,
 	country_iso 	integer 		NOT NULL,
 	code 		text 			NOT NULL,
  	PRIMARY KEY(e_region_id)
);
CREATE UNIQUE INDEX e_region_code ON e_region(country_iso, code);

-- Switzerland (ISO 3166-2:CH)
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:CH
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Argovie', 756, 'CH-AG');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Appenzell Rhodes-Interieures', 756, 'CH-AI');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Appenzell Rhodes-Exterieures', 756, 'CH-AR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Berne', 756, 'CH-BE');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Bale-Campagne', 756, 'CH-BL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Bale-Ville', 756, 'CH-BS');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Fribourg', 756, 'CH-FR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Geneve', 756, 'CH-GE');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Glaris', 756, 'CH-GL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Grisons', 756, 'CH-GR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Jura', 756, 'CH-JU');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Lucerne', 756, 'CH-LU');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Neuchatel', 756, 'CH-NE');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Nidwald', 756, 'CH-NW');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Obwald', 756, 'CH-OW');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Saint-Gall', 756, 'CH-SG');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Schaffhouse', 756, 'CH-SH');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Soleure', 756, 'CH-SO');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Schwytz', 756, 'CH-SZ');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Thurgovie', 756, 'CH-TG');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Tessin', 756, 'CH-TI');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Uri', 756, 'CH-UR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Vaud', 756, 'CH-VD');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Valais', 756, 'CH-VS');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Zoug', 756, 'CH-ZG');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Zurich', 756, 'CH-ZH');

-- France (ISO 3166-2:2002-5-21)
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:FR
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Alsace', 250, 'FR-A');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Aquitaine', 250, 'FR-B');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Auvergne', 250, 'FR-C');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Basse-Normandie', 250, 'FR-P');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Bourgogne', 250, 'FR-D');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Bretagne', 250, 'FR-E');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Centre', 250, 'FR-F');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Champagne-Ardenne', 250, 'FR-G');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Corse', 250, 'FR-H');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Franche-Comté', 250, 'FR-I');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Haute-Normandie', 250, 'FR-Q');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Ile-de-France', 250, 'FR-J');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Languedoc-Roussillon', 250, 'FR-K');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Limousin', 250, 'FR-L');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Lorraine', 250, 'FR-M');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Midi-Pyrénées', 250, 'FR-N');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Nord-Pas-de-Calais', 250, 'FR-O');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Pays de la Loire', 250, 'FR-R');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Picardie', 250, 'FR-S');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Poitou-Charentes', 250, 'FR-T');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Provence-Alpes-Côte d\'Azur', 250, 'FR-U');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Rhône-Alpes', 250, 'FR-V');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Guadeloupe', 250, 'FR-GP');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Guyane', 250, 'FR-GF');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Martinique', 250, 'FR-MQ');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Réunion', 250, 'FR-RE');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Saint-Barthélemy', 250, 'FR-BL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Saint-Martin', 250, 'FR-MF');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Mayotte', 250, 'FR-YT');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Saint-Pierre-et-Miquelon', 250, 'FR-PM');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Nouvelle-Calédonie', 250, 'FR-NC');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Polynésie française', 250, 'FR-PF');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Terres Australes Françaises', 250, 'FR-TF');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Wallis et Futuna', 250, 'FR-WF');

-- Germany (ISO)
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:DE
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Baden-Wurttemberg', 276, 'DE-BW');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Bayern', 276, 'DE-BY');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Berlin', 276, 'DE-BE');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Brandenburg', 276, 'DE-BR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Bremen', 276, 'DE-HB');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Hamburg', 276, 'DE-HH');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Hessen', 276, 'DE-HE');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Mecklemburg-Vorpommern', 276, 'DE-MV');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Nordrhein-Westfalen', 276, 'DE-NW');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Rheinland-Pfalz', 276, 'DE-RP');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Saarland', 276, 'DE-SL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Freistaat Sachsen', 276, 'DE-SN');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Sachsen-Anhalt', 276, 'DE-ST');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Niedersachsen', 276, 'DE-NI');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Schleswig-Holstein', 276, 'DE-SH');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Thuringen', 276, 'DE-TH');

-- United Kingdom (ISO 3166-2:2002-05-21)
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:GB
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Channel Islands', 826, 'CHA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'England', 826, 'ENG');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Isle of Man', 826, 'IOM');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Northern Ireland', 826, 'NIR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Scotland', 826, 'SCT');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Wales', 826, 'WLS');

-- Italy
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:IT
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Abruzzo', 	380, '65');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Basilicata', 	380, '77');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Calabria', 	380, '78');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Campania', 	380, '72');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Emilia-Romagna', 380, '45');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Friuli-Venezia Giulia', 380, '36');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Lazio', 		380, '62');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Liguria', 	380, '42');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Lombardia', 	380, '25');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Marche', 		380, '57');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Molise', 		380, '67');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Piemonte', 	380, '21');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Puglia',	 	380, '75');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Sardegna', 	380, '88');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Sicilia', 	380, '82');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Toscana', 	380, '52');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Trentino-Alto Adige', 380, '32');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Umbria', 		380, '55');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Valle d Aosta', 380, '23');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Veneto', 		380, '34');

-- Spain
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:ES
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Andalucía', 	724, 'AN');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Aragon', 		724, 'AR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Asturias', 	724, 'O');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Canarias', 	724, 'CN');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Cantabria', 	724, 'S');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Castilla-La Mancha', 	724, 'CM');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Castilla y León', 	724, 'CL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Extremadura', 724, 'EX');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Galicia', 	724, 'GA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Illes Balears', 	724, 'IB');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'La Rioja', 	724, 'LO');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Madrid',	 	724, 'M');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Murcia', 		724, 'MU');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Navarra', 	724, 'NA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Valenciana', 	724, 'VC');

-- United States
-- see: http://fr.wikipedia.org/wiki/ISO_3166-2:US
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Alabama ', 840, 'US-AL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Alaska ', 840, 'US-AK');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Arizona ', 840, 'US-AZ');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Arkansas ', 840, 'US-AR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'California ', 840, 'US-CA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Colorado ', 840, 'US-CO');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Connecticut ', 840, 'US-CT');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Delaware ', 840, 'US-DE');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Florida ', 840, 'US-FL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Georgia ', 840, 'US-GA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Hawaii ', 840, 'US-HI');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Idaho ', 840, 'US-ID');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Illinois ', 840, 'US-IL');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Indiana ', 840, 'US-IN');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Iowa ', 840, 'US-IA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Kansas ', 840, 'US-KS');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Kentucky ', 840, 'US-KY');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Louisiana ', 840, 'US-LA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Maine ', 840, 'US-ME');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Maryland ', 840, 'US-MD');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Massachusetts ', 840, 'US-MA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Michigan ', 840, 'US-MI');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Minnesota ', 840, 'US-MN');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Mississippi ', 840, 'US-MS');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Missouri ', 840, 'US-MO');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Montana ', 840, 'US-MT');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Nebraska ', 840, 'US-NE');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Nevada ', 840, 'US-NV');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'New Hampshire ', 840, 'US-NH');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'New Jersey ', 840, 'US-NJ');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'New Mexico ', 840, 'US-NM');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'New York ', 840, 'US-NY');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'North Carolina ', 840, 'US-NC');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'North Dakota ', 840, 'US-ND');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Ohio ', 840, 'US-OH');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Oklahoma ', 840, 'US-OK');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Oregon ', 840, 'US-OR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Pennsylvania ', 840, 'US-PA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Rhode Island ', 840, 'US-RI');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'South Carolina ', 840, 'US-SC');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'South Dakota ', 840, 'US-SD');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Tennessee ', 840, 'US-TN');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Texas ', 840, 'US-TX');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Utah ', 840, 'US-UT');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Vermont ', 840, 'US-VT');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Virginia ', 840, 'US-VA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Washington ', 840, 'US-WA');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'West Virginia ', 840, 'US-WV');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Wisconsin ', 840, 'US-WI');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Wyoming', 840, 'US-WY');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'District of Columbia ', 840, 'US-DC');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'American Samoa ', 840, 'US-AS');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Guam ', 840, 'US-GU');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Northern Mariana Islands ', 840, 'US-MP');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Porto Rico ', 840, 'US-PR');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'U.S. Minor Outlying Islands', 840, 'US-UM');
INSERT INTO e_region ( name, country_iso, code) VALUES ( 'Virgin Islands of the U.S.', 840, 'US-VI');

--
-- Internet Top Level Domains
-- see: http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains
CREATE SEQUENCE e_top_domain_serial;
CREATE TABLE e_top_level_domains (
	top_domain_id	int DEFAULT nextval('e_top_domain_serial'),
	tld				text NOT NULL,
	description		text
,	PRIMARY KEY (top_domain_id)
);
CREATE UNIQUE INDEX e_top_level_domains_tld ON e_top_level_domains (tld);

INSERT into e_top_level_domains (tld) VALUES ('AC');
INSERT into e_top_level_domains (tld) VALUES ('AD');
INSERT into e_top_level_domains (tld) VALUES ('AE');
INSERT into e_top_level_domains (tld) VALUES ('AERO');
INSERT into e_top_level_domains (tld) VALUES ('AF');
INSERT into e_top_level_domains (tld) VALUES ('AG');
INSERT into e_top_level_domains (tld) VALUES ('AI');
INSERT into e_top_level_domains (tld) VALUES ('AL');
INSERT into e_top_level_domains (tld) VALUES ('AM');
INSERT into e_top_level_domains (tld) VALUES ('AN');
INSERT into e_top_level_domains (tld) VALUES ('AO');
INSERT into e_top_level_domains (tld) VALUES ('AQ');
INSERT into e_top_level_domains (tld) VALUES ('AR');
INSERT into e_top_level_domains (tld) VALUES ('ARPA');
INSERT into e_top_level_domains (tld) VALUES ('AS');
INSERT into e_top_level_domains (tld) VALUES ('AT');
INSERT into e_top_level_domains (tld) VALUES ('AU');
INSERT into e_top_level_domains (tld) VALUES ('AW');
INSERT into e_top_level_domains (tld) VALUES ('AZ');
INSERT into e_top_level_domains (tld) VALUES ('BA');
INSERT into e_top_level_domains (tld) VALUES ('BB');
INSERT into e_top_level_domains (tld) VALUES ('BD');
INSERT into e_top_level_domains (tld) VALUES ('BE');
INSERT into e_top_level_domains (tld) VALUES ('BF');
INSERT into e_top_level_domains (tld) VALUES ('BG');
INSERT into e_top_level_domains (tld) VALUES ('BH');
INSERT into e_top_level_domains (tld) VALUES ('BI');
INSERT into e_top_level_domains (tld) VALUES ('BIZ');
INSERT into e_top_level_domains (tld) VALUES ('BJ');
INSERT into e_top_level_domains (tld) VALUES ('BM');
INSERT into e_top_level_domains (tld) VALUES ('BN');
INSERT into e_top_level_domains (tld) VALUES ('BO');
INSERT into e_top_level_domains (tld) VALUES ('BR');
INSERT into e_top_level_domains (tld) VALUES ('BS');
INSERT into e_top_level_domains (tld) VALUES ('BT');
INSERT into e_top_level_domains (tld) VALUES ('BV');
INSERT into e_top_level_domains (tld) VALUES ('BW');
INSERT into e_top_level_domains (tld) VALUES ('BY');
INSERT into e_top_level_domains (tld) VALUES ('BZ');
INSERT into e_top_level_domains (tld) VALUES ('CA');
INSERT into e_top_level_domains (tld) VALUES ('CAT');
INSERT into e_top_level_domains (tld) VALUES ('CC');
INSERT into e_top_level_domains (tld) VALUES ('CD');
INSERT into e_top_level_domains (tld) VALUES ('CF');
INSERT into e_top_level_domains (tld) VALUES ('CG');
INSERT into e_top_level_domains (tld) VALUES ('CH');
INSERT into e_top_level_domains (tld) VALUES ('CI');
INSERT into e_top_level_domains (tld) VALUES ('CK');
INSERT into e_top_level_domains (tld) VALUES ('CL');
INSERT into e_top_level_domains (tld) VALUES ('CM');
INSERT into e_top_level_domains (tld) VALUES ('CN');
INSERT into e_top_level_domains (tld) VALUES ('CO');
INSERT into e_top_level_domains (tld) VALUES ('COM');
INSERT into e_top_level_domains (tld) VALUES ('COOP');
INSERT into e_top_level_domains (tld) VALUES ('CR');
INSERT into e_top_level_domains (tld) VALUES ('CU');
INSERT into e_top_level_domains (tld) VALUES ('CV');
INSERT into e_top_level_domains (tld) VALUES ('CX');
INSERT into e_top_level_domains (tld) VALUES ('CY');
INSERT into e_top_level_domains (tld) VALUES ('CZ');
INSERT into e_top_level_domains (tld) VALUES ('DE');
INSERT into e_top_level_domains (tld) VALUES ('DJ');
INSERT into e_top_level_domains (tld) VALUES ('DK');
INSERT into e_top_level_domains (tld) VALUES ('DM');
INSERT into e_top_level_domains (tld) VALUES ('DO');
INSERT into e_top_level_domains (tld) VALUES ('DZ');
INSERT into e_top_level_domains (tld) VALUES ('EC');
INSERT into e_top_level_domains (tld) VALUES ('EDU');
INSERT into e_top_level_domains (tld) VALUES ('EE');
INSERT into e_top_level_domains (tld) VALUES ('EG');
INSERT into e_top_level_domains (tld) VALUES ('ER');
INSERT into e_top_level_domains (tld) VALUES ('ES');
INSERT into e_top_level_domains (tld) VALUES ('ET');
INSERT into e_top_level_domains (tld) VALUES ('EU');
INSERT into e_top_level_domains (tld) VALUES ('FI');
INSERT into e_top_level_domains (tld) VALUES ('FJ');
INSERT into e_top_level_domains (tld) VALUES ('FK');
INSERT into e_top_level_domains (tld) VALUES ('FM');
INSERT into e_top_level_domains (tld) VALUES ('FO');
INSERT into e_top_level_domains (tld) VALUES ('FR');
INSERT into e_top_level_domains (tld) VALUES ('GA');
INSERT into e_top_level_domains (tld) VALUES ('GB');
INSERT into e_top_level_domains (tld) VALUES ('GD');
INSERT into e_top_level_domains (tld) VALUES ('GE');
INSERT into e_top_level_domains (tld) VALUES ('GF');
INSERT into e_top_level_domains (tld) VALUES ('GG');
INSERT into e_top_level_domains (tld) VALUES ('GH');
INSERT into e_top_level_domains (tld) VALUES ('GI');
INSERT into e_top_level_domains (tld) VALUES ('GL');
INSERT into e_top_level_domains (tld) VALUES ('GM');
INSERT into e_top_level_domains (tld) VALUES ('GN');
INSERT into e_top_level_domains (tld) VALUES ('GOV');
INSERT into e_top_level_domains (tld) VALUES ('GP');
INSERT into e_top_level_domains (tld) VALUES ('GQ');
INSERT into e_top_level_domains (tld) VALUES ('GR');
INSERT into e_top_level_domains (tld) VALUES ('GS');
INSERT into e_top_level_domains (tld) VALUES ('GT');
INSERT into e_top_level_domains (tld) VALUES ('GU');
INSERT into e_top_level_domains (tld) VALUES ('GW');
INSERT into e_top_level_domains (tld) VALUES ('GY');
INSERT into e_top_level_domains (tld) VALUES ('HK');
INSERT into e_top_level_domains (tld) VALUES ('HM');
INSERT into e_top_level_domains (tld) VALUES ('HN');
INSERT into e_top_level_domains (tld) VALUES ('HR');
INSERT into e_top_level_domains (tld) VALUES ('HT');
INSERT into e_top_level_domains (tld) VALUES ('HU');
INSERT into e_top_level_domains (tld) VALUES ('ID');
INSERT into e_top_level_domains (tld) VALUES ('IE');
INSERT into e_top_level_domains (tld) VALUES ('IL');
INSERT into e_top_level_domains (tld) VALUES ('IM');
INSERT into e_top_level_domains (tld) VALUES ('IN');
INSERT into e_top_level_domains (tld) VALUES ('INFO');
INSERT into e_top_level_domains (tld) VALUES ('INT');
INSERT into e_top_level_domains (tld) VALUES ('IO');
INSERT into e_top_level_domains (tld) VALUES ('IQ');
INSERT into e_top_level_domains (tld) VALUES ('IR');
INSERT into e_top_level_domains (tld) VALUES ('IS');
INSERT into e_top_level_domains (tld) VALUES ('IT');
INSERT into e_top_level_domains (tld) VALUES ('JE');
INSERT into e_top_level_domains (tld) VALUES ('JM');
INSERT into e_top_level_domains (tld) VALUES ('JO');
INSERT into e_top_level_domains (tld) VALUES ('JOBS');
INSERT into e_top_level_domains (tld) VALUES ('JP');
INSERT into e_top_level_domains (tld) VALUES ('KE');
INSERT into e_top_level_domains (tld) VALUES ('KG');
INSERT into e_top_level_domains (tld) VALUES ('KH');
INSERT into e_top_level_domains (tld) VALUES ('KI');
INSERT into e_top_level_domains (tld) VALUES ('KM');
INSERT into e_top_level_domains (tld) VALUES ('KN');
INSERT into e_top_level_domains (tld) VALUES ('KR');
INSERT into e_top_level_domains (tld) VALUES ('KW');
INSERT into e_top_level_domains (tld) VALUES ('KY');
INSERT into e_top_level_domains (tld) VALUES ('KZ');
INSERT into e_top_level_domains (tld) VALUES ('LA');
INSERT into e_top_level_domains (tld) VALUES ('LB');
INSERT into e_top_level_domains (tld) VALUES ('LC');
INSERT into e_top_level_domains (tld) VALUES ('LI');
INSERT into e_top_level_domains (tld) VALUES ('LK');
INSERT into e_top_level_domains (tld) VALUES ('LR');
INSERT into e_top_level_domains (tld) VALUES ('LS');
INSERT into e_top_level_domains (tld) VALUES ('LT');
INSERT into e_top_level_domains (tld) VALUES ('LU');
INSERT into e_top_level_domains (tld) VALUES ('LV');
INSERT into e_top_level_domains (tld) VALUES ('LY');
INSERT into e_top_level_domains (tld) VALUES ('MA');
INSERT into e_top_level_domains (tld) VALUES ('MC');
INSERT into e_top_level_domains (tld) VALUES ('MD');
INSERT into e_top_level_domains (tld) VALUES ('MG');
INSERT into e_top_level_domains (tld) VALUES ('MH');
INSERT into e_top_level_domains (tld) VALUES ('MIL');
INSERT into e_top_level_domains (tld) VALUES ('MK');
INSERT into e_top_level_domains (tld) VALUES ('ML');
INSERT into e_top_level_domains (tld) VALUES ('MM');
INSERT into e_top_level_domains (tld) VALUES ('MN');
INSERT into e_top_level_domains (tld) VALUES ('MO');
INSERT into e_top_level_domains (tld) VALUES ('MOBI');
INSERT into e_top_level_domains (tld) VALUES ('MP');
INSERT into e_top_level_domains (tld) VALUES ('MQ');
INSERT into e_top_level_domains (tld) VALUES ('MR');
INSERT into e_top_level_domains (tld) VALUES ('MS');
INSERT into e_top_level_domains (tld) VALUES ('MT');
INSERT into e_top_level_domains (tld) VALUES ('MU');
INSERT into e_top_level_domains (tld) VALUES ('MUSEUM');
INSERT into e_top_level_domains (tld) VALUES ('MV');
INSERT into e_top_level_domains (tld) VALUES ('MW');
INSERT into e_top_level_domains (tld) VALUES ('MX');
INSERT into e_top_level_domains (tld) VALUES ('MY');
INSERT into e_top_level_domains (tld) VALUES ('MZ');
INSERT into e_top_level_domains (tld) VALUES ('NA');
INSERT into e_top_level_domains (tld) VALUES ('NAME');
INSERT into e_top_level_domains (tld) VALUES ('NC');
INSERT into e_top_level_domains (tld) VALUES ('NE');
INSERT into e_top_level_domains (tld) VALUES ('NET');
INSERT into e_top_level_domains (tld) VALUES ('NF');
INSERT into e_top_level_domains (tld) VALUES ('NG');
INSERT into e_top_level_domains (tld) VALUES ('NI');
INSERT into e_top_level_domains (tld) VALUES ('NL');
INSERT into e_top_level_domains (tld) VALUES ('NO');
INSERT into e_top_level_domains (tld) VALUES ('NP');
INSERT into e_top_level_domains (tld) VALUES ('NR');
INSERT into e_top_level_domains (tld) VALUES ('NU');
INSERT into e_top_level_domains (tld) VALUES ('NZ');
INSERT into e_top_level_domains (tld) VALUES ('OM');
INSERT into e_top_level_domains (tld) VALUES ('ORG');
INSERT into e_top_level_domains (tld) VALUES ('PA');
INSERT into e_top_level_domains (tld) VALUES ('PE');
INSERT into e_top_level_domains (tld) VALUES ('PF');
INSERT into e_top_level_domains (tld) VALUES ('PG');
INSERT into e_top_level_domains (tld) VALUES ('PH');
INSERT into e_top_level_domains (tld) VALUES ('PK');
INSERT into e_top_level_domains (tld) VALUES ('PL');
INSERT into e_top_level_domains (tld) VALUES ('PM');
INSERT into e_top_level_domains (tld) VALUES ('PN');
INSERT into e_top_level_domains (tld) VALUES ('PR');
INSERT into e_top_level_domains (tld) VALUES ('PRO');
INSERT into e_top_level_domains (tld) VALUES ('PS');
INSERT into e_top_level_domains (tld) VALUES ('PT');
INSERT into e_top_level_domains (tld) VALUES ('PW');
INSERT into e_top_level_domains (tld) VALUES ('PY');
INSERT into e_top_level_domains (tld) VALUES ('QA');
INSERT into e_top_level_domains (tld) VALUES ('RE');
INSERT into e_top_level_domains (tld) VALUES ('RO');
INSERT into e_top_level_domains (tld) VALUES ('RU');
INSERT into e_top_level_domains (tld) VALUES ('RW');
INSERT into e_top_level_domains (tld) VALUES ('SA');
INSERT into e_top_level_domains (tld) VALUES ('SB');
INSERT into e_top_level_domains (tld) VALUES ('SC');
INSERT into e_top_level_domains (tld) VALUES ('SD');
INSERT into e_top_level_domains (tld) VALUES ('SE');
INSERT into e_top_level_domains (tld) VALUES ('SG');
INSERT into e_top_level_domains (tld) VALUES ('SH');
INSERT into e_top_level_domains (tld) VALUES ('SI');
INSERT into e_top_level_domains (tld) VALUES ('SJ');
INSERT into e_top_level_domains (tld) VALUES ('SK');
INSERT into e_top_level_domains (tld) VALUES ('SL');
INSERT into e_top_level_domains (tld) VALUES ('SM');
INSERT into e_top_level_domains (tld) VALUES ('SN');
INSERT into e_top_level_domains (tld) VALUES ('SO');
INSERT into e_top_level_domains (tld) VALUES ('SR');
INSERT into e_top_level_domains (tld) VALUES ('ST');
INSERT into e_top_level_domains (tld) VALUES ('SU');
INSERT into e_top_level_domains (tld) VALUES ('SV');
INSERT into e_top_level_domains (tld) VALUES ('SY');
INSERT into e_top_level_domains (tld) VALUES ('SZ');
INSERT into e_top_level_domains (tld) VALUES ('TC');
INSERT into e_top_level_domains (tld) VALUES ('TD');
INSERT into e_top_level_domains (tld) VALUES ('TF');
INSERT into e_top_level_domains (tld) VALUES ('TG');
INSERT into e_top_level_domains (tld) VALUES ('TH');
INSERT into e_top_level_domains (tld) VALUES ('TJ');
INSERT into e_top_level_domains (tld) VALUES ('TK');
INSERT into e_top_level_domains (tld) VALUES ('TL');
INSERT into e_top_level_domains (tld) VALUES ('TM');
INSERT into e_top_level_domains (tld) VALUES ('TN');
INSERT into e_top_level_domains (tld) VALUES ('TO');
INSERT into e_top_level_domains (tld) VALUES ('TP');
INSERT into e_top_level_domains (tld) VALUES ('TR');
INSERT into e_top_level_domains (tld) VALUES ('TRAVEL');
INSERT into e_top_level_domains (tld) VALUES ('TT');
INSERT into e_top_level_domains (tld) VALUES ('TV');
INSERT into e_top_level_domains (tld) VALUES ('TW');
INSERT into e_top_level_domains (tld) VALUES ('TZ');
INSERT into e_top_level_domains (tld) VALUES ('UA');
INSERT into e_top_level_domains (tld) VALUES ('UG');
INSERT into e_top_level_domains (tld) VALUES ('UK');
INSERT into e_top_level_domains (tld) VALUES ('UM');
INSERT into e_top_level_domains (tld) VALUES ('US');
INSERT into e_top_level_domains (tld) VALUES ('UY');
INSERT into e_top_level_domains (tld) VALUES ('UZ');
INSERT into e_top_level_domains (tld) VALUES ('VA');
INSERT into e_top_level_domains (tld) VALUES ('VC');
INSERT into e_top_level_domains (tld) VALUES ('VE');
INSERT into e_top_level_domains (tld) VALUES ('VG');
INSERT into e_top_level_domains (tld) VALUES ('VI');
INSERT into e_top_level_domains (tld) VALUES ('VN');
INSERT into e_top_level_domains (tld) VALUES ('VU');
INSERT into e_top_level_domains (tld) VALUES ('WF');
INSERT into e_top_level_domains (tld) VALUES ('WS');
INSERT into e_top_level_domains (tld) VALUES ('YE');
INSERT into e_top_level_domains (tld) VALUES ('YT');
INSERT into e_top_level_domains (tld) VALUES ('YU');
INSERT into e_top_level_domains (tld) VALUES ('ZA');
INSERT into e_top_level_domains (tld) VALUES ('ZM');
INSERT into e_top_level_domains (tld) VALUES ('ZW');

INSERT into e_top_level_domains (tld) VALUES ('ASIA');
INSERT into e_top_level_domains (tld) VALUES ('TEL');

--
-- No timezone table. using postgresql view pg_timezone_name
-- source : zone.tab from zoneinfo
--

CREATE TABLE e_timezone_to_country(
        timezone        text,
        country_iso     integer,
        PRIMARY KEY(timezone, country_iso)
);

INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Andorra', 20);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Dubai', 784);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Kabul', 4);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Antigua', 28);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Anguilla', 660);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Tirane', 8);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Yerevan', 51);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Curacao', 530);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Luanda', 24);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/Buenos_Aires', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/Cordoba', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/Jujuy', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/Tucuman', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/Catamarca', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/La_Rioja', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/San_Juan', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/Mendoza', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/Rio_Gallegos', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Argentina/Ushuaia', 32);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Pago_Pago', 16);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Vienna', 40);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Lord_Howe', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Hobart', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Currie', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Melbourne', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Sydney', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Broken_Hill', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Brisbane', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Lindeman', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Adelaide', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Darwin', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Perth', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Australia/Eucla', 36);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Aruba', 533);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Mariehamn', 248);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Baku', 31);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Sarajevo', 70);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Barbados', 52);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Dhaka', 50);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Brussels', 56);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Ouagadougou', 854);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Sofia', 100);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Bahrain', 48);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Bujumbura', 108);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Porto-Novo', 204);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Bermuda', 60);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Brunei', 96);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/La_Paz', 68);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Noronha', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Belem', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Fortaleza', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Recife', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Araguaina', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Maceio', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Bahia', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Sao_Paulo', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Campo_Grande', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Cuiaba', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Porto_Velho', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Boa_Vista', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Manaus', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Eirunepe', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Rio_Branco', 76);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Nassau', 44);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Thimphu', 64);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Gaborone', 72);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Minsk', 112);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Belize', 84);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/St_Johns', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Halifax', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Glace_Bay', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Moncton', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Goose_Bay', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Blanc-Sablon', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Montreal', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Toronto', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Nipigon', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Thunder_Bay', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Iqaluit', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Pangnirtung', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Resolute', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Atikokan', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Rankin_Inlet', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Winnipeg', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Rainy_River', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Regina', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Swift_Current', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Edmonton', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Cambridge_Bay', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Yellowknife', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Inuvik', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Dawson_Creek', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Vancouver', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Whitehorse', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Dawson', 124);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Cocos', 166);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Kinshasa', 180);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Lubumbashi', 180);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Bangui', 140);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Brazzaville', 178);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Zurich', 756);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Abidjan', 384);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Rarotonga', 184);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Santiago', 152);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Easter', 152);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Douala', 120);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Shanghai', 156);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Harbin', 156);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Chongqing', 156);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Urumqi', 156);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Kashgar', 156);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Bogota', 170);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Costa_Rica', 188);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Havana', 192);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Cape_Verde', 132);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Christmas', 162);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Nicosia', 196);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Prague', 203);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Berlin', 276);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Djibouti', 262);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Copenhagen', 208);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Dominica', 212);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Santo_Domingo', 214);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Algiers', 12);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Guayaquil', 218);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Galapagos', 218);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Tallinn', 233);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Cairo', 818);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/El_Aaiun', 732);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Asmara', 232);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Madrid', 724);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Ceuta', 724);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Canary', 724);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Addis_Ababa', 231);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Helsinki', 246);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Fiji', 242);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Stanley', 238);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Truk', 583);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Ponape', 583);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Kosrae', 583);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Faroe', 234);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Paris', 250);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Paris', 249);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Libreville', 266);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/London', 826);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Grenada', 308);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Tbilisi', 268);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Cayenne', 254);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Guernsey', 831);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Accra', 288);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Gibraltar', 292);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Godthab', 304);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Danmarkshavn', 304);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Scoresbysund', 304);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Thule', 304);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Banjul', 270);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Conakry', 324);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Guadeloupe', 312);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Malabo', 226);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Athens', 300);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/South_Georgia', 239);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Guatemala', 320);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Guam', 316);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Bissau', 624);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Guyana', 328);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Hong_Kong', 344);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Tegucigalpa', 340);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Zagreb', 191);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Port-au-Prince', 332);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Budapest', 348);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Jakarta', 360);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Pontianak', 360);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Makassar', 360);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Jayapura', 360);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Dublin', 372);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Jerusalem', 376);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Isle_of_Man', 833);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Calcutta', 356);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Baghdad', 368);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Tehran', 364);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Reykjavik', 352);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Rome', 380);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Jersey', 832);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Jamaica', 388);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Amman', 400);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Tokyo', 392);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Nairobi', 404);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Bishkek', 417);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Phnom_Penh', 116);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Tarawa', 296);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Enderbury', 296);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Kiritimati', 296);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Comoro', 174);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/St_Kitts', 659);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Pyongyang', 408);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Seoul', 410);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Kuwait', 414);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Cayman', 136);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Almaty', 398);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Qyzylorda', 398);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Aqtobe', 398);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Aqtau', 398);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Oral', 398);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Vientiane', 418);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Beirut', 422);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/St_Lucia', 662);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Vaduz', 438);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Colombo', 144);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Monrovia', 430);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Maseru', 426);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Vilnius', 440);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Luxembourg', 442);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Riga', 428);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Tripoli', 434);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Casablanca', 504);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Monaco', 492);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Chisinau', 498);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Podgorica', 499);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Antananarivo', 450);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Majuro', 584);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Kwajalein', 584);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Skopje', 807);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Bamako', 466);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Rangoon', 104);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Ulaanbaatar', 496);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Hovd', 496);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Choibalsan', 496);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Macau', 446);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Saipan', 580);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Martinique', 474);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Nouakchott', 478);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Montserrat', 500);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Malta', 470);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Mauritius', 480);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Maldives', 462);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Blantyre', 454);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Mexico_City', 484);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Cancun', 484);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Merida', 484);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Monterrey', 484);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Mazatlan', 484);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Chihuahua', 484);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Hermosillo', 484);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Tijuana', 484);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Kuala_Lumpur', 458);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Kuching', 458);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Maputo', 508);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Windhoek', 516);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Noumea', 540);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Niamey', 562);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Norfolk', 574);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Lagos', 566);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Managua', 558);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Amsterdam', 528);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Oslo', 578);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Katmandu', 524);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Nauru', 520);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Niue', 570);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Auckland', 554);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Chatham', 554);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Muscat', 512);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Panama', 591);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Lima', 604);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Tahiti', 258);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Marquesas', 258);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Gambier', 258);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Port_Moresby', 598);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Manila', 608);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Karachi', 586);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Warsaw', 616);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Miquelon', 666);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Pitcairn', 612);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Puerto_Rico', 630);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Gaza', 275);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Lisbon', 620);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Madeira', 620);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Azores', 620);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Palau', 585);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Asuncion', 600);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Qatar', 634);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Reunion', 638);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Bucharest', 642);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Belgrade', 688);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Belgrade', 891);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Kaliningrad', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Moscow', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Volgograd', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Samara', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Yekaterinburg', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Omsk', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Novosibirsk', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Krasnoyarsk', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Irkutsk', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Yakutsk', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Vladivostok', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Sakhalin', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Magadan', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Kamchatka', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Anadyr', 643);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Kigali', 646);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Riyadh', 682);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Guadalcanal', 90);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Mahe', 690);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Khartoum', 736);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Stockholm', 752);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Singapore', 702);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/St_Helena', 654);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Ljubljana', 705);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Arctic/Longyearbyen', 744);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Atlantic/Jan_Mayen', 744);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Bratislava', 703);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Freetown', 694);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/San_Marino', 674);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Dakar', 686);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Mogadishu', 706);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Paramaribo', 740);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Sao_Tome', 678);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/El_Salvador', 222);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Damascus', 760);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Mbabane', 748);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Grand_Turk', 796);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Ndjamena', 148);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Kerguelen', 260);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Lome', 768);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Bangkok', 764);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Dushanbe', 762);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Fakaofo', 772);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Ashgabat', 795);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Tunis', 788);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Tongatapu', 776);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Istanbul', 792);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Port_of_Spain', 780);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Funafuti', 798);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Taipei', 158);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Dar_es_Salaam', 834);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Kiev', 804);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Uzhgorod', 804);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Zaporozhye', 804);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Simferopol', 804);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Kampala', 800);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Johnston', 581);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Midway', 581);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Wake', 581);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/New_York', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Detroit', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Kentucky/Louisville', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Kentucky/Monticello', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Indiana/Indianapolis', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Indiana/Vincennes', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Indiana/Knox', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Indiana/Winamac', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Indiana/Marengo', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Indiana/Vevay', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Chicago', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Indiana/Tell_City', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Indiana/Petersburg', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Menominee', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/North_Dakota/Center', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/North_Dakota/New_Salem', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Denver', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Boise', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Shiprock', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Phoenix', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Los_Angeles', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Anchorage', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Juneau', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Yakutat', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Nome', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Adak', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Honolulu', 840);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Montevideo', 858);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Samarkand', 860);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Tashkent', 860);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Europe/Vatican', 336);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/St_Vincent', 670);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Caracas', 862);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/Tortola', 92);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('America/St_Thomas', 850);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Saigon', 704);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Efate', 548);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Wallis', 876);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Pacific/Apia', 882);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Asia/Aden', 887);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Indian/Mayotte', 175);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Johannesburg', 710);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Lusaka', 894);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Africa/Harare', 716);
--
-- added these 2 manually so every country in our db is associated with at least 1 tz
--
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Etc/GMT+9', 626);
INSERT INTO e_timezone_to_country (timezone, country_iso) VALUES ('Etc/GMT+5', 334);



CREATE SEQUENCE	e_cross_domain_serial;
CREATE TABLE e_cross_domain(
	e_cross_domain_id 	integer 	DEFAULT nextval('e_cross_domain_serial'),
	domain_name 	 text 	 NOT NULL,
	http_domain_id 	 integer UNIQUE, --http.t_domain
	mail_domain_id 	 integer UNIQUE, --mail.t_domain
	chat_domain_id 	 integer UNIQUE, --mail.t_domain
	top_level_domain_id 	integer, --e_top_level_domains
	PRIMARY KEY(e_cross_domain_id)
);

CREATE UNIQUE INDEX e_cross_domain_name ON e_cross_domain (domain_name);

--
-- the company domains
--
CREATE TABLE e_company_domain(
        e_cross_domain_id       integer,
        e_company_id            integer,
        date_added              timestamptz NOT NULL DEFAULT current_timestamp,
        modifier                int NOT NULL, --e_people
        PRIMARY KEY(e_cross_domain_id, e_company_id)
);

