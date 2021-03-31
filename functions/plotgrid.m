function Z = plotgrid(name, mag_data, trj, x_min, x_max, y_min, y_max, gridsize)


z = mag_data;
T = delaunay(trj(:,1),trj(:,2));
subplot(1,3,1);
trisurf(T,trj(:,1),trj(:,2),z);xlabel('X(m)');ylabel('Y(m)');zlabel('Magnetic field(µT)');
colorbar;
set(gca,'FontWeight','bold','fontsize',18);
axis equal tight;

x = x_min:gridsize:x_max;
y = y_min:gridsize:y_max;
[X,Y] = meshgrid(x,y);
V = [trj(:,1),trj(:,2),z];
Z = gridtrimesh(T,V,X,Y);

subplot(1,3,2);
surf(X,Y,Z); xlabel('X(m)');ylabel('Y(m)');zlabel('Magnetic field(µT)');
set(gca,'FontWeight','bold','fontsize',18);
colorbar;
axis equal tight;

subplot(1,3,3);
imagesc([x_min x_max],[y_min y_max],Z);
set(gca,'YDir','normal','FontWeight','bold','fontsize',18);
colorbar;
axis equal tight;

title(name)
end