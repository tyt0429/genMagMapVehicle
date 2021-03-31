function magXYZ = coor2xyz(magPhone, orientation)
for i = 1:size(magPhone, 1)
    Rx = rotx(-orientation(i,1));
    Ry = roty(-orientation(i,2));
    Rz = rotz(-orientation(i,3));
    
    magXYZ(i,1:3) = Rz*Ry*Rx*[magPhone(i,1);magPhone(i,2);magPhone(i,3);]; 
    magXYZ(i,4) = norm(magXYZ(i,1:3));
    
end