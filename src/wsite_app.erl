-module(wsite_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatcher = cowboy_router:compile(

		[ %Host starts.
			{'_', [
					{"/", wsite_handler,[]},
					{"/logo", wsite_logo, []},
					{"/audio", wsite_mp3,[]}
				]
			} 
		] %Host ends.
	),
	{ok, _} = cowboy:start_http(
		my_http_listener, 
		100, [{port, 8083}],
		[{env, [{dispatch, Dispatcher}]}]
	),
	wsite_sup:start_link().

stop(_State) ->
	ok.
