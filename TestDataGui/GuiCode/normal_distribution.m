% Created by: Isak Bohman, 2015
function [ num ] = normal_distribution(mu, sigma)
% Generate a number from a normal distribution.

% Select a percentile
p = 0.5*rand()+0.5;


% % Use a folded normal distribution.
% 
% x0 = [mu,sigma];
% 
% function F = root(x, mu, sigma)
% F(1) = x(1)*sqrt(2/pi)*exp(-x(1)^2/2/x(2)^2) + x(1)*(1-2*normcdf(-x(1)/x(2),0,1))-mu;
% F(2) = x(1)^2+x(2)^2-mu^2-sigma^2;
% end
% 
% % A = root(x0, mu, sigma)
% 
% fun = @(x) root(x,mu,sigma);
% 
% x = fsolve(fun,x0);
% 
% % To be found via equation-solving.
% mu_mod = x(1);
% 
% sigma_mod = x(2);

% Create a number with the desired characteristics.
num = round(norminv(p,mu,sigma));


end

