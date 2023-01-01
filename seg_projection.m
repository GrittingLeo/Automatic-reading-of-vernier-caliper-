
function [I_main_otsu,locs1,pks1]=seg_projection(I1,a1,b1,status,mph1) % I1输入数据，a1上界，b1下届，status(1为主尺，2为副尺)，mph1搜索峰值（主尺15 副尺5）
if status ==1
I_main=I1(floor((a1+b1)/2):b1,:);
end
if status ==2
    I_main=I1(a1:ceil((a1+b1)/2),:);
end 

thd_otsu1=graythresh(I_main);
I_main_otsu=im2bw(I_main,thd_otsu1);
figure;imshow(I_main_otsu);
[m1,n1]=size(I_main_otsu);


for y1=2:n1-1
    V(y1)=sum(sum(I_main_otsu(:,y1-1:y1+1)));
end
y1=2:n1-1;
figure; plot(y1,V(y1));
% mph1=15;  %% 搜索峰值最小值
[pks1,locs1] = findpeaks(V(y1),y1,'minpeakheight',mph1);
% mpd=10;
% [pks,locs] = findpeaks(V(y),y,'minpeakdistance',mpd);
text(locs1+.02,pks1,num2str((1:numel(pks1))'));

I_out=I1;
if status ==1
for i=1:length(locs1)
    tag=locs1(i);
    I_out(b1-15:b1,tag,1)=255;
    I_out(b1-15:b1,tag,2)=0;
    I_out(b1-15:b1,tag,3)=0;
end
end
if status ==2
for i=1:length(locs1)
    tag=locs1(i);
    I_out(a1:a1+10,tag,1)=255;
    I_out(a1:a1+10,tag,2)=255;
    I_out(a1:a1+10,tag,3)=0;
end
end
figure;imshow(I_out)
end