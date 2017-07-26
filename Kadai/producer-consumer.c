#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#define BSIZE 5 //* \label{thread5-BSIZE}

typedef struct {
  char buf[BSIZE];
  sem_t *occupied; //* \label{thread5-occupied}
  sem_t *empty;   //* \label{thread5-empty}
  int nextin;
  int nextout;
  sem_t *pmut;    //* \label{thread5-pmut}
  sem_t *cmut;    //* \label{thread5-cmut}
} buffer_t;

buffer_t buffer;

void producer(buffer_t *, char);
char consumer(buffer_t *);

void *producer_thread(void *arg)
{
  char item;
  for(int i = 0; i < 10 ; i++){
    item =(char)('a'+i);    //* \label{thread5-item}
    printf("producer->%c\n",item);
    producer(&buffer, item);
  }
  return 0;
}

void *consumer_thread(void *arg)
{
  char item;
  for(int i = 0 ; i < 10 ; i++){
    item =consumer(&buffer);
    printf("consume:%c\n", item);
  }
  return 0;
}

int main(void){
  pthread_t t0;
  pthread_t t1;
  buffer.occupied= sem_open("/occupied",O_CREAT,0644,0); //* \label{thread5-open-occupied}
  buffer.empty = sem_open("/empty",O_CREAT,0644,BSIZE);   //* \label{thread5-open-empty}
  buffer.pmut = sem_open("/pmut",O_CREAT,0644,1); //* \label{thread5-open-pmut}
  buffer.cmut = sem_open("/cmut",O_CREAT,0644,1); //* \label{thread5-open-cmut}

  buffer.nextin = buffer.nextout = 0;

  pthread_create( &t0, NULL, producer_thread, NULL);
  pthread_create( &t1, NULL, consumer_thread, NULL);
  pthread_join( t0, NULL );
  pthread_join( t1, NULL );

  exit(0);

}

void producer(buffer_t *b, char item) { //* \label{thread5-producer}
  sem_wait(b->empty);
  sem_wait(b->pmut);
  b->buf[b->nextin] = item;
  b->nextin++;
  b->nextin %= BSIZE;
  sem_post(b->pmut);
  sem_post(b->occupied);
}

char consumer(buffer_t *b) {    //* \label{thread5-consumer}
  char item;
  sem_wait(b->occupied);
  sem_wait(b->cmut);
  item = b->buf[b->nextout];
  b->nextout++;
  b->nextout %= BSIZE;
  sem_post(b->cmut);
  sem_post(b->empty);
  return(item);
}
