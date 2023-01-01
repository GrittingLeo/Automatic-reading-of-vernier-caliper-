import time
import matlab.engine
from PIL import Image
import numpy as np

eng = matlab.engine.start_matlab()
img_PIL = Image.open('D:/read_rule_tst\img_unet\刻度式游标卡尺001_unet.jpg')
img_PIL = np.array(img_PIL)
#print(img_PIL.dtype)
img_PIL = img_PIL.tolist()  #array转成matlab可读的列表格
img_PIL = matlab.uint8(img_PIL) #转成matlab图像数据格式uint8
img_rotation = eng.rule_read1(img_PIL) #利用matlab.engine直接运行matlab程序

FileLoc = "D:/read_rule_tst\label/box_coord001.txt"
img_orgin = Image.open('D:/read_rule_tst\img_orgin\刻度式游标卡尺001.jpg')#原图
img_orgin = np.array(img_orgin)
img_orgin = img_orgin.tolist()  #array转成matlab可读的列表格
img_orgin = matlab.uint8(img_orgin) #转成matlab图像数据格式uint8
rule_rading = eng.main_demo(img_orgin, FileLoc)

time.sleep(1000)
eng.exit()
