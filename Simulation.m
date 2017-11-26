function result=Simulation(O,S,Flux)
%% main
%preprocess sheltering among objects
global rho_O rho_W C c size_p size_v W;

%create result variable，data are {y,z}, t(time), E(lux)
result=cell(W(2),W(4));

for i=1:length(O)
    E_O=illum1(i,O,S,Flux,size_p,size_v);%calculate illuminance from wall to objects
    for j=W(1):W(2)
        for k=W(3):W(4)
            E_W=illum2(E_O,i,j,k,O,size_p,size_v);%calculate illuminance from objects back to wall
            result{j,k}(i,:)=illum3(E_W,i,j,k,O,size_p,size_v,S);%calculate the effect of a single voxel
        end
    end
end

%scatter3(result(:,1),result(:,2),result(:,3),10,result(:,4),'filled');
%colorbar;

end

function [ E_O ] = illum1( i,O,S,Flux,size_p,size_v )
%illum1 计算第i个voxel面上的照度

n_y=[0,1,0];%n_y is unit vector
n_x=[1,0,0];
n_z=[0,0,1];

a=O{i};
r=a.*size_v-S.*[0,size_p];%r为体素i到S的向量
R=norm(r);
cos_angle_s=abs(dot(r,n_x)/norm(r));

cos_angle_y=abs(dot(n_y,r)/R);
I=Flux/pi;%发光强度
E_O_y=I*cos_angle_s*cos_angle_y/R^2;%体素上平行于oxz平面的面接收到的光照度

%同理，另外两个面的照度可以求出来
cos_angle_x=abs(dot(n_x,r)/R);
E_O_x=I*cos_angle_s*cos_angle_x/R^2;%体素上平行于oyz平面的面接收到的光照度

cos_angle_z=abs(dot(n_z,r)/R);
E_O_z=I*cos_angle_s*cos_angle_z/R^2;%体素上平行于oxy平面的面接收到的光照度

E_O=[E_O_x,E_O_y,E_O_z];
end

function [ E_W ] = illum2( E_O,i,j,k,O,size_p,size_v )
%illum2 calculate illuminance of voxel i to pixel [j,k]
global rho_O;
n_y=[0,1,0];%n_y is unit vector
n_x=[1,0,0];
n_z=[0,0,1];

a=O{i};
r=a.*size_v-[0,[j,k].*size_p];
R=norm(r);
%consider shelter among voxels
% for n=[1:i-1,i+1:length(O)]
%     a_prime=O{n};
%     r_prime=a_prime.*size_v-[0,[j,k].*size_p];
%     R_prime=norm(r_prime);
%     if cross(r,r_prime)/R/R_prime<=1/sqrt(2)/min(R,R_prime)
%         E_W=0;
%         return;
%     end;
% end;

cos_angle_ix=abs(dot(r,n_x)/R);
cos_angle_iy=abs(dot(r,n_y)/R);
cos_angle_iz=abs(dot(r,n_z)/R);

Lx=rho_O*E_O(1)/pi;
Ly=rho_O*E_O(2)/pi;
Lz=rho_O*E_O(3)/pi;

S=size_v(1)*size_v(2);
Ix=Lx*cos_angle_ix*S;
Iy=Ly*cos_angle_iy*S;
Iz=Lz*cos_angle_iz*S;

E_W=(Ix*cos_angle_ix+Iy*cos_angle_iy+Iz*cos_angle_iz)/R^2;
end

function result = illum3( E_W,i,j,k,O,size_p,size_v,S )
%illum3 calculate the illuminance of pixel [j,k] and total flight time
global C rho_W c;
%n_x=[1,0,0];

r_s=S.*[0,size_p];
r_p=[0,[j,k].*size_p];
r_v=O{i}.*size_v;
R_sv=norm(r_s-r_v);
R_vp=norm(r_v-r_p);
R_pc=norm(r_p-C);
%cos_angle_pc=abs(dot(r_p-C,n_x)/R_pc);
%flux=E_W*size_p(1)*size_p(2);
%I=rho_W*flux/pi;
%E=I*(cos_angle_pc)^2/R_pc^2;
E=E_W;
t=(R_sv+R_vp+R_pc)/c;

result=[t,E];
end