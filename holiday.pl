:- dynamic(known/3).
:- discontiguous menuask/3.
:- discontiguous ask/2.

/* ------- Knowledge base ------- */

offer(porto) :- ( location_type(seaside);
                  location_type(city) ),
                ( trip_time(summer);
                  trip_time(autumn) ),
                ( activity_type(wine_tasting);
                  activity_type(swimming) ).

offer(london) :- location_type(city),
                 ( trip_time(spring);
                   trip_time(summer);
                   trip_time(autumn);
                   trip_time(winter) ).

offer(cortina_dAmpezzo) :- location_type(mountains),
                           trip_time(winter).


/* ------- Rules ------- */

/*
   Optional:
   location_type(Q) :- menuask(location_type, Q, [city, seaside]).
*/
location_type(city) :- sightseeing(yes).
location_type(seaside) :- sea(yes).
location_type(mountains) :- mountains(yes),
                            ( activity_type(skiing);
                              activity_type(snowboarding) ).

trip_time(Q) :- menuask(trip_time, Q, [spring, summer, autumn, winter]).

activity_type(skiing) :- trip_time(winter),
                         skiing(yes).

activity_type(snowboarding) :- trip_time(winter),
                               snowboarding(yes).

activity_type(swimming) :- swimming(yes).

activity_type(wine_tasting) :- wine_tasting(yes).

sport(Q) :- ask(sport, Q).
skiing(Q) :- sport(yes), ask(skiing, Q).
snowboarding(Q) :- sport(yes), ask(snowboarding, Q).
swimming(Q) :- sport(yes), ask(swimming, Q).

wine_tasting(Q) :- ask(wine_tasting, Q).
sightseeing(Q) :- ask(sightseeing, Q).

sea(Q) :- ask(sea, Q).
mountains(Q) :- ask(mountains, Q).


/* ------- Asking logic ------- */

/* Do not ask if it has been already positively answered */
ask(Key, Val) :- known(yes, Key, Val), !.
menuask(Key, Val, _) :- known(yes, Key, Val), !.

/* Do not ask if it has been already negatively answered */
ask(Key, Val) :- known(_, Key, Val), !, fail.
menuask(Key, Val, _) :- known(_, Key, Val), !, fail.

/* Do not ask if it has been already answered in a different way */
menuask(Key, Val, _) :- known(yes, Key, OtherVal),  OtherVal\== Val, !, fail.

/* Finally, ask */
ask(Key, Val) :-
                 nl, format('Do you want ~w ?', [Key]), nl,
                 read(Ans),
                 asserta(known(Ans, Key, Val)), Ans == yes.

menuask(Key, Val, List) :-
                            nl, format('Please type your preferred ~w ?', [Key]), nl,
                            write(List), nl,
                            read(Ans),
                            check_val(Ans, Key, Val, List),
                            asserta(known(yes, Key, Ans)),
                            Ans == Val.


/* ------- Processing answers ------- */

/* Check if a picked element is present in the list */
check_val(Ans, _, _, List) :- member(Ans, List), !.

/* If it is not in the list, ask again */
check_val(Ans, Key, Val, List) :-
                            write(Ans), write(' is not a known answer, please try again.'), nl,
                            menuask(Key, Val, List).


/* ------- Executives ------- */

find :- offer(X), !,
        nl, format('Think out of our trip to ~w', X), nl.

clear :- retractall(known(_,_,_)).
