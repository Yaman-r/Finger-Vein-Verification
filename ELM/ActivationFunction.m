function H = ActivationFunction(H_temp,activationFunctionType)

switch lower(activationFunctionType)
    case {'sig','sigmoid'} % Sigmoid 
        H = 1./(1 + exp(-H_temp));
    case {'sin','sine'} % Sine
        H = sin(H_temp);    
    case {'hardlim'}  % Hard Limit
        H = double(hardlim(H_temp));
    case {'tribas'}  % Triangular basis function
        H = tribas(H_temp);
    case {'radbas'}  % Radial basis function
        H = radbas(H_temp); 
end

end