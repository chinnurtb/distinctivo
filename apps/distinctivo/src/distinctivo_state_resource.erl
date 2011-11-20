-module(distinctivo_state_resource).
-compile(export_all).

-include_lib("webmachine/include/webmachine.hrl").

-record(state, {
         }).

init([]) -> {ok, #state{}}.

content_types_provided(ReqData, State) ->
    {[{"application/json", to_json}], ReqData, State}.


to_json(ReqData, State) ->
    ScoreTable = distinctivo_score:table(),
    ScoreTableJSON = [ [transform_key(K), transform_score(V)] || {K,V} <- ScoreTable ],
    Response = jsx:term_to_json(ScoreTableJSON),
    {Response, ReqData, State}.

%% internal

transform_key({distinctivo_callcenter, Id}) ->
    {<<"object">>, iolist_to_binary(io_lib:format("Call center agent ~p",[Id]))}.
transform_score(I) ->
    {<<"description">>, iolist_to_binary(io_lib:format("Score: ~p",[I]))}.
