#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <assert.h>
#include <unistd.h>












#define LOCATION_ARRAY_SIZE 2
#define COLLISION_ARRAY_SIZE 1

#define POP 0
#define PUSH 1
#define TRUE 1
#define FALSE 0

typedef struct Cell Cell;
struct Cell {
    Cell        *pnext;
    int         pdata;
};

typedef struct ThreadInfo ThreadInfo;
struct ThreadInfo {
    unsigned int  id;
    int           op;
    Cell           cell;
};

typedef struct Simple_Stack Simple_Stack;
struct Simple_Stack {
    Cell *ptop;
};


Simple_Stack S;
ThreadInfo *location[LOCATION_ARRAY_SIZE];
int collision;

// int unique_id = 0;
void StackOp(ThreadInfo *p);
int TryPerformStackOp(ThreadInfo *p);
void __VERIFIER_atomic_FinishCollision(ThreadInfo *p);
int __VERIFIER_atomic_TryCollision(ThreadInfo *, ThreadInfo *, int);



/**
 * THREADS and STUFF
 */

int taken_ids[LOCATION_ARRAY_SIZE];
pthread_mutex_t mutex;
int __VERIFIER_atomic_chooseUniqueId() {
    int i;
    pthread_mutex_lock(&mutex);
    while (1) {
        for (i = 1; i <= LOCATION_ARRAY_SIZE; ++i) {
            if (!taken_ids[i - 1]) {
                taken_ids[i - 1] = 1;
                pthread_mutex_unlock(&mutex);
                return i;
            }
        }
    }
}
















/**
 *  ALGORITHM
 */
void LesOP(ThreadInfo *p) {
    p->id = __VERIFIER_atomic_chooseUniqueId();
    while (1) {
        int mypid = p->id;
        location[mypid - 1] = p;
        int him = collision;
        while (!__sync_bool_compare_and_swap(&collision, him, mypid)) {
            him = collision;
        }
        if (him > 0) {
            ThreadInfo* q = location[him - 1];
            if (q != NULL && q->id == him && q->op != p->op) {
                if (__sync_bool_compare_and_swap(&location[mypid - 1], p, NULL)) {
                    if (__VERIFIER_atomic_TryCollision(p, q, him)) {
                        return;
                    } else {
                        goto stack;
                    }
                }
                else {
                    __VERIFIER_atomic_FinishCollision(p);
                    return;
                }
            }
        }
        sleep(9);
        if (!__sync_bool_compare_and_swap(&location[mypid - 1], p, NULL)) {
            __VERIFIER_atomic_FinishCollision(p);
            return;
        }
stack:
        if (TryPerformStackOp(p) == TRUE) {
            return;
        }
    }
}

int TryPerformStackOp(ThreadInfo* p) {
    Cell *thead, *tnext;
    if (p->op == PUSH) {
        thead = S.ptop;
        p->cell.pnext = thead;
        return __sync_bool_compare_and_swap(&S.ptop, thead, &p->cell);
    }




    if (p->op == POP) {
        thead = S.ptop;
        if (thead == NULL) {
            // p->cell = EMPTY;
            p->cell.pnext = 0; p->cell.pdata = 2;    // 2 means EMPTY
            return TRUE;
        }
        tnext = thead->pnext;
        if (__sync_bool_compare_and_swap(&S.ptop, thead, tnext)) {
            // p->cell.pdata = thead->pdata;    // JAD modification
            p->cell = *thead;









            return TRUE;
        }
        else {
            // p->cell = EMPTY;
            p->cell.pnext = 0; p->cell.pdata = 2;    // 2 means EMPTY
            return FALSE;
        }
    }
}

void __VERIFIER_atomic_FinishCollision(ThreadInfo *p) {
    pthread_mutex_lock(&mutex);
    if (p->op == POP) {
        int mypid = p->id;
        // BUG commented for 'empty' bug
        // p->cell = location[mypid - 1]->cell;
        location[mypid - 1] = NULL;
    }
    pthread_mutex_unlock(&mutex);
}

int __VERIFIER_atomic_TryCollision(ThreadInfo *p, ThreadInfo *q, int him) {
    pthread_mutex_lock(&mutex);
    int mypid = p->id;
    if (p->op == PUSH) {
        pthread_mutex_unlock(&mutex);
        return __sync_bool_compare_and_swap(&location[him - 1], q, p);
    }




    if (p->op == POP) {
        if (__sync_bool_compare_and_swap(&location[him - 1], q, NULL)) {
            // BUG commented for 'empty' bug
            // p->cell = q->cell;
            location[mypid - 1] = NULL;
            pthread_mutex_unlock(&mutex);
            return TRUE;
        }
        else {
            pthread_mutex_unlock(&mutex);
            return FALSE;
        }
    }
    pthread_mutex_unlock(&mutex);
    return FALSE;
}


/**
 * Injected code
 */

void Init() {
    S.ptop = NULL;
}

// Derive from
// void StackOp (ThreadInfo * pInfo) {
//     if (TryPerformStackOp (p) == FALSE)
//         LesOP (p);
//     return;
// }

void Push(int x) {
    ThreadInfo *ti = malloc(sizeof(*ti));

    ti->op = PUSH;
    ti->cell.pdata = x;

    if (!TryPerformStackOp(ti)) {
        LesOP(ti);
    }
}



int Pop() {
    ThreadInfo *ti = malloc(sizeof(*ti));

    ti->op = POP;

    if (!TryPerformStackOp(ti)) {
        LesOP(ti);
    }

    int v = ti->cell.pdata;
    return v;
}
int tick = 0;
int tickBound = 1;
#define PushArg0Max 2
int PushOpen[2][PushArg0Max];
int PushDone[2][2][PushArg0Max];

#define PopRetMax 3
int PopOpen[2];
int PopDone[2][2][PopRetMax];

void checkInvariant() {
    assert
    (
        (PopDone[1][1][2] == 0 &&
         PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] +
         PopDone[0][1][0] >= 0 &&
         PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] >= 0 &&

         PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] >= 0 &&
         PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PopDone[0][0][1] >= 0 &&
         PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] >= 0 &&
         PopOpen[1] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PopDone[0][0][1] >= 0 &&
         PopOpen[1] >= 0 &&
         PopOpen[0] + PushOpen[1][0] + PushOpen[0][0] + PushDone[1][1][0] + PushDone[0][1][0] + PushDone[0][0][0] - PopDone[0][0][0] >= 0 &&
         PopOpen[0] >= 0 &&
         PopDone[0][1][2] >= 0 &&
         PopDone[0][0][2] >= 0 &&
         PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PopDone[0][0][1] - PopDone[0][1][1] >= PopDone[1][1][1] &&
         PopDone[1][1][1] >= 0 &&
         PopDone[0][1][1] >= 0 &&
         PushOpen[0][1] + PushDone[0][1][1] + PushDone[0][0][1] >= PopDone[0][0][1] &&
         PopDone[0][0][1] >= 0 &&
         PushOpen[1][0] + PushOpen[0][0] + PushDone[1][1][0] + PushDone[0][1][0] + PushDone[0][0][0] - PopDone[0][0][0] - PopDone[0][1][0] >= PopDone[1][1][0] &&
         PopDone[1][1][0] >= 0 &&
         PopDone[0][1][0] >= 0 &&
         PushOpen[0][0] + PushDone[0][1][0] + PushDone[0][0][0] >= PopDone[0][0][0] &&
         PopDone[0][0][0] >= 0 &&
         PushOpen[1][1] >= 0 &&
         PushOpen[0][1] >= 0 &&
         PushDone[1][1][1] >= 0 &&
         PushDone[0][1][1] >= 0 &&
         PushDone[0][0][1] >= 0 &&
         PushOpen[1][0] >= 0 &&
         PushOpen[0][0] >= 0 &&
         PushDone[1][1][0] >= 0 &&
         PushDone[0][1][0] >= 0 &&
         PushDone[0][0][0] >= 0) || (PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] + -1 * PushDone[0][0][1] - PushDone[0][0][0] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] + PushDone[0][1][0] - PushDone[0][0][1] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] - PushDone[0][0][1] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] + PopDone[1][1][0] + PopDone[0][1][0] - PushDone[0][0][1] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] + PushOpen[0][1] - PushDone[0][0][0] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] - PushDone[0][0][0] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][1] + PushOpen[0][0] + PushDone[0][1][0] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][1] + PushOpen[0][0] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][1] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] + PushDone[0][1][0] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] >= 0 &&
                                     PopOpen[1] + 2 * PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] + -1 * PushDone[0][0][1] - PushDone[0][0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] + PushDone[0][1][0] - PushDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] - PushDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] + PopDone[1][1][0] + PopDone[0][1][0] - PushDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[0][0][1] - PushDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] + PushOpen[0][1] - PushDone[0][0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] - PushDone[0][0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][1] + PushOpen[0][0] + PushDone[0][1][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][1] + PushOpen[0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] + PushDone[0][1][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PopDone[1][1][0] + PopDone[0][1][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] + PushOpen[0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][1] + PopDone[0][1][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] + PushOpen[1][1] + 2 * PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PushDone[0][0][0] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PushDone[0][0][0] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + 2 * PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] + PushOpen[0][0] + PushDone[0][1][0] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + 2 * PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] + PushOpen[0][0] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + 2 * PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] + PushOpen[0][0] + PushDone[0][1][0] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] + PushOpen[0][0] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] - PushDone[0][0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PopDone[0][0][0] - PushDone[0][0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushOpen[0][0] + PushDone[0][1][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushOpen[0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] + PushDone[0][1][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] + PushOpen[0][0] >= 0 &&
                                     PopOpen[1] + PopOpen[0] + PopDone[1][1][0] + PopDone[0][1][0] >= 0 &&
                                     PopOpen[1] + PushOpen[1][1] + 2 * PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PopDone[0][0][1] >= 0 &&
                                     PopOpen[1] + PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] >= 0 &&
                                     PopOpen[1] >= 0 &&
                                     PopOpen[0] + PushOpen[1][0] + 2 * PushOpen[0][0] + PushDone[1][1][0] + 2 * PushDone[0][1][0] + PushDone[0][0][0] - PopDone[0][0][0] >= 0 &&
                                     PopOpen[0] + PushOpen[1][0] + 2 * PushOpen[0][0] + PushDone[1][1][0] + PushDone[0][1][0] + PushDone[0][0][0] - PopDone[0][0][0] >= 0 &&
                                     PopOpen[0] + PushOpen[1][0] + PushOpen[0][0] + PushDone[1][1][0] + PushDone[0][1][0] + PushDone[0][0][0] - PopDone[0][0][0] >= 0 &&
                                     PopOpen[0] + PushOpen[1][0] + PushOpen[0][0] + PushDone[1][1][0] + PushDone[0][1][0] >= 0 &&
                                     PopOpen[0] >= 0 &&
                                     PopDone[1][1][2] >= 1 &&
                                     PopDone[0][1][2] >= 0 &&
                                     PopDone[0][0][2] >= 0 &&
                                     PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] - PopDone[0][0][1] - PopDone[0][1][1] >= PopDone[1][1][1] &&
                                     PopDone[1][1][1] >= 0 &&
                                     PopDone[0][1][1] >= 0 &&
                                     PushOpen[1][1] + 2 * PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] + PushDone[0][0][1] >= PopDone[0][0][1] &&
                                     PushOpen[0][1] + PushDone[0][1][1] + PushDone[0][0][1] >= PopDone[0][0][1] &&
                                     PopDone[0][0][1] >= 0 &&
                                     PushOpen[1][0] + PushOpen[0][0] + PushDone[1][1][0] + PushDone[0][1][0] + PushDone[0][0][0] - PopDone[0][0][0] - PopDone[0][1][0] >= PopDone[1][1][0] &&
                                     PopDone[1][1][0] >= 0 &&
                                     PopDone[0][1][0] >= 0 &&
                                     PushOpen[1][0] + 2 * PushOpen[0][0] + PushDone[1][1][0] + 2 * PushDone[0][1][0] + PushDone[0][0][0] >= PopDone[0][0][0] &&
                                     PushOpen[1][0] + 2 * PushOpen[0][0] + PushDone[1][1][0] + PushDone[0][1][0] + PushDone[0][0][0] >= PopDone[0][0][0] &&
                                     PushOpen[0][0] + PushDone[0][1][0] + PushDone[0][0][0] >= PopDone[0][0][0] &&
                                     PopDone[0][0][0] >= 0 &&
                                     PushOpen[1][1] + PushOpen[0][1] + PushDone[1][1][1] + PushDone[0][1][1] >= 0 &&
                                     PushOpen[1][1] >= 0 &&
                                     PushOpen[0][1] >= 0 &&
                                     PushDone[1][1][1] >= 0 &&
                                     PushDone[0][1][1] >= 0 &&
                                     PushDone[0][0][1] >= 0 &&
                                     PushOpen[1][0] + PushOpen[0][0] + PushDone[1][1][0] + PushDone[0][1][0] >= 0 &&
                                     PushOpen[1][0] >= 0 &&
                                     PushOpen[0][0] >= 0 &&
                                     PushDone[1][1][0] >= 0 &&
                                     PushDone[0][1][0] >= 0 &&
                                     PushDone[0][0][0] >= 0)
    );
}

void __VERIFIER_atomic_atomicIncr_Push(int tickStart, int localPush1) {
    pthread_mutex_lock(&mutex);
    PushOpen[tickStart][localPush1]++;
    pthread_mutex_unlock(&mutex);
}

void __VERIFIER_atomic_atomicDecrIncr_Push(int tickStart, int tick, int localPush1) {
    pthread_mutex_lock(&mutex);
    PushOpen[tickStart][localPush1]--;
    PushDone[tickStart][tick][localPush1]++;
    checkInvariant();
    pthread_mutex_unlock(&mutex);
}

void __VERIFIER_atomic_atomicIncr_Pop(int tickStart) {
    pthread_mutex_lock(&mutex);
    PopOpen[tickStart]++;
    pthread_mutex_unlock(&mutex);
}

void __VERIFIER_atomic_atomicDecrIncr_Pop(int tickStart, int tick, int localPop_ret) {
    pthread_mutex_lock(&mutex);
    PopOpen[tickStart]--;
    PopDone[tickStart][tick][localPop_ret]++;
    checkInvariant();
    pthread_mutex_unlock(&mutex);
}

void* instrPush0(void* unused) {
    int tickStart = tick;
    __VERIFIER_atomic_atomicIncr_Push(tickStart, 1);
    Push(1);
    __VERIFIER_atomic_atomicDecrIncr_Push(tickStart, tick, 1);
    return NULL;
}

void* instrPush1(void* unused) {
    int tickStart = tick;
    __VERIFIER_atomic_atomicIncr_Push(tickStart, 1);
    Push(1);
    __VERIFIER_atomic_atomicDecrIncr_Push(tickStart, tick, 1);
    return NULL;
}

void* instrPush2(void* unused) {
    int tickStart = tick;
    __VERIFIER_atomic_atomicIncr_Push(tickStart, 1);
    Push(1);
    __VERIFIER_atomic_atomicDecrIncr_Push(tickStart, tick, 1);
    return NULL;
}

void* instrPop3(void* unused) {
    int tickStart = tick;
    __VERIFIER_atomic_atomicIncr_Pop(tickStart);
    int localPop_ret = Pop();
    __VERIFIER_atomic_atomicDecrIncr_Pop(tickStart, tick, localPop_ret);
    return NULL;
}



int main() {
    Init();
    pthread_t tid1, tid2, tid3, tid4;
    pthread_mutex_init(&mutex, 0);
    pthread_create(&tid1, NULL, &instrPush0, NULL);
    pthread_create(&tid2, NULL, &instrPush1, NULL);
    pthread_create(&tid3, NULL, &instrPush2, NULL);
    pthread_create(&tid4, NULL, &instrPop3, NULL);
    while (tick < tickBound) {
        tick++;
    }
}
