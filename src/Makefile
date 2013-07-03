$?EXTRACFLAGS=
OPT_CFLAGS:=-O0 -g
#OPT_CFLAGS:=-O4
XMLOBJ:= tinyxml2.o

main: $(XMLOBJ)
	cp "$(FLASCC)/usr/share/HTTPBackingStore.as" .
	"$(FLASCC)/usr/bin/genfs" --type=http res testres
	mv testres_manifest.as manifest.as
	
	$(AS3COMPILERARGS)	-import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/BinaryData.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/ISpecialFile.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/IBackingStore.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/IVFS.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/InMemoryBackingStore.abc) \
			-import $(call nativepath,$(FLASCC)/usr/lib/PlayerKernel.abc) \
			HTTPBackingStore.as -outdir . -out VFS
				
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

	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) main.c mathlib.c drawdef.c $(XMLOBJ) VFS.abc -symbol-abc=Console.abc -emit-swf -swf-version=17 -swf-size=800x600 -o main.swf $(EXTRACFLAGS)

tinyxml2.o : xml/tinyxml2.cpp
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) -c xml/tinyxml2.cpp
	
include ../../Makefile.common

clean:
	rm -f *.swf *.bc *.abc
