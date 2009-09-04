MAKE=make

include Makefile_base
include Makefile_$(ARCH)

BASEDIR=$(PWD)

MYDYN = jim
COMPONENTS = utils $(MYDYN)
FTNALLSRC = utils/*.ftn90 $(MYDYN)/*.ftn90 utils/*.hf $(MYDYN)/*.hf
FTNALLOBJ = utils/*.o $(MYDYN)/*.o

COMM     =
OTHERS   =  $(RPNCOMM) lapack blas massvp4 bindcpu_002 $(LLAPI) $(IBM_LD)
#LIBS     = $(MODEL) $(V4D) $(PHY) $(PATCH) $(CHM) $(CPL) $(OTHERS)
LIBS     = $(OTHERS)

INSTALLDIR= $(HOME)/ovbin/python/lib.linux-i686-2.4-dev

default: all

slib: all
	r.build \
	  -obj $(FTNALLOBJ) \
	  -shared \
	  -librmn $(RMNLIBSHARED) \
	  -o jim.so

all:
	for i in $(COMPONENTS); \
	do cd $$i ; $(MAKE) all ; cd .. ;\
	done ;\
	python setup.py build

install:
	cp build/lib.linux-i686-2.4/* $(INSTALLDIR)

clean:
	rm -rf build; \
	for i in $(COMPONENTS); \
	do \
	cd $$i ; $(MAKE) clean0 ; cd .. ;\
	done
	/bin/rm -f mec_$(MYDYN)_$(EC_ARCH).Abs

tags: clean
	rm -f tags TAGS
	list='$(FTNALLSRC)'; \
	for myfile in $$list; do \
		etags --language=fortran --defines --append $$myfile ; \
		ctags --language=fortran --defines --append $$myfile ; \
	done
