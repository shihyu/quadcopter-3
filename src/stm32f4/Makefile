
MCU = cortex-m4
MCFLAGS = -mcpu=$(MCU) -mthumb -mlittle-endian -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb-interwork -std=c99
DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F4XX -DHSE_VALUE=8000000
STM32_INCLUDES = -I./Libraries/CMSIS/Device/ST/STM32F4xx/Include/ \
	-I./Libraries/CMSIS/Include/ \
	-I./Libraries/STM32F4xx_StdPeriph_Driver/inc/

CFLAGS = $(MCFLAGS)  $(OPTIMIZE)  $(DEFS) -I. -I./src -I./ $(STM32_INCLUDES)  -Wl,-T,./src/stm32_flash.ld

STARTUP = ./Libraries/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc_ride7/startup_stm32f40xx.s

SRC = ./src/main.c \
	./src/stm32f4xx_it.c \
	./src/system_stm32f4xx.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/misc.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_can.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_crc.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_aes.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_des.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_cryp_tdes.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dbgmcu.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dcmi.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_md5.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_hash_sha1.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_iwdg.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_pwr.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rtc.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_sdio.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.c \
	./Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_wwdg.c

all: build/quadcopter.bin
	@echo "hello quadcopter"

build/quadcopter.bin: build/quadcopter.elf
	arm-none-eabi-objcopy -O binary build/quadcopter.elf build/quadcopter.bin

build/quadcopter.elf: $(SRC) $(STARTUP)
	arm-none-eabi-gcc $(CFLAGS) $^ -lm -lc -lnosys -o build/quadcopter.elf
















