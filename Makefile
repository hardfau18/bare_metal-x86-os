BUILD_DIR=${PWD}/build/
QEMU_ARGS=--nographic --serial mon:stdio

ifdef DEBUG
	QEMU_ARGS += -d in_asm -D log
endif

ifdef GDB
	QEMU_ARGS += -S -s
endif

.PHONY: clean bin run

bin: ${BUILD_DIR}/boot.bin
	@echo ============all done==================

run: ${BUILD_DIR}/boot.bin
	qemu-system-x86_64 $< ${QEMU_ARGS}

clean:
	@rm -rf ${BUILD_DIR}

${BUILD_DIR}/boot.bin: ${BUILD_DIR}/boot.o | ${BUILD_DIR}
	@ld -e entry --oformat binary $< -o $@ --fatal-warnings

${BUILD_DIR}/boot.o: src/boot.s | ${BUILD_DIR}
	@as -mx86-used-note=no -o $@ $<

${BUILD_DIR}:
	@mkdir $@
