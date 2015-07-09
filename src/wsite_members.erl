-module(wsite_members).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).

members()->
	{
		[
			{
				author,
				[<<"e">>, <<"n">>, <<"a">>]
			}
		]
	}.


init(_, Req, _Opts)->
	Req2 = cowboy_req:reply(200,
		[{<<"content-type">>, <<"text/plain">>}],
		jiffy:encode(members()),
		Req
	),
	{ok, Req2, #state{}}.

handle(Req, State=#state{}) ->
	{ok, Req2} = cowboy_req:reply(200, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.
