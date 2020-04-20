#include "fonctionTCP.h"
#include "validation.h"
#include "protocolQuantik.h"


/*
    Structures definition
*/
typedef struct {
    char* name;
    int socket;
    TCoul color;
} PlayerData;


/*
    Global parameters
*/
int debugMode = 0;
int noValid = 0;
int noTimeout = 0;
int port = -1;


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
            noValid = 1;
        }
        else if (strcmp(argv[i], "--noTimeout") == 0) {
            noTimeout = 1;
        }
        else if (strcmp(argv[i], "--debug") == 0) {
            debugMode = 1;
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
    if (debugMode) {
        printf("%s\n", msg);
    }
}


PlayerData initPlayerData(int sock) {
    return (PlayerData) { NULL, sock, -1 }; // TODO : check the -1 for the enum
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
        return -1; // 2 players already playing
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

    players[newPlayer] = initPlayerData(playerSock);

    return 0;

}


int handlePlayerAction(PlayerData player) {
    printf("Hello player");
}


int main(int argc, char** argv) {

    /*
        Server initializing part
    */

    int err,
        socketServer;

    PlayerData players[2];
    for (int i = 0; i < 2; i++) {
        players[i] = initPlayerData(-1);
    }

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
