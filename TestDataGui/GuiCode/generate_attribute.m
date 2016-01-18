% Created by: Isak Bohman, 2015
function [ TimelineAttribute ] = generate_attribute(TimelineSolution,L,mu1,sigma1,distribution1,mu2,sigma2,distribution2)
% Generates an attribute based on the desired characteristics.

% scaling = (TimelineSolution(2)-TimelineSolution(1))/4;

% Short scale
scale_factor1 = TimelineSolution(2);

% Long scale
scale_factor3 = floor(L/2);

% Medium scale
scale_factor2 = floor(sqrt(scale_factor1*scale_factor3));

% With 25 % probability, use short and long, with 50 % probability, use
% medium length.
p=randi(4,1,1);
switch p
    case 1
        scale_factor = scale_factor1;
    case 2
        scale_factor = scale_factor2;
    case 3
        scale_factor = scale_factor2;
    case 4
        scale_factor = scale_factor3;
end

% Minimum time
rand1 = TimelineSolution(1)-distribution1(mu1*scale_factor,sigma1*scale_factor);

% Maximum time
rand2 = TimelineSolution(2)+TimelineSolution(1)+distribution2(mu2*scale_factor,sigma2*scale_factor);
% rand1 = norminv(rand(1,1),TimelineSolution(1)-mu*scaling,sigma);
% rand2 = norminv(rand(1,1),TimelineSolution(2)+mu*scaling,sigma);
TimelineAttribute = [max(0,rand1), min(L,rand2)];

end

