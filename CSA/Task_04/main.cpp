#include <pthread.h>
#include <semaphore.h>
#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include <vector>
#include <fstream>
#include <sstream>

using std::cout;

int front_read = 0; // Номер текущей ячейки БД для чтения.
int front_write = 0; // Номер текущей ячейки БД для записи.

int bufSize; // Размер БД.
std::vector<int> buf; // БД.

sem_t readers; // Семафор для операции чтения.
sem_t writers; // Семафор для операции записи.

std::ostream* ostr = NULL; // Выходной поток
std::istream* istr = NULL; // Входной поток

int writers_count;
int readers_count;

int key; // Текущий режим работы
// 0 - консоль
// 1 - файл
// 2 - командная строка
// 3 - рандом

pthread_mutex_t mutexW; // Мутекс для операции записи.
pthread_mutex_t mutexR; // Мутекс для операции чтенмия.

// Читатель
void* Reader(void* arg) {
    int no = *((int*) arg);
    int res;
    while (1) {
        pthread_mutex_lock(&mutexR); //защита операции чтения
        //критическая секция
        sem_wait(&readers); //количество свободных для чтения ячеек уменьшилось на единицу
        res = buf[front_read];
        front_read = (front_read + 1) % bufSize;
        sem_post(&readers); //количество свободных для чтения ячеек увеличилось на единицу
        pthread_mutex_unlock(&mutexR);
        std::stringstream ss;
        ss << "Reader " << no << ": Reads value = " << res << " from cell [" <<
              (front_read-1 < 0 ? bufSize-1: front_read-1) << "]\n";
        cout << ss.str();
        if (key == 1 || key == 3) {
            *ostr << ss.str();
        }
        sleep(rand() % 20); // Поток засыпает на случайное время
    }
    return NULL;
}

// Писатель
void* Writer(void* arg) {
    int no = *((int*) arg);
    while (1) {
        // Создать элемент для БД
        int data = rand() % 100 - 50;
        int last_val;
        // Поместить элемент в БД
        pthread_mutex_lock(&mutexW) ; //защита операции записи
        //критическая секция
        sem_wait(&writers); //количество свободных для записи ячеек уменьшилось на единицу
        last_val = buf[front_write];
        buf[front_write] = data;
        front_write = (front_write+1)%bufSize ;
        sem_post(&writers) ; //количество свободных для записи ячеек увеличилось на единицу
        pthread_mutex_unlock(&mutexW) ;
        std::stringstream ss;
        ss << "Writer " << no << ": Changes value = " << last_val << " to " << data << " in cell [" <<
           (front_write-1 < 0 ? bufSize-1: front_write-1) << "]\n";
        std::string output = ss.str();
        cout << output;
        if (key == 1 || key == 3) {
            *ostr << output;
        }
        ss.clear();
        sleep(rand() % 20); // Поток засыпает на случайное время
    }
    return NULL;
}

// В соответствии с выбранным режимом работы инициализируются входной и выходной потоки.
int defineStreams(char* argv[], std::ifstream& ifs, std::ofstream& ofs) {
    switch (key) {
        case 0:
            istr = &std::cin;
            ostr = NULL;
            break;
        case 1:
            ifs.open(argv[2]);
            if (!ifs) {
                cout << "The file doesn't exist or is inaccessible!";
                return 1;
            }
            ofs.open("out.txt");
            if (!ofs) {
                cout << "The file doesn't exist or is inaccessible!";
                return 1;
            }
            istr = &ifs;
            ostr = &ofs;
            break;
        case 2:
            istr = NULL;
            ostr = NULL;
            break;
        case 3:
            istr = NULL;
            ofs.open("out.txt");
            if (!ofs) {
                cout << "The file doesn't exist or is inaccessible!";
                return 1;
            }
            ostr = &ofs;
            break;
        default:
            std::cout << "Argument exception!\n";
            return 1;
    }
    return 0;
}

int main(int argc, char* argv[]) {
    try {
        key = atoi(argv[1]);
    } catch (...) {
        cout << "You must write a number!\n";
        return 1;
    }
    std::ofstream ofs;
    std::ifstream ifs;

    int res = defineStreams(argv, ifs, ofs);
    if (res) {
        return res;
    }

    srand(time(NULL));

    try {
        if (key == 2) {
            if (argc < 5) {
                return 1;
            }
            bufSize = atoi(argv[2]);
            writers_count = atoi(argv[3]);
            readers_count = atoi(argv[4]);
        } else if (key == 3) {
            bufSize = rand() % 100000;
            writers_count = rand() % 1000;
            readers_count = rand() % 1000;
        } else {
            if (key == 0) {
                cout << "Data Base size?\n";
            }
            std::string input;
            *istr >> input;
            bufSize = atoi(input.c_str());
            if (bufSize == 0) {
                return 1;
            }
            if (key == 0) {
                cout << "Writers count?\n";
            }
            *istr >> input;
            writers_count = atoi(input.c_str());
            if (key == 0) {
                cout << "Readers count?\n";
            }
            *istr >> input;
            readers_count = atoi(input.c_str());
            if (writers_count == 0 && readers_count == 0) {
                return 1;
            }
        }
    } catch (...) {
        std::cout << "Reading error!\n";
        return 1;
    }

    buf = std::vector<int>(bufSize);
    //инициализация мутексов и семафоров
    pthread_mutex_init(&mutexW, NULL);
    pthread_mutex_init(&mutexR, NULL);
    sem_init(&writers, 0, bufSize); //количество свободных ячеек равно bufSize
    sem_init(&readers, 0, bufSize); //количество свободных ячеек равно bufSize
    // Заполняем БД возрастающей последовательностью натуральных чисел от 1 до bufSize
    for (int i = 0; i < bufSize; ++i) {
        buf[i] = i + 1;
    }
    // Запуск читателей
    pthread_t threadP[readers_count];
    int producers[readers_count];
    for (int i = 0; i < readers_count; ++i) {
        producers[i] = i + 1;
        pthread_create(&threadP[i],NULL,Reader, (void*)(&producers[i])) ;
    }
    // Запуск писателей
    pthread_t threadC[writers_count];
    int consumers[writers_count];
    for (int i = 0 ; i < writers_count; ++i) {
        consumers[i] = i + 1;
        pthread_create(&threadC[i],NULL,Writer, (void*)(&consumers[i])) ;
    }

    while (std::cin.get() != 'q');
    if (key == 3) {
    	*ostr << "bufSize = " << bufSize << "; ";
        *ostr << "writers_count = " << writers_count << "; ";
        *ostr << "readers_count = " << readers_count << "\n";
    }
    ifs.close();
    ofs.close();
    return 0;
}
