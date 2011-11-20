-module(distinctivo_callcenter).
-export([outbound_call_reward/2]).
-rules([outbound_call_reward]).
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


%% Rules

%% 1. For every outbound call, you get one point.
outbound_call_reward(Engine, {call, outbound, CustomerId, AgentId, Timestamp}) ->
    change_score(AgentId, 1),
    Engine.


%% Implementation details
change_score(AgentId, By) ->
    distinctivo_score:change({?MODULE, AgentId}, By).
    


