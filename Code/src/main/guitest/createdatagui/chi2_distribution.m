% Created by: Isak Bohman, 2015
function [ num ] = chi2_distribution(mu, sigma)
%   NB: should be a fat tail, so low number of degrees of freedom.
%   Multiply the result in order to get desired expectancy and variance. df =
%   3 or 4! rather 3.
p = rand();

% Generate the number as a fixed number plus a chi-squared number.
num = round(mu-sigma+sigma*chi2inv(p,3)/sqrt(6));

end

