#include "fonctionTCP.h"
#include "validation.h"
#include "protocolQuantik.h"


/*
    Structures definition
*/
typedef struct PlayerData {
    struct PlayerData *opponent;
    char name[T_NOM];
    int socket;
    TCoul color;
    int ready;
} PlayerData;


/*
    Global parameters
*/
int debug = 0;
int valid = 1;
int timeout = 1;
int port = -1;


/*
    Game datas
*/
PlayerData players[2];


void printUsage(char* execName) {
    printf("Usage: %s [--noValid|--noTimeout|--debug] no_port\n", execName);
}


int parsingParameters(int argc, char** argv) {
    if (argc < 2) {
        printf("Error: too few parameters\n");
        printUsage(argv[0]);
        return 1;
    }
    for (int i = 1; i < argc - 1; i++) {
        if (strcmp(argv[i], "--noValid") == 0) {
            valid = 0;
        }
        else if (strcmp(argv[i], "--noTimeout") == 0) {
            timeout = 0;
        }
        else if (strcmp(argv[i], "--debug") == 0) {
            debug = 1;
        }
        else {
            printf("Error: unknown argument '%s'\n", argv[i]);
            printUsage(argv[0]);
            return 1;
        }
    }
    port = atoi(argv[argc - 1]);
    return 0;
}


/*
    See usage of 'sprintf' to pass formatted strings as parameter
*/
void debugLog(char* msg) {
    if (debug) {
        printf("[debug] %s\n", msg);
    }
}


void initPlayers() {
    for (int i = 0; i < 2; i++) {
        players[i].socket = -1;
        players[i].ready = 0;
    }
    players[0].opponent = &players[1];
    players[1].opponent = &players[0];
}


int handlePlayerConnection(int socketServer, PlayerData players[]) {
    int newPlayer;
    if (players[0].socket == -1) {
        newPlayer = 0;
    }
    else if (players[1].socket == -1) {
        newPlayer = 1;
    }
    else {
        return -1;
    }

    int sizeAddr = sizeof(struct sockaddr_in);
    struct sockaddr_in addClient;

    int playerSock = accept(socketServer,
                    (struct sockaddr *)&addClient,
                    (socklen_t *)&sizeAddr);
    if (playerSock < 0) {
        printf("[QuantikServer] Error occured while accepting a player connection.");
        return -2;
    }

    players[newPlayer].socket = playerSock;

    return 0;
}


/*
    Called for game initialization requests.
*/
int handleGameRequest(PlayerData player) {
    TPartieReq gameRequest;

    int err = recv(player.socket, &gameRequest, sizeof(TPartieReq), 0);
    if (err <= 0) {
        printf("[QuantikServer] Error occured while receiving player request.");
        return 1;
    }

    strcpy(player.name, gameRequest.nomJoueur);
    if (player.opponent->ready && player.opponent->color == gameRequest.coulPion) {
        if (gameRequest.coulPion == BLANC) {
            player.color = NOIR;
        }
        else {
            player.color = BLANC;
        }
    }
    else {
        player.color = gameRequest.coulPion;
    }
    player.ready = 1;
}


/*
    Called for playing requests.
*/
int handlePlayingRequest(PlayerData player) {
    TCoupReq playingRequest;

    int err = recv(player.socket, &playingRequest, sizeof(TCoupReq), 0);
    if (err <= 0) {
        printf("[QuantikServer] Error occured while receiving player request.");
        return 1;
    }
}


/*
    Called for every player action on his socket.
*/
int handlePlayerAction(PlayerData player) {
    TIdReq idRequest;

    int err = recv(player.socket, &idRequest, sizeof(TIdReq), MSG_PEEK);
    if (err <= 0) {
        printf("[QuantikServer] Error occured while receiving player request.");
        return 1;
    }

    if (idRequest == PARTIE) {
        handleGameRequest(player);
    }
    else if (idRequest == COUP) {
        handlePlayingRequest(player);
    }
    else {
        // TODO
    }

    return 0;
}


int main(int argc, char** argv) {
    /*
        Server initializing part
    */

    int err,
        socketServer;

    initPlayers();

    fd_set readfs;

    err = parsingParameters(argc, argv);
    if (err == 1) {
        exit(1);
    }

    socketServer = socketServeur(port);
    if (socketServer < 0) {
        printf("[QuantikServer] Error occured while initializing server on port %i.\n", port);
        exit(2);
    }

    /*
        Waiting for players requests
    */

    for (;;) {
        FD_ZERO(&readfs);
        FD_SET(socketServer, &readfs);

        for (int i = 0; i < 2; i++) {
            if (players[i].socket != -1) {
                FD_SET(players[i].socket, &readfs);
            }
        }

        err = select(4, &readfs, NULL, NULL, NULL);
        if ((err < 0) && (errno!=EINTR)) {
            printf("[QuantikServer] Error occured on select");
            exit(3);
        }

        if (FD_ISSET(socketServer, &readfs)) {  // New player connecting
            handlePlayerConnection(socketServer, players); // TODO : handle too much players connecting
        }

        for (int i = 0; i < 2; i++) {
            if (players[i].socket != -1) {
                if (FD_ISSET(players[i].socket, &readfs)) { // Action on player's socket
                    handlePlayerAction(players[i]);
                }
            }
        }
    }
}
