PLAT_ASFLAGA = __USE_GNU
PLAT_CCFLAGS = -DCONFIG_TARGET_CPU_${TARGET_CPU} -D_GNU_SOURCE -std=c++11 -Wall -Wno-unused -Werror -O3 


PLAT_LDFLAGS = -L${PORTING_INSTALL_DIR}/lib \
			   -lz -lpthread





