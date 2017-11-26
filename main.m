global c rho_W rho_O C min_delta_t nu Max_Trav Min_Trav lambda_glob size_p size_v W;
c=3*10^11;
rho_W=0.9;
rho_O=0.9;
C=[1000,-1000,1500];
min_delta_t=200*10^-12;
nu=3*10^14;
Max_Trav=[75,75,75];
Min_Trav=[40,40,40];
lambda_glob=0.25;
size_p=[100,100];
size_v=[20,20,20];
W=[5,15,5,15];%W=[ymin=1,ymax,zmin=1,zmax](pixel)

S={[0,5,5],[0,5,10],[0,5,15],[0,10,5],[0,10,10],[0,10,15],[0,15,5],[0,15,10],[0,15,15]};%(pixel)
Flux=30*10^-8;%1000 lx,varing by cosine
%% Simulation
global O;
O={[50,50,50],[50,50,51],[50,50,52],[50,51,50],[50,51,51],[50,51,52],[50,52,50],[50,52,51],[50,52,52]};
H_f=cell(1,length(S));
for n=1:length(S)
    result=Simulation(O,S{n},Flux);
    result=Discretization(result);
    tic;
    H_f{n}=BP_Bayes(result,S{n});
    toc;
end
%% Intersect&Deblur
F_n=cell(1,length(S));
for n=1:length(S)
    F_n{n}=find(H_f{n});
end
F=Intersect_soft(F_n,size(H_f{1}));
H=zeros(size(H_f{1}));
for n=1:length(S)
    H(F)=H(F)+H_f{n}(F);
end
H(F)=H(F)/length(S);
H(H<lambda_glob*max(max(max(H))))=0;
Ind=find(H);
Ind=Deblur(Ind,H,size(H));
%% Plot
[X,Y,Z]=ind2sub(size(H),Ind);
V=H(Ind);
Draw_Cube(X,Y,Z,V);