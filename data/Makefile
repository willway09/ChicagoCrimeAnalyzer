queries: NIBRS IUCR communityareas borders crimes
	./NIBRS
	./IUCR
	./communityareas
	./borders
	./crimes

NIBRS: NIBRS.go general.go
	go build NIBRS.go general.go

IUCR: IUCR.go general.go
	go build IUCR.go general.go

communityareas: communityareas.go general.go
	go build communityareas.go general.go

borders: borders.go general.go
	go build borders.go general.go

crimes: crimes.go general.go
	go build crimes.go general.go

clean:
	@-rm NIBRS NIBRS.sql
	@-rm IUCR IUCR.sql
	@-rm borders borders.sql
	@-rm communityareas communityareas.sql communityareapopulations.sql
	@-rm crimes crimes.sql locations.sql
