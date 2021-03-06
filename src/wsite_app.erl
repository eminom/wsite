-module(wsite_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatcher = cowboy_router:compile(
		[ %Host starts.
			{'_', [
					{"/", cowboy_static, {priv_file, wsite, "static/index.html"}},
					{"/assets/[...]", cowboy_static, {priv_dir, wsite, "static/assets"}},
					%{"/", wsite_handler,[]},
					{"/logo", wsite_logo, []},
					{"/audio", wsite_mp3,[]},
					{"/members", wsite_members, []},
					{"/path", wsite_path, []},
					{"/list", wsite_list, []},
					{"/image", wsite_image, []},
					{"/longtext", wsite_longtext,[]}
				]
			} 
		] %Host ends.
	),
	{ok, _} = cowboy:start_http(
		my_http_listener, 
		100, [{port, 8083}],
		[{env, [{dispatch, Dispatcher}]}]
	),
	{ok, _} = walker:start_link(),
	wsite_sup:start_link().

stop(_State) ->
	ok.
