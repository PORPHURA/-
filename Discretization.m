function result=Discretization(result)
%% ¿Î…¢ªØt”ÎE

global min_delta_t nu W;
h=6.62607*10^-34;
E_photon=h*nu;
for x=  W(1):W(2)
    for y = W(3):W(4)
        result{x,y}(:,1)=min_delta_t*ceil(result{x,y}(:,1)/min_delta_t);
        result{x,y}(:,2)=floor(result{x,y}(:,2)/E_photon);
        T=unique(result{x,y}(:,1));
        E=zeros(length(T),1);
        for i=1:length(T)
            EE=result{x,y}(:,2);
            E(i)=sum(EE(result{x,y}(:,1)==T(i)));
        end
        result{x,y}=[T,E];
    end
end
