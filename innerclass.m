function a=innerclass(img , hand )
    %% a : 
    % 1 index left hand 
    % 2 middle left hand 
    % 3 ring left hand
    % 4 index right hand
    % 5 middle right hand
    % 6 ring right hand
    if img(1) == 'i'
        a=1;
    elseif img(1) == 'm'
        a=2;
    elseif img(1) == 'r'
        a=3;
    else
        display('error innerclass');
    end
    a = a+(hand-1)*3; 
end