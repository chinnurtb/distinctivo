all: rel

compile:
	@./rebar compile

rel: compile
	@rm -rf release
	@./rebar generate
