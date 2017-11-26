function []=Draw_Cube(X,Y,Z,V)
global Max_Trav Min_Trav O;

figure;
L = length(X);
for i = 1 : L 
    Dot_to_Cube(X(i),Y(i),Z(i),V(i),1);  %棱长1
    hold on;
end
%同样标记出物点
 L_O = length(O);
 XO = zeros(1,L_O);
 YO = zeros(1,L_O);
 ZO = zeros(1,L_O);
 for i = 1 : L_O
     XO(i) = O{i}(1);
     YO(i) = O{i}(2);
     ZO(i) = O{i}(3);
 end
% figure;
 for i =1 : length(O)
     Dot_to_Cube(XO(i),YO(i),ZO(i),'r',0.5);
     hold on;
 end
 Min_Axis = min(Min_Trav);
 Max_Axis = max(Max_Trav);
 
axis([ Min_Axis Max_Axis Min_Axis Max_Axis Min_Axis Max_Axis]);
end

function [  ] = Dot_to_Cube( x,y,z,i,a )
%将三维离散点(x,y,z)画成以(x,y,z)为体心的一个棱长为a的立方体
%实现方式：画出立方体的六个面
%i对应离散点(x,y,z)的强度,即对应colorbar,因此不同强度的点可以用不同颜色的立方体表示（颜色即代表强度）
X = [x-a/2;x-a/2;x-a/2;x-a/2];%left
Y = [y-a/2;y+a/2;y+a/2;y-a/2];
Z = [z-a/2;z-a/2;z+a/2;z+a/2];
C=i;
fill3(X,Y,Z,C,'edgecolor','none','facealpha',0.6);
colorbar;
hold on
X = [x+a/2;x+a/2;x+a/2;x+a/2];%right
Y = [y-a/2;y+a/2;y+a/2;y-a/2];
Z = [z-a/2;z-a/2;z+a/2;z+a/2];
fill3(X,Y,Z,C,'edgecolor','none','facealpha',0.6);
hold on
X = [x-a/2;x-a/2;x+a/2;x+a/2];%up
Y = [y-a/2;y+a/2;y+a/2;y-a/2];
Z = [z+a/2;z+a/2;z+a/2;z+a/2];
fill3(X,Y,Z,C,'edgecolor','none','facealpha',0.6);
hold on
X = [x-a/2;x-a/2;x+a/2;x+a/2];%down
Y = [y-a/2;y+a/2;y+a/2;y-a/2];
Z = [z-a/2;z-a/2;z-a/2;z-a/2];
fill3(X,Y,Z,C,'edgecolor','none','facealpha',0.6);
hold on
X = [x-a/2;x-a/2;x+a/2;x+a/2];%front
Y = [y+a/2;y+a/2;y+a/2;y+a/2];
Z = [z-a/2;z+a/2;z+a/2;z-a/2];
fill3(X,Y,Z,C,'edgecolor','none','facealpha',0.6);
hold on
X = [x-a/2;x-a/2;x+a/2;x+a/2];%behind
Y = [y-a/2;y-a/2;y-a/2;y-a/2];
Z = [z-a/2;z+a/2;z+a/2;z-a/2];
fill3(X,Y,Z,C,'edgecolor','none','facealpha',0.6);
end