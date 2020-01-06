function [weights,d]=ComputeWeights(eta,rs)
% Equation 16 & 17 in paper
d=abs(1-2.*eta).*rs;
weights=1./(d+eps);
end