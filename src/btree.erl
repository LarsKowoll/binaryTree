%% @author larsk
%% @doc @todo Add description to btree.
%% Der Baum ist wie folgt aufgebaut: {<Element>, <Hoehe>, <linker Teilbaum>, <rechter Teilbaum>}

-module(btree).

%% ====================================================================
%% API functions
%% ====================================================================

-export([initBT/0, isEmptyBT/1, equalBT/2, insertBT/2, deleteBT/2, findBT/2, inOrderBT/1]).

%% ====================================================================
%% Internal functions
%% ====================================================================

initBT() ->
	{}.

%% ====================================================================

isEmptyBT({}) ->
	true;

isEmptyBT({_, _, _, _}) ->
	false.

%% ====================================================================

equalBT({}, {}) ->
	true;

equalBT(_, {}) ->
	false;

equalBT({}, _) ->
	false;

equalBT(ErsterBaum, ZweiterBaum) ->
	inOrderBT(ErsterBaum) == inOrderBT(ZweiterBaum).

%% ====================================================================

insertBT({}, NeuesElement) ->
	{NeuesElement, 1, {}, {}};

%linke Baumseite
insertBT({AktuellesElement, _, LinkerTeilbaum, RechterTeilbaum}, NeuesElement) when AktuellesElement > NeuesElement -> 
	NeuerTeilbaum = insertBT(LinkerTeilbaum, NeuesElement),
	NeueHoehe = calculateHeight(NeuerTeilbaum, RechterTeilbaum),
	{AktuellesElement, NeueHoehe, NeuerTeilbaum, RechterTeilbaum};

%rechte Baumseite
insertBT({AktuellesElement, _, LinkerTeilbaum, RechterTeilbaum}, NeuesElement) when AktuellesElement < NeuesElement -> 
	NeuerTeilbaum = insertBT(RechterTeilbaum, NeuesElement),
	NeueHoehe = calculateHeight(LinkerTeilbaum, NeuerTeilbaum),
	{AktuellesElement, NeueHoehe, LinkerTeilbaum, NeuerTeilbaum}.

%% ====================================================================

deleteBT({AktuellesElement, _, {}, {}}, EntfernenElement) when AktuellesElement == EntfernenElement ->
	{};

deleteBT({AktuellerKnoten, _, LinkerTeilbaum, {}}, EntfernenElement) when AktuellerKnoten == EntfernenElement ->
	LinkerTeilbaum;

deleteBT({AktuellerKnoten, _, {}, RechterTeilbaum}, EntfernenElement) when AktuellerKnoten == EntfernenElement ->
	RechterTeilbaum;

deleteBT({AktuellesElement, _, LinkerTeilbaum, RechterTeilbaum}, EntfernenElement) when AktuellesElement == EntfernenElement -> 
	KleinstesElement = findSmallest(LinkerTeilbaum),
	TeilbaumOhneKleinstesElement = deleteBT(LinkerTeilbaum, KleinstesElement),
	NeueHoehe = calculateHeight(TeilbaumOhneKleinstesElement, RechterTeilbaum),
	{KleinstesElement, NeueHoehe, TeilbaumOhneKleinstesElement, RechterTeilbaum};

%linke Baumseite
deleteBT({AktuellesElement, _, LinkerTeilbaum, RechterTeilbaum}, EntfernenElement) when AktuellesElement > EntfernenElement -> 
	NeuerTeilbaum = deleteBT(LinkerTeilbaum, EntfernenElement),
	NeueHoehe = calculateHeight(NeuerTeilbaum, RechterTeilbaum),
	{AktuellesElement, NeueHoehe, NeuerTeilbaum, RechterTeilbaum};

%rechte Baumseite
deleteBT({AktuellesElement, _, LinkerTeilbaum, RechterTeilbaum}, EntfernenElement) when AktuellesElement < EntfernenElement -> 
	NeuerTeilbaum = deleteBT(RechterTeilbaum, EntfernenElement),
	NeueHoehe = calculateHeight(LinkerTeilbaum, NeuerTeilbaum),
	{AktuellesElement, NeueHoehe, LinkerTeilbaum, NeuerTeilbaum}.

%% ====================================================================

findBT({}, _) ->
	0;

findBT({AktuellesElement, Hoehe, _, _}, NeuesElement) when AktuellesElement == NeuesElement ->
	Hoehe;

findBT({AktuellesElement, _, LinkerTeilbaum, _}, NeuesElement) when AktuellesElement > NeuesElement ->
	findBT(LinkerTeilbaum, NeuesElement);

findBT({AktuellesElement, _, _, RechterTeilbaum}, NeuesElement) when AktuellesElement < NeuesElement ->
	findBT(RechterTeilbaum, NeuesElement).

%% ====================================================================

% Idee von https://stackoverflow.com/questions/47382273/sort-elements-in-list-erlang
inOrderBT({}) ->
	[];

inOrderBT({Element, _, {}, RechterTeilbaum}) ->
    [Element] ++ inOrderBT(RechterTeilbaum);

inOrderBT({Element, _, LinkerTeilbaum, {}}) ->
    inOrderBT(LinkerTeilbaum) ++ [Element];

inOrderBT({Element, _, LinkerTeilbaum, RechterTeilbaum}) ->
    inOrderBT(LinkerTeilbaum) ++ [Element] ++ inOrderBT(RechterTeilbaum).

%% ====================================================================

findSmallest({Element, _, {}, {}}) ->
	Element;

findSmallest({Element, _, _, {}}) ->
	Element;

findSmallest({_, _, _, RechterTeilbaum}) ->
	findSmallest(RechterTeilbaum).

%% ====================================================================

calculateHeight({}) ->
	0;

calculateHeight({_, _, LinkerTeilbaum, RechterTeilbaum}) ->
    maxBT(calculateHeight(LinkerTeilbaum), calculateHeight(RechterTeilbaum)) + 1.
    
calculateHeight(LinkerTeilbaum, RechterTeilbaum) ->
    maxBT(calculateHeight(LinkerTeilbaum), calculateHeight(RechterTeilbaum)) + 1.

%% ====================================================================

maxBT(A, B) when A > B ->
	A;

maxBT(_, B) ->
	B.



	











