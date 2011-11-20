-module(distinctivo_state_resource).
-compile(export_all).

-include_lib("webmachine/include/webmachine.hrl").

-record(state, {
         }).

init([]) -> {ok, #state{}}.

content_types_provided(ReqData, State) ->
    {[{"application/json", to_json}], ReqData, State}.


to_json(ReqData, State) ->
    Response = jsx:term_to_json([[
                                 {<<"object">>, <<"operator 1">>},
                                 {<<"description">>, <<"score 1">>}
                                ]]),
    {Response, ReqData, State}.
