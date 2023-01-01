function [num_loc,main_loc_for_first,min_loc_for_0]=numbuer_location(FileLoc,locs1,a1,b1,c1)
mdata.object = [];
mdata.box= [];
mdata.center= [];
mdata.class= [];

[datafid,datamess] = fopen(FileLoc,"r");    % 打开文本文件，只读模式打开

if datafid==-1
    % 成功打开，返回非负数；打开失败返回-1
    disp(datamess);
    disp("文件打开失败");
else
    tline = fgets(datafid);     % 先读取第一行
    while tline~=-1 % 当一行数据为-1，说明文件所有行遍历结束
        % 判断行开头的第一个单词
        [ln,~,~,n] = sscanf(tline,'%s',1);  % 处理该行
        if ln=="object_names"
            tline1=tline(n+3:end);    % 截断-删除
            Vxyz = sscanf(tline1,'%f',1);   % 读取该行数字
            mdata.object=[mdata.object;Vxyz'];  % 存储在数组
        end
        if ln=="bounding"
            tline1=tline(n+8:end);    
            Vxyz = sscanf(tline1,'%f',4);   
            mdata.box=[mdata.box;Vxyz'];  
        end
        tline = fgets(datafid);     % 迭代
    end
    fclose(datafid);   
    disp("成功读取标注数据");  % 提示
end



% 返回主尺第一个数字first_y(1,1)及其y坐标first_y(1,2)
mdata.center=[round(0.5*(mdata.box(:,2)+mdata.box(:,4))),round(0.5*(mdata.box(:,1)+mdata.box(:,3)))];
first_y=[-1,max(locs1)];
for i=1:length(mdata.object);
    if mdata.center(i,1)>=a1 && mdata.center(i,1)<=b1
        mdata.class(i)=1;  % 主尺数字
        if first_y(1,2)>mdata.center(i,2)
            first_y(1,2)=mdata.center(i,2);
            first_y(1,1)=mdata.object(i);
        end
%         first_y(1,1)=mdata.object(i);
%         first_y(1,2)=min(mdata.center(i,2),first_y(1,2));  
    end
    if mdata.center(i,1)>b1 && mdata.center(i,1)<=c1
        mdata.class(i)=2; % 游标数字
        
    end
end

num_loc(:,1)=mdata.object;
num_loc(:,2:3)=mdata.center;
num_loc(:,4)=mdata.class;
main_num=num_loc(find(num_loc(:,4)==1),:);
min_num=num_loc(find(num_loc(:,4)==2),:);

main_loc_for_first=main_num((find(main_num(:,1)==min(main_num(:,1)))),1:3);
min_loc_for_0=min_num((find(min_num(:,3)==min(min_num(:,3)))),1:3);
end
