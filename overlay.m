function v=overlay(x,y)
v = zeros([size(x) 3]);
v(:,:,1) = x;
v(:,:,2) = x + 0.4*y;
v(:,:,3) = x;
end