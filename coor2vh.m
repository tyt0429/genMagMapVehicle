function magvh = coor2vh(M, G)
for i = 1:size(M, 1)
    a(i)=dot(G(i,:),M(i,:))/norm(G(i,:));%地磁投影至重力方向 純量
    V(i,:)=a(i)* (G(i,:)/norm(G(i,:)));%投影後向量----垂直分量
    H(i,:)=M(i,:)-V(i,:);%水平分量
    b(i)=norm(H(i,:));%水平分量強度
    c(i)=norm(M(i,:));%地磁總強度     
    a(i)=-a(i);    
end

magvh=[b;a;c;]';