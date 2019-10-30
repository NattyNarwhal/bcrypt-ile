/* Compatibility stubs for OpenBSD on XPF (internal to bcrypt impl) */
#ifndef _BSDCOMPAT_H
#define _BSDCOMPAT_H
/* Numeric types */
#include "bsdint.h"

/* Linkage */
#define DEF_WEAK(x)

/* XXX: VERY BAD NO GOOD! ACTUALLY IMPLEMENT A REAL IMPLEMENTATION! */
void explicit_bzero(void *buf, size_t len);
int timingsafe_bcmp(const void *b1, const void *b2, size_t n);

void arc4random_buf(void*, size_t);

/* Horrible implementation */
#define CLOCK_THREAD_CPUTIME_ID 0

#include <time.h>
int clock_gettime(int clk_id, struct timespec *tp);

/* And an OK one */
long long strtonum(const char *numstr, long long minval, long long maxval, const char **errstrp);
#endif
