function magvh = coor2vh(M, G)
for i = 1:size(M, 1)
    a(i)=dot(G(i,:),M(i,:))/norm(G(i,:));%�a�ϧ�v�ܭ��O��V �¶q
    V(i,:)=a(i)* (G(i,:)/norm(G(i,:)));%��v��V�q----�������q
    H(i,:)=M(i,:)-V(i,:);%�������q
    b(i)=norm(H(i,:));%�������q�j��
    c(i)=norm(M(i,:));%�a���`�j��     
    a(i)=-a(i);    
end

magvh=[b;a;c;]';