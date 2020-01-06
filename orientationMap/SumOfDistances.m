function summation=SumOfDistances(contour,adjMat)
% Sum of distance
summation=0;
for i=1:length(contour)-1
    summation=summation+adjMat(contour(i),contour(i+1));
end
summation=summation+adjMat(contour(1),contour(end));
end