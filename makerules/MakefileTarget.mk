# (c) Itarge.Inc

include Rules.make

all: uboot lsp
clean: uboot_clean lsp_clean 

help:
	@echo  "uboot:          uboot"
	@echo  "lsp:            lsp"
	@echo  "uboot_clean:    clean uboot"
	@echo  "lsp_clean:      clean lsp"

uboot:
	echo "runing uboot"
test:
	# Build the binary for factory without encryt it
	# Build the Second stage u-boot
	rm -rf ${UBOOT_BUILD_OBJ_PATH}
	mkdir -p ${UBOOT_BUILD_OBJ_PATH} 
	make -C ${UBOOT_PATH} O=${UBOOT_BUILD_OBJ_PATH} ARCH=arm p2371-2180_defconfig
	echo " " > ${UBOOT_BUILD_OBJ_PATH}/tmp_ite.h
	make -C ${UBOOT_PATH} O=${UBOOT_BUILD_OBJ_PATH} ARCH=arm CROSS_COMPILE=${COMPILE_64BIT_PREFIX}
	cp -af ${UBOOT_BUILD_OBJ_PATH}/tools/mkimage ${PLATFORM_RELEASE_DIRECTORY}/utils
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${UBOOT_RELEASE_VERSION} -d \
		${UBOOT_BUILD_OBJ_PATH}/u-boot-dtb.bin ${PLATFORM_UBOOT_TARGET_DIRECTORY}/u-boot.itarge
	# Build the First stage u-boot
	rm -rf ${UBOOT_BUILD_OBJ_PATH}
	mkdir -p ${UBOOT_BUILD_OBJ_PATH} 
	make -C ${UBOOT_PATH} O=${UBOOT_BUILD_OBJ_PATH} ARCH=arm p2371-2180_defconfig
	echo "#define CONFIG_ITARGE_FIRST_STAGE" > ${UBOOT_BUILD_OBJ_PATH}/tmp_ite.h
	echo "#define CONFIG_ITE_FORCE_COLD_REBOOT" >> ${UBOOT_BUILD_OBJ_PATH}/tmp_ite.h
	make -C ${UBOOT_PATH} O=${UBOOT_BUILD_OBJ_PATH} ARCH=arm CROSS_COMPILE=${COMPILE_64BIT_PREFIX}
	cp -af ${UBOOT_BUILD_OBJ_PATH}/u-boot ${PLATFORM_UBOOT_TARGET_DIRECTORY}/u-boot
	cp -af ${UBOOT_BUILD_OBJ_PATH}/u-boot-dtb.bin ${PLATFORM_UBOOT_TARGET_DIRECTORY}/u-boot.bin
	mkdir -p ${PLATFORM_RELEASE_DIRECTORY}/utils
	cp -af ${UBOOT_BUILD_OBJ_PATH}/tools/ite_mkimage ${PLATFORM_RELEASE_DIRECTORY}/utils/
	cp -af ${UBOOT_BUILD_OBJ_PATH}/tools/ite_unpack ${PLATFORM_RELEASE_DIRECTORY}/utils/
	rm -rf ${UBOOT_BUILD_OBJ_PATH}/tmp_ite.h
	
lsp:
	rm -rf ${KERNEL_BUILD_OBJ_PATH}
	mkdir -p ${KERNEL_BUILD_OBJ_PATH}
	make -C ${KERNEL_PATH} O=${KERNEL_BUILD_OBJ_PATH} ARCH=arm64 CROSS_COMPILE=${COMPILE_64BIT_PREFIX} tegra_t210ref_gnu_linux_defconfig
	make -C ${KERNEL_PATH} O=${KERNEL_BUILD_OBJ_PATH} ARCH=arm64 CROSS_COMPILE=${COMPILE_64BIT_PREFIX} -j8
	make -C ${KERNEL_PATH} O=${KERNEL_BUILD_OBJ_PATH} ARCH=arm64 CROSS_COMPILE=${COMPILE_64BIT_PREFIX} modules -j8
	make -C ${KERNEL_PATH} O=${KERNEL_BUILD_OBJ_PATH} ARCH=arm64 CROSS_COMPILE=${COMPILE_64BIT_PREFIX} \
		 INSTALL_MOD_PATH={PLATFORM_RELEASE_DIRECTORY}/rootfs modules_install 
	#cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/Image  ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/kernel/Image
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/Image ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/kernel/Image.itarge
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/Image  ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/kernel/Image_default
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-* ${PLATFORM_KERNEL_TARGET_DIRECTORY}/dtb/
	#cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-ydf.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-00.dtb
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-medical-24x7.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-01
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-meye-24x7.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-02
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-oled-24x7.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-03
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-teye-mipi-24x7.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-04
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-teye-pcie-24x7.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-05
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-two-eye-mipi-24x7.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-06
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-two-eye-pcie-24x7.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-07
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n ${KERNEL_RELEASE_VERSION} -d \
		${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-teye-mipi-24x7.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-default
lsp_cpy:
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-medical.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-01.dtb
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-meye.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-02.dtb
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-oled.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-03.dtb
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-teye-mipi.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-04.dtb
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-teye-pcie.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-05.dtb
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-two-eye-mipi.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-06.dtb
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-two-eye-pcie.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-07.dtb
	cp -af ${KERNEL_BUILD_OBJ_PATH}/arch/arm64/boot/dts/tegra210-jetson-tx1-itarge-teye-mipi.dtb ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-default.dtb

libs:
	make -C platform_libs

package:
	#复制库以及应用程序到文件系统中
	${PLATFORM_RELEASE_DIRECTORY}/utils/do.cp
	${PLATFORM_RELEASE_DIRECTORY}/utils/do.make_increment_rootfs
	#@echo  "There is no need to compile the package for TX1"
	rm -rf ${PACKAGE_BUILE_OBJ_PATH}
	mkdir -p ${PACKAGE_BUILE_OBJ_PATH}
	cp -af ${PLATFORM_UBOOT_TARGET_DIRECTORY}/u-boot.itarge ${PACKAGE_BUILE_OBJ_PATH}/emmc_uboot.itarge
	cp -af ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/kernel/Image.itarge ${PACKAGE_BUILE_OBJ_PATH}/emmc_Image.itarge
	cp -af ${PLATFORM_KERNEL_TARGET_DIRECTORY}/itarge/dtb/tx1-itarge-dtb-default ${PACKAGE_BUILE_OBJ_PATH}/emmc_dtb.itarge
	cd ${PACKAGE_BUILE_OBJ_PATH}/; \
	${PLATFORM_RELEASE_DIRECTORY}/utils/ite_mkimage -m 1000 -f emmc_uboot.itarge emmc_Image.itarge emmc_dtb.itarge tx1-upgrade.bin
	cp -af ${PACKAGE_BUILE_OBJ_PATH}/tx1-upgrade.bin ${PLATFORM_RELEASE_DIRECTORY}/product_packages/TX1_EMMC_UPGRADE_${PLATFORM_RELEASE_VERSION}.bin
package_all:package
	- cd ${PLATFORM_RELEASE_DIRECTORY}/factory_tools/Linux_for_Tegra; \
		 ./flash.sh -k EBT jetson-tx1 mmcblk0p12;
	${PLATFORM_RELEASE_DIRECTORY}/utils/mkimage -A arm64 -O linux -T firmware -C none -a 0x0 -e 0x0 -n '${KERNEL_RELEASE_VERSION}' -d \
		${PLATFORM_RELEASE_DIRECTORY}/factory_tools/Linux_for_Tegra/bootloader/signed/u-boot.bin.encrypt ${PLATFORM_UBOOT_TARGET_DIRECTORY}/emmc_ubl.itarge
	cp -af ${PLATFORM_UBOOT_TARGET_DIRECTORY}/emmc_ubl.itarge ${PACKAGE_BUILE_OBJ_PATH}/
	cd ${PACKAGE_BUILE_OBJ_PATH}/; \
	${PLATFORM_RELEASE_DIRECTORY}/utils/ite_mkimage -m 1000 -f emmc_ubl.itarge emmc_uboot.itarge emmc_Image.itarge emmc_dtb.itarge tx1-upgrade-all.bin
	cp -af ${PACKAGE_BUILE_OBJ_PATH}/tx1-upgrade-all.bin ${PLATFORM_RELEASE_DIRECTORY}/product_packages/TX1_EMMC_UPGRADE_${PLATFORM_RELEASE_VERSION}_ALL.bin

uboot_clean:
	#make -C ${UBOOT_PATH} O=${UBOOT_BUILD_OBJ_PATH} distclean
	rm -rf ${UBOOT_BUILD_OBJ_PATH}

lsp_clean:
	#make -C ${KERNEL_PATH} O=${KERNEL_BUILD_OBJ_PATH} distclean
	rm -rf ${KERNEL_BUILD_OBJ_PATH} 

libs_clean:
	make -C platform_libs clean
