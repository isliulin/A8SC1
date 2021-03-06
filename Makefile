CC = arm-hisiv300-linux-gcc
LD = arm-hisiv300-linux-ld
INCLUDE := -I ./
INCLUDE += -I ./hi_common
INCLUDE += -I ./common
INCLUDE += -I ./hi_include
CC_FLAGS :=   $(INCLUDE)
LD_SHARE := -L ./common_lib
LD_SHARE += -L ./hi_lib


HIARCH?=hi3518
LIBC?=uclibc
HIDBG?=HI_DEBUG
CHIP_ID ?= CHIP_HI3518E_V200
SENSOR_TYPE ?= SONY_IMX222_DC_1080P_30FPS
CC_FLAGS += -DCHIP_ID=$(CHIP_ID) -DSENSOR_TYPE=$(SENSOR_TYPE)
TAG = room_app
LIBS = -lpthread -lrt -lm -lcurl -lsqlite3

MPI_LIBS += ./hi_lib/libive.so
MPI_LIBS += ./hi_lib/libisp.so
MPI_LIBS += ./hi_lib/lib_hiawb.so
MPI_LIBS += ./hi_lib/libsns_imx222.so
MPI_LIBS += ./hi_lib/lib_hidefog.so
MPI_LIBS += ./hi_lib/lib_hiaf.so
MPI_LIBS += ./hi_lib/lib_hiae.so
MPI_LIBS += ./hi_lib/libmpi.so 
MPI_LIBS += ./hi_lib/libdnvqe.so 
MPI_LIBS += ./hi_lib/libVoiceEngine.so 
MPI_LIBS += ./hi_lib/libupvqe.so 






COMMON	  := $(shell pwd)/common
HI_COMMON := $(shell pwd)/hi_common
WATCHDOG  := $(shell pwd)/watchdog
WAVPLAY   := $(shell pwd)/wavPlay
COUURENT_PATH = $(shell pwd)
#将common目录下的所有点c文件名(包括路径)放到SRC中
SRC  :=  $(wildcard $(COMMON)/*.c)
SRC  +=  $(wildcard $(HI_COMMON)/*.c)
SRC  +=  $(wildcard $(WATCHDOG)/*.c)
SRC  +=  $(wildcard $(WAVPLAY)/*.c)
#将当前目录下的所有点c文件名追加到SRC中
SRC  +=  $(wildcard $(COUURENT_PATH)/*.c)
#去掉路径只留文件名存到SRC_FILE中
SRC_FILE:= $(notdir $(SRC))
OUTPUT_DIR = $(shell pwd)/output
#将SRC包含的所有点c文件 转换成相应的点o文件 再存放到OBJS中
OBJS := $(SRC:%.c=%.o)
#将SRC_FILE包含的所有点c文件 转换成相应的点o文件 再存放到OBJS_FILE中
OBJS_FILE := $(SRC_FILE:%.c=%.o)
export LD_LIBRARY_PATH = ./lib
#当要匹配点c文件时 到后缀的两个目录下找
vpath %.c $(COMMON) $(HI_COMMON) $(WATCHDOG) $(WAVPLAY) $(COUURENT_PATH)

GEN_O = $(OUTPUT_DIR)/*.o
all: $(OBJS_FILE) 
	$(CC) $(CC_FLAGS)   -o $(TAG) $(GEN_O) $(LD_SHARE) $(LIBS) $(AUDIO_LIBA)  $(MPI_LIBS) 
	cp ${TAG}  /rootnfs
%.o: %.c
	$(CC) $(CC_FLAGS) -c  $< -o  $(OUTPUT_DIR)/$@

clean:
	rm -rf *.o $(TAG) $(GEN_O)
