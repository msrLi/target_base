# (c) binsonLi add 

include ${PLATFORM_PATH}/makerules/Rules.make

all: help libs

help:
	@echo  "libs:    build all platform libs"
	@echo  "libs_clean clean all platform libs"

libs:
	echo ${PLATFORM_PATH}
	@echo compare com libs 
	make -C common_libs/osal

clean:
	rm -rf ${PLATFORM_PATH}/out

.PHONY:all help libs
