
-module(wsite_list).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).

-define(FixPrePath, "/lib/wsite-0.1.0/priv/static/assets").

%init(_, Req, _Opts) ->
%	{ok, Req, #state{}}.

init(_, Req, _Opts)->
	{ok, Cwd} = file:get_cwd(),
	Path = Cwd ++ ?FixPrePath,
	BinaryContent = walker:retrieve_page(Path),
	Req2 = cowboy_req:reply(200,
		[{<<"content-type">>, <<"text/html">>}],
		BinaryContent,
		Req
	),
	{ok, Req2, #state{}}.

handle(Req, State=#state{}) ->
	{ok, Req2} = cowboy_req:reply(200, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.
