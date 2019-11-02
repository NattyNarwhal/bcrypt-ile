# bcrypt for ILE

Port of the OpenBSD C implementation, by request. Not throughly tested, but seems to work; ILE bcrypt generates hashes that verify on OpenBSD et vice versa. Please let me know if you run into or forsee issues.

## Usage

See the [OpenBSD manual page for `crypt_checkpass` and `crypt_newhash`](http://man.openbsd.org/crypt_checkpass.3) for how to use this.

Note that these APIs *must* take a UTF-8 null-terminated string.

## Build instructions

Edit Makefile to select the library you want to put files in, then run `make` from PASE to build it.

Tested on IBM i 7.2, targets as back as 6.1.

## Improvements to suggest

* Build system (this is hairy, uses PASE make, might not pass desires flags to ILE compilers and such)
* Security (security properties of ILE?)
* Ease of use (with RPG and the ilk)

PRs welcome.
