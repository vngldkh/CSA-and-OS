#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <unistd.h>
#include <signal.h>

#define nprog 3

pid_t* processes;
int shmid[nprog];
int sem_id, pshmid, process_id = 0;
const int progs = 10000;

void intHandler(int dummy) {
    printf("[Cutter] SIGINT Detected!\n");

    for (int i = 0; i < nprog - 1; ++i) {
        kill(processes[(process_id + i + 1) % nprog], SIGINT);
    }

    for (int i = 0; i < nprog; ++i) {
        shmctl(shmid[i], IPC_RMID, NULL);
        semctl(sem_id, i, IPC_RMID, NULL);
    }
    shmctl(pshmid, IPC_RMID, NULL);
    exit(0);
}

void review(struct sembuf buf, int* arr[nprog], int author, int program_no) {
    printf("Programmer #%d >> Started reviewing program #%d from programmer #%d.\n", process_id + 1, program_no + 1, author + 1);
    // Проверяет полученную программу.
    for (int j = 0; j < 10000; ++j);

    // Блокируем область памяти.
    buf.sem_op = -1;
    buf.sem_num = author;
    if (semop(sem_id, &buf, 1) < 0) {
        printf("Programmer #%d >> Can't write task queue.\n", process_id + 1);
        exit(-1);
    }

    int offset = 0;
    while (arr[author][offset] != -1) {
        offset += 3;
    }

    arr[author][offset + 0] = author;
    arr[author][offset + 1] = program_no;
    arr[author][offset + 2] = (rand() % 100) >= 50 ? 1 : -1;

    printf("Programmer #%d >> Reviewed program #%d from programmer #%d.\n", process_id + 1, program_no + 1, author + 1);

    // Разблокируем область памяти.
    buf.sem_op = 1;
    buf.sem_num = author;
    if (semop(sem_id, &buf, 1) < 0) {
        printf("Programmer #%d >> Can't close task queue.\n", process_id + 1);
        exit(-1);
    }
}

int main() {
    srand(time(NULL));
    signal(SIGINT, intHandler);

    key_t key[] = {ftok("key_file1.txt", 24),
                   ftok("key_file2.txt", 24),
                   ftok("key_file3.txt", 24)};

    sem_id = semget(key[0], nprog, 0666 | IPC_CREAT | IPC_EXCL);
    if (sem_id >= 0) {
        semctl(sem_id, 0, SETVAL, 1);
        semctl(sem_id, 1, SETVAL, 1);
        semctl(sem_id, 2, SETVAL, 1);
    } else {
        sem_id = semget(key[0], 3, 0);
    }

    int* arr[nprog];
    for (int i = 0; i < nprog; ++i) {
        shmid[i] = shmget(key[i], (3 * nprog + 1) * sizeof(int), 0666 | IPC_CREAT | IPC_EXCL);
        if (shmid[i] >= 0) {
            arr[i] = (int*) shmat(shmid[i], NULL, 0);
            for (int j = 0; j < 3 * nprog; ++j) {
                arr[i][j] = -1;
            }
            arr[i][9] = 0;
        } else {
            shmid[i] = shmget(key[i], (3 * nprog + 1) * sizeof(int), 0);
            arr[i] = (int*) shmat(shmid[i], NULL, 0);
        }
    }

    key_t pid_key = ftok("pid_key.txt", 0);
    pshmid = shmget(pid_key, nprog * sizeof(pid_t), 0666 | IPC_CREAT | IPC_EXCL);
    if (pshmid >= 0) {
        processes = (pid_t*) shmat(pshmid, NULL, 0);
        for (int j = 0; j < nprog; ++j) {
            processes[j] = 0;
        }
        processes[process_id] = getpid();
    } else {
        pshmid = shmget(pid_key, nprog * sizeof(pid_t), 0);
        processes = (pid_t *) shmat(pshmid, NULL, 0);
    }

    struct sembuf buf = {.sem_flg = 0};
    bool done = true;
    // Каждый программист пишет по progs программ.
    for (int i = 0; i < progs; ++i) {
        // Пишет программу.
        if (done) {
            printf("Programmer #%d >> Started writing program #%d.\n", process_id + 1, i + 1);
        } else {
            printf("Programmer #%d >> Continued writing program #%d.\n", process_id + 1, i + 1);
        }
        for (int j = 0; j < 10000; ++j);
        bool reviewed = false;

        // Выбирает проверяющего. Если программа дорабатывалась, отправляется тому же.
        int inspector_id = done ? (process_id + rand() % 2 + 1) % 3 : inspector_id;

        // Блокируем область памяти.
        buf.sem_op = -1;
        buf.sem_num = inspector_id;
        //printf("%d %d %d\n", semctl(sem_id, 0, GETVAL), semctl(sem_id, 1, GETVAL), semctl(sem_id, 2, GETVAL));
        if (semop(sem_id, &buf, 1) < 0) {
            printf("Programmer #%d >> Can't send program #%d to review.\n", process_id + 1, i + 1);
            exit(-1);
        }

        int offset = 0;
        while (arr[inspector_id][offset] != -1) {
            offset += 3;
        }

        // Автор программы, номер программы, состояние.
        // Состояния: 0 - отправлен на проверку, 1 - успешно прошла проверку, 2 - не прошла.
        arr[inspector_id][offset + 0] = process_id;
        arr[inspector_id][offset + 1] = i;
        arr[inspector_id][offset + 2] = 0;

        printf("Programmer #%d >> Sent program #%d to review to programmer #%d.\n", process_id + 1, i + 1, inspector_id + 1);


        // Разблокируем область памяти.
        buf.sem_op = 1;
        if (semop(sem_id, &buf, 1) < 0) {
            printf("Programmer #%d >> Can't send program #%d to review.\n", process_id + 1, i + 1);
            exit(-1);
        }

        // Пока программа не будет проверена.
        while (!reviewed) {
            // Блокируем область памяти.
            buf.sem_op = -1;
            buf.sem_num = process_id;
            if (semop(sem_id, &buf, 1) < 0) {
                printf("Programmer #%d >> Can't read task queue.\n", process_id + 1);
                exit(-1);
            }

            int author = arr[process_id][0];
            int program_no = arr[process_id][1];
            int descision = arr[process_id][2];

            offset = 0;
            for (int j = 0; j < 2; ++j) {
                arr[process_id][offset + 0] = arr[process_id][offset + 3 + 0];
                arr[process_id][offset + 1] = arr[process_id][offset + 3 + 1];
                arr[process_id][offset + 2] = arr[process_id][offset + 3 + 2];
                offset += 3;
            }
            arr[process_id][offset + 0] = -1;
            arr[process_id][offset + 1] = -1;
            arr[process_id][offset + 2] = -1;

            if (author == process_id) {
                done = descision > 0;
                if (descision > 0) {
                    ++arr[process_id][9];
                    printf("Programmer #%d >> Get program #%d back.\n", process_id + 1, program_no + 1);
                } else {
                    --i;
                }
            }

            // Разблокируем область памяти.
            buf.sem_op = 1;
            if (semop(sem_id, &buf, 1) < 0) {
                printf("Programmer #%d >> Can't close task queue.\n", process_id + 1);
                exit(-1);
            }

            reviewed = author == process_id;

            if (!reviewed && author >= 0) {
                review(buf, arr, author, program_no);
            }

            // Программист отдыхает.
            //printf("Programmer #%d >> Went sleeping.\n", process_id + 1);
            for (int j = 0; j < 10000; ++j);
        }
    }

    bool flag;
    do {
        flag = true;
        // Блокируем область памяти.
        buf.sem_op = -1;
        buf.sem_num = (process_id + 1) % 3;
        semop(sem_id, &buf, 1);

        flag &= arr[(process_id + 1) % 3][9] >= progs;

        //  Освобождаем область памяти.
        buf.sem_op = 1;
        buf.sem_num = (process_id + 1) % 3;
        semop(sem_id, &buf, 1);

        // Блокируем область памяти.
        buf.sem_op = -1;
        buf.sem_num = (process_id + 2) % 3;
        semop(sem_id, &buf, 1);

        flag &= arr[(process_id + 2) % 3][9] >= progs;

        //  Освобождаем область памяти.
        buf.sem_op = 1;
        buf.sem_num = (process_id + 2) % 3;
        semop(sem_id, &buf, 1);

        // Блокируем область памяти.
        buf.sem_op = -1;
        buf.sem_num = process_id;
        semop(sem_id, &buf, 1);

        int author = arr[process_id][0];
        int program_no = arr[process_id][1];
        int descision = arr[process_id][2];

        int offset = 0;
        for (int j = 0; j < 2; ++j) {
            arr[process_id][offset + 0] = arr[process_id][offset + 3 + 0];
            arr[process_id][offset + 1] = arr[process_id][offset + 3 + 1];
            arr[process_id][offset + 2] = arr[process_id][offset + 3 + 2];
            offset += 3;
        }
        arr[process_id][offset + 0] = -1;
        arr[process_id][offset + 1] = -1;
        arr[process_id][offset + 2] = -1;

        // Разблокируем область памяти.
        buf.sem_op = 1;
        semop(sem_id, &buf, 1);

        if (author >= 0) {
            review(buf, arr, author, program_no);
        }

        for (int j = 0; j < 10000; ++j);
    } while (!flag);

    for (int i = 0; i < nprog; ++i) {
        shmctl(shmid[i], IPC_RMID, NULL);
        semctl(sem_id, i, IPC_RMID, NULL);
    }
    shmctl(pshmid, IPC_RMID, NULL);
}
