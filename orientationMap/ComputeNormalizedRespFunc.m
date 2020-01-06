function [s,etaVal]=ComputeNormalizedRespFunc(rt)

etaVal=0:0.001:1;
s=zeros(1,length(etaVal));

etaR=0.5*(1-rt);
etaRDash=0.5*(1+rt);

% Computing s according to equation 15 in page 6 in the paper
for j=1:length(etaVal)
    phiL=acos(1-2*etaVal(j));
    phiS=acos((1-2*etaVal(j))/rt);
 
    func1= @(theta) (-1/pi)*exp(-(16*(1-2*etaVal(j))^2)./(cos(theta).^2));
    
    func21= @(theta) (-1/pi)*exp(-(16*(1-2*etaVal(j))^2)./(cos(theta).^2));
    func22= @(theta) (1/pi)*exp(-(16*(1-2*etaVal(j))^2)./(rt^2.*cos(theta).^2));
    
    func31= @(theta) (1/pi)*exp(-(16*(1-2*etaVal(j))^2)./(cos(theta).^2));
    func32= @(theta) (-1/pi)*exp(-(16*(1-2*etaVal(j))^2)./(rt^2.*cos(theta).^2));
    
    func4= @(theta) (1/pi)*exp(-(16*(1-2*etaVal(j))^2)./(cos(theta).^2));
   
    if etaVal(j)==0 || etaVal(j)==0.5 || etaVal(j)==1
        s(j)=0;
    elseif etaVal(j)>0         && etaVal(j)<=etaR
        s(j)=integral(func1,0,phiL);
    elseif etaVal(j)>etaR      && etaVal(j)<0.5
        s(j)=integral(func21,0,phiL)+integral(func22,0,phiS);
    elseif etaVal(j)>0.5       && etaVal(j)<etaRDash
        s(j)=integral(func31,0,phiL)+integral(func32,0,phiS);
    elseif etaVal(j)>=etaRDash && etaVal(j)<1
        s(j)=integral(func4,0,phiL);
    end
    
end

end