# NUCLEO-N657X0-Q NPU SETUP REPORT

## Introduction
This tutorial begins with STM32CubeMX and demonstrates an AI application for the NUCLEO-N657X0-Q board.

This example explains how to load an application from external flash memory, execute an AI model inference stored in external flash, and display the inference output via a serial interface.

## Create a project

1. Select Board
**[Board Selector] $\rightarrow$ [ NUCLEO-N657X0-Q]**
1. Select **[Seure Domain Only]**
2. **[Finish]** to create Project
## STM32CubeMX
### Pinout & Configuration
**1. System Core**
- **CORTEX_M55_FSBL** $\rightarrow$ Enable [CPU ICache], [CPU DCache]
- **CACHEAXI** $\rightarrow$ Enable in Runtime Contexts: **Appli** $\rightarrow$ Activated
- **ICACHE** $\rightarrow$ **Disable**

Using **Overdrive mode**, where the CPU operates at its maximum frequency
- **GPIO** $\rightarrow$ **PB12** $\rightarrow$[GPIO_Ouput] $\rightarrow$ Config as follow in GPIO configuration

|                        |                             |
| ---------------------- | --------------------------- |
| Pin Context Assignment |   First Stage Boot Loader   |
| GPIO output level      |          **High**           |
| GPIO mode              |      Output Push Pull       |
| GPIO Pull-up/Pull-down | No pull-up and no pull-down |
| Maximum output speed   |             Low             |
| Label                  |        EXT_SMPS_MODE        |

Additionally, the maximum CPU frequency in overdrive mode requires setting the "Power Regulator Voltage Scale" to "**0**"
- **RCC** $\rightarrow$ [Power Parameters] $\rightarrow$ Set [Power Regulator Voltage Scale 0] in [Power Regulator Voltage Scale]

Intermediate activations during inference are stored in RAM
- **RAMCFG** $\rightarrow$ Runtime Contexts: **Appli** $\rightarrow$ Enble [RAMCFG AXISRAM3] - [RAMCFG AXISRAM6] 

**2. Analog**
Can deactivate everything in this part to avoid potential conflict
**3. Conectivity**
can deactivate everything that is set by default by CubeMX that we do not use, and just keep
- **XSPIM** $\rightarrow$ Runtime Contexts: **FSBL** $\rightarrow$ Mode: [**Direct** (XSPI1 to Port1; XSPI2 to Port2; XSPI3 not used)]
- **XSPI2** $\rightarrow$ Runtime Contexts: **FSBL** $\rightarrow$ Mode: **Octo SPI** $\rightarrow$ Port: **Port2 Octo** $\rightarrow$ Chip Select Override **NCS1: --Port2--**
In [Parameter Settings], config as follow

|                                 |               |
| ------------------------------- | ------------- |
| Fifo Threshold                  | 4             |
| Memory Mode                     | Macronix      |
| Memory Type                     | Disable       |
| Memory size                     | 1Gbits        |
| Chip Select High Time Cycle     | 1             |
| Free Running Clock              | Disable       |
| Clock Mode                      | Low           |
| Wrap Size                       | Not Supported |
| Clock Prescaler                 | 0             |
| Sample Shift                    | None          |
| Delay Hold Quarter Cycle        | Enable        |
| Chip Select Boundary            | Disable       |
| Maximum Transfer                | 0             |
| Refresh Rate                    | 0             |
| Memory Select                   | NCS1          |
| Switching Duration Clock Number | 1             |

The serial interface LUSART1, which supports the bootloader, is directly accessible as a Virtual COM port on the PC when connected via the STLINK-V3EC USB connector.  We use this interface to redirect the ‘printf‘ output, enabling easy debugging through a serial terminal
- **LUART1** $\rightarrow$ Runtime Contexts: **Appli** $\rightarrow$ Mode: **Asynchronous** $\rightarrow$ [Parameter Settings]

|             |                           |
| ----------- | ------------------------- |
| Baud Rate   | 115200 Bits/s             |
| Word Length | 8 Bits (including Parity) |
| Parity      | None                      |
| Stop Bits   | 1                         |

**(!) Warning**
There is a conflict shown in orange. To fix it, change the pin **PA11** to [LUSART1_CTS]

**4. Security**

- **BSEC** $\rightarrow$ Runtime Contexts: **FSBL** $\rightarrow$ Activated
- **RIF** $\rightarrow$ Runtime Contexts: **Appli**
 
**5. Middleware and Software Packs**

- **EXTMEM_MANAGER** $\rightarrow$ Runtime Contexts: **FSBL**,**External Memory Loader** $\rightarrow$ Activate External Memory Manager

In [Cofiguration] $\rightarrow$ **[Boot usecase]** tab

| Boot                         |              |
| ---------------------------- | ------------ |
| Select boot code generation  | Tick         |
| Selection of the boot system | Load and Run |
| Header Size                  | 0x400        |

| LRUN source              |                |
| ------------------------ | -------------- |
| Select the source memory | Memory 1       |
| Source Address offset    | 0x00100000 hex |
| Source code size         | 0x10000* hex   |

(*) _This parameter depends on Application size._ 

| LRUN destination        |                 |
| ----------------------- | --------------- |
| selection of the memory | Internal Memory |
| destination address     | 0x34000000 hex  |

In [Cofiguration] $\rightarrow$ **[Memory 1]** tab

| Select driver            |                 |
| ------------------------ | --------------- |
| Select the memory driver | EXTMEM_NOR_SFDP |

| Configuration              |                           |
| -------------------------- | ------------------------- |
| Memory Instance            | XSPI2                     |
| Number of memory data line | EXTMEM_LINK_CONFIG_1LINES |


**Memory Map**
![mem_map](/images/mem_map.png)

Note two key addresses in this map: the secure **RAM block** starts at address `0x34000000`, and the **Octo-SPI flash** (interfaced by **XSPI2**) starts at address `0x70000000`.

Upon power-up, the **boot ROM** is executed first. After that, the **FSBL** (stored at the beginning of flash) is copied into RAM and executed. The **FSBL** then copies the **Appli** binary from flash to RAM and executes it. Thus, the **FSBL** binary is stored at `0x70000000` in the External Flash.

The **Appli** binary should be placed at an address offset greater than the FSBL size. Choosing an offset of `0x00100000` (1 MB) provides ample space. The code size corresponds to the Appli binary size.

FSBL with **Load & Run** application
![LRun](/images/LRun.png)

- **X-CUBE_AI** $\rightarrow$ (Application) STMicroelectronics.X-CUBE-AI 
$\rightarrow$ Artificial Intelligence X-CUBE-AI $\rightarrow$ Core (Tick)
$\rightarrow$ Device Application $\rightarrow$ Application Template

In [Configuration] $\rightarrow$ Add **network** (next to **Main**) $\rightarrow$ name model inputs $\rightarrow$ Select **TFLite** $\rightarrow$ Browse for the model $\rightarrow$ select the profile **"n6-allmems-03"** $\rightarrow$ **Analyze**

![model_analyze](/images/model_analyze.png)

In the **Advanced Settings** (accessible via the blue gadget icon above **Show Graph**), you can view the **External RAM, External Flash, Memory pool** information used by X-CUBE-AI. The pool stores the model's fixed weights in flash and its activations in RAM. The **OctoFlash** pool begins at address `0x71000000`, so after generating the model weights image, it should be downloaded to this address. 

![model_memory](/images/model_memory.png)
### Clock Configuration
![alt text](/images/overdive_mode.png)

Configure the clock according to the maximum supported frequencies (shown above).

![text](/images/clk_conf.png)

High-speed OTP optimization is not enabled for XSPI. Therefore, the XSPI2 clock must be reduced. Configure IC3 with PLL4 as input and a prescaler of 1, then set IC3 as the input for the XSPI2 clock multiplexer.

![alt text](/images/xspi2_clk.png)

Finally, click on **Resolve Clock Issues** to solve the **LPUART1 Source Mux** issue
### Project Manager

At this point, the CubeMX design and configuration are complete. In the **Project Manager** section, click [Generate Code] to export the project. Ensure that both **FSBL** and **Appli** are included and select STM32CubeIDE as the target toolchain.

## STM32CUBEIDE
### FSBL code
First of all, we need to complement BSEC initialization. First, add the following constants into the _private define area_ of `stm32n6xx_hal_msp.c`
```c=
/* Private define ------------------------*/
/* USER CODE BEGIN Define */
#define HSLV_OTP 124
#define VDDIO3_HSLV_MASK (1<<15)
/* USER CODE END Define */
```
Then add the following piece of code into the `HAL_XSPI_MspInit` function.
```c=
/* USER CODE BEGIN XSPI2_MspInit 0 */
BSEC_HandleTypeDef hbsec;
uint32_t fuse_data = 0;
/* Enable BSEC & SYSCFG clocks to ensure BSEC data accesses */
__HAL_RCC_BSEC_CLK_ENABLE();
__HAL_RCC_SYSCFG_CLK_ENABLE();
hbsec.Instance = BSEC;
if (HAL_BSEC_OTP_Read(&hbsec, HSLV_OTP, &fuse_data) != HAL_OK)
{
Error_Handler();
}
/* Set PWR configuration for IO speed optimization */
__HAL_RCC_PWR_CLK_ENABLE();
HAL_PWREx_EnableVddIO3();
HAL_PWREx_ConfigVddIORange(PWR_VDDIO3, PWR_VDDIO_RANGE_1V8);
/* Set SYSCFG configuration for IO speed optimization (clock already enabled)
*/
HAL_SYSCFG_EnableVDDIO3CompensationCell();
/* Enable the XSPI memory interface clock */
__HAL_RCC_XSPI2_CLK_ENABLE();
/* USER CODE END XSPI2_MspInit 0 */
```
Now, we need add some code into the main functions of each project to use the LEDs to flag good execution. In the FSBL, to turn on the `LED_BLUE`.

Note that the initialization added by STM32CubeMX was commented out and this same piece of code was added under the _User Area Code 2_. This was done because the function to turn the LED blue on has to be called before booting the application. This is the only User Area Code available for such a purpose. Be aware that the section commented out may uncomment itself after STM32CubeMX modifications so be sure to comment it before rebuilding.

In `main.c`,
```c=
/*USER CODE BEGIN 2 */
BSP_LED_Init(LED_BLUE);
BSP_LED_Init(LED_RED);
BSP_LED_Init(LED_GREEN);
BSP_LED_On(LED_BLUE);
/*USER CODE END 2 */
```
Moreover, the _Overdrive mode_ selection pin must be high before configuring the clock. Make sure to add the GPIO init function before the system clock initialization.
 ```c=
/* USER CODE BEGIN Init*/
MX_GPIO_Init();
HAL_Delay(1);
/* USER CODE END Init*/

/*Cofigure the system clock*/
SystemClock_Config();
 ```
### Appli code
At the top of `main.c`, in the _private define_ section, declare the following macro for the `put_char` function.
```c=
/* Private define ------------------------*/
/* USER CODE BEGIN PD */
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
/* USER CODE END PD */
```
Then, in the `User Code 4` section at the bottom of `main.c`, implement the following functions:
```c=
/* USER CODE BEGIN 4 */
PUTCHAR_PROTOTYPE
{
HAL_UART_Transmit(&hlpuart1, (uint8_t *)ch, 1, 0xFFFF);
return ch;
}
int _write(int fd, char * ptr, int len){
HAL_UART_Transmit(&hlpuart1, (uint8_t *) ptr, len, HAL_MAX_DELAY);
return len;
}
/* USER CODE END 4 */
```
Within `main.c`, in the X-CUBE-AI initialization function `MX_X_CUBE_AI_Init` (in `app_x-cube-ai.c`), enable the RAM sections
```c=
void MX_X_CUBE_AI_Init(void)
{
	__HAL_RCC_AXISRAM2_MEM_CLK_ENABLE();
	__HAL_RCC_AXISRAM3_MEM_CLK_ENABLE();
	__HAL_RCC_AXISRAM4_MEM_CLK_ENABLE();
	__HAL_RCC_AXISRAM5_MEM_CLK_ENABLE();
	__HAL_RCC_AXISRAM6_MEM_CLK_ENABLE();
	RAMCFG_SRAM2_AXI->CR &= ~RAMCFG_CR_SRAMSD;
	RAMCFG_SRAM3_AXI->CR &= ~RAMCFG_CR_SRAMSD;
	RAMCFG_SRAM4_AXI->CR &= ~RAMCFG_CR_SRAMSD;
	RAMCFG_SRAM5_AXI->CR &= ~RAMCFG_CR_SRAMSD;
	RAMCFG_SRAM6_AXI->CR &= ~RAMCFG_CR_SRAMSD;
    set_clk_sleep_mode();
    __HAL_RCC_NPU_CLK_ENABLE();
    __HAL_RCC_NPU_FORCE_RESET();
    __HAL_RCC_NPU_RELEASE_RESET();
    npu_cache_init();
    /* USER CODE BEGIN 5 */
    /* USER CODE END 5 */
}
```
The `MX_X_CUBE_AI_Process` function below implements the following features:

- Calculating buffer sizes.
- Filling the input buffer with constant values.
- Cleaning and invalidating the MCU DCACHE and invalidating the NPU cache prior to inference.
- Converting integer table values to float and printing them via UART.

```c=
void MX_X_CUBE_AI_Process(void)
{
    /* USER CODE BEGIN 6 */
	LL_ATON_RT_RetValues_t ll_aton_rt_ret = LL_ATON_RT_DONE;
	const LL_Buffer_InfoTypeDef * ibuffersInfos = NN_Interface_Default.input_buffers_info();
	const LL_Buffer_InfoTypeDef * obuffersInfos = NN_Interface_Default.output_buffers_info();
	buffer_in = (uint8_t *)LL_Buffer_addr_start(&ibuffersInfos[0]);
	buffer_out = (uint8_t *)LL_Buffer_addr_start(&obuffersInfos[0]);
	// Printing buffer start and end addresses.
	printf("Input buffer: offset start = %lu, \n \r offset end = %lu \n \r",ibuffersInfos->offset_start,ibuffersInfos->offset_end);
	printf("Output buffer: offset start = %lu, \n \r offset end = %lu \n \r",obuffersInfos->offset_start,obuffersInfos->offset_end);
	// Getting buffer size and printing it.
	buff_in_len = ibuffersInfos->offset_end - ibuffersInfos->offset_start;
	buff_out_len = obuffersInfos->offset_end - obuffersInfos->offset_start;
	printf("Buffer input size = %lu \n\r Buffer output size = %lu \n\r", buff_in_len, buff_out_len);
	uint8_t val = 10;
	LL_ATON_RT_RuntimeInit();
	// Run 10 inferences
	for (int inferenceNb = 0; inferenceNb < 10; ++inferenceNb) {
		/* ------------- */
		/* - Inference - */
		/* ------------- */
		/* Pre-process and fill the input buffer */
		// Fill input buffer with constant data.
		for(uint32_t i = 0; i < buff_in_len; i++){
			buffer_in[i] = val;
		}
		// Clean and invalidate MCU DCache and invalidate NPU cache.
		mcu_cache_clean_invalidate_range(buffer_in, buffer_in + buff_in_len);
		npu_cache_invalidate();
		// Check that input buffer was properly assigned with "val".
		printf("Buffer[1] = %d \n \r", buffer_in[1]);
		printf("Buffer[1000] = %d \n \r", buffer_in[1000]);
		printf("Buffer[10000] = %d \n \r", buffer_in[10000]);
		//_pre_process(buffer_in);
		/* Perform the inference */
		LL_ATON_RT_Init_Network(&NN_Instance_Default); // Initialize network instance
		do {
			// Execute first/next epoch block
			ll_aton_rt_ret = LL_ATON_RT_RunEpochBlock(&NN_Instance_Default);
			// Wait for event if required
			if (ll_aton_rt_ret == LL_ATON_RT_WFE) {
				LL_ATON_OSAL_WFE();
			}
		} while (ll_aton_rt_ret != LL_ATON_RT_DONE);
		// Post-process the output buffer
		// Invalidate CPU cache if needed
		// Convert int8 to float. Buffer is int8, but model's output is float.
		uint8_t aux[4];
		float_t *conver;
		for(uint32_t i = 0; i < 40; i += 4){
			aux[0] = buffer_out[i];
			aux[1] = buffer_out[i+1];
			aux[2] = buffer_out[i+2];
			aux[3] = buffer_out[i+3];
			conver = (float_t *)aux;
			printf("Out %lu = %f \n \r", i, *conver);
		}
		//_post_process(buffer_out);
		LL_ATON_RT_DeInit_Network(&NN_Instance_Default);
		/* -------------------- */
		/* - End of Inference - */
		/* -------------------- */
	}
	LL_ATON_RT_RuntimeDeInit();
    /* USER CODE END 6 */
}
```
**(!) Warning:**
_We have to enable use float with print_

Appli  project $\rightarrow$ Properties $\rightarrow$ C/C++ Build $\rightarrow$ Settings $\rightarrow$ Tool Settings tab $\rightarrow$ MCU/MPU Settings $\rightarrow$ Tick Use float with printf from newlib-nano (-u_printf_float).

![appli_float](/images/appli_float.png)

To ensure that the application operates correctly , that the peripheral initialization succeeded, and that the main loop is not stuck during inference, add the following two lines of code to blink the red LED:

```c=
 /* USER CODE BEGIN 2 */
  MX_X_CUBE_AI_Process(); 
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
	  BSP_LED_Toggle(LED_GREEN);
	  HAL_Delay(200);
    /* USER CODE END WHILE */


    /* USER CODE BEGIN 3 */
  }
```
## Deloy the application 
### Sign binary files with Signing Tool
```
cd "${ProjDirPath}/Debug" && echo y | "D:\Download\STM32CubeIDE_1.18.1\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.win32_2.2.100.202412061334\tools\bin\STM32_SigningTool_CLI.exe" -bin "${ProjName}.bin" -nk -of 0x80000000 -t fsbl -o "${ProjName}-Trusted.bin" -hv 2.3 -dump "${ProjName}-Trusted.bin"
```

Sign two files (FSBL + Appli)
### Generate model weights binary image

In our project folder, we can find at the root a file named `network_data.xSPI2.raw` that contains the weights of the model. This file results from `X-CUBE-AI` and in particular is the result of the `ST Edge AI Core` command running behind it:
```
stedgeai generate --model Model_File.tflite --target stm32n6 --st-neural-art
```

In our case, we want to rename and convert this file to `network_data.xSPI2.bin`
```
cp network_atonbuf.xSPI2.raw network_data.xSPI2.bin
```
Next, add the path to `arm-none-eabi-objcopy` to the environment variables. This tool allows you to convert the `.bin` file into a `.hex` file with a specified flash memory address:
```
arm-none-eabi-objcopy -I binary network_data.xSPI2.bin --change-addresses 0x71000000 -O ihex network_data.hex
```

### Build
Our project is now complete. We may proceed to build it. Normally, there should be no errors. However, we can encounter one of these errors:
- **Linker garbage problem**:
  ![linker-garbage-er](/images/linker_garbage_er.png)

  Our code (or the library are used) calls standard C library I/O functions (such as printf, scanf, fopen, etc.).These functions rely on low-level system calls to communicate with the hardware or operating system. However, the STM32 microcontroller runs in "bare-metal" mode (without an operating system like Windows or Linux). Therefore, the compiler (using the libc_nano library) warns that these system functions have not been written for actual processing, so if the program runs into them, it will fail.

  **Fix**
  We have to add a `syscalls.c` file in `Core/Src` to define these functions. The `syscalls.c` code can be found in `Github` link at the end of the report.

  - **Undefined reference to AI/NPU functions**:
  
  
  ![undefine_npu_func](/images/undefine_npu_func.png)

 	We get errors indicating that LL functions are undeclared, it means that the compiler cannot locate the LL sources in the global `Middleware` folder.

	In that case, import the required source files and ensure that the folder is marked as a source location in the project settings.

	To import a folder, right-click on the project, then **Import $\rightarrow$ General $\rightarrow$ File System**. Here, we can browse for the project directory $\rightarrow$ **Middleware $\rightarrow$ NPU**, then check the box `ll_aton` and `Devices` in `NPU` folder, choose the folder containing the missing source files, and filter to import only `.c` files. 

	![npu_er_fix](/images/npu_er_fix.png)

	Then, right-click the project again, go to **Properties** $\rightarrow$ **C/C++ General** $\rightarrow$ **Paths and Symbols**. Under the **Source Location** tab, add the folder we just imported.

	![npu_er](/images/npu_er_fix_2.png)

	If the `Midlleware` folder is empy, you can use our `Middleware` folder in the `Github` link at the end of the report.  
## STM32CubeProgrammer

We now have all three image files: the FSBL, the application, and the model weights. Flash binaries with STM32CubeProgrammer.

Boot jumpers on the Nucleo board:

| Boot 0 | Boot 1 |
| ------ | ------ |
| x      | 2-3    |

FSBL and Application are binary files, and their flashing addresses must be specified manually.

- Flash FSBL to the start of OctoFlash at `0x70000000`.
- Flash the application to `0x70100000`, based on the offset defined in the external memory loader.
- The weights image is a `.hex` file with a predefined address (`0x71000000`), specified in the `objcopy` command.

Flash using STM32CubeProgrammer

- `External loaders` $\rightarrow$ `MX25UM51245G-STM32N6570-NUCLEO`

- `Connect` board to the dessktop via CN10

- `Erasing & Programming` $\rightarrow$ Browse files $\rightarrow$ Flash all binary (FBSL,Appli Trusted .bin files) and hex image (network_data.hex) to above address
  
After flashing, switch the board to flash boot mode. 

| Boot 0 | Boot 1 |
| ------ | ------ |
| 1-2    | 1-2    |

Then power-cycle or reset the board.

## Result

If following above steps, after reset, the `LED_BLUE` should now be turned on, and the `LED_GREEN` should be blinking after the `UART` COM displayed the following information, and printed Output values 10 times (according to the code in `MX_X_CUBE_AI_Process` and Appli `main` ). 

![uart_op](/images/uart_output.png)

## Resources
[Github Project](https://github.com/tintran193/NUCLEO-N65X0Q-NPU-Setup)

[References](https://github.com/tintran193/STM32N6-DOCUMENT)
