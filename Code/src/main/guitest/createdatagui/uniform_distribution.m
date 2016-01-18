% Created by: Isak Bohman, 2015
function [ num ] = uniform_distribution(mu, sigma)
% Generates a number from a uniform distribution.
a = mu-sqrt(3)*sigma;
b = mu+sqrt(3)*sigma;
% We don't want numbers below zero.
if a <0
    a=0;
    b=b+a;
end

num = max(0,floor(randi(round(b-a+1),1,1)+round(a)));

end

