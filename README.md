# Automatic-reading-of-vernier-caliper-游标卡尺的自动读数
# 该程序实现了对游标卡尺的自动读数，精度达到0.02mm

## 预处理

对原图首先有两个预处理，分别用深度学习中的U-net,YOLOV5网络，U-net网络用来分割游标卡尺区域，yolov5识别卡尺上的数字并输出数字所在图像中的坐标。
![image](https://github.com/GrittingLeo/Automatic-reading-of-vernier-caliper-/blob/main/images/unet1.jpg)
![image](https://github.com/GrittingLeo/Automatic-reading-of-vernier-caliper-/blob/main/images/yolov5.jpg)

## 主程序rule_reading.py

由于yolov5及unet都是python编写，而后续数据处理部分是利用matlab,为了整体操作方便，该部分了利用了matlab.engine功能  ，可在python中直接调用main_demo.m函数。**此部分可换成main_demo1.m文件，可在matlab里直接运行整个程序。**

## rule_read1.m 

此函数输入为U-net分割好的游标卡尺图片，对此图片做了透视校正，以此来提高读数的精准度。整体思路是先确定unet分割出来的不规则四边形的四个顶点（ROI区域），利用投影矩阵反算原图坐标。将不规整的卡尺区域转换成水平于视角的卡尺，方便后续读数精度的提高。

## edge_detect.m

确定游标卡尺边界：上界，主尺与副尺的分界，下界。整体思路是先找出图像中最长的直线边缘，标记直线边缘对应起点，输出上届，下界，分界的像素y坐标。

## seg_projection.m 

输入上届，下界，分界。输出主尺刻度区域，副尺刻度区域。

## numbuer_location.m

 输入为box_coord001.txt，内容为卡尺上的数字以及对应像素坐标。返回主尺第一个数字及其y坐标

## tick2num.m

分为两部分

主尺读数：先找游标第一个刻度对应的主尺最小距离是哪个位置，确定与其距离最近的数字即为卡尺读数的整数部分。

游标读数：确定游标0刻度位置，确定主尺刻度与副尺刻度的对其位置，有刻度y坐标即表示是游标刻度的第几根刻度线，乘上卡尺精度则为卡尺读数的小数部分。

<u>**PS:该程序不包括unet，以及yolov5部分，如何得到刻度式游标卡尺001_unet.jpg和box_coord001.txt请参考u-net网络，yolov5的使用。**</u>
![image](https://github.com/GrittingLeo/Automatic-reading-of-vernier-caliper-/blob/main/images/rsult1.png)
![image](https://github.com/GrittingLeo/Automatic-reading-of-vernier-caliper-/blob/main/images/rsult2.png)
