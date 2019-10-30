#include "bsdint.h"

#define _PASSWORD_LEN 128

char		*bcrypt_gensalt(u_int8_t);
char		*bcrypt(const char *, const char *);
int		bcrypt_newhash(const char *, int, char *, size_t);
int		bcrypt_checkpass(const char *, const char *);

/* Internal usage */
int _bcrypt_autorounds(void);

/* From unistd.h on OpenBSD */
int crypt_checkpass(const char *password, const char *hash);
int crypt_newhash(const char *password, const char *pref, char *hash, size_t hashsize);
char *crypt(const char *key, const char *setting);

