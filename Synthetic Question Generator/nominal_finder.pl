% Query: generate_questions('adüye n_605 numaralý otobüs gitmektedir', Q).

:-include('tokenizer.pl').
:-include('morphologicalAnalyzer.pl').

generate_questions(String, Q_String) :-
    find_units(String, List_of_Lists),
    (
      length(List_of_Lists, N),
      synonyms(N, List_of_Lists, SynList),
      generate_questions1(SynList, Q_List)
      ;
      generate_questions1(List_of_Lists, Q_List)
    ),
    permutation(Q_List, P_List),
    lists_to_string(P_List, Q_String).
    % lists_to_string(Q_List, Q_String).

synonyms(N, List, SList) :-
    N > 0 ->
    S is N - 1,
    get_member(List, [ListMember]),
    length(ListMember, NList),
    ( NList > 1 ->
      get_member(ListMember, [List1]),
      find_synonym([List1], SynList),
      get_member(SynList, [Syn]),
      replace(List1, Syn, ListMember, SList1)
      ;
      find_synonym(ListMember, SynList),
      get_member(SynList, SList1)
    ),
    replace(ListMember, SList1, List, RepList),
    synonyms(S, RepList, SList).
synonyms(0, List, List).

get_member([Member|_], [Member]).
get_member([_|RestList], Member) :- get_member(RestList, Member).

replace(_, _, [], []).
replace(O, R, [O|T], [R|T2]) :- replace(O, R, T, T2).
replace(O, R, [H|T], [H|T2]) :- dif(H, O), replace(O, R, T, T2).

lists_to_string([],'').
lists_to_string([List|Lists],String) :-
    list_to_string(List,String1),
    lists_to_string(Lists, String2),
    concat(String1, '', String11),
    concat(String11,String2,String).

list_to_string([],'').
list_to_string([W|Ws],String) :-
    list_to_string(Ws,String1),
    concat(W, ' ', W1),
    concat(W1, String1, String).

generate_questions1([List|Rest], [[Q]|Rest]) :-
    reverse(List,[W|_]),

    analyze(W,L),
    reverse(L,[Last|_]),
    allomorph(Last,L1),

    ( word(v1, [W]) -> find_Q1(L1, Q) ; find_Q(L1, Q) ).

generate_questions1([List|Rest], [[Q|Ws]|Rest]) :-
    List = [A|Ws],
    Ws = [A1|_],
    word(a, [A]),
    word(a, [A1]),
    Q = kaç.

generate_questions1([List|Rest], [[Q|Ws]|Rest]) :-
    List = [_|[A|Ws]],
    word(a, [A]),
    Q = hangi.

generate_questions1([List|RestIN], [List|RestOUT]) :-
    generate_questions1(RestIN, RestOUT).

find_Q(dat, neye).
find_Q(dat, nereye).

find_Q(noun, ne).
find_Q(noun, hangisi).

find_Q1(tAor, 'gidiyor mu').
find_Q1(tAor, 'gider mi').
find_Q1(tAor, 'gidecek mi').

find_units(String,List_of_Lists) :-
    tokenize(String, List_of_Words),
    find_units(List_of_Words,[],List_of_Lists).

find_units([],[],[]).
find_units([W|Ws],SubList,[List|List_of_Lists]) :-
    (word(n, [W]); word(v, [W]); word(v1, [W])),
    append(SubList, [W], List),
    find_units(Ws,[],List_of_Lists).
find_units([W|Ws],SubList,List_of_Lists) :-
    not(word(n, [W])), not(word(v, [W])), not(word(v1, [W])),
    append(SubList, [W], List),
    find_units(Ws,List,List_of_Lists).

word(n, [adüye]).
word(n, [aydına]).
word(n, [meydanına]).
word(n, [garına]).
word(n, [foruma]).
word(n, [otogara]).
word(n, [karpuzluya]).
word(n, [koçarlıya]).
word(n, [incirliovaya]).
word(n, [sökeye]).
word(n, [kuşadasına]).
word(n, [adaya]).
word(n, [köşke]).
word(n, [germenciğe]).
word(n, [efelere]).
word(n, [bozdoğana]).
word(n, [çineye]).
word(n, [pazara]).
word(n, [nazilliye]).
word(n, [hisara]).
word(n, [kuyucağa]).
word(n, [karacasuya]).

word(a, [forum]).
word(a, [zafer]).
word(a, [tren]).
word(a, [yeni]).
word(a, [sultan]).

word(a, [n_605]).
word(a, [n_606]).
word(a, [n_607]).
word(a, [n_608]).

word(a, [numaralı]).

word(n, [otobüs]).

word(v1, [gitmektedir]).
