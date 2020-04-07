#include "fonctionTCP.h"
#include "validation.h"
#include "protocolQuantik.h"

typedef struct {
    char* name;
    int socket;
    TCoul color;
} PlayerData;

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

void printUsage(char* execName) {
    printf("Usage: %s [--noValid|--noTimeout] no_port\n", execName);
}

int main(int argc, char** argv) {

    /*
        Server initializing part
    */

    int port,
        err,
        socketServer;

    PlayerData players[2];
    for (int i = 0; i < 2; i++) {
        players[i] = initPlayerData(-1);
    }

    fd_set readfs;

    if (argc != 2) {
        printUsage(argv[0]);
        exit(1);
    }

    port = atoi(argv[1]);
    socketServer = socketServeur(port);
    if (socketServer < 0) {
        printf("[QuantikServer] Error occured while initializing server on port %i.", port);
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
