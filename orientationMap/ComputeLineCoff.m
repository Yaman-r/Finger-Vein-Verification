function  [b,k,ekb]=ComputeLineCoff(weights,xi,yi,d,resp)
%Compute the line coefficients
threshold=0.009;
[xi1,yi1]=meshgrid(xi,yi);
ind=find(abs(resp)>=threshold);
xi1=xi1(ind);
yi1=yi1(ind);
weights=weights(ind);
d=d(ind);

error=sum(diff(xi1));

if ~isempty(ind) && length(ind)>1 && error~=0
mat1=[sum(weights(:)) sum(weights(:).*xi1(:));sum(weights(:).*xi1(:)) sum(weights(:).*xi1.*xi1)];
mat2=[sum(weights(:).*yi1(:));sum(weights(:).*xi1.*yi1(:))];
res=mat1\mat2;
b=res(1);
k=res(2);

if isinf(k) || isinf(b)
    b=NaN;
    k=NaN;
end
%Compute error
mat1=abs(k*xi1+b-yi1);
mat2=sqrt(k^2+1);
mat3=((mat1/mat2)-d).^2;
ekb=sum(weights.*mat3);
else
k=NaN;
b=NaN;
ekb=10000;
end

end