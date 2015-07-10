

%%%%%% MIT LICENSE %%%%%% YES %%%%%%%%%%%%%
%%%%%%%%%%%The module is added by somehow. I don't know$$$%%%%

-module(walker).
-behaviour(gen_server).
-vsn(1001).
-author({eminom}).

%% API.
-export([start_link/0, retrieve_page/1, retrieve_page2/1]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-record(state, {
}).

-include_lib("kernel/include/file.hrl").
-define(AssetsPrefix, "assets/").
-define(DefaultHtml,  "index.html").

-record(list_state, {
	binary = <<>>,
	prepath = ""
}).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%-spec retrieve_page() -> {ok, binary()}.
retrieve_page(Path) ->
	{ok, BinaryContent} = gen_server:call(?MODULE, {retrieve_page, Path}),
	BinaryContent.

%-spec retrieve_page2() -> {ok, binary()}.
retrieve_page2(Path) ->
	{ok, BinaryContent} = gen_server:call(?MODULE, {retrieve_page2, Path}),
	BinaryContent.

%% gen_server.

init([]) ->
	{ok, #state{}}.

handle_call({retrieve_page, Path}, _From, State)->
	#list_state{binary=Binary} = retrieve(Path),
	{reply, {ok, Binary}, State};

handle_call({retrieve_page2, Path}, _From, State)->
	#list_state{binary=Binary} = retrieve2(Path),
	{reply, {ok, Binary}, State};

handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%% Module implementations here %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

if_directory(Full)->
	{ok, #file_info{type=Type}} = file:read_file_info(Full),
	Type == directory.

%start()->
%	{ok, Cwd} = file:get_cwd(),
%	list(Cwd, fun print/3, {}).

%start()->
%	#list_state{binary=Binary} = retrieve(),
%	file:write_file(?DefaultHtml, Binary).

%retrieve()->
%	{ok, Cwd} = file:get_cwd(),
%	retrieve(Cwd).

%start(Path)->
%	#list_state{binary=Binary} = retrieve(Path),
%	file:write_file(?DefaultHtml, Binary).

retrieve(Cd)->
	list(Cd, fun printer/3, #list_state{prepath=Cd}).

retrieve2(Cd)->
	list(Cd, fun page_printer/3, #list_state{prepath=Cd}).

list(Cd, Processor, State)->
	case if_directory(Cd) of
		true->
			list_go(Cd, Processor, State);
		false->
			State
	end.

list_go(Cd, Processor, State)->
	{ok, List} = file:list_dir(Cd),
	NewState = Processor(Cd, List, State),
	list_sub(Cd, List, Processor, NewState).

list_sub(Cd, [H|T], Processor, State)->
	NewState = list(Cd++"/"++H,  Processor, State),
	list_sub(Cd, T, Processor, NewState);

list_sub(_Cd, [], _Processor, State)->
	State.

read_type(Full)->
	{ok, #file_info{type=Type}} = file:read_file_info(Full),
	atom_to_list(Type).
	
%print(Cd, [H|T], State)->
%	Full = Cd ++"/" ++ H,
%	Type = read_type(Full),
%	io:format("<~p> : ~p~n", [H, Type]),
%	print(Cd, T, State);
%print(_Cd, [], State)->
%	State.
		
printer(Cd, [H|T], State=#list_state{prepath=PrePath, binary=Binary})->
	Full = Cd ++ "/" ++ H,
	Type = read_type(Full),
	case Type of
		"directory"->
			printer(Cd, T, State);
		_ ->
			Rest = lists:nthtail(length(PrePath) + 1, Full), %+1 skips slash
			Fmt = "<a href=\"" ++ ?AssetsPrefix ++ "~s\">~s</a><br/>~n",
			NewListRaw = <<Binary/binary, 
				(list_to_binary(io_lib:format(Fmt, [Rest, Rest])))/binary>>,
			printer(Cd, T, State#list_state{binary=NewListRaw})
	end;

printer(_Cd, [], State)->
	State.

page_printer(Cd, [H|T]
		,State=#list_state{prepath=PrePath, binary=Binary}) ->
	Full = Cd ++ "/" ++ H,
	Type = read_type(Full),
	case Type of 
		"directory"->
			page_printer(Cd, T, State);
		_ ->
			Rest = lists:nthtail(length(PrePath)+1, Full),
			Fmt = "<img src=\"" ++ ?AssetsPrefix ++ "~s\"/><br/>~n",
			NewListRaw = <<Binary/binary,
				(list_to_binary(io_lib:format(Fmt, [Rest])))/binary>>,
			page_printer(Cd, T, State#list_state{binary=NewListRaw})
	end;

page_printer(_Cd, [], State)->
	State.
