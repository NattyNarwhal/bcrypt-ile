# bcrypt for ILE

Port of the OpenBSD C implementation, by request.

## Usage

See the [OpenBSD manual page for `crypt_checkpass` and `crypt_newhash`](http://man.openbsd.org/crypt_checkpass.3) for how to use this.

Note that these APIs *must* take a UTF-8 null-terminated string.

## Build instructions

Edit Makefile to select the library you want to put files in, then run `make` from PASE to build it.

Tested on IBM i 7.2.
