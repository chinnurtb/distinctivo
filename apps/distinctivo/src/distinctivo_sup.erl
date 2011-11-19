-module(distinctivo_sup).

-include_lib("esupervisor/include/esupervisor.hrl").
-behaviour(esupervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    esupervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    #one_for_one{
      children = [
                  #worker{
                     id = distinctivo_dispatch,
                     restart = permanent
                    }
                 ]
     }.

