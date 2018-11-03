:- dynamic(known/3).
:- discontiguous menuask/3.

offer(porto) :- ( location_type(seaside);
                  location_type(city) ),
                ( trip_time(summer);
                  trip_time(autumn) ).

offer(london) :- location_type(city),
                 ( trip_time(spring);
                   trip_time(summer);
                   trip_time(autumn);
                   trip_time(winter) ).

location_type(Q) :- menuask(location_type, Q, [city, seaside]).
trip_time(Q) :- menuask(trip_time, Q, [spring, summer, autumn, winter]).

find :- offer(X), !,
        nl, format('Think out of our trip to ~w', X), nl.

/* Do not ask if it has been already positively answered */
menuask(Key, Val, _) :- known(yes, Key, Val), !.

/* Do not ask if it has been already negatively answered */
menuask(Key, Val, _) :- known(_, Key, Val), !, fail.

/* Do not ask if it has been already answered in a different way */
menuask(Key, Val, _) :- known(yes, Key, OtherVal),  OtherVal\== Val, !, fail.

menuask(Key, Val, List) :-
                            nl, format('Please type your preferred ~w ?', [Key]), nl,
                            write(List), nl,
                            read(Ans),
                            check_val(Ans, Key, Val, List),
                            asserta(known(yes, Key, Ans)),
                            Ans == Val.

/* Check if a picked element is present in the list */
check_val(Ans, _, _, List) :- member(Ans, List), !.

/* If it is not in the list, ask again */
check_val(Ans, Key, Val, List) :-
                            write(Ans), write(' is not a known answer, please try again.'), nl,
                            menuask(Key, Val, List).
