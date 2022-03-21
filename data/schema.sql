CREATE TABLE IUCRCrimes (
    IUCR VARCHAR(4) NOT NULL,
    PrimaryDesc VARCHAR(40) NOT NULL,
    SecondaryDesc VARCHAR(65) NOT NULL,
    IndexCode VARCHAR(1) NOT NULL,
    Active INTEGER NOT NULL,
    PRIMARY KEY(IUCR),
    CONSTRAINT check_IUCR CHECK(REGEXP_LIKE(IUCR, '\d{3}([A-Z]|\d)?')),
    CONSTRAINT check_IndexCode CHECK(REGEXP_LIKE(IndexCode, '(I|N)')),
    CONSTRAINT check_Active_Boolean CHECK (Active = 0 OR Active = 1)
);
CREATE TABLE NIBRSCrimes (
    NIBRS VARCHAR(3) NOT NULL,
    Title VARCHAR(20) NOT NULL,
    CrimeAgainst VARCHAR(10) NOT NULL,
    Defintion VARCHAR(20) NOT NULL,
    PRIMARY KEY(NIBRS),
    CONSTRAINT check_NIBRS CHECK(REGEXP_LIKE(NIBRS,'\d{2}[A-Z]?'))
);
CREATE TABLE CommunityAreas (
    ID INTEGER NOT NULL,
    Name VARCHAR(25) NOT NULL,
    PRIMARY KEY(ID),
    CONSTRAINT check_CommunityArea CHECK (ID >= 1 AND ID <= 77)
);
CREATE TABLE CommunityAreaPopulations (
    CommunityArea INTEGER NOT NULL,
    Year INTEGER NOT NULL,
    Population INTEGER NOT NULL,
    Households INTEGER,
    NextYear INTEGER NOT NULL,
    PRIMARY KEY(CommunityArea, Year),
    FOREIGN KEY(CommunityArea) REFERENCES CommunityAreas(ID)
);
CREATE TABLE Borders (
    CommunityAreaFrom INTEGER NOT NULL,
    CommunityAreaTo INTEGER NOT NULL,
    PRIMARY KEY(CommunityAreaFrom, CommunityAreaTo),
    FOREIGN KEY(CommunityAreaFrom) REFERENCES CommunityAreas(ID),
    FOREIGN KEY(CommunityAreaTo) REFERENCES CommunityAreas(ID)
);
CREATE TABLE Crimes (
	ID INTEGER NOT NULL,
	CaseNumber VARCHAR(10),
	CrimeDate DATE NOT NULL,
	CrimeBlock VARCHAR(40) NOT NULL,
	IUCR VARCHAR(4) NOT NULL,
	LocDescription VARCHAR(60),
	Arrest INTEGER NOT NULL,
	Domestic INTEGER NOT NULL,
	Beat INTEGER NOT NULL,
	District INTEGER,
	Ward INTEGER,
	CommunityArea INTEGER,
	NIBRS VARCHAR(3) NOT NULL,
	XCoord REAL,
	YCoord REAL,
	UpdatedOn DATE NOT NULL,
	Latitude REAL,
	Longitude REAL,
	PRIMARY KEY(ID),
	FOREIGN KEY(IUCR) REFERENCES IUCRCrimes(IUCR),
	FOREIGN KEY(NIBRS) REFERENCES NIBRSCrimes(NIBRS),
	FOREIGN KEY(CommunityArea) REFERENCES CommunityAreas(ID),
	CONSTRAINT check_Beat CHECK (Beat >= 111 AND Beat <= 2535),
	CONSTRAINT check_District CHECK (District >= 1 AND District <= 31),
	CONSTRAINT check_Ward CHECK (Ward >= 1 AND Ward <= 50),
	CONSTRAINT check_Arrest_Boolean CHECK (Arrest = 0 OR Arrest = 1),
	CONSTRAINT check_Domestic_Boolean CHECK (Domestic = 0 OR Domestic = 1)
);

