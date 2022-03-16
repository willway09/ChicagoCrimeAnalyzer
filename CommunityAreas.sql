CREATE TABLE CommunityAreas (
    ID INTEGER NOT NULL,
    Name VARCHAR(25) NOT NULL,
    PRIMARY KEY(ID),
    CONSTRAINT check_CommunityArea CHECK (ID >= 1 AND ID <= 77)
);
SELECT * FROM CommunityAreas;