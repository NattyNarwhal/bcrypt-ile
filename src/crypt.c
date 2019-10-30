/*	$OpenBSD: crypt.c,v 1.31 2015/09/12 14:56:50 guenther Exp $	*/

#include "../include-private/bsdcompat.h"
#include <errno.h>
#include "../include-private/pwd.h"
#include <unistd.h>

char *
crypt(const char *key, const char *setting)
{
#pragma convert(1208)
	if (setting[0] == '$') {
		switch (setting[1]) {
		case '2':
			return bcrypt(key, setting);
		default:
			errno = EINVAL;
			return (NULL);
		}
	}
	errno = EINVAL;
	return (NULL);
#pragma convert(0)
}
DEF_WEAK(crypt);

