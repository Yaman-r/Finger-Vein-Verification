function V = WideLineDetector(F , r , g, t)
% wide line detector method
% r,g,t parameters described in the paper
H = size(F , 1);
W = size(F , 2);
% V = F;
V=zeros(size(F));
for x0 = 1 : W
    for y0 = 1:H
       m = 0;
       cnt = 0;
       for i=-r:r
          for j=-r:r
              x=x0+i;
              y=y0+j;
              if x < 1 || x > W || y < 1 || y > H 
                  continue
              elseif (x-x0)*(x-x0)+(y-y0)*(y-y0) > r*r 
                  continue;
              end
              cnt = cnt + 1;
              if F(y,x) - F(y0,x0) > t
                  s=0;
              else
                  s=1;
              end
              m = m+s;       
          end
       end
       if m/cnt > g
           V(y0,x0) = 0;
       else
           V(y0,x0) = 1;
       end
    end
end

