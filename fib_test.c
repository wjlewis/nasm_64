#include <stdio.h>
#include <inttypes.h>

int64_t fib(int64_t n);

int main(void) {
		for (int64_t n = 0; n < 20; n++) {
				printf("fib(%ld) = %ld\n", n, fib(n));
		}

		return 0;
}
