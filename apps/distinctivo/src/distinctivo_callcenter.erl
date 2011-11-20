-module(distinctivo_callcenter).

%% Rules
-export([outbound_call_reward/2, unsatisfied_customer/3]).
-rules([outbound_call_reward, unsatisfied_customer]).

%% API
-export([start/0, from_json/1]).

start() ->
    seresye:start(?MODULE),
    seresye:add_rules(?MODULE, ?MODULE).
%%
%%
%% Events
%%
%% 1. Outbound Call
%% {call, outbound, CustomerId, AgentId, Timestamp}
%% 2. Inbound Call
%% {call, inbound, CustomerId, AgentId, Timestamp}
%% 3. Hangup
%% {hangup, CustomerId, AgentId, Timestamp}
%% 4. Customer Feedback
%% {customer_agent_rating, CustomerId, AgentId, Rating (0-10), Timestamp}
%%

from_json(JSON) ->
    Object = jsx:json_to_term(JSON),
    from_json(proplists:get_value(<<"type">>, Object), Object).

from_json(<<"call">>, Object) ->
    Dir =
    case proplists:get_value(<<"direction">>, Object) of
        <<"outbound">> ->
            outbound;
        <<"inbound">> ->
            inbound
    end,
    {call, Dir, 
     proplists:get_value(<<"customer_id">>, Object),
     proplists:get_value(<<"agent_id">>, Object),
     proplists:get_value(<<"timestamp">>, Object)};
from_json(<<"customer_agent_rating">>, Object) ->
    {customer_agent_rating,
     proplists:get_value(<<"customer_id">>, Object),
     proplists:get_value(<<"agent_id">>, Object),
     proplists:get_value(<<"rating">>, Object),
     proplists:get_value(<<"timestamp">>, Object)}.



%% Rules

%% 1. For every outbound call, you get one point.
outbound_call_reward(Engine, {call, outbound, CustomerId, AgentId, Timestamp}) ->
    change_score(AgentId, 1),
    Engine.

%% 1. For every unsatisfied customer, you get minus 5 points
unsatisfied_customer(Engine, {call, outbound, CustomerId, AgentId, Timestamp0},
                     {customer_agent_rating, CustomerId, AgentId, Rating, Timestamp}) when Rating =< 3 andalso Timestamp0 < Timestamp ->
    change_score(AgentId, -5),
    Engine.

%% Implementation details
change_score(AgentId, By) ->
    distinctivo_score:change({?MODULE, AgentId}, By).
    


