################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Devices/STM32N6XX/mcu_cache.c \
../Devices/STM32N6XX/npu_cache.c 

OBJS += \
./Devices/STM32N6XX/mcu_cache.o \
./Devices/STM32N6XX/npu_cache.o 

C_DEPS += \
./Devices/STM32N6XX/mcu_cache.d \
./Devices/STM32N6XX/npu_cache.d 


# Each subdirectory must supply rules for building sources it contributes
Devices/STM32N6XX/%.o Devices/STM32N6XX/%.su Devices/STM32N6XX/%.cyclo: ../Devices/STM32N6XX/%.c Devices/STM32N6XX/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32N657xx -DLL_ATON_DUMP_DEBUG_API -DLL_ATON_PLATFORM=LL_ATON_PLAT_STM32N6 -DLL_ATON_OSAL=LL_ATON_OSAL_BARE_METAL -DLL_ATON_RT_MODE=LL_ATON_RT_ASYNC -DLL_ATON_SW_FALLBACK -DLL_ATON_EB_DBG_INFO -DLL_ATON_DBG_BUFFER_INFO_EXCLUDED=1 -DUSE_NUCLEO_64 -c -I../Core/Inc -I../X-CUBE-AI/App -I../X-CUBE-AI -I../../Secure_nsclib -I../../Middlewares/ST/AI/Npu/Devices/STM32N6XX -I../../Middlewares/ST/AI/Inc -I../../Middlewares/ST/AI/Npu/ll_aton -I../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../Drivers/BSP/STM32N6xx_Nucleo -I../../Drivers/CMSIS/Include -I../../Appli/X-CUBE-AI/App -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Devices-2f-STM32N6XX

clean-Devices-2f-STM32N6XX:
	-$(RM) ./Devices/STM32N6XX/mcu_cache.cyclo ./Devices/STM32N6XX/mcu_cache.d ./Devices/STM32N6XX/mcu_cache.o ./Devices/STM32N6XX/mcu_cache.su ./Devices/STM32N6XX/npu_cache.cyclo ./Devices/STM32N6XX/npu_cache.d ./Devices/STM32N6XX/npu_cache.o ./Devices/STM32N6XX/npu_cache.su

.PHONY: clean-Devices-2f-STM32N6XX

