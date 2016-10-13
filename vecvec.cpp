#include <stdio.h>
int main(int argc, char *argv[])
{
    const int N = 100;
    double x[N];
    double y[N];

    /* initialization */

    for (int i=0; i<N; i++) {
	x[i] = (double) i;
	y[i] = (double) i;
    }

    /* compute inner product */

    double sum = 0.0;
    for (int i=0; i<N; i++) {
	sum += x[i]*y[i];
    }
    printf("inner product x.y = %f\n", sum);
}
