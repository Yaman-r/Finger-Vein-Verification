function eta=ComputeEta(resp,respFunc,etaVal)

if resp<min(respFunc)
    eta=etaVal(respFunc==min(respFunc));
    return;
elseif resp>max(respFunc)
    eta=etaVal(respFunc==max(respFunc));
    return;
end

if resp==0 || resp<0.001
    eta=0;
elseif resp>0
    ind=length(respFunc);
    while resp>respFunc(ind)
        ind=ind-1;
    end
    eta=etaVal(ind+1);
elseif resp<0
    ind=1;
    while resp<respFunc(ind)
        ind=ind+1;
    end
    eta=etaVal(ind);
end
end