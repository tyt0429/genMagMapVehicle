function coor = interpPosOri(sensor, trj, pos_trans)
xi = sensor(:,1);
x_pos = interp1(trj(:,1), pos_trans(:,1), xi, 'linear');
y_pos = interp1(trj(:,1), pos_trans(:,2), xi, 'linear');
z_pos = interp1(trj(:,1), trj(:,4), xi, 'linear');
x_ori = interp1(trj(:,1), trj(:,5), xi, 'linear');
y_ori = interp1(trj(:,1), trj(:,6), xi, 'linear');
z_ori = interp1(trj(:,1), trj(:,7), xi, 'linear');
coor = [xi x_pos y_pos z_pos x_ori y_ori z_ori];

end