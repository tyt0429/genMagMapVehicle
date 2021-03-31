% created by Tang 2020.
clc; clear all; close all;
%% field
x_min = 120.2194;
x_max = 120.2201;
y_min = 22.9995;
y_max = 23.0002;
grid_sz = 0.00005;
addpath functions\;
%% read file
% trj file
format = ['%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'];
fileID = fopen('offline\PR_LC_97.txt','r');
datacell = textscan(fileID, format, 'Delimiter', ',', 'HeaderLines', 24, 'CollectOutput', 1);
fclose(fileID);
trj_data = datacell{1,1};
trj_data(:,[2, 3]) = trj_data(:,[3, 2]);
clear datacell

% load HMR file
fmt = ['%f %f %f %f %f %f %f %f '];
fileID = fopen('offline\HMR3000_20210323_202149.txt','r');
datacell = textscan(fileID, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
fclose(fileID);
HMR_data_inner = datacell{1,1};
HMR_time = HMR_data_inner(:,1);
HMR_time = utc2gps(HMR_time);
HMR_data_inner(:,1) = HMR_time;


% load HMR file
fmt = ['%f %f %f %f %f %f %f %f '];
fileID = fopen('offline\HMR3000_20210323_203350.txt','r');
datacell = textscan(fileID, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
fclose(fileID);
HMR_data_outter = datacell{1,1};
HMR_time = HMR_data_outter(:,1);
HMR_time = utc2gps(HMR_time);
HMR_data_outter(:,1) = HMR_time;

% Androsensor file
format = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
sizetx = [16 Inf];
fileID = fopen('offline\Sensor_record_20210323_202702_AndroSensor_IMU.txt','r');
mi8_data_inner = fscanf(fileID, format, sizetx);
mi8_data_inner = mi8_data_inner';
fclose(fileID);

format = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
sizetx = [16 Inf];

fileID = fopen('offline\Sensor_record_20210323_203939_AndroSensor_IMU.txt','r');
mi8_data_outter = fscanf(fileID, format, sizetx);
mi8_data_outter = mi8_data_outter';
fclose(fileID);


%load bg map
fmt = ['%f %f '];
fileID = fopen('edge.csv','r');
datacell = textscan(fileID, fmt, 'Delimiter', ',', 'HeaderLines', 0, 'CollectOutput', 1);
fclose(fileID);
edge = datacell{1,1};
clear datacell
%% align data
[trj_data_inner,mi8_data_inner] = aligndata(trj_data, mi8_data_inner);
[trj_data_outter,mi8_data_outter] = aligndata(trj_data, mi8_data_outter);

trj_data_inner = trj_data_inner(1:30830,:);
figure();
plot(edge(:,1),edge(:,2),'.');hold on;
plot(trj_data_inner(:,end-1),trj_data_inner(:,end),'.');hold on;
plot(trj_data_outter(:,end-1),trj_data_outter(:,end),'.');
%% trj interpolation & split processing
[mag_data_inter_inner, trj_interp_mag_inner] = inter2trjbytime(mi8_data_inner, trj_data_inner);
[mag_data_inter_outter, trj_interp_mag_outter] = inter2trjbytime(mi8_data_outter, trj_data_outter);

mag_data_inter_inner(:,17:19) = coor2vh(mag_data_inter_inner(:,11:13), mag_data_inter_inner(:,4:6));
mag_data_inter_outter(:,17:19) = coor2vh(mag_data_inter_outter(:,11:13), mag_data_inter_outter(:,4:6));
% cut section
trj_interp_mag_inner = [trj_interp_mag_inner,zeros(length(trj_interp_mag_inner),1)];
trj_interp_mag_inner(1:259,end) = 1;
trj_interp_mag_inner(469:729,end) = 2;
trj_interp_mag_inner(1052:1262,end) = 3;
trj_interp_mag_inner(1658:1788,end) = 4;
trj_interp_mag_inner(1815:1886,end) = 5;
trj_interp_mag_inner(1933:2078,end) = 6;
trj_interp_mag_inner(2569:2686,end) = 7;
trj_interp_mag_inner(2721:2802,end) = 8;
trj_interp_mag_inner(2832:2997,end) = 9;
trj_inner_1 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==1,:);
trj_inner_2 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==2,:);
trj_inner_3 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==3,:);
trj_inner_4 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==4,:);
trj_inner_5 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==5,:);
trj_inner_6 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==6,:);
trj_inner_7 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==7,:);
trj_inner_8 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==8,:);
trj_inner_9 = trj_interp_mag_inner(trj_interp_mag_inner(:,end)==9,:);
% dir 1=> 2<= 3up 4down
trj_interp_mag_inner = [trj_interp_mag_inner,zeros(length(trj_interp_mag_inner),1)];
trj_interp_mag_inner(trj_interp_mag_inner(:,end-1)==1 | trj_interp_mag_inner(:,end-1)==4 | trj_interp_mag_inner(:,end-1)==7,end) = 1;
trj_interp_mag_inner(trj_interp_mag_inner(:,end-1)==3 | trj_interp_mag_inner(:,end-1)==6 | trj_interp_mag_inner(:,end-1)==9,end) = 2;
trj_interp_mag_inner(trj_interp_mag_inner(:,end-1)==2,end) = 3;
trj_interp_mag_inner(trj_interp_mag_inner(:,end-1)==5 | trj_interp_mag_inner(:,end-1)==8,end) = 4;

figure();
plot(edge(:,1),edge(:,2),'.'); hold on;
plot(trj_inner_1(:,2),trj_inner_1(:,3),'.');hold on;
plot(trj_inner_2(:,2),trj_inner_2(:,3),'.');hold on;
plot(trj_inner_3(:,2),trj_inner_3(:,3),'.');hold on;
plot(trj_inner_4(:,2),trj_inner_4(:,3),'.');hold on;
plot(trj_inner_5(:,2),trj_inner_5(:,3),'.');hold on;
plot(trj_inner_6(:,2),trj_inner_6(:,3),'.');hold on;
plot(trj_inner_7(:,2),trj_inner_7(:,3),'.');hold on;
plot(trj_inner_8(:,2),trj_inner_8(:,3),'.');hold on;
plot(trj_inner_9(:,2),trj_inner_9(:,3),'.');

% cut section
trj_interp_mag_outter = [trj_interp_mag_outter,zeros(length(trj_interp_mag_outter),1)];
trj_interp_mag_outter(1:343,end) = 1;
trj_interp_mag_outter(587:878,end) = 2;
trj_interp_mag_outter(1188:1418,end) = 3;
trj_interp_mag_outter(1932:2164,end) = 4;
trj_interp_mag_outter(2211:2297,end) = 5;
trj_interp_mag_outter(2394:2646,end) = 6;
trj_interp_mag_outter(2973:3191,end) = 7;
trj_interp_mag_outter(3231:3363,end) = 8;
trj_interp_mag_outter(3420:3722,end) = 9;
trj_outter_1 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==1,:);
trj_outter_2 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==2,:);
trj_outter_3 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==3,:);
trj_outter_4 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==4,:);
trj_outter_5 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==5,:);
trj_outter_6 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==6,:);
trj_outter_7 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==7,:);
trj_outter_8 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==8,:);
trj_outter_9 = trj_interp_mag_outter(trj_interp_mag_outter(:,end)==9,:);
% dir 1=> 2<= 3up 4down
trj_interp_mag_outter = [trj_interp_mag_outter,zeros(length(trj_interp_mag_outter),1)];
trj_interp_mag_outter(trj_interp_mag_outter(:,end-1)==1 | trj_interp_mag_outter(:,end-1)==4 | trj_interp_mag_outter(:,end-1)==7,end) = 1;
trj_interp_mag_outter(trj_interp_mag_outter(:,end-1)==3 | trj_interp_mag_outter(:,end-1)==6 | trj_interp_mag_outter(:,end-1)==9,end) = 2;
trj_interp_mag_outter(trj_interp_mag_outter(:,end-1)==2,end) = 3;
trj_interp_mag_outter(trj_interp_mag_outter(:,end-1)==5 | trj_interp_mag_outter(:,end-1)==8,end) = 4;

figure();
plot(edge(:,1),edge(:,2),'.'); hold on;
plot(trj_outter_1(:,2),trj_outter_1(:,3),'.');hold on;
plot(trj_outter_2(:,2),trj_outter_2(:,3),'.');hold on;
plot(trj_outter_3(:,2),trj_outter_3(:,3),'.');hold on;
plot(trj_outter_4(:,2),trj_outter_4(:,3),'.');hold on;
plot(trj_outter_5(:,2),trj_outter_5(:,3),'.');hold on;
plot(trj_outter_6(:,2),trj_outter_6(:,3),'.');hold on;
plot(trj_outter_7(:,2),trj_outter_7(:,3),'.');hold on;
plot(trj_outter_8(:,2),trj_outter_8(:,3),'.');hold on;
plot(trj_outter_9(:,2),trj_outter_9(:,3),'.');

%time x y section direction mag x y z v h sum
map_inner = [trj_interp_mag_inner(:,1:3), trj_interp_mag_inner(:,10:11), mag_data_inter_inner(:,11:13), mag_data_inter_inner(:,17:19)];
map_outter = [trj_interp_mag_outter(:,1:3), trj_interp_mag_outter(:,10:11), mag_data_inter_outter(:,11:13), mag_data_inter_outter(:,17:19)];

%only cut section
map_inner = map_inner(trj_interp_mag_inner(:,end-1)~=0,:);
map_outter = map_outter(trj_interp_mag_outter(:,end-1)~=0,:);
%% acc distance
map_inner = [map_inner,zeros(length(map_inner),1)];
dis(1,2) = 0;
center = [];
p = 1;
for i = 1:length(map_inner)-1    
    dis(i,1) = sqrt((map_inner(i+1,2)-map_inner(i,2)).^2 + (map_inner(i+1,3)-map_inner(i,3)).^2);
    dis(i+1,2) = dis(i,2) + dis(i,1);
    %another section
    if map_inner(i,4) ~= map_inner(i+1,4)
        %0~fix(dis(i,1))
        for j = 1:fix(dis(i,2))
            [~, iMin] = min(abs(map_inner(p:i,12)-(j-0.5)));
            center = [center; iMin+p-1];
        end
        map_inner_c = map_inner(center,:);
        dis(i+1,2) = 0;
        p = i+1;
    end
    map_inner(i+1,end) = dis(i+1,2);
end
%last section
for j = 1:fix(dis(i+1,2))
    [~, iMin] = min(abs(map_inner(p:i+1,12)-(j-0.5)));
    center = [center; iMin+p-1];
end
map_inner_c = map_inner(center,:);
%
map_outter = [map_outter,zeros(length(map_outter),1)];
dis = [];
dis(1,2) = 0;
center = [];
p = 1;
for i = 1:length(map_outter)-1    
    dis(i,1) = sqrt((map_outter(i+1,2)-map_outter(i,2)).^2 + (map_outter(i+1,3)-map_outter(i,3)).^2);
    dis(i+1,2) = dis(i,2) + dis(i,1);
    %another section
    if map_outter(i,4) ~= map_outter(i+1,4)
        %0~fix(dis(i,1))
        for j = 1:fix(dis(i,2))
            [~, iMin] = min(abs(map_outter(p:i,12)-(j-0.5)));
            center = [center; iMin+p-1];
        end
        map_outter_c = map_outter(center,:);
        dis(i+1,2) = 0;
        p = i+1;
    end
    map_outter(i+1,end) = dis(i+1,2);
end
%last section
for j = 1:fix(dis(i+1,2))
    [~, iMin] = min(abs(map_outter(p:i+1,12)-(j-0.5)));
    center = [center; iMin+p-1];
end
map_outter_c = map_outter(center,:);
%write file
header = {'GPST','TWD97_x','TWD97_y','Section','Direction','Mag_x','Mag_y','Mag_z','Mag_v','Mag_h','Mag_sum','Grid'};
map_inner_output = [header; num2cell(map_inner_c)];
map_outter_output = [header; num2cell(map_outter_c)];
writetable(cell2table(map_inner_output), 'map_inner_output.csv', 'writevariablenames', false, 'quotestrings', true);
writetable(cell2table(map_outter_output), 'map_outter_output.csv', 'writevariablenames', false, 'quotestrings', true);
%trj figure
% edge(:,1) = edge(:,1) - 170000;
% edge(:,2) = edge(:,2) - 2544000;
% trj_interp_mag_inner(:,2) = trj_interp_mag_inner(:,2) - 170000;
% trj_interp_mag_inner(:,3) = trj_interp_mag_inner(:,3) - 2544000;
% trj_interp_mag_outter(:,2) = trj_interp_mag_outter(:,2) - 170000;
% trj_interp_mag_outter(:,3) = trj_interp_mag_outter(:,3) - 2544000;
figure('Name', 'trj interpolation(trans)');
plot(edge(:,1),edge(:,2),'.'); hold on;
plot(trj_interp_mag_inner(:,2),trj_interp_mag_inner(:,3),'b.'); hold on;
plot(trj_interp_mag_outter(:,2),trj_interp_mag_outter(:,3),'c.');
grid on;
axis equal tight;
%% mag map
%x 
figure();
plot3(map_inner(:,2), map_inner(:,3), map_inner(:,11));hold on;
plot(edge(:,1),edge(:,2),'.');

figure();
plot3(map_outter(:,2), map_outter(:,3), map_outter(:,11));hold on;
plot(edge(:,1),edge(:,2),'.');
