function [ruler_out,major_result,minor_result,mark1_for_min_0,mark2_for_lineup]=tick2num(locs1,locs2rev,main_mark_firstnum,fistnum,resolution,m_resolution)

for i=1:length(locs2rev)
    for j=1:length(locs1)
    dist(i,j)=locs2rev(i)-locs1(j);
    end
end

%游标读数
minor2main_dist=min(abs(dist(:)));
[x1,y1]=find(abs(dist)==minor2main_dist); %% x1表示是第几个minor刻度，y1表示第几个主刻度
mark2_for_lineup=x1;
minor_result=[x1(1)-1]*resolution;
%disp(['minor tick is  ',num2str(x1) ]);
disp(['num is',num2str(minor_result),',即对齐位置为游标第',num2str(x1(1)),'个刻度处']);
% minor_tick_locs=locs2(1,x(1));  % 返回对齐的位置
% major_tick_locs=locs1(1,y(1));  
% disp(['major tick and minor tick locate at ',num2str(major_tick_locs),'and ',num2str(minor_tick_locs),' respectively' ]);


% 主尺读数
% 游标0对应主尺刻度的位置
minor0_2_main_tick_dist=min(abs(dist(1,:)));  % 找游标第一个刻度（0）对应的主尺最小距离位置
[x,y]=find(abs(dist(1,:))==minor0_2_main_tick_dist); %%y表示是主刻度的第几个刻度线
% if minor_result<=10*5*resolution/2
%     mark0=y(1);
%     mark1_for_min_0=locs1(1,y(1)); % 离游标0最近的为主尺读数 且游标读数小于主尺最小刻度的一半
% else 
%     mark0=y(1)-1;
%     mark1_for_min_0=locs1(1,y(1)-1); % 离游标0最近的为主尺读数减1 
% end
%updated at 2022.11.1
vv=dist(1,y);
if dist(1,y)<=0  || minor_result>=10*5*resolution*0.4   %位于左侧且游标读数大于0.4倍游标量程，需要主刻度-1
    mark1_for_min_0=y(1)-2;
else 
    mark1_for_min_0=y(1); % 离游标0最近的为主尺读数减1 
end

disp(['游标0刻度位于主尺第',num2str(mark1_for_min_0),'个刻度线处']); %
  
%%%%%%主尺读数%%%%
major_result=(mark1_for_min_0-main_mark_firstnum)*m_resolution+fistnum;
% 游标读数

%disp(['主尺读数为',num2str(major_result*10) 'mm']); 
ruler_out=major_result*10+minor_result;
%disp(['读数为',num2str(ruler_out) 'mm']); 
