QSYS := /QSYS.LIB/
LIB_NAME := BCRYPTP
LIB_PATH := $(QSYS)$(LIB_NAME).LIB
EXPORTSPF_NAME := QSRVSRC
EXPORTSPF_PATH := $(LIB_PATH)/$(EXPORTSPF_NAME).FILE
EXPORTSMBR_NAME := BCRYPT
EXPORTSMBR_PATH := $(EXPORTSPF_PATH)/$(EXPORTSMBR_NAME).MBR
SRVPGM_NAME := BCRYPT
SRVPGM_PATH := $(LIB_PATH)/$(SRVPGM_NAME).SRVPGM
TESTPGM_NAME := BCRYPTTEST
TESTPGM_PATH := $(LIB_PATH)/$(TESTPGM_NAME).PGM
TESTMOD_PATH := $(LIB_PATH)/$(TESTPGM_NAME).MODULE

CRTCMOD_OPTS := "output(*PRINT)"

DEPS := include-private/blf.h include-private/bsdcompat.h include-private/bsdint.h include-private/pwd.h

.PHONY: all clean test

all: $(SRVPGM_PATH)

clean:
	system dltobj "obj($(LIB_NAME)/BCRYPT)" "objtype(*MODULE)" || true
	system dltobj "obj($(LIB_NAME)/BLOWFISH)" "objtype(*MODULE)" || true
	system dltobj "obj($(LIB_NAME)/BSDCOMPAT)" "objtype(*MODULE)" || true
	system dltobj "obj($(LIB_NAME)/CRYPT)" "objtype(*MODULE)" || true
	system dltobj "obj($(LIB_NAME)/CRYPTUTIL)" "objtype(*MODULE)" || true
	system dltobj "obj($(LIB_NAME)/$(TESTPGM_NAME))" "objtype(*MODULE)" || true 
	system dltobj "obj($(LIB_NAME)/$(TESTPGM_NAME))" "objtype(*PGM)" || true 
	system dltobj "obj($(LIB_NAME)/$(SRVPGM_NAME))" "objtype(*SRVPGM)" || true 
	system dltobj "obj($(LIB_NAME)/$(EXPORTSPF_NAME))" "objtype(*FILE)" || true

# Modules
$(LIB_PATH)/BCRYPT.MODULE: src/bcrypt.c $(DEPS)
	system crtcmod "module($(LIB_NAME)/BCRYPT)" "srcstmf(\"src/bcrypt.c\")" "localetype(*LOCALEUTF)" $(CRTCMOD_OPTS)

$(LIB_PATH)/BLOWFISH.MODULE: src/blowfish.c $(DEPS)
	system crtcmod "module($(LIB_NAME)/BLOWFISH)" "srcstmf(\"src/blowfish.c\")" "localetype(*LOCALEUTF)" $(CRTCMOD_OPTS)

$(LIB_PATH)/BSDCOMPAT.MODULE: src/bsdcompat.c $(DEPS)
	system crtcmod "module($(LIB_NAME)/BSDCOMPAT)" "srcstmf(\"src/bsdcompat.c\")" "localetype(*LOCALEUTF)" $(CRTCMOD_OPTS)

$(LIB_PATH)/CRYPT.MODULE: src/crypt.c $(DEPS)
	system crtcmod "module($(LIB_NAME)/CRYPT)" "srcstmf(\"src/crypt.c\")" "localetype(*LOCALEUTF)" $(CRTCMOD_OPTS)

$(LIB_PATH)/CRYPTUTIL.MODULE: src/cryptutil.c $(DEPS)
	system crtcmod "module($(LIB_NAME)/CRYPTUTIL)" "srcstmf(\"src/cryptutil.c\")" "localetype(*LOCALEUTF)" $(CRTCMOD_OPTS)

# End modules

test: $(TESTPGM_PATH)
	echo "Making a hash of password"
	system call $(LIB_NAME)/$(TESTPGM_NAME) "parm(test)"

$(TESTPGM_PATH): $(SRVPGM_PATH) src/bcrypt-test.c $(DEPS)
	system crtcmod "module($(LIB_NAME)/$(TESTPGM_NAME))" "srcstmf(\"src/bcrypt-test.c\")" $(CRTCMOD_OPTS)
	system crtpgm "bndsrvpgm($(LIB_NAME)/$(SRVPGM_NAME))" "pgm($(LIB_NAME)/$(TESTPGM_NAME))" "module($(LIB_NAME)/$(TESTPGM_NAME))"

$(SRVPGM_PATH): $(LIB_PATH) $(EXPORTSMBR_PATH) $(LIB_PATH)/BCRYPT.MODULE $(LIB_PATH)/BLOWFISH.MODULE $(LIB_PATH)/BSDCOMPAT.MODULE $(LIB_PATH)/CRYPT.MODULE $(LIB_PATH)/CRYPTUTIL.MODULE
	system crtsrvpgm "export(*srcfile)" "srcfile($(LIB_NAME)/$(EXPORTSPF_NAME))" "srcmbr($(EXPORTSMBR_NAME))" "srvpgm($(LIB_NAME)/$(SRVPGM_NAME))" "module($(LIB_NAME)/BCRYPT $(LIB_NAME)/BLOWFISH $(LIB_NAME)/BSDCOMPAT $(LIB_NAME)/CRYPT $(LIB_NAME)/CRYPTUTIL)"

$(EXPORTSMBR_PATH): $(EXPORTSPF_PATH) src/bcrypt.bnd
	system addpfm "srctype(\"BND\")" "file($(LIB_NAME)/$(EXPORTSPF_NAME))" "mbr($(EXPORTSMBR_NAME))"
	system cpyfrmstmf "fromstmf(\"src/bcrypt.bnd\")" "tombr(\"$(EXPORTSMBR_PATH)\")" "mbropt(*replace)"

$(EXPORTSPF_PATH):
	system crtsrcpf "file($(LIB_NAME)/$(EXPORTSPF_NAME))" "rcdlen(112)"

$(LIB_PATH):
	system crtlib "lib($(LIB_NAME))"

