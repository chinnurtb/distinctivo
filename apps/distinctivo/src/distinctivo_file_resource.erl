-module(distinctivo_file_resource).
-compile(export_all).

-include_lib("webmachine/include/webmachine.hrl").

-record(state, {
         }).

init([]) -> {ok, #state{}}.

resource_exists(ReqData, State) ->
  Filename = filepath(string:join(wrq:path_tokens(ReqData),"/")),
  {filelib:is_regular(Filename), ReqData, State}.

to_html(ReqData, State) ->
    Filename = filepath(string:join(wrq:path_tokens(ReqData),"/")),
    case file:read_file(Filename) of
        {ok, Binary} ->
            case mimetypes:filename(Filename) of
                Exts when is_list(Exts) ->
                    ContentType = hd(Exts);
                ContentType ->
                    ok
            end,
            Str = binary_to_list(Binary),
            {Str, wrq:set_resp_header("Content-Type", binary_to_list(ContentType), ReqData), State};
        {error, _} ->
            {"Not found or error", ReqData, State}
    end.

%% private
filepath([]) ->
    filepath("index.html");
filepath(RawPath) ->
    filename:join([priv_dir(), RawPath]).

priv_dir() ->
    {ok, Path} = application:get_env(distinctivo, ui_path),
    Path.
