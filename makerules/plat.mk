PLAT_ASFLAGA = __USE_GNU
PLAT_CCFLAGS = -DCONFIG_TARGET_CPU_${TARGET_CPU} -D_GNU_SOURCE -Wall -Wno-unused -Werror -O3 \
               -mcpu=cortex-a57 \
               -I${PORTING_INSTALL_DIR}/include \
               -I${PORTING_INSTALL_DIR}/include/freetype2 \
               -I${PLATFORM_RELEASE_DIRECTORY}/include

PLAT_LDFLAGS = -L${PORTING_INSTALL_DIR}/lib \
               -L${TOOLCHAIN_PATH}/lib \
               -L${PLATFORM_RELEASE_DIRECTORY}/lib \
               -lupgradeserver -lACE -larchive -lxml2 \
               -lmtd -litejpeg -li2c -lswosd -lfreetype -lexpat \
               -llzma -lz -lm -lpthread -lcrypto -ldl -lstdc++
