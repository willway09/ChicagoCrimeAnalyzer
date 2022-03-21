load data 
infile '../datasources/CrimesTransformed.csv' "str '\n'"
append
into table CRIMES
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( ID,
             CASENUMBER CHAR(10),
             CRIMEDATE TIMESTAMP "mm/dd/yyyy hh12:mi:ss AM",
             CRIMEBLOCK CHAR(40),
             IUCR CHAR(4),
             LOCDESCRIPTION CHAR(60),
             ARREST,
             DOMESTIC,
             BEAT,
             DISTRICT,
             WARD,
             COMMUNITYAREA,
             NIBRS CHAR(3),
             XCOORD,
             YCOORD,
             UPDATEDON TIMESTAMP "mm/dd/yyyy hh12:mi:ss AM",
             LATITUDE,
             LONGITUDE
           )
