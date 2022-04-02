CREATE TABLE IUCRCrimes (
    IUCR VARCHAR(4) NOT NULL,
    PrimaryDesc VARCHAR(40) NOT NULL,
    SecondaryDesc VARCHAR(65) NOT NULL,
    IndexCode VARCHAR(1),
    Active INTEGER,
    PRIMARY KEY(IUCR),
    CONSTRAINT check_IUCR CHECK(REGEXP_LIKE(IUCR, '\d{3}([A-Z]|\d)?')),
    CONSTRAINT check_IndexCode CHECK(REGEXP_LIKE(IndexCode, '(I|N)')),
    CONSTRAINT check_Active_Boolean CHECK (Active = 0 OR Active = 1)
);
CREATE TABLE NIBRSCrimes (
    NIBRS VARCHAR(3) NOT NULL,
    Title VARCHAR(30) NOT NULL,
    CrimeAgainst VARCHAR(20) NOT NULL,
    Definition VARCHAR(400) NOT NULL,
    PRIMARY KEY(NIBRS),
    CONSTRAINT check_NIBRS CHECK(REGEXP_LIKE(NIBRS,'\d{2}[A-Z]?'))
);
CREATE TABLE CommunityAreas (
    ID INTEGER NOT NULL,
    Name VARCHAR(25) NOT NULL,
    Area REAL,
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
CREATE TABLE Locations (
    ID INTEGER NOT NULL,
    Description VARCHAR(60) NOT NULL,
    PRIMARY KEY(ID)
);
CREATE TABLE Crimes (
	ID INTEGER NOT NULL,
	CaseNumber VARCHAR(10),
	CrimeDate TIMESTAMP NOT NULL,
	IUCR VARCHAR(4) NOT NULL,
	Location INTEGER,
	Arrest INTEGER NOT NULL,
	Domestic INTEGER NOT NULL,
	CommunityArea INTEGER,
	NIBRS VARCHAR(3) NOT NULL,
	Latitude REAL,
	Longitude REAL,
	PRIMARY KEY(ID),
	CONSTRAINT IUCR FOREIGN KEY (IUCR) REFERENCES IUCRCrimes(IUCR),
	CONSTRAINT NIBRS FOREIGN KEY (NIBRS) REFERENCES NIBRSCrimes(NIBRS),
	CONSTRAINT Location FOREIGN KEY (Location) REFERENCES Locations(ID),
	CONSTRAINT CommunityArea FOREIGN KEY (CommunityArea) REFERENCES CommunityAreas(ID),
	CONSTRAINT check_Arrest_Boolean CHECK (Arrest = 0 OR Arrest = 1),
	CONSTRAINT check_Domestic_Boolean CHECK (Domestic = 0 OR Domestic = 1)
);

