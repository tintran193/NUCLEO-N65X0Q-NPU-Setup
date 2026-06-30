################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../ll_aton/ecloader.c \
../ll_aton/ll_aton.c \
../ll_aton/ll_aton_cipher.c \
../ll_aton/ll_aton_dbgtrc.c \
../ll_aton/ll_aton_debug.c \
../ll_aton/ll_aton_lib.c \
../ll_aton/ll_aton_lib_sw_operators.c \
../ll_aton/ll_aton_osal_freertos.c \
../ll_aton/ll_aton_osal_threadx.c \
../ll_aton/ll_aton_osal_zephyr.c \
../ll_aton/ll_aton_profiler.c \
../ll_aton/ll_aton_reloc_callbacks.c \
../ll_aton/ll_aton_reloc_network.c \
../ll_aton/ll_aton_rt_main.c \
../ll_aton/ll_aton_runtime.c \
../ll_aton/ll_aton_util.c \
../ll_aton/ll_sw_float.c \
../ll_aton/ll_sw_integer.c 

OBJS += \
./ll_aton/ecloader.o \
./ll_aton/ll_aton.o \
./ll_aton/ll_aton_cipher.o \
./ll_aton/ll_aton_dbgtrc.o \
./ll_aton/ll_aton_debug.o \
./ll_aton/ll_aton_lib.o \
./ll_aton/ll_aton_lib_sw_operators.o \
./ll_aton/ll_aton_osal_freertos.o \
./ll_aton/ll_aton_osal_threadx.o \
./ll_aton/ll_aton_osal_zephyr.o \
./ll_aton/ll_aton_profiler.o \
./ll_aton/ll_aton_reloc_callbacks.o \
./ll_aton/ll_aton_reloc_network.o \
./ll_aton/ll_aton_rt_main.o \
./ll_aton/ll_aton_runtime.o \
./ll_aton/ll_aton_util.o \
./ll_aton/ll_sw_float.o \
./ll_aton/ll_sw_integer.o 

C_DEPS += \
./ll_aton/ecloader.d \
./ll_aton/ll_aton.d \
./ll_aton/ll_aton_cipher.d \
./ll_aton/ll_aton_dbgtrc.d \
./ll_aton/ll_aton_debug.d \
./ll_aton/ll_aton_lib.d \
./ll_aton/ll_aton_lib_sw_operators.d \
./ll_aton/ll_aton_osal_freertos.d \
./ll_aton/ll_aton_osal_threadx.d \
./ll_aton/ll_aton_osal_zephyr.d \
./ll_aton/ll_aton_profiler.d \
./ll_aton/ll_aton_reloc_callbacks.d \
./ll_aton/ll_aton_reloc_network.d \
./ll_aton/ll_aton_rt_main.d \
./ll_aton/ll_aton_runtime.d \
./ll_aton/ll_aton_util.d \
./ll_aton/ll_sw_float.d \
./ll_aton/ll_sw_integer.d 


# Each subdirectory must supply rules for building sources it contributes
ll_aton/%.o ll_aton/%.su ll_aton/%.cyclo: ../ll_aton/%.c ll_aton/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32N657xx -DLL_ATON_DUMP_DEBUG_API -DLL_ATON_PLATFORM=LL_ATON_PLAT_STM32N6 -DLL_ATON_OSAL=LL_ATON_OSAL_BARE_METAL -DLL_ATON_RT_MODE=LL_ATON_RT_ASYNC -DLL_ATON_SW_FALLBACK -DLL_ATON_EB_DBG_INFO -DLL_ATON_DBG_BUFFER_INFO_EXCLUDED=1 -DUSE_NUCLEO_64 -c -I../Core/Inc -I../X-CUBE-AI/App -I../X-CUBE-AI -I../../Secure_nsclib -I../../Middlewares/ST/AI/Npu/Devices/STM32N6XX -I../../Middlewares/ST/AI/Inc -I../../Middlewares/ST/AI/Npu/ll_aton -I../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../Drivers/BSP/STM32N6xx_Nucleo -I../../Drivers/CMSIS/Include -I../../Appli/X-CUBE-AI/App -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-ll_aton

clean-ll_aton:
	-$(RM) ./ll_aton/ecloader.cyclo ./ll_aton/ecloader.d ./ll_aton/ecloader.o ./ll_aton/ecloader.su ./ll_aton/ll_aton.cyclo ./ll_aton/ll_aton.d ./ll_aton/ll_aton.o ./ll_aton/ll_aton.su ./ll_aton/ll_aton_cipher.cyclo ./ll_aton/ll_aton_cipher.d ./ll_aton/ll_aton_cipher.o ./ll_aton/ll_aton_cipher.su ./ll_aton/ll_aton_dbgtrc.cyclo ./ll_aton/ll_aton_dbgtrc.d ./ll_aton/ll_aton_dbgtrc.o ./ll_aton/ll_aton_dbgtrc.su ./ll_aton/ll_aton_debug.cyclo ./ll_aton/ll_aton_debug.d ./ll_aton/ll_aton_debug.o ./ll_aton/ll_aton_debug.su ./ll_aton/ll_aton_lib.cyclo ./ll_aton/ll_aton_lib.d ./ll_aton/ll_aton_lib.o ./ll_aton/ll_aton_lib.su ./ll_aton/ll_aton_lib_sw_operators.cyclo ./ll_aton/ll_aton_lib_sw_operators.d ./ll_aton/ll_aton_lib_sw_operators.o ./ll_aton/ll_aton_lib_sw_operators.su ./ll_aton/ll_aton_osal_freertos.cyclo ./ll_aton/ll_aton_osal_freertos.d ./ll_aton/ll_aton_osal_freertos.o ./ll_aton/ll_aton_osal_freertos.su ./ll_aton/ll_aton_osal_threadx.cyclo ./ll_aton/ll_aton_osal_threadx.d ./ll_aton/ll_aton_osal_threadx.o ./ll_aton/ll_aton_osal_threadx.su ./ll_aton/ll_aton_osal_zephyr.cyclo ./ll_aton/ll_aton_osal_zephyr.d ./ll_aton/ll_aton_osal_zephyr.o ./ll_aton/ll_aton_osal_zephyr.su ./ll_aton/ll_aton_profiler.cyclo ./ll_aton/ll_aton_profiler.d ./ll_aton/ll_aton_profiler.o ./ll_aton/ll_aton_profiler.su ./ll_aton/ll_aton_reloc_callbacks.cyclo ./ll_aton/ll_aton_reloc_callbacks.d ./ll_aton/ll_aton_reloc_callbacks.o ./ll_aton/ll_aton_reloc_callbacks.su ./ll_aton/ll_aton_reloc_network.cyclo ./ll_aton/ll_aton_reloc_network.d ./ll_aton/ll_aton_reloc_network.o ./ll_aton/ll_aton_reloc_network.su ./ll_aton/ll_aton_rt_main.cyclo ./ll_aton/ll_aton_rt_main.d ./ll_aton/ll_aton_rt_main.o ./ll_aton/ll_aton_rt_main.su ./ll_aton/ll_aton_runtime.cyclo ./ll_aton/ll_aton_runtime.d ./ll_aton/ll_aton_runtime.o ./ll_aton/ll_aton_runtime.su ./ll_aton/ll_aton_util.cyclo ./ll_aton/ll_aton_util.d ./ll_aton/ll_aton_util.o ./ll_aton/ll_aton_util.su ./ll_aton/ll_sw_float.cyclo ./ll_aton/ll_sw_float.d ./ll_aton/ll_sw_float.o ./ll_aton/ll_sw_float.su ./ll_aton/ll_sw_integer.cyclo ./ll_aton/ll_sw_integer.d ./ll_aton/ll_sw_integer.o ./ll_aton/ll_sw_integer.su

.PHONY: clean-ll_aton

