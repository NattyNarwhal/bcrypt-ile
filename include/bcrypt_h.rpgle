**FREE

/if defined(BCRYPTFREE)
/eof
/endif

/define BCRYPTFREE

///
// bcrypt service program
//
// This service program provides the OpenBSD implementation of the bcrypt
// hashing algorithm, and safe APIs to use it.
//
// @info These APIs are flexible, so if OpenBSD introduces new algorithms,
//       the API will automatically use them, while remaining backwards-
//       compatible.
//
// @info This uses free RPG features only available in IBM i 7.2 or newer, in
//       particular, it has automatic CCSID conversion of function arguments.
//       For usage with older versions of IBM i, you will have to adapt this
//       to older versions of RPG yourself or create a wrapper module/program;
//       patches are welcome to provide them.
//
// @info Please consult the OpenBSD manual for usage of these functions if the
//       header is unclear.
//
// @author Calvin Buckley
// @date 2019/11/02
// @project bcrypt-ile
///

///
// Verify password
//
// @param The plain-text password. Must be a zero-terminated UTF-8 string.
// @param The hash to verify against. Must be a zero-terminated UTF-8 string.
// @return Returns -1 on failure, 0 on success.
///
dcl-pr crypt_checkpass binary(4) extproc(*dclcase);
  password char(*) ccsid(*utf8) const;
  hash char(*) ccsid(*utf8) const;
end-pr;

///
// Create hash
//
// @param The plain-text password. Must be a zero-terminated UTF-8 string.
// @param The options to uses. Must be a zero-terminated UTF-8 string, or a
//        null pointer to use sane defaults.
// @param The hash to create. Will be a zero-terminated UTF-8 string.
// @param The size of the the buffer for hash.
// @return Returns -1 on failure, 0 on success.
///
dcl-pr crypt_newhash binary(4) extproc(*dclcase);
  password char(*) ccsid(*utf8) const;
  pref char(*) ccsid(*utf8) const;
  hash char(*) ccsid(*utf8);
  hashsize binary(4);
end-pr;
