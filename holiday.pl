offer(porto) :- location_type(seaside),
                location_type(city),
                trip_time(summer);
                trip_time(autumn).

offer(london) :- location_type(city),
                  trip_time(spring);
                  trip_time(summer);
                  trip_time(autumn);
                  trip_time(winter).

location_type(Q) :-
        format("Is a ~w your perfect holiday destination?\n", [Q]),
        read(yes).

trip_time(Q) :-
        format("Do you wish to travel in ~w?\n", [Q]),
        read(yes).

find :- offer(X), !,
        format('~nThink out of our trip to ~w', X),
        nl.
