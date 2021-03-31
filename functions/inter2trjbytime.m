function [data, trj_interp]= inter2trjbytime(data, data2)
xi = data(:,1);
x_pos = interp1(data2(:,1), data2(:,2), xi, 'linear');
y_pos = interp1(data2(:,1), data2(:,3), xi, 'linear');
z_pos = interp1(data2(:,1), data2(:,4), xi, 'linear');
x_pos_twd = interp1(data2(:,1), data2(:,23), xi, 'linear');
y_pos_twd = interp1(data2(:,1), data2(:,24), xi, 'linear');
x_ori = interp1(data2(:,1), unwrap(data2(:,8)*pi/180), xi, 'linear');
y_ori = interp1(data2(:,1), unwrap(data2(:,9)*pi/180), xi, 'linear');
z_ori = interp1(data2(:,1), unwrap(data2(:,10)*pi/180), xi, 'linear');
x_ori = wrapToPi(x_ori)*180/pi;
y_ori = wrapToPi(y_ori)*180/pi;
z_ori = wrapToPi(z_ori)*180/pi;
% z_ori(z_ori(:,1)<10^-4,1) = 0;
trj_interp = [xi x_pos_twd y_pos_twd x_pos y_pos z_pos x_ori y_ori z_ori ];
index = find(~isnan(trj_interp(:,2)));
trj_interp = trj_interp(index,:);

data = data(index,:);
end