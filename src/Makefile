$?EXTRACFLAGS=
OPT_CFLAGS:=-O0 -g
#OPT_CFLAGS:=-O4
XMLOBJ:= tinyxml2.o

main: $(XMLOBJ) mathlib.o drawdef.o drawutils.o Console.abc
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) main.c mathlib.o drawdef.o drawutils.o $(XMLOBJ)  VFS.abc $(FLASCC)/usr/lib/AlcVFSZip.abc -symbol-abc=Console.abc -emit-swf -swf-version=17 -swf-size=800x600 -o main.swf $(EXTRACFLAGS)

exe:
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) $(XMLOBJ) tinyxmltest.c -o testxml.exe
	
Console.abc: Console.as
	"$(FLASCC)/usr/bin/genfs" res testres
	cp "$(FLASCC)/usr/share/LSOBackingStore.as" .
	
	$(AS3COMPILERARGS)	-import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/BinaryData.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/ISpecialFile.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/IBackingStore.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/IVFS.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/InMemoryBackingStore.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/PlayerKernel.abc) \
			testresRootFSBackingStore.as -outdir . -out VFS
			
	$(AS3COMPILERARGS) -strict -AS3 \
		-import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
		-import $(call nativepath,$(FLASCC)/usr/lib/CModule.abc) \
		-import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
		-import $(call nativepath,$(FLASCC)/usr/lib/BinaryData.abc) \
		-import $(call nativepath,$(FLASCC)/usr/lib/ISpecialFile.abc) \
		-import $(call nativepath,$(FLASCC)/usr/lib/IBackingStore.abc) \
		-import $(call nativepath,$(FLASCC)/usr/lib/IVFS.abc) \
		-import $(call nativepath,$(FLASCC)/usr/lib/InMemoryBackingStore.abc) \
		-import $(call nativepath,$(FLASCC)/usr/lib/PlayerKernel.abc) \
		-import VFS.abc \
		Console.as -outdir . -out Console
	
tinyxml2.o: xml/tinyxml2.cpp
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) -c xml/tinyxml2.cpp
	 @echo built for tinyxml2.h

mathlib.o: mathlib.c
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) -c mathlib.c
	@echo built for mathlib.h

drawdef.o: drawdef.c
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) -c drawdef.c
	@echo built for drawdef.h
	
drawutils.o: drawutils.c
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) -c drawutils.c
	@echo built for drawutils.h

include ../../Makefile.common

clean:
	rm -f *.swf *.bc *.abc *.o LSOBackingStore.as testresRootFSBackingStore.as *.exe
