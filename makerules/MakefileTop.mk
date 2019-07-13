# (c) binsonLi add 


all: help libs

help:
	@echo  "libs:    build all platform libs"
	@echo  "libs_clean clean all platform libs"

libs:
	@echo compare com libs 
	make -C common_libs/osal 


.PHONY:all help libs
