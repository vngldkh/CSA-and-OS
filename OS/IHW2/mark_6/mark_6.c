#include <sys/ipc.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <fcntl.h>

#define nprog 3
const int progs = 1000;

static sem_t* sem[nprog];
static int* arr[nprog];
static char* sem_names[nprog] = {"/sem-01", "/sem-02", "/sem-03"};
static char* names[nprog] = {"/sh-m-01", "/sh-m-02", "/sh-m-03"};

void intHandler(int dummy) {
    printf("[Cutter] SIGINT Detected!\n");
    for (int i = 0; i < nprog; ++i) {
        sem_close(sem[i]);
        sem_unlink(sem_names[i]);

        munmap(arr[i], (3 * nprog + 1) * sizeof(int));
        shm_unlink(names[i]);
    }
    exit(0);
}

void review(int process_id, int author, int program_no) {
    printf("Programmer #%d >> Started reviewing program #%d from programmer #%d.\n", process_id + 1, program_no + 1, author + 1);
    // Проверяет полученную программу.
    for (int j = 0; j < 10000; ++j);

    // Блокируем область памяти.
    sem_wait(sem[author]);

    int offset = 0;
    while (arr[author][offset] != -1) {
        offset += 3;
    }

    arr[author][offset + 0] = author;
    arr[author][offset + 1] = program_no;
    arr[author][offset + 2] = (rand() % 100) >= 50 ? 1 : -1;

    printf("Programmer #%d >> Reviewed program #%d from programmer #%d.\n", process_id + 1, program_no + 1, author + 1);

    // Разблокируем область памяти.
    sem_post(sem[author]);
}

void programmer(int process_id) {
    bool done = true;
    // Каждый программист пишет по 10 программ.
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
        sem_wait(sem[inspector_id]);

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
        sem_post(sem[inspector_id]);

        // Пока программа не будет проверена.
        while (!reviewed) {
            // Блокируем область памяти.
            sem_wait(sem[process_id]);

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
            sem_post(sem[process_id]);

            reviewed = author == process_id;

            if (!reviewed && author >= 0) {
                review(process_id, author, program_no);
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
        sem_wait(sem[(process_id + 1) % 3]);

        flag &= arr[(process_id + 1) % 3][9] >= progs;

        //  Освобождаем область памяти.
        sem_post(sem[(process_id + 1) % 3]);

        // Блокируем область памяти.
        sem_wait(sem[(process_id + 2) % 3]);

        flag &= arr[(process_id + 2) % 3][9] >= progs;

        //  Освобождаем область памяти.
        sem_post(sem[(process_id + 2) % 3]);

        // Блокируем область памяти.
        sem_wait(sem[process_id]);

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
        sem_post(sem[process_id]);

        if (author >= 0) {
            review(process_id, author, program_no);
        }

        for (int j = 0; j < 10000; ++j);
    } while (!flag);
}

int main() {
    srand(time(NULL));
    signal(SIGINT, intHandler);

    for (int i = 0; i < nprog; ++i) {
        sem[i] = sem_open(sem_names[i], O_CREAT, 0666, 1);
    }

    int shmid[nprog];
    for (int i = 0; i < nprog; ++i) {
        shmid[i] = shm_open(names[i], O_CREAT | O_RDWR, 0666);
        ftruncate(shmid[i], (3 * nprog + 1) * sizeof(int));
        arr[i] = mmap(0, (3 * nprog + 1) * sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED, shmid[i], 0);
        for (int j = 0; j < 9; ++j) {
            arr[i][j] = -1;
        }
        arr[i][9] = 0;
    }

    int p_no;
    pid_t pid = fork();
    if (pid < 0) {
        printf("Fork error\n");
        return -1;
    } else if (pid == 0) {
        pid = fork();
        if (pid < 0) {
            printf("Fork error\n");
            return -1;
        } else if (pid == 0) {
            p_no = 1;
        } else {
            p_no = 2;
        }
        programmer(p_no);
    } else {
        p_no = 0;
        programmer(p_no);
        wait(0);
        for (int i = 0; i < nprog; ++i) {
            sem_close(sem[i]);
            sem_unlink(sem_names[i]);

            munmap(arr[i], (3 * nprog + 1) * sizeof(int));
            shm_unlink(names[i]);
        }
    }
}
