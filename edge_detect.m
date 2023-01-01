
function [a1,b1,c1]=edge_detect(I)
I4=edge(I,'canny');
figure( 'Name', 'canny检测');imshow(I4);

[H,T,R] = hough(I4);  
figure,imshow(H,[],'XData',T,'YData',R, 'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
% f=houghpeaks(H,3,'threshold',ceil(0.5*(max(H(:)))));
P=houghpeaks(H,3,'threshold',ceil(0.3*max(H(:))));
x=T(P(:,2));
y=R(P(:,1));
plot(x,y,'s','color','white');
% 找出最长的直线边缘
lines = houghlines(I4,T,R,P,'FillGap',5,'MinLength',7);

figure( 'Name', '直线检测'), imshow(I),hold on;
max_len=0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   % 标记直线边缘对应的起点
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   % 计算直线边缘长度
   line_y(k)=xy(1,2);
end

%%分区域处理
a1=min(line_y);
b1=round(median(line_y));
c1=max(line_y);
end 