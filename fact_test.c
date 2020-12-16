#include <stdio.h>
#include <inttypes.h>

int64_t fact(int64_t n);

int main(void) {
		for (int64_t n = 0; n < 10; n++) {
				printf("%ld! = %ld\n", n, fact(n));
		}

		return 0;
}
