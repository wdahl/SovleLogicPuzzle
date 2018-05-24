%Creates possable views for videos
views(four_million).
views(five_million).
views(six_million).
views(seven_million).

%Creates possibale times for videos
times_(fifteen_seconds).
times_(thirty-one_seconds).
times_(thirty-eight_seconds).
times_(fifty-five_seconds).

%Possible titles for videos
titles(baby_eats_cake).
titles(dancing_hyena).
titles(happy_hermits).
titles(magnet_mayhem).

%Solves the logic puzzle
solve :-
	%Varibales for views
	views(Bills_views),
	views(Carl_views),
	views(Inez_views),
	views(Stacy_views),
	all_different([Bills_views, Carl_views, Inez_views, Stacy_views]),

	%Variables for times
	times_(Bills_time),
	times_(Carl_time),
	times_(Inez_time),
	times_(Stacy_time),
	all_different([Bills_time, Carl_time, Inez_time, Stacy_time]),
	
	%Variables for titles
	titles(Bills_title),
	titles(Carl_title),
	titles(Inez_title),
	titles(Stacy_title),
	all_different([Bills_title, Carl_title, Inez_title, Stacy_title]),

	%2d list for which varibales go with which author
	Triples = [[bill, Bills_views, Bills_time, Bills_title], [carl, Carl_views, Carl_time, Carl_title], [inez, Inez_views, Inez_time, Inez_title], [stacy, Stacy_views, Stacy_time, Stacy_title]],

	%Rules gathered from the hints given

	%1.
	(member([_, six_million, _, happy_hermits], Triples); member([_, six_million, fifteen_seconds, _], Triples)),
	not(member([_, _, fifteen_seconds, happy_hermits], Triples)),

	%2.
	(member([_, seven_million, _, magnet_mayhem], Triples); member([_, _, thirty-one_seconds, magnet_mayhem], Triples)),
	not(member([_, seven_million, thirty-one_seconds, _], Triples)),

	%3.
	member([stacy, _, fifteen_seconds, _], Triples),

	%4.
	not(member([_, _, thirty-eight_seconds, baby_eats_cake], Triples)),

	%5.
	((member([carl, six_million, _, _], Triples), member([_, four_million, _, dancing_hyena], Triples)); 
		(member([carl, seven_million, _, _], Triples), member([_, five_million, _, dancing_hyena], Triples))),
	not((member([carl, four_million, _, _], Triples); member([carl, five_million, _, _], Triples))),

	not((member([_, six_million, _, dancing_hyena], Triples); member([_, seven_million, _, dancing_hyena], Triples))),

	not(member([carl, _, _, dancing_hyena], Triples)),

	%6.
	member([bill, four_million, _, _], Triples),

	%7.
	not((member([inez, _, _, happy_hermits], Triples); member([inez, _, thirty-one_seconds, _], Triples))),
	not(member([_, _, thirty-one_seconds, happy_hermits], Triples)),

	%8.
	not(member([carl, _, fifteen_seconds, _], Triples)),
	not(member([_, six_million, _, magnet_mayhem], Triples)),
	(member([_, six_million, fifteen_seconds, _], Triples); member([_, _, fifteen_seconds, magnet_mayhem], Triples)),
	(member([carl, six_million, _, _], Triples); member([carl, _, _, magnet_mayhem], Triples)),

	%Passes values into tell method for printing
	tell(bill, Bills_views, Bills_time, Bills_title),
	tell(carl, Carl_views, Carl_time, Carl_title),
	tell(inez, Inez_views, Inez_time, Inez_title),
	tell(stacy, Stacy_views, Stacy_time, Stacy_title).

%makes sure that all entries in the list are diffrent
all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

%formats the way the output is printed
tell(W, X, Y, Z) :-
    write(W), write('\'s video got '), write(X), write(' views and was '),
    write(Y), write(' long and was called '), write(Z), write('.'), nl.