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
             CRIMEBLOCK FILLER,
             IUCR CHAR(4),
             LOCATION,
             ARREST,
             DOMESTIC,
             BEAT FILLER,
             DISTRICT FILLER,
             WARD FILLER,
             COMMUNITYAREA,
             NIBRS CHAR(3),
             XCOORD FILLER,
             YCOORD FILLER,
             UPDATEDON FILLER,
             LATITUDE,
             LONGITUDE
           )
