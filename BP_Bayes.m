function H_f=BP_Bayes(result,S)

global C c Max_Trav Min_Trav size_p size_v W lambda_glob;

sigma=75*10^-12;
coef_c=2.4;
coef_d=20;
step=1;

H=PD(result,S,sigma,coef_c,coef_d,step);
H_f=Filter(H);

%ª≠…¢µ„Õº

% F=find(H_f);
% [X,Y,Z]=ind2sub(size(H_f),F);
% V=H_f(F);
% scatter3(X,Y,Z,20,V,'filled');   
%ª≠«–∆¨Õº
%slice(H_f,1:MAX_Trav(1),[],[]);

end

function [ P ] = PD( result,S,sigma,coef_c,coef_d,step )
%return the posterior probability of voxel space
global C c Min_Trav Max_Trav W size_p size_v;

a=W(2)-W(1)+1;
b=W(4)-W(3)+1;
S=S.*[0,size_p];
w(:,1)=reshape(repmat(W(1):W(2),b,1),a*b,1);
w(:,2)=repmat(W(3):W(4),1,a)';
M_w=w*diag(size_p);
M_w=[zeros(a*b,1),M_w];
M_wc=sqrt(sum(bsxfun(@minus,M_w,C).^2,2));
clear w;

P=zeros(Max_Trav);
for i=Min_Trav(1):Max_Trav(1)
    for j=Min_Trav(2):Max_Trav(2)
        for k=Min_Trav(3):Max_Trav(3)

            P(i,j,k)=1;
            r_v=[i,j,k].*size_v;
            M_vw=sqrt(sum(bsxfun(@minus,M_w,r_v).^2,2));
            R_sv=norm(r_v-S);
            T_id=(reshape(M_vw+M_wc,a,b)'+R_sv*ones(a,b))/c;%ideal flight time

            P_id=i*size_v(1)./reshape(M_vw,a,b);
            P_id=P_id.^2;%Ideal probability
            for x=W(1):step:W(2)%Here x axis is the same with y axis in the world coordinate, y axis is z axis in the world coordinate
                for y=W(3):step:W(4)
                    P(i,j,k)=P(i,j,k)*max(0.1,sum((coef_c*P_id(x-W(1)+1,y-W(3)+1)*exp(-(result{x,y}(:,1)-T_id(x-W(1)+1,y-W(3)+1)).^2./sigma^2)).^(result{x,y}(:,2)/coef_d)));%coef controls P in a resonable range
                end
            end
        end
    end
end

end

function [ H_f ] = Filter( H )
global lambda_glob Min_Trav Max_Trav;

H_f=zeros(Max_Trav);
H=max(log(H),0);
for x=Min_Trav(1):Max_Trav(1)
    H_f(x,:,:)=-H(min(x+1,Max_Trav(1)),:,:)+2*H(x,:,:)-H(max(x-1,Min_Trav(1)),:,:);
end
H_f=max(H_f,0);

% H_r=zeros(Max_Trav);%regional maximum value
% for x=Min_Trav(1):Max_Trav(1)
%     for y=Min_Trav(2):Max_Trav(2)
%         for z=Min_Trav(3):Max_Trav(3)
%             H_r(x,y,z)=max(max(max(H_f(max(1,x-3):min(x+3,Max_Trav(1)),max(1,y-3):min(y+3,Max_Trav(2)),max(1,z-3):min(z+3,Max_Trav(3))))));
%         end;
%     end;
% end;
H_f(H_f<lambda_glob*max(max(max(H_f))))=0;

end
