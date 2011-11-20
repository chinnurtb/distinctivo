-module(distinctivo_dispatch).
 
-behaviour(gen_server).

%% API
-export([start_link/0, routes/0]).

%% Internal
-export([route_table/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-include_lib("esupervisor/include/esupervisor.hrl").

-record(state, {
          http_port,
          ssl,
          ssl_opts,
          routes = [],
          webmachine
         }).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

routes() ->
    gen_server:call(?SERVER, routes).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    Routes = ?MODULE:route_table(),
    {ok, HttpPort} = application:get_env(distinctivo, http_port),
    Ssl = case application:get_env(htapi, ssl) of
        undefined ->
            false;
        {ok, Val} ->
            Val
    end,
    SslOpts = case application:get_env(htapi, ssl_opts) of
        undefined ->
            [];
        {ok, Opts} ->
            Opts
    end,
    gen_server:cast(self(), init),
    {ok, #state{ routes = Routes, http_port = HttpPort,
                 ssl = Ssl, ssl_opts = SslOpts }}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(routes, _From, #state{ routes = Routes } = State) ->
    {reply, Routes, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast(init, #state{ http_port = HttpPort, routes = Routes,
                          ssl = Ssl, ssl_opts = SslOpts } = State) ->
    WebConfig = [
                 {ip, "0.0.0.0"},
                 {port, HttpPort},
                 {ssl, Ssl},
                 {ssl_opts, SslOpts},
                 {dispatch, Routes}],
    {ok, Pid} = webmachine_mochiweb:start(WebConfig),
    link(Pid),
    {noreply, State#state{ webmachine = Pid }}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, #state{ webmachine = Pid } = State, _Extra) ->
    {ok, HttpPort} = application:get_env(distinctivo, http_port),
    Routes = ?MODULE:route_table(),

    unlink(Pid),
    exit(Pid, normal),

    gen_server:cast(self(), init),
    
    {ok, State#state{ routes = Routes, http_port = HttpPort } }.

%%%===================================================================
%%% Internal functions
%%%===================================================================
route_table() ->
    [
     {["event"], distinctivo_event_resource, []},
     {['*'], distinctivo_file_resource, []}
    ].
