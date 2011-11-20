-module(distinctivo_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    seresye:start(distinctivo_callcenter),
    seresye:add_rules(distinctivo_callcenter, distinctivo_callcenter),
    distinctivo_sup:start_link().

stop(_State) ->
    ok.
