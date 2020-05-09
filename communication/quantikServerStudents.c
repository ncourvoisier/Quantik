/**
 * @file quantikServerStudents.c
 * @author Augustin Bordy
 * @author Nicolas Courvoisier
 * @date 9 May 2020
 * @brief Quantik game server source code, developped for a scholar project
 * @see https://www.gigamic.com/jeu/quantik
 */


#include "fonctionTCP.h"
#include "validation.h"
#include "protocolQuantik.h"

#include <time.h>
#include <signal.h>
#include <sys/wait.h>
#include <fcntl.h>

#define SEVERE_COLOR "\x1B[31m"
#define RESET_COLOR "\x1B[0m"

#define TIME_MAX 5000


/**
 * Structures definition
 */
typedef struct PlayerData {
    int id;
    int number; // playing order of the player in the current round
    struct PlayerData *opponent;
    char name[T_NOM];
    int socket;
    TCoul color;
    TValidCoul colorAccepted;
    int ready;
    int score;
} PlayerData;


/**
 * Global parameters
 */
int valid = 1;
int timeout = 1;
int port = -1;
int showBoard = 0;


/**
 * Game datas
 */
int socketServer;
PlayerData players[2];
PlayerData *currentPlayer; //player currently playing
int gameStarted = 0;
int gameContinue = 1;
int roundNumber = 1; // 1 for the first round, 2 for the second
int playerTimedOut = 0;


/**
 * Timer datas
 */
pid_t clockPid;
int timerInterrupted = 0;


/**
 * Logs mechanic
 */
int debug = 0;
char logMessage[200];
typedef enum { INFO, SEVERE, DEBUG } LogType;


/**
 * @brief Called by the timer process. \n
 * Interrupts the timer.
 */
void timerInterruptSignalHandler() {
    timerInterrupted = 1;
}


/**
 * @brief Forks the main process to create a timer routine
 */
void startClockTimer() {
    struct timespec nano1, nano2;
    nano1.tv_sec = 0;
    nano1.tv_nsec = 1000000L; // 1 micro second
    pid_t ppid = getpid();
    clockPid = fork();
    if (clockPid == 0) {
        for (;;) {
            for (int i = 0; i < TIME_MAX && !timerInterrupted; i++) {
                nanosleep(&nano1, &nano2);
            }
            if (timerInterrupted) {
                timerInterrupted = 0;
            }
            else {
                kill(ppid, SIGUSR1); // The timer is out
            }
        }
    }
}


/**
 * @brief Reset the clock routine
 */
void resetClockTimer() {
    kill(clockPid, SIGUSR2);
}


/**
 * @brief Stops the clock timer
 */
void stopClockTimer() {
    kill(clockPid, SIGKILL);
    wait(NULL);
}


/**
 * @brief A simple logging fonction
 * @param [in] type The type of log information to print
 */
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


/**
 * @brief Prints the executable file usage
 * @param execName [in] the executable file name
 */
void printUsage(char* execName) {
    printf("Usage: %s [--noValid|--noTimeout|--debug|--showBoard] no_port\n", execName);
}


/**
 * @brief Parses the given parameters
 * @param [in] argc The number of arguments
 * @param [in] argv The arguments array
 * @return The parameters validity code \n
 * 0 -> valid parameters \n
 * 1 -> invalid parameters
 */
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
        else if (strcmp(argv[i], "--showBoard") == 0) {
            showBoard = 1;
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


/**
 * @brief Initializes the players array
 */
void initPlayers() {
    for (int i = 0; i < 2; i++) {
        players[i].socket = -1;
        players[i].ready = 0;
    }
    players[0].opponent = &players[1];
    players[1].opponent = &players[0];
}


/**
 * @brief Close the communication socket for a given player
 * @param [in] player The player to close the socket of
 */
void closeConnection(PlayerData *player) {
    if (player->socket == -1) {
        return;
    }
    shutdown(player->socket, SHUT_RDWR);
    close(player->socket);
    player->socket = -1;
}


/**
 * @brief Send a game initialization response to the player
 * @param [in] player The player to send a response to
 * @param [in] code The nature of the  response
 * @return the response sending state \n
 * 0 -> The response was sent successfully \n
 * 1 -> An error occured
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
    }
    return 0;
}


/**
 * @brief Send playing response to all players
 * @param [in] code The response code
 * @param [in] val The move value
 * @param [in] prop The move property
 */
void sendPlayingResponse(TCodeRep code, TValCoup val, TPropCoup prop) {
    sprintf(logMessage, "Sending TCoupRep to players (Err: %i, Val: %i, Prop: %i)", code, val, prop); printLog(DEBUG);
    TCoupRep playingResponse;
    playingResponse.err = code;
    playingResponse.validCoup = val;
    playingResponse.propCoup = prop;
    for (int i = 0; i < 2; i++) {
        int err = send(players[i].socket, &playingResponse, sizeof(TCoupRep), 0);
        if (err <= 0) {
            sprintf(logMessage, "Error while sending TCoupRep to player '%s'", players[i].name); printLog(SEVERE);
        }
    }
}


/**
 * @brief Starts a game round
 * @param [in] number The number of the round to start
 * @details The player who will start playing is decided here, depending \n
 * on his color and the round number. During the first round the white \n
 * starts then it's alternating.
 */
void launchRound(int number) {
    initialiserPartie();
    roundNumber = number;
    if (roundNumber == 1) {
        if (players[0].color == BLANC) {
            currentPlayer = &players[0];
        }
        else {
            currentPlayer = &players[1];
        }
    }
    else {
        if (players[0].number == 1) {
            currentPlayer = &players[1];
        }
        else {
            currentPlayer = &players[0];
        }
    }
    currentPlayer->number = 1;
    currentPlayer->opponent->number = 2;
    sprintf(logMessage, "Starting the round %i, player '%s' has number 1", number, currentPlayer->name); printLog(INFO);
}


/**
 * @brief Starts the game
 * @return 0 if the game was launched successfully \n
 * 1 if a request couldn't be sent
 */
int launchGame() {
    for (int i = 0; i < 2; i++) {
        if (sendGameResponse(&players[i], ERR_OK)) {
            return 1;
        }
    }
    if (timeout) {
        startClockTimer();
    }
    gameStarted = 1;
    launchRound(1);
    return 0;
}


/**
 * @brief Ends the game
 * @details Closes the timer and stops the players connections.
 */
void endGame() {
    sprintf(logMessage, "End of the game"); printLog(INFO);
    if (timeout) {
        stopClockTimer();
    }
    gameContinue = 0;
    close(socketServer);
    closeConnection(&players[0]);
    closeConnection(&players[1]);
}


/**
 * @brief Handles the SIGINT brute stopping signal (Ctrl+C) to close the server properly
 */
void intHandler() {
    sprintf(logMessage, "Server was force stopped, shutting down the connections..."); printLog(INFO);
    endGame();
}


/**
 * @brief Ends a game round
 * @param [in] winner The winner of the round, can be null
 */
void endRound(PlayerData *winner) {
    sprintf(logMessage, "------------ End of the round %i ------------", roundNumber); printLog(INFO);
    if (winner == NULL) {
        sprintf(logMessage, "Result: draw"); printLog(INFO);
    }
    else {
        sprintf(logMessage, "Result: player '%s' won", winner->name); printLog(INFO);
    }
    sprintf(logMessage, "--------------------------------------------"); printLog(INFO);
    if (roundNumber == 1 && gameContinue) {
        roundNumber = 2;
        launchRound(2);
    }
    else {
        endGame();
    }
}


/**
 * @brief Ends a player action
 * @param [in] player The players whose action is ended
 * @param [in] code The response code to send
 * @param [in] The value of the move that was players
 * @param [in] moveProperty The property of the move that was played
 * @param [in] playingRequest The playing request that was just sent
 * @details This function calls {@link sendPlayingResponse}, changes the current playing user and sends the \n
 * played request if the game is continuing, calls {@link endRound} if the round has to stop.
 */
void endAction(PlayerData *player, TCodeRep code, TValCoup value, TPropCoup moveProperty, TCoupReq *playingRequest) {
    if (timeout) {
        resetClockTimer();
    }

    sendPlayingResponse(code, value, moveProperty);

    int err;
    PlayerData *winner;

    switch (moveProperty) {
        case CONT:
            err = send(player->opponent->socket, playingRequest, sizeof(TCoupReq), 0);
            if (err <= 0) {
                sprintf(logMessage, "Error while sending 'TCoupReq' request to player '%s'", player->opponent->name); printLog(SEVERE);
            }
            currentPlayer = currentPlayer->opponent;
            return;
        case GAGNE:
            winner = player;
            break;
        case PERDU:
            winner = player->opponent;
            break;
        case NUL:
            winner = NULL;
    }

    endRound(winner);
}


/**
 * @brief Disconnects a player
 * @param [in] player The player that is getting disconnected
 * @details The victory is given to the opponent and the player connection is closed.
 */
void playerDisconnected(PlayerData *player) {
    if (gameStarted) {
        sprintf(logMessage, "Player '%s' disconnected", player->name); printLog(INFO);
        gameContinue = 0;
        endRound(player->opponent);
    }
    else {
        sprintf(logMessage, "Player %i disconnected", player->id); printLog(INFO);
    }
    closeConnection(player);
}


/**
 * @brief Handles a player connection on the connection socket
 * @param [in] socketServer The server connection socket
 * @param  [in,out] players The array of players where to add the new player to
 * @return 0 if the player connection was accepted \n
 * -1 if there's already 2 players \n
 * -2 if an error occured
 */
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
        if (gameContinue) {
            sprintf(logMessage, "Error occured while accepting a player connection"); printLog(SEVERE);
        }
        return -2;
    }

    players[newPlayer].socket = playerSock;
    players[newPlayer].id = newPlayer;

    sprintf(logMessage, "New connection on socket %i with id %i", playerSock, newPlayer); printLog(INFO);

    return playerSock;
}


/**
 * @brief Handles game initialization requests
 * @param [in,out] player The player who sent a {@link TPartieReq} request
 * @return 0 if the player was successfully initialized \n
 * 1 if an error occured
 */
int handleGameRequest(PlayerData *player) {
    sprintf(logMessage, "game request by player %i", player->id); printLog(DEBUG);

    TPartieReq gameRequest;

    int err = recv(player->socket, &gameRequest, sizeof(TPartieReq), 0);
    if (err <= 0) {
        sprintf(logMessage, "Error occured while receiving player request"); printLog(SEVERE);
        return 1;
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
        return launchGame();
    }

    return 0;
}


/**
 * @brief Handles playing requests
 * @param [in] player Playing request sender
 * @return 0 if the request was successfully threated \n
 * 1 if an error occured \n
 * 2 if if the played move was rejected \n
 * 3 if it's not the player's turn to play
 * @details The function receives the playing request, validates the move if the validation \n
 * is enabled and ends the player action.
 */
int handlePlayingRequest(PlayerData *player) {
    if (player != currentPlayer) {
        return 3;
    }

    TCoupReq playingRequest;

    int err = recv(player->socket, &playingRequest, sizeof(TCoupReq), 0);
    if (err <= 0) {
        sprintf(logMessage, "Error occured while receiving player request"); printLog(SEVERE);
        return 1;
    }

    if (timeout && playerTimedOut) {
        endAction(player, ERR_COUP, TIMEOUT, PERDU, NULL);
        return 0;
    }

    TPropCoup moveProperty;
    bool isValidMove;

    if (valid) { // If validation is turned on
        sprintf(logMessage, "Validating..."); printLog(DEBUG);
        if (showBoard) {
            printf("\n------------------------------ [ Game State ] ------------------------------\n\n");
            isValidMove = validationCoup(player->number, playingRequest, &moveProperty);
            printf("\n----------------------------------------------------------------------------\n\n");
        }
        else {
            int stdout = dup(STDOUT_FILENO);
            int tmp = open("/dev/null", O_WRONLY, 0600);
            dup2(tmp, STDOUT_FILENO);

            isValidMove = validationCoup(player->number, playingRequest, &moveProperty);

            dup2(stdout, STDOUT_FILENO);
            close(tmp);
        }
    }
    else {
        sprintf(logMessage, "Skipping validation"); printLog(DEBUG);
        isValidMove = true;
        moveProperty = playingRequest.propCoup;
    }

    if (isValidMove) {
        sprintf(logMessage, "Player '%s' move was accepted", player->name); printLog(INFO);
        endAction(player, ERR_OK, VALID, moveProperty, &playingRequest);
        return 0;
    }

    sprintf(logMessage, "Player '%s' move was refused", player->name); printLog(INFO);

    return 2;
}


/**
 * @brief Handles every player action on his socket
 * @param [in,out] player The player who sent a request
 * @return 0 if the request was successfully threated \n
 * 1 if an error occured
 */
int handlePlayerAction(PlayerData *player) {
    sprintf(logMessage, "Player %i performed an action", player->id); printLog(DEBUG);

    TIdReq idRequest;
    TCodeRep errorCode;

    int err = recv(player->socket, &idRequest, sizeof(TIdReq), MSG_PEEK);
    if (err <= 0) {
        return 1;
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
            if (!gameStarted) {
                errorCode = ERR_TYP;
            }
            else {
                err = handlePlayingRequest(player);
                if (err == 0 || err == 3) {
                    return 0;
                }
                else if (err == 1) {
                    errorCode = ERR_TYP;
                }
                else if (err == 2) {
                    errorCode = ERR_COUP;
                }
            }
        }
        else {
            errorCode = ERR_TYP;
        }
    }

    if (gameStarted) {
        endAction(player, errorCode, TRICHE, PERDU, NULL);
    }
    else {
        if (sendGameResponse(player, errorCode)) {
            return 1;
        }
    }

    return 0;
}


/**
 * @brief Handles the timeout signal sent by the timer process
 * @details Ends the current player action and announces his timeout
 */
void timerOutSignalHandler() {
    sprintf(logMessage, "Player '%s' timed out", currentPlayer->name); printLog(INFO);
    endAction(currentPlayer, ERR_COUP, TIMEOUT, PERDU, NULL);
}


/**
 * The server's main function
 * @param [in] argc The arguments number
 * @param [in] argv The arguments list
 * @return The termination error code
 */
int main(int argc, char** argv) {
    /*
        Server initializing part
    */

    int err,
        maxSock;

    signal(SIGUSR1, timerOutSignalHandler);
    signal(SIGUSR2, timerInterruptSignalHandler);
    signal(SIGINT, intHandler);

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

    while (gameContinue) {
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
            handlePlayerConnection(socketServer, players);
        }

        for (int i = 0; i < 2; i++) {
            if (players[i].socket != -1) {
                if (FD_ISSET(players[i].socket, &readfs)) { // Action on player's socket
                    if (handlePlayerAction(&players[i]) && gameContinue) {
                        playerDisconnected(&players[i]);
                    }
                }
            }
        }
    }

}
