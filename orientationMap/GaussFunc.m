function z=GaussFunc(std,x,y)
z=(1/(pi*std^2))*exp(-(x.^2+y.^2)/(std^2));
end