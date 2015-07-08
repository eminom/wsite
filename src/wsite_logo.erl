-module(wsite_logo).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).

%init(_, Req, _Opts) ->
%	{ok, Req, #state{}}.

init(_, Req, Opts) ->
  {ok, BinaryContent} = file:read_file("lib/wsite-0.1.0/src/res/FUNS.png"),
	Req2 = cowboy_req:reply(200,
    [{<<"content-type">>, <<"image/png">>}],
		BinaryContent,
		Req),
	{ok, Req2, Opts}.

handle(Req, State=#state{}) ->
	{ok, Req2} = cowboy_req:reply(200, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.
