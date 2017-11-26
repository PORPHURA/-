function F_union=Intersect_soft(F_n,size)

weight_inter = 0.15;
weight_neigh = 0.02;

F_union=[];
for n=1:length(F_n)
    F_union = union(F_union,F_n{n});
end
F_weight = zeros(2,length(F_union));
for i = 1 : length(F_union)
    for n=1:length(F_n)
        F_weight(1,i)=F_weight(1,i)+any(F_n{n}==F_union(i));
    end
end
for i = 1 : length(F_union)
    ind=F_union(i);
    F_weight(2,i)=length(intersect([ind,ind+1,ind-1,ind+size(1),ind+size(1)+1,ind+size(1)-1,ind-size(1)+1,ind-size(1)-1,size(1)*size(2)+[ind,ind+1,ind-1,ind+size(1),ind+size(1)+1,ind+size(1)-1,ind-size(1)+1,ind-size(1)-1],-size(1)*size(2)+[ind,ind+1,ind-1,ind+size(1),ind+size(1)+1,ind+size(1)-1,ind-size(1)+1,ind-size(1)-1]],F_union));
end
F_union(F_weight(1,:)*weight_inter+F_weight(2,:)*weight_neigh<1)=[];

end
