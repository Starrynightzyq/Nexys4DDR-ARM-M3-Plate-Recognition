# 全国大学生集成电路创新创业大赛

![集成电路大赛logo](pic/集成电路大赛.jpg)

## 1. 赛题介绍：Arm 片上系统设计挑战赛

**参赛要求：本科生组/无限制组**

**赛题内容：**

利用Arm Cortex-M3 DesignStart处理器在可编程逻辑平台上构建片上系统，实现图像采集，图像处理和人机交互功能，观察并优化系统的性能。

使用ArmCortex-M3 DesignStart Eval提供的处理器IP，在你的可编程逻辑平台上构建简单的Cortex-M3片上系统。
系统应至少包含：

ArmCortex-M3 DesignStart处理器；

利用片上或板上资源实现的ROM与RAM；

与芯片外部引脚连接的GPIO外设。

使用KeilμVision工具编写并生成软件程序，实现GPIO输出引脚跟随GPIO输入引脚变化。将对应的输入、输出引脚连接至板上开关与LED，确认程序正确运行。

![ ](pic/ABUIABAEGAAgmcLS4wUowNmwhQQw6wM4vwI.png)



如上图，在FPGA中编写图像传感器的接口和数据缓存，作为Cortex-M3片上系统的一个外设，并编写软件程序，将图像传感器的采集结果显示在开发平台自带的液晶屏上。

![ ](pic/ABUIABAEGAAgtMLS4wUosO6EGzDeBDjKAg.png)

在Cortex-M3上编写软件程序，识别摄像头拍摄到的车牌中的5位数字并显示在LCD屏上。可以在FPGA中设计硬件加速器，帮助Cortex-M3加快图像识别的速度。

利用以上实现的系统，进行20张图像识别挑战赛：

测试图片由“模型车牌生成器”生成；参赛队自制20张不同的车牌，保持原大小复制到白底Power Point中，每页一张。模型车牌由XX.YYYYY组成，其中YYYYY为5位纯数字，此次识别就仅限于这个5个数字。

测试时，启动PPT演示计时功能，摄像头拍摄屏幕上的“模型车牌”（拍摄位置由参赛队自由选择），识别并在LCD屏上显示其中的5位数字，同时给出识别完成信号（蜂鸣或亮灯），人工切换到下一张测试，所有测试完成后计时停止。计时停止后，参赛队在LCD屏上显示所有识别结果供裁判核对正确率。

最终得分以速度排序，时间越短的参赛队成绩越好。但识别错误3张以上取消比赛成绩。在3张错误以内，每错一张时间罚5秒。

**作品提交：**

设计报告：

作品展板（团队介绍、项目心得体会、项目研发情况、技术创新点、后续工作）

作品PPT（团队介绍、项目心得体会、项目研发情况、技术创新点、后续工作）

系统设计方案

功能仿真及测试结果图

系统展示图片、或视频

设计数据：

系统原理图、软硬件代码，仿真和测试结果；

现场测试比赛



**评分规则：**

| 内容                                                         | 分值 | 评分要求                                                     |
| ------------------------------------------------------------ | ---- | ------------------------------------------------------------ |
| 1.  完成Cortex-M3片上系统的基础设计                          | 20分 | 1.  正确获得Arm Cortex-M3DesignStart Eval IP，正确使用内部总线连接存储器与外设；2. 在硬件平台上实现系统，并正确编译、下载软件程序， 现场编程调试，通过按键改变LED等的闪烁方式或频率证实系统运行情况； |
| 2.  完成图像传感器芯片的数字接口设计，并作为与Cortex-M3片上系统的外设 | 20分 | 1.  详实规范的设计文档2.  编写软件成功实现图像采集；3. 数字接口设计的功能仿真结果等可视化成果； |
| 3.  图像识别算法的实现                                       | 30分 | 1.  图像识别算法的详实设计方案2. 图像处理协处理器的功能仿真结果等可视化成果 |
| 4.  现场演示                                                 | 30分 | 1.  现场演示图像识别功能2.  追求更高的识别正确率和速度       |



本题目可选用MPS2开发，但不限于此平台，队伍可自行选择使用类似的硬件平台开发。但所使用板卡的官方售价不得高于MPS2，且FPGA主芯片限于Altera的Cyclone、Max系列，和Xilinx的Spartan、Artix系列。不得采用其他中高端系列FPGA芯片。



**技术讨论区：百度贴吧“**[**全国大学生集成电路大赛**](https://tieba.baidu.com/f?kw=%E5%85%A8%E5%9B%BD%E5%A4%A7%E5%AD%A6%E7%94%9F%E9%9B%86%E6%88%90%E7%94%B5%E8%B7%AF%E5%A4%A7%E8%B5%9B&ie=utf-8)**”**

## 2. 约束(Nexys4)

### Pmod Ports

[![img](pic/n4v.png)](https://reference.digilentinc.com/_detail/reference/programmable-logic/nexys-4-ddr/n4v.png?id=reference%3Aprogrammable-logic%3Anexys-4-ddr%3Areference-manual)


| **Pmod JA** | **Pmod JB** | **Pmod JC** | **Pmod JD** | **Pmod XDAC**        |
| ----------- | ----------- | ----------- | ----------- | -------------------- |
| JA1: C17    | JB1: D14    | JC1: K1     | JD1: H4     | JXADC1: A13 (AD3P)   |
| JA2: D18    | JB2: F16    | JC2: F6     | JD2: H1     | JXADC2: A15 (AD10P)  |
| JA3: E18    | JB3: G16    | JC3: J2     | JD3: G1     | JXADC3: B16 (AD2P)   |
| JA4: G17    | JB4: H14    | JC4: G6     | JD4: G3     | JXADC4: B18 (AD11P)  |
| JA7: D17    | JB7: E16    | JC7: E7     | JD7: H2     | JXADC7: A14 (AD3N)   |
| JA8: E17    | JB8: F13    | JC8: J3     | JD8: G4     | JXADC8: A16 (AD10N)  |
| JA9: F18    | JB9: G13    | JC9: J4     | JD9: G2     | JXADC9: B17 (AD2N)   |
| JA10: G18   | JB10: H16   | JC10: E6    | JD10: F3    | JXADC10: A18 (AD11N) |

| **Pmod JA** |                        |
| ----------- | ---------------------- |
| JA1: C17    | spi_rtl_ss_io[1] (CS2) |
| JA2: D18    | spi_rtl_ss_io[0] (CS1) |
| JA3: E18    | spi_rtl_io1_io (MISO)  |
| JA4: G17    | GPIO_lcd[2] (BLK)      |
| JA7: D17    | GPIO_lcd[0] (DC)       |
| JA8: E17    | GPIO_lcd[1] (RES)      |
| JA9: F18    | spi_rtl_io0_io (MOSI)  |
| JA10: G18   | spi_rtl_sck_io (CLK)   |

![SPI LCD 接口](pic/LCD.jpg)


| **Pmod JB** |          |
| ----------- | -------- |
| JB1: D14    |          |
| JB2: F16    | nTRST    |
| JB3: G16    | TDO      |
| JB4: H14    | TDI      |
| JB7: E16    |          |
| JB8: F13    | nSRST    |
| JB9: G13    | SWDIO    |
| JB10: H16   | SWCLKTCK |

| **Pmod JC** |       |
| ----------- | ----- |
| JC1: K1     | PWDN  |
| JC2: F6     | PCLK  |
| JC3: J2     | D6    |
| JC4: G6     | D4    |
| JC7: E7     | FLASH |
| JC8: J3     | D7    |
| JC9: J4     | D5    |
| JC10: E6    | D3    |

| **Pmod JD** |         |
| ----------- | ------- |
| JD1: H4     | D2      |
| JD2: H1     | D0      |
| JD3: G1     | CAM_SDA |
| JD4: G3     | CAM_SCL |
| JD7: H2     | D1      |
| JD8: G4     | RST     |
| JD9: G2     | HREF    |
| JD10: F3    | VSYNC   |

## 3. 简介

### 3.1 工程目录结构

~~~
.
├── backup
├── docs
│   ├── my
│   ├── nexys4ddr
│   └── 中期
├── hardware
│   └── m3_for_arty_a7
│       ├── block_diagram
│       ├── constraints
│       ├── ip_repo
│       ├── m3_for_arty_a7
│       └── testbench
├── matlab
├── software
│   ├── arm_xilinx_file
│   ├── flash_downloader
│   └── m3_for_arty_a7
│       ├── Build_Keil
│       ├── cmos
│       ├── cmsis
│       ├── gpio
│       ├── iic
│       ├── image
│       ├── main
│       ├── sdk_workspace
│       ├── spi
│       ├── uart
│       └── vdma
├── tools
│   └── 模型车牌生成器
└── vivado
    ├── Arm_ipi_repository
    └── Arm_sw_repository
~~~

## 4. 准备工作

### 4.1 安装板卡文件

如果打开工程后出现如下警告：

![error_message](pic/1559136392227.png)

表明缺少板卡文件，本工程使用的开发板为 Nexys4 DDR ，具体板卡文件安装方法参考 [**Vivado板卡文件安装教程**](http://digilent.com.cn/community/192.html)。

### 4.2 添加 IP 目录

初次打开vivado工程需要添加 IP 目录，具体目录如下：

~~~
./vivado/Arm_ipi_repository
./vivado/My_repo
vivado_library
~~~

其中第三个IP目录为Digital制作的IP，下载地址：[git@github.com:Digilent/vivado-library.git](https://github.com/Digilent/vivado-library)。

添加IP目录后，需要Refresh目录：Tools → Settings → IP → Repository → Refresh all，然后Report IP Status：Report → Report IP Status，如果有过期 IP ，需要Upgrate。

### 4.3 添加 Arm software repository

1.  打开 Vivado;

2.  File → Lanuch SDK;

3.  选择路径：`Exported location` to `V:/software` and the default `Workspace` to `V:/software/m3_for_arty_a7/sdk_workspace`。

    >   将 "V:" 替换为自己的实际路径

    ![Lanuch SDK](pic/1559137525929.png)

4.  SDK打开后选择：`Xilinx → Repositories`，添加 `V:vivado/Arm_sw_repository/` 到 `Global Repositories`。

    >   将 "V:" 替换为自己的实际路径

    ![1559139877749](pic/1559139877749.png)
    
    ![1559139915717](pic/1559139915717.png)

## 5. 开始使用

### 5.1 修改硬件工程

1.  打开vivado，对硬件工程进行修改；

2.  修改完成后，点击`Validate Design`验证Block Design是否正确；

    ![Validate Design](pic/1559138949251.png)

3.  之后生成 HDL Wrapper；

    ![Create HDL Wrapper](pic/1559138877508.png)

4.  根据需要，修改约束文件；

5.  点击 Generate Bitstream，生成 bit 流文件；

6.  bit流文件生成完成后，导出硬件文件：File→ Export→ Export Hardware...，**导出路径不要选择默认路径！**

    ![1559139272259](pic/1559139272259.png)

    ![1559139347547](pic/1559139347547.png)
    
    ​    

### 5.2 修改软件工程

1.  Launch SDK，**不要选择默认路径！**

    ![1559139485231](pic/1559139485231.png)
    
    2.  重新生成BSP文件，需要注意`stdin`、`stdout`、`sleep_timer`的配置是否正确。首先点击`Modify this BSP’s Settings`，确认`stdin`、`stdout`、`sleep_timer`的配置是否正确，后点击 `Regenerate BSP Sources`，重新生成BSP。
    
        ![1559140136695](pic/1559140136695.png)
    
        ![1559139758571](pic/1559139758571.png)

3.  由于Keil和SDK的文件结构稍有差异，需要将`xpseudo_asm_rcvt.h`和`xpseudo_asm_rcvt.c`从`V:/vivado/Arm_sw_respository/CortexM/bsp/standalone_v6_7/src/arm/cortexm3/armcc`复制到`V:/software/m3_for_arty_a7/sdk_workspace/standalone_bsp_0/CORTEX_M3_0/include`。

    由于一部分IP的驱动中一些文件也需要修改，所以已将修改好的文件放在`V:\software\arm_xilinx_file`，因此这一步只需要执行`V:/software/regenerate_bsp.bat`这个批处理文件，即可将需要的文件复制到 Keil MDK 工程下。

4.  之后就可以打开 Keil MDK 工程，编写软件程序部分了，Keil 工程位于`V:\software\m3_for_arty_a7\Build_Keil\m3_for_arty_a7.uvprojx`。

## 6. 实物

![-25024690176dca5f](pic/-25024690176dca5f.jpg)

