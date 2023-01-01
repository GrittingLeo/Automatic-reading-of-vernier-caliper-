clear all
close all
clc
%%尺子参数
m_resolution=0.1; % 主尺最小刻度
resolution=0.02;  % 游标最小刻度

%%分别做透视变换后  分割主尺副尺 然后投影找刻度
%cd D:\1长三角研究院\智能遥感应用团队\Ruler_Detect\刻度式游标卡尺
I=imread('D:\rule_detect\透视变换.tif');
[m,n]=size(I);
figure;imshow(I)
[m,n,p]=size(I);
    for i=2:n
        I1(:,i)=I(:,i)-I(:,i-1);              
    end
imshow(I1)

[a1,b1,c1]=edge_detect(I);

[I_otsu1,locs1,pks1]=seg_projection(I1,a1,b1,1,15);  % 输入  上界 下届  1主尺 峰值下届15
[I_otsu2,locs2,pks2]=seg_projection(I1,b1,c1,2,15);  % 输入  上界 下届  2副尺 峰值下届5  需要结合游标0的位置去除边界干扰

FileLoc = "D:\read_rule_tst\label\box_coord001.txt";   % 文本文件所在路径
[num_loc,main_loc_for_first,min_loc_for_0]=numbuer_location(FileLoc,locs1,a1,b1,c1);

dist_main_loc_for_first=abs(locs1-main_loc_for_first(1,3));
fistnum=main_loc_for_first(1,1);
main_mark_firstnum=find(dist_main_loc_for_first==min(dist_main_loc_for_first));
if main_mark_firstnum>1 && main_mark_firstnum < length(pks1) && pks1(main_mark_firstnum)==max(pks1(main_mark_firstnum-1:main_mark_firstnum+1))
    fprintf(['经峰值检验，主尺第',num2str(main_mark_firstnum),'刻度对应数字',num2str(fistnum)]);  % 提示
end

locs2rev=locs2(locs2>(min_loc_for_0(1,3)-0.7*mean(diff(locs2))));  %去除游标的边界干扰
pks2rev=pks2(locs2>(min_loc_for_0(1,3)-0.7*mean(diff(locs2))));

[ruler_out,major_result,minor_result,mark1_for_min_0,mark2_for_lineup]=tick2num(locs1,locs2rev,main_mark_firstnum,fistnum,resolution,m_resolution)
