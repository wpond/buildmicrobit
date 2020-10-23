-include /input/makefile.conf


INPUT_CS = $(patsubst %, /input/%, $(CS))
INPUT_INC_DIRS = $(patsubst %, -I/input/%, $(INC_DIRS))


SYSTEM_C = /workdir/toolchain/system_nrf51.c
SYSTEM_OBJ = $(SYSTEM_C:.c=.o)

ELF = output.elf
BIN = output.bin
OUTPUT = /output/${BIN}

START = /workdir/toolchain/gcc/gcc_startup_nrf51.S

C_OBJS = ${INPUT_CS:.c=.o}
START_OBJ = ${START:.S=.o}

CC = arm-none-eabi-gcc
CC_FLAGS  = -c -fno-common -Os -g -mcpu=cortex-m0 -mthumb -Wall 
CC_FLAGS += -ffunction-sections -fdata-sections -fno-builtin 
CC_FLAGS += -L/workdir/toolchain/gcc -I/workdir/toolchain/gcc
CC_FLAGS += -I/workdir/toolchain -I/workdir/toolchain/cmsis/include
CC_FLAGS += -Wno-unused-function -ffreestanding -I/workdir/include -DNRF51
CC_FLAGS += ${INPUT_INC_DIRS}

LD_FILE = nrf51_xxaa.ld

LD = arm-none-eabi-g++
LD_FLAGS  = -nostartfiles -Wl,--gc-sections -L/workdir/toolchain/gcc
LD_FLAGS += -T${LD_FILE}

OBJCOPY = arm-none-eabi-objcopy
OBJCOPY_FLAGS = -O binary

SRCS = ${INPUT_CS} ${SYSTEM_C} ${START}
OBJS = ${START_OBJ} ${C_OBJS} ${SYSTEM_OBJ}

.phony: build clean init

build: ${OUTPUT}

init: ${START_OBJ} ${SYSTEM_OBJ}

${OUTPUT}: ${BIN}
	cp ${BIN} ${OUTPUT}

clean:
	rm -f ${BIN} ${ELF} ${OBJS} ${OUTPUT}

${ELF}: ${OBJS} ${START_OBJ}
	${LD} ${LD_FLAGS} -o ${ELF} ${OBJS}

${BIN}: ${ELF}
	${OBJCOPY} ${OBJCOPY_FLAGS} ${ELF} ${BIN}

%.o: %.c
	${CC} ${CC_FLAGS} -o $@ $<

%.o: %.S
	${CC} ${CC_FLAGS} -o $@ $<
