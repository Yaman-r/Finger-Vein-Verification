close all
imshow(imOut);
hold on
for i=1:length(nodes)
if  isempty(find(i==initContour{2})) 
    continue;
end
    plot(nodes(i).start(1),nodes(i).start(2),'r*');
    plot(nodes(i).end(1),nodes(i).end(2),'g*');
end
%pause(0.5)
%end
hold off