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
TESTMOD_NAME := BCRYPTTEST
TESTPGM_PATH := $(LIB_PATH)/$(TESTPGM_NAME).PGM
TESTMOD_PATH := $(LIB_PATH)/$(TESTMOD_NAME).MODULE
SAVF_NAME := BCRYPTDIST
SAVF_PATH := $(LIB_PATH)/$(SAVF_NAME).FILE

CRTCMOD_UTF8 := "localetype(*localeutf)"

CRTCMOD_OPTS := "output(*PRINT)" "tgtrls(V6R1M0)"
CRTSRVPGM_OPTS := "tgtrls(V6R1M0)"
CRTPGM_OPTS := "tgtrls(V6R1M0)"

ADDPFM := system addpfm
CALL := system call
CPYFRMSTMF := system cpyfrmstmf
CRTCMOD := system crtcmod $(CRTCMOD_OPTS)
CRTLIB := system crtlib
CRTPGM := system crtpgm $(CRTPGM_OPTS)
CRTSAVF := system crtsavf
CRTSRCPF := system crtsrcpf
CRTSRVPGM := system crtsrvpgm $(CRTSRVPGM_OPTS)
DLTOBJ := system dltobj
RMVM := system rmvm
SAVOBJ := system savobj

DEPS := include-private/blf.h include-private/bsdcompat.h include-private/bsdint.h include-private/pwd.h

.PHONY: all clean test dist

all: $(SRVPGM_PATH)

clean:
	$(DLTOBJ) "obj($(LIB_NAME)/BCRYPT)" "objtype(*MODULE)" || true
	$(DLTOBJ) "obj($(LIB_NAME)/BLOWFISH)" "objtype(*MODULE)" || true
	$(DLTOBJ) "obj($(LIB_NAME)/BSDCOMPAT)" "objtype(*MODULE)" || true
	$(DLTOBJ) "obj($(LIB_NAME)/CRYPT)" "objtype(*MODULE)" || true
	$(DLTOBJ) "obj($(LIB_NAME)/CRYPTUTIL)" "objtype(*MODULE)" || true
	$(DLTOBJ) "obj($(LIB_NAME)/$(TESTMOD_NAME))" "objtype(*MODULE)" || true 
	$(DLTOBJ) "obj($(LIB_NAME)/$(TESTPGM_NAME))" "objtype(*PGM)" || true 
	$(DLTOBJ) "obj($(LIB_NAME)/$(SRVPGM_NAME))" "objtype(*SRVPGM)" || true 
	$(DLTOBJ) "obj($(LIB_NAME)/$(EXPORTSPF_NAME))" "objtype(*FILE)" || true
	$(DLTOBJ) "obj($(LIB_NAME)/$(SAVF_NAME))" "objtype(*FILE)" || true

# Modules
$(LIB_PATH)/BCRYPT.MODULE: src/bcrypt.c $(DEPS)
	 $(CRTCMOD) "module($(LIB_NAME)/BCRYPT)" "srcstmf(\"src/bcrypt.c\")" $(CRTCMOD_UTF8)

$(LIB_PATH)/BLOWFISH.MODULE: src/blowfish.c $(DEPS)
	$(CRTCMOD) "module($(LIB_NAME)/BLOWFISH)" "srcstmf(\"src/blowfish.c\")" $(CRTCMOD_UTF8)

$(LIB_PATH)/BSDCOMPAT.MODULE: src/bsdcompat.c $(DEPS)
	$(CRTCMOD) "module($(LIB_NAME)/BSDCOMPAT)" "srcstmf(\"src/bsdcompat.c\")" $(CRTCMOD_UTF8)

$(LIB_PATH)/CRYPT.MODULE: src/crypt.c $(DEPS)
	$(CRTCMOD) "module($(LIB_NAME)/CRYPT)" "srcstmf(\"src/crypt.c\")" $(CRTCMOD_UTF8)

$(LIB_PATH)/CRYPTUTIL.MODULE: src/cryptutil.c $(DEPS)
	$(CRTCMOD) "module($(LIB_NAME)/CRYPTUTIL)" "srcstmf(\"src/cryptutil.c\")" $(CRTCMOD_UTF8)
# End modules

# Testing
test: $(TESTPGM_PATH)
	$(CALL) $(LIB_NAME)/$(TESTPGM_NAME) "parm('test')"

$(TESTPGM_PATH): $(SRVPGM_PATH) src/bcrypt-test.c $(DEPS)
	$(CRTCMOD) "module($(LIB_NAME)/$(TESTMOD_NAME))" "srcstmf(\"src/bcrypt-test.c\")"
	$(CRTPGM) "bndsrvpgm($(LIB_NAME)/$(SRVPGM_NAME))" "pgm($(LIB_NAME)/$(TESTPGM_NAME))" "module($(LIB_NAME)/$(TESTMOD_NAME))"
# End testing

# Service Program

$(SRVPGM_PATH): $(LIB_PATH) $(EXPORTSMBR_PATH) $(LIB_PATH)/BCRYPT.MODULE $(LIB_PATH)/BLOWFISH.MODULE $(LIB_PATH)/BSDCOMPAT.MODULE $(LIB_PATH)/CRYPT.MODULE $(LIB_PATH)/CRYPTUTIL.MODULE
	$(CRTSRVPGM) "export(*srcfile)" "srcfile($(LIB_NAME)/$(EXPORTSPF_NAME))" "srcmbr($(EXPORTSMBR_NAME))" "srvpgm($(LIB_NAME)/$(SRVPGM_NAME))" "module($(LIB_NAME)/BCRYPT $(LIB_NAME)/BLOWFISH $(LIB_NAME)/BSDCOMPAT $(LIB_NAME)/CRYPT $(LIB_NAME)/CRYPTUTIL)"

# XXX: This is unnecessary on IBM i 7.3, we could specify SRCSTMF above instead of having it in a library
$(EXPORTSMBR_PATH): $(EXPORTSPF_PATH) src/bcrypt.bnd
	# remove the member in case it exists already, ignoring if it doesn't exist
	$(RMVM) "file($(LIB_NAME)/$(EXPORTSPF_NAME))" "mbr($(EXPORTSMBR_NAME))" || true
	$(ADDPFM) "srctype(\"BND\")" "file($(LIB_NAME)/$(EXPORTSPF_NAME))" "mbr($(EXPORTSMBR_NAME))"
	$(CPYFRMSTMF) "fromstmf(\"src/bcrypt.bnd\")" "tombr(\"$(EXPORTSMBR_PATH)\")" "mbropt(*replace)"

$(EXPORTSPF_PATH):
	$(CRTSRCPF) "file($(LIB_NAME)/$(EXPORTSPF_NAME))" "rcdlen(112)"

# End service program

# Distribution

# XXX: Do we need to distribute anything else? C include file?
dist: $(SAVF_PATH)
	$(SAVOBJ) "savf($(LIB_NAME)/$(SAVF_NAME))" "objtype(*SRVPGM)" "lib($(LIB_NAME))" "obj($(SRVPGM_NAME))" "dev(*SAVF)"

$(SAVF_PATH): $(SRVPGM_PATH)
	$(DLTOBJ) "obj($(LIB_NAME)/$(SAVF_NAME))" "objtype(*FILE)" || true
	$(CRTSAVF) "file($(LIB_NAME)/$(SAVF_NAME))"

# End distribution

$(LIB_PATH):
	$(CRTLIB) "lib($(LIB_NAME))"

