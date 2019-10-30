/*
 * Copyright (c) 2019 Calvin Buckley <calvin@qseco.fr>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include <stdint.h>

/*
 * Please refer to OpenBSD documentation for how to effectively use these
 * functions. Generally, you will probably want to use crypt_checkpass and
 * crypt_newhash.
 *
 * Because the modules are compiled with UTF locale, they only work on UTF-8
 * C-style strings. Do not pass EBCDIC strings to these functions!
 */

#define _PASSWORD_LEN 128

char		*bcrypt_gensalt(uint8_t);
char		*bcrypt(const char *, const char *);
int		bcrypt_newhash(const char *, int, char *, size_t);
int		bcrypt_checkpass(const char *, const char *);

/* From unistd.h on OpenBSD */
int crypt_checkpass(const char *password, const char *hash);
int crypt_newhash(const char *password, const char *pref, char *hash, size_t hashsize);
char *crypt(const char *key, const char *setting);

