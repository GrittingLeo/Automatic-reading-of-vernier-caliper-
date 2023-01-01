
function new_img=rule_read1(im)
%dot=ginput(4);       %取四个点，依次是左上，右上，左下，右下
%dot(:,[1,2])= dot(:,[2,1]); % 变换x y坐标，x=行 y=列
a=im(:,:,1);  %提取R通道
[m,n] = size(a);

thresh1 = graythresh(a);     %自动确定二值化阈值
I2 = im2bw(a,thresh1);       %对图像二值化
[row,col]=find(I2~=0);


I3=edge(I2,'sobel');
points = detectHarrisFeatures(I2);
Points1 = selectStrongest(points,50);%找到边界上的点

result=(Points1.Location);
%原图左下角的点，特点：行列差值最小
a1=min(result(:,1)-result(:,2));
[i1,j1]=find(result(:,1)-result(:,2)==a1);
a1_col=result(i1,1);
a1_row=result(i1,2);
%原图右下角的点，特点：行列和最大
a2sum=max(sum(result,2));
[i2,j2]=find(sum(result,2)==a2sum);
a2_col=result(i2,1);
a2_row=result(i2,2);
%原图左上角的点,特点：行列和最小
a3sum=min(sum(result,2));
[i3,j3]=find(sum(result,2)==a3sum);
a3_col=result(i3(1),1);
a3_row=result(i3(1),2);
%原图右上角的点，特点：行列差值最大
a4sub=max(abs(result(:,1)-result(:,2)));
[i4,j4]=find(abs(result(:,1)-result(:,2))==a4sub);
a4_col=result(i4,1);
a4_row=result(i4,2);
% 
%  sprintf('左上角坐标为：%.0f，%.0f',a3_row,a3_col)
%  sprintf('右上角坐标为：%.0f，%.0f',a4_row,a4_col)
%  sprintf('左下角坐标为：%.0f，%.0f',a1_row,a1_col)
%  sprintf('右下角坐标为：%.0f，%.0f',a2_row,a2_col)

col=round(sqrt((a3_row-a4_row)^2+(a3_col-a4_col)^2));   %从原四边形获得新矩形宽
row=round(sqrt((a3_row-a1_row)^2+(a3_col-a1_col)^2));   %从原四边形获得新矩形高
new_img = ones(row,col);
% 原图四个基准点的坐标
x = [a3_row-6,a4_row-6,a1_row+6,a2_row+6];
y = [a3_col,a4_col,a1_col,a2_col];
% 新图四个基准点坐标
X = [1,1,row,row];
Y = [1,col,1,col];
% 列出投影关系 求出投影矩阵
A=[x(1),y(1),1,0,0,0,-X(1)*x(1),-X(1)*y(1);             
   0,0,0,x(1),y(1),1,-Y(1)*x(1),-Y(1)*y(1);
   x(2),y(2),1,0,0,0,-X(2)*x(2),-X(2)*y(2);
   0,0,0,x(2),y(2),1,-Y(2)*x(2),-Y(2)*y(2);
   x(3),y(3),1,0,0,0,-X(3)*x(3),-X(3)*y(3);
   0,0 ,0,x(3),y(3),1,-Y(3)*x(3),-Y(3)*y(3);
   x(4),y(4),1,0,0,0,-X(4)*x(4),-X(4)*y(4);
   0,0,0,x(4),y(4),1,-Y(4)*x(4),-Y(4)*y(4)];%求解变换矩阵的行列式
B = [X(1),Y(1),X(2),Y(2),X(3),Y(3),X(4),Y(4)]';
C = inv(A)*B;
D = [C(1),C(2),C(3);
     C(4),C(5),C(6);
     C(7),C(8),1]; % 变换矩阵3*3模式
 inv_D = inv(D);
 for i = 1:row
     for j = 1:col
       % 解二元一次方程组，根据目标图像坐标反求出原图坐标
       pix = inv_D * [i j 1]';
       pix1 = inv([C(7)*pix(1)-1 C(8)*pix(1);C(7)*pix(2) C(8)*pix(2)-1])*[-pix(1) -pix(2)]';
       if pix1(1)<m && pix1(2)<n
           new_img(i,j) = im(round(pix1(1)),round(pix1(2))); %最近邻插值
       else
           new_img(i,j) = 255;
       end
     end
 end
figure;
imshow(im,[]);title('原图');
figure;
imshow(new_img,[]);title('透视变换后')
imwrite(uint8(new_img),'透视变换.tif')

end