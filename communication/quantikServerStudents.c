#include "fonctionTCP.h"
#include "validation.h"
#include "protocolQuantik.h"

#include <time.h>

#define SEVERE_COLOR "\x1B[31m"
#define RESET_COLOR "\x1B[0m"

/*
    Structures definition
*/
typedef struct PlayerData {
    int id;
    struct PlayerData *opponent;
    char name[T_NOM];
    int socket;
    TCoul color;
    TValidCoul colorAccepted;
    int ready;
} PlayerData;


/*
    Global parameters
*/
int valid = 1;
int timeout = 1;
int port = -1;


/*
    Game datas
*/
PlayerData players[2];
int gameStarted = 0;


/*
    Logs mechanic
*/
int debug = 0;
char logMessage[200];
typedef enum { INFO, SEVERE, DEBUG } LogType;


void printLog(LogType type) {
    char logTypeStr[7];
    if (type == DEBUG && debug) {
        strcpy(logTypeStr, "DEBUG");
    }
    else if (type == SEVERE) {
        strcpy(logTypeStr, "SEVERE");
        printf(SEVERE_COLOR);
    }
    else if (type == INFO) {
        strcpy(logTypeStr, "INFO");
    }
    else {
        return;
    }
    time_t now = time(NULL);
    struct tm *t = localtime(&now);
    int h = t->tm_hour;
    int m = t->tm_min;
    int s = t->tm_sec;
    char hc='\0', mc='\0', sc='\0';
    if (h < 10) {
        hc = '0';
    }
    if (m < 10) {
        mc = '0';
    }
    if (s < 10) {
        sc = '0';
    }
    printf("[%c%i:%c%i:%c%i][%s] %s\n" RESET_COLOR, hc, h, mc, m, sc, s, logTypeStr, logMessage);
}


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


void initPlayers() {
    for (int i = 0; i < 2; i++) {
        players[i].socket = -1;
        players[i].ready = 0;
    }
    players[0].opponent = &players[1];
    players[1].opponent = &players[0];
}


void disconnectPlayer(PlayerData *player) {
    sprintf(logMessage, "Player %i disconnected", player->id); printLog(INFO);
    shutdown(player->socket, SHUT_RDWR);
    close(player->socket);
    player->socket = -1;
    // TODO give victory to opponent ...
}


/*
    Send a game initialization response to the player.
    -> use ERR_OK value for code when both players are ready.
    -> use ERR_PARTIE or ERR_TYP to warn the player that his attempt is invalid.
*/
int sendGameResponse(PlayerData *player, TCodeRep code) {
    TPartieRep gameResponse;
    gameResponse.err = code;
    if (code == ERR_OK) {
        strcpy(gameResponse.nomAdvers, player->opponent->name);
        gameResponse.validCoulPion = player->colorAccepted;
    }
    int err = send(player->socket, &gameResponse, sizeof(TPartieRep), 0);
    if (err <= 0) {
        return 1;
        // TODO
    }
}


int sendPlayingResponse(PlayerData *player, TCodeRep code) {
    // TODO
}


void launchGame() {
    sprintf(logMessage, "Starting the game"); printLog(INFO);
    for (int i = 0; i < 2; i++) {
        sendGameResponse(&players[i], ERR_OK); // TODO test ret
    }
    gameStarted = 1;
    // Game initializing ...
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
        sprintf(logMessage, "Error occured while accepting a player connection"); printLog(SEVERE);
        return -2;
    }

    players[newPlayer].socket = playerSock;
    players[newPlayer].id = newPlayer;

    sprintf(logMessage, "New connection on socket %i with id %i", playerSock, newPlayer); printLog(INFO);

    return playerSock;
}


/*
    Called for game initialization requests.
    Error code:
    1 -> invalid request type
    2 -> name already used
*/
int handleGameRequest(PlayerData *player) {
    sprintf(logMessage, "game request by player %i", player->id); printLog(DEBUG);

    TPartieReq gameRequest;

    int err = recv(player->socket, &gameRequest, sizeof(TPartieReq), 0);
    if (err <= 0) {
        sprintf(logMessage, "Error occured while receiving player request"); printLog(SEVERE);
        return 1;
    }

    if (strcmp(gameRequest.nomJoueur, player->opponent->name) == 0) {
        sprintf(logMessage, "Name '%s' already exists", gameRequest.nomJoueur); printLog(DEBUG);
        return 2;
    }

    strcpy(player->name, gameRequest.nomJoueur);

    if (player->opponent->ready && player->opponent->color == gameRequest.coulPion) {
        player->colorAccepted = KO;
        if (gameRequest.coulPion == BLANC) {
            player->color = NOIR;
        }
        else {
            player->color = BLANC;
        }
    }
    else {
        player->colorAccepted = OK;
        player->color = gameRequest.coulPion;
    }

    player->ready = 1;

    sprintf(logMessage, "Player '%s' with id %i is ready using color %i", player->name, player->id, player->color); printLog(INFO);

    if (player->opponent->ready) {
        launchGame();
    }
}


/*
    Called for playing requests.
*/
int handlePlayingRequest(PlayerData *player) {
    TCoupReq playingRequest;

    int err = recv(player->socket, &playingRequest, sizeof(TCoupReq), 0);
    if (err <= 0) {
        sprintf(logMessage, "Error occured while receiving player request"); printLog(SEVERE);
        return 1;
    }
}


/*
    Called for every player action on his socket.
*/
int handlePlayerAction(PlayerData *player) {
    sprintf(logMessage, "action by player %i", player->id); printLog(DEBUG);

    TIdReq idRequest;
    TCodeRep errorCode;

    int err = recv(player->socket, &idRequest, sizeof(TIdReq), MSG_PEEK);
    if (err <= 0) {
        disconnectPlayer(player);
        return 0;
    }
    else {
        if (idRequest == PARTIE) {
            if (gameStarted) {
                errorCode = ERR_TYP;
            }
            else {
                err = handleGameRequest(player);
                if (err == 0) {
                    return 0;
                }
                else if (err == 1) {
                    errorCode = ERR_TYP;
                }
                else if (err == 2) {
                    errorCode = ERR_PARTIE;
                }
            }
        }
        else if (idRequest == COUP) {
            handlePlayingRequest(player);
            // Return ...
        }
        else {
            errorCode = ERR_TYP;
        }
    }

    if (gameStarted) {
        sendPlayingResponse(player, errorCode);
    }
    else {
        sendGameResponse(player, errorCode);
    }

    return 0;
}


int main(int argc, char** argv) {
    /*
        Server initializing part
    */

    int err,
        socketServer,
        maxSock;

    initPlayers();

    fd_set readfs;

    err = parsingParameters(argc, argv);
    if (err == 1) {
        exit(1);
    }

    socketServer = socketServeur(port);
    if (socketServer < 0) {
        sprintf(logMessage, "Error occured while initializing server on port %i.\n", port); printLog(SEVERE);
        exit(2);
    }

    char initMessage[150] = "Server initialized on port %i with ";
    if (!timeout) {
        strcat(initMessage, "no ");
    }
    strcat(initMessage, "timeout and ");
    if (!valid) {
        strcat(initMessage, "no ");
    }
    strcat(initMessage, "validation");
    if (debug) {
        strcat(initMessage, " in debug mode");
    }
    sprintf(logMessage, initMessage, port); printLog(INFO);

    /*
        Waiting for players requests
    */

    maxSock = socketServer;

    for (;;) {
        FD_ZERO(&readfs);
        FD_SET(socketServer, &readfs);

        for (int i = 0; i < 2; i++) {
            if (players[i].socket != -1) {
                FD_SET(players[i].socket, &readfs);
                if (players[i].socket > maxSock) {
                    maxSock = players[i].socket;
                }
            }
        }

        err = select(maxSock + 1, &readfs, NULL, NULL, NULL);
        if ((err < 0) && (errno!=EINTR)) {
            sprintf(logMessage, "Error occured on select"); printLog(SEVERE);
            exit(3);
        }

        if (FD_ISSET(socketServer, &readfs)) {  // New player connecting
            handlePlayerConnection(socketServer, players); // TODO : handle too much players connecting
        }

        for (int i = 0; i < 2; i++) {
            if (players[i].socket != -1) {
                if (FD_ISSET(players[i].socket, &readfs)) { // Action on player's socket
                    handlePlayerAction(&players[i]);
                }
            }
        }
    }
}
