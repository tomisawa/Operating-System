#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/time.h> //* \label{thread1-time.h}
#define N 1000 //* \label{thread1-N}

int sum; //* \label{thread1-sum}

int fun(int id) //* \label{thread-fun}
{
  for (int  i=0 ; i < N ; i++ ) {
    sum = sum + 1; //* \label{thread1-critical-region}
    printf( "%d", id) ; //* \label{thread1-print}
    fflush(stdout);//* \label{thread1-fflush}
  }
  return sum;
}

int main(void) {
  long dt; //* \label{thread1-dt}
  struct timeval tp[2];  //* \label{thread1-timeval}
  pthread_t t0,t1 ; //* \label{thread1-t}
  void *thread0_return,*thread1_return; //* \label{thread1-return}

  sum=0;

  gettimeofday(&tp[0], NULL);　//* \label{thread1-start}

  pthread_create( &t0, NULL, (void *)fun,  (void *)0) ; //* \label{thread2-t0}
  pthread_create( &t1, NULL, (void *)fun,  (void *)1) ; //* \label{thread2-t1}


  pthread_join(t0, &thread0_return);  //* \label{thread0-join}
  pthread_join(t1, &thread1_return);  //* \label{thread1-join}

  printf("\nthread0_return=%d\n",(int)thread0_return ); //* \label{thread0-return}
  printf("\nthread1_return=%d\n",(int)thread1_return ); //* \label{thread1-return}

  gettimeofday(&tp[1], NULL); //* \label{thread1-end}
  dt = (tp[1].tv_sec - tp[0].tv_sec) * 1000000 //* \label{calc-execute0}
  + (tp[1].tv_usec - tp[0].tv_usec);
  if (dt % 10000 == 0) {
    printf("\n%ld usec (suspsect this is not high-resolution timer)\n", dt);
  } else {
    printf("\n%ld usec\n", dt);
  };//* \label{calc-execute1}

  printf("\nsum=%d\n",sum);　//* \label{thread1-print-sum}

  exit(0);

}
