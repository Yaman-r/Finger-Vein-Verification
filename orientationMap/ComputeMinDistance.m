function [dis,index]=ComputeMinDistance(node1,node2)
start1=node1.start;
start2=node2.start;
end1=node1.end;
end2=node2.end;
dis1=sqrt((start1(1)-start2(1))^2+(start1(2)-start2(2))^2);
dis2=sqrt((start1(1)-end2(1))^2+(start1(2)-end2(2))^2);
dis3=sqrt((end1(1)-start2(1))^2+(end1(2)-start2(2))^2);
dis4=sqrt((end1(1)-end2(1))^2+(end1(2)-end2(2))^2);
dis=min([dis1 dis2 dis3 dis4]);
index=find(dis==min(dis));
end