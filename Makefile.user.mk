ifneq (,$(DEBUGMAKE))
$(info ## ====================================================================)
$(info ## File: $$rpnpy/Makefile.user.mk)
$(info ## )
endif
#VERBOSE=1

ATM_MODEL_ISOFFICIAL := true
RBUILD_EXTRA_OBJ0    := 

COMPONENTS        := rpnpy
COMPONENTS_UC     := $(foreach item,$(COMPONENTS),$(call rdeuc,$(item)))
COMPONENTS_VFILES := $(foreach item,$(COMPONENTS_UC),$($(item)_VFILES))

MODULES_DOCTESTS := $(ROOT)/lib/Fstdc.py $(ROOT)/lib/rpnstd.py $(ROOT)/lib/rpnpy/rpndate.py $(ROOT)/lib/rpnpy/librmn/base.py $(ROOT)/lib/rpnpy/librmn/fstd98.py  $(ROOT)/lib/rpnpy/librmn/interp.py $(ROOT)/lib/rpnpy/librmn/grids.py
MODULES_TESTS    := $(wildcard $(ROOT)/share/tests/test_*.py)

#------------------------------------

MYSSMINCLUDEMK = $(wildcard $(RDE_INCLUDE0)/Makefile.ssm.mk $(rpnpy)/include/Makefile.ssm.mk)
ifneq (,$(MYSSMINCLUDEMK))
   ifneq (,$(DEBUGMAKE))
      $(info include $(MYSSMINCLUDEMK))
   endif
   include $(MYSSMINCLUDEMK)
endif

#------------------------------------

.PHONY: components_vfiles
components_vfiles: $(COMPONENTS_VFILES)


.PHONY: components_objects
components_objects: $(COMPONENTS_VFILES) $(OBJECTS)


.PHONY: components_libs
COMPONENTS_LIBS_FILES = $(foreach item,$(COMPONENTS_UC),$($(item)_LIBS_ALL_FILES_PLUS))
components_libs: $(COMPONENTS_VFILES) $(OBJECTS) $(COMPONENTS_LIBS_FILES)
	ls -l $(COMPONENTS_LIBS_FILES)
	ls -lL $(COMPONENTS_LIBS_FILES)


COMPONENTS_ABS  := $(foreach item,$(COMPONENTS_UC),$($(item)_ABS))
COMPONENTS_ABS_FILES  := $(foreach item,$(COMPONENTS_UC),$($(item)_ABS_FILES))
.PHONY: components_abs components_abs_check
components_abs: $(COMPONENTS_ABS)
	ls -l $(COMPONENTS_ABS_FILES)


COMPONENTS_SSM_ALL  := $(foreach item,$(COMPONENTS_UC),$($(item)_SSMALL_FILES))
COMPONENTS_SSM_ARCH := $(foreach item,$(COMPONENTS_UC),$($(item)_SSMARCH_FILES))
COMPONENTS_SSM := $(COMPONENTS_SSM_ALL) $(COMPONENTS_SSM_ARCH)
.PHONY: components_ssm
components_ssm: $(COMPONENTS_VFILES) $(COMPONENTS_SSM)
components_ssm_all: $(COMPONENTS_VFILES) $(COMPONENTS_SSM_ALL)
components_ssm_arch: $(COMPONENTS_VFILES) $(COMPONENTS_SSM_ARCH)


COMPONENTS_INSTALL_ALL := $(foreach item,$(COMPONENTS_UC),$($(item)_INSTALL))
COMPONENTS_UNINSTALL_ALL := $(foreach item,$(COMPONENTS_UC),$($(item)_UNINSTALL))
.PHONY: components_install components_uninstall
components_install: $(COMPONENTS_INSTALL_ALL)
components_uninstall: $(COMPONENTS_UNINSTALL_ALL)


#------------------------------------
doctests:
	echo -e "\n======= PY-DocTest List ========\n" ; \
	for i in $(MODULES_DOCTESTS); \
	do echo -e "\n==== PY-DocTest: " $$i "====\n"; python $$i ;\
	done

unittests: 
	echo -e "\n======= PY-UnitTest List ========\n" ; \
	for i in $(MODULES_TESTS); \
	do echo -e "\n==== PY-UnitTest: " $$i "====\n"; python $$i ;\
	done

alltests: doctests unittests

alldoc:
	cd $(ROOT) ;\
	mkdir doc 2>/dev/null ;\
	./bin/pydoc2wiki.py

ifneq (,$(DEBUGMAKE))
$(info ## ==== $$rpnpy/Makefile.user.mk [END] ================================)
endif
