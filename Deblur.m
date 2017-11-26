function [ Ind ] = Deblur( F,H_f,size )

lambda=0.7;

Ind=[];
siz=size([2,3]);
[X,~,~]=ind2sub(size,F);
uX=unique(X);

for n=1:length(uX)
    H_x=H_f(uX(n),:,:);
    H_x=reshape(H_x,siz);
    B=imregionalmax(H_x);%note: this func can be used in 3d situation; find regional maximum

    seed=find(B);%image growth
    for m=1:length(seed)
        V=H_x(seed(m));%maxima value
        seed_ind=seed(m);
        while ~isempty(seed_ind)
            new_seed=[];%find new points satisfy threshold
            for i=1:length(seed_ind)
                [y,z]=ind2sub(siz,seed_ind(i));
                ind=find(H_x(y-1:y+1,z-1:z+1)>=lambda*V);
                [Y,Z]=ind2sub([3,3],ind);
                Y=Y+y-2;
                Z=Z+z-2;
                ind=sub2ind(siz,Y,Z);
                new_seed=[new_seed;ind];
            end
            new_seed=setdiff(unique(new_seed),find(B));
            B(new_seed)=1;
            seed_ind=new_seed;
        end
    end
    
    [ind_y,ind_z]=ind2sub(siz,find(B));
    Ind=[Ind;sub2ind(size,uX(n)*ones(length(ind_y),1),ind_y,ind_z)];
end

end