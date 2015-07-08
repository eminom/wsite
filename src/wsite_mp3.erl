-module(wsite_mp3).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).


init(_, Req, Opts)->
	{ok, Stream} = file:read_file("lib/wsite-0.1.0/src/res/SEED.mp3"),
	Req2 = cowboy_req:reply(200,
		[{<<"content-type">>, <<"audio/mp3">>}],
		Stream,
		Req),
	{ok, Req2, Opts}.

handle(Req, State=#state{}) ->
	{ok, Req2} = cowboy_req:reply(200, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.
