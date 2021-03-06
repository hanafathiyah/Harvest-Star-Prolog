/* inventory(jenis,jumlah) */

/* Dynamic Variable */
:- dynamic(inventory/2).
:- dynamic(inventory_seed/2).
:- dynamic(capacity_inventory/1).
:- dynamic(inventoryRanching/2).
:- dynamic(inventoryHasil/2).

/*
Hasil Farming
inventory(carrot,10).
inventory(potato,10).
inventory(wheat,10).
inventory(paddy,10).
inventory(cassava,10).
inventory(corn,10).
Hasil Fishing 
inventory(goldfish,10).
inventory(catfish,10).
inventory(gurame,10).
inventory(tilapia,10).
inventory(parrotfish,10).
Hasil Ranching 
inventoryHasil(eggs, 1).
inventoryHasil(milk, 2).
inventoryHasil(wool, 0).
inventoryHasil(chicken, 0).
inventoryHasil(beef, 0).
*/



/* Inventory operators */

add_to_inventory(X) :-
    add_N_to_inventory(1,X).

add_N_to_inventory(N,X) :-
    (inventory(X,Y) ->
    Y1 is Y+N,
    retractall(inventory(X,Y)),
    asserta(inventory(X,Y1));
    asserta(inventory(X,N))
    ).

substract_N_to_inventory(N,X) :-
    (inventory(X,Y) ->
    Y1 is Y-N,
    retractall(inventory(X,Y)),
    asserta(inventory(X,Y1));
    asserta(inventory(X,N))
    ).

delete_zero_inventory :-
    retractall(inventory(_,0)).

/* Inventory seed operators */

add_to_inventory_seed(X) :-
    add_N_to_inventory_seed(1,X).

add_N_to_inventory_seed(N,X) :-
    (inventory_seed(X,Y) ->
    Y1 is Y+N,
    retractall(inventory_seed(X,Y)),
    asserta(inventory_seed(X,Y1));
    asserta(inventory_seed(X,N))
    ).

delete_zero_inventory_seed:-
    retractall(inventory_seed(_,0)).

substract_N_to_inventory_seed(N,X) :-
    (inventory_seed(X,Y) ->
    Y1 is Y-N,
    retractall(inventory_seed(X,Y)),
    asserta(inventory_seed(X,Y1));
    asserta(inventory_seed(X,N))
    ).

/* Inventory ranching operators */

add_N_to_inventory_ranching(N,X) :-
    (inventoryRanching(X,Y) ->
    Y1 is Y+N,
    retractall(inventoryRanching(X,Y)),
    asserta(inventoryRanching(X,Y1));
    asserta(inventoryRanching(X,N))
    ).

substract_N_to_inventory_ranching(N,X) :-
    (inventoryRanching(X,Y) ->
    Y1 is Y-N,
    retractall(inventoryRanching(X,Y)),
    asserta(inventoryRanching(X,Y1));
    asserta(inventoryRanching(X,N))
    ).

delete_zero_inventory_ranching :-
    retractall(inventoryRanching(_,0)).

/* Inventory hasil operators */

add_N_to_inventory_hasil(N,X) :-
    (inventoryHasil(X,Y) ->
    Y1 is Y+N,
    retractall(inventoryHasil(X,Y)),
    asserta(inventoryHasil(X,Y1));
    asserta(inventoryHasil(X,N))
    ).

substract_N_to_inventory_hasil(N,X) :-
    (inventoryHasil(X,Y) ->
    Y1 is Y-N,
    retractall(inventoryHasil(X,Y)),
    asserta(inventoryHasil(X,Y1));
    asserta(inventoryHasil(X,N))
    ).

delete_zero_inventory_hasil :-
    retractall(inventoryHasil(_,0)).

/* display */

displayInventory :-
    forall(inventory(X,Y),(writeInventory(X,Y),nl)).

displayInventorySeed :-
    forall(inventory_seed(X,Y),(writeInventory(X,Y), write(' seed'),nl)).

displayInventoryRanching :-
    forall(inventoryRanching(X,Y),(writeInventory(X,Y),nl)).

displayInventoryHasil :-
    forall(inventoryHasil(X,Y),(writeInventory(X,Y),nl)).

writeInventory(X,Y) :-
    write(Y),
    write(' '),
    write(X).

showInventory :-
    game_opened(_), game_started(_),
    nl,
    write('Your inventory ('),
    capacity_inventory(X),
    write(X),
    write('/100)\n'),
    displayEquipment,
    displayInventory,
    displayInventoryHasil,
    total_seed_item(NSeed),
    write(NSeed),
    write(' Seed'),
    write('\n'),!.

throwItem :-
    game_opened(_), game_started(_),
    showInventory,
    write('What do you want to throw?\n> '),
    read(Item),
    (equipment(Item,_,_) ->
        retractall(equipment(Item,_,_)),
        write('You threw away 1 '),
        write(Item),
        nl
    ;
    inventory(Item,X) ->
        write('You have '),
        write(X),
        write(' '),
        write(Item),
        write('How many do you want to throw?\n> '),
        read(Y),
        (Y > X ->
            write('You don\'t have enough '), write(Item), write('. Cancelling...'), nl, !;
            substract_N_to_inventory(Y,Item),
            Q is -Y,
            change_capacity_inventory(Q),
            write('You threw away '),
            write(Y),
            write(' '),
            write(Item),
            nl,
            delete_zero_inventory
        )
    ;
    inventoryHasil(Item,X) ->
        write('You have '),
        write(X),
        write(' '),
        write(Item),
        write(' How many do you want to throw?\n> '),
        read(Y),
        (Y > X ->
            write('You don\'t have enough '), write(Item), write('. Cancelling...'), nl, !;
            substract_N_to_inventory_hasil(Y,Item),
            Q is -Y,
            change_capacity_inventory(Q),
            write('You threw away '),
            write(Y),
            write(' '),
            write(Item),
            nl,
            delete_zero_inventory_hasil
        )
    ;
    Item == seed ->
        write('You have\n'),
        displayInventorySeed,
        write('What seed do you want to throw?\n> '),
        read(Seed),
        inventory_seed(Seed,X),
        write('You have '),
        write(X),
        write(' '),
        write(Seed),
        write(' How many do you want to throw?\n> '),
        read(Y),
        (Y > X ->
            write('You don\'t have enough '), write(Seed), write('. Cancelling...'), nl, !;
            substract_N_to_inventory_seed(Y,Seed),
            Q is -Y,
            change_capacity_inventory(Q),
            write('You threw away '),
            write(Y),
            write(' '),
            write(Seed),
            nl,
            delete_zero_inventory_seed
        )
    ),
    !.
