#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>

#define FUNCNUM 3

typedef void (*func_t)(int arg);

struct {
    int active;
    func_t func;
    jmp_buf context;
} func[FUNCNUM], *current;

void func_change();
void func_end();

void func1(int arg)
{
    printf("%d", arg);
    printf("A");
    func_change();
    func_change();
    printf("B");
}

void func2(int arg)
{
    printf("%d", arg);
    func_change();
    printf("C");
    func_change();
    printf("D");
    func_change();
    printf("E");
    func_change();
    printf("F");
}

void func3(int arg)
{
    printf("%d", arg);
    printf("G");
    func_change();
    printf("H");
    func_end();
    printf("I");
}

func_t func_tbl[] = { func1, func2, func3 };

void schedule()
{
    static int n = 0;
    int i;
    for (i = 0; i < FUNCNUM; i++) {
        n = (n + 1) % FUNCNUM;
        current = &func[n];
        if (current->active) {
            longjmp(current->context, 1);
        }
    }
    exit(0);
}

void func_change()
{
    if (setjmp(current->context) == 0)
        schedule();
}

void func_end()
{
    current->active = 0;
    schedule();
}

void func_start(int arg)
{
    current->func(arg);
    func_end();
}

void func_create()
{
    char stack[1024];
    static int n = 0;
    
    if (n == FUNCNUM)
        schedule();
    
    memset(&stack, 0, sizeof(stack));
    func[n].active = 1;
    func[n].func = func_tbl[n];
    if (setjmp(func[n].context))
        func_start(n);
    n++;
    func_create();
}

int main()
{
    memset(func, 0, sizeof(func));
    func_create();
    return 0;
}
