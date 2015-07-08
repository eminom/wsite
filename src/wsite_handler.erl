
%% This file is generated by make new t=cowboy_http n=wsite_handler

-module(wsite_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).

%init(_, Req, _Opts) ->
%	{ok, Req, #state{}}.

init(_, Req, Opts)->
	Req2 = cowboy_req:reply(
		200,
		[{<<"content-type">>, <<"text/plain">>}],
		<<"Hello, wsite 8083!">>,
		Req
	),	
	{ok, Req2, Opts).

handle(Req, State=#state{}) ->
	{ok, Req2} = cowboy_req:reply(200, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.
