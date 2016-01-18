function cost = CostFunction(data, tempSolution, weights)
%% CostFunction wrapper script
% This script is the wrapper for calculating all cost functions 
% and cost weights
%
% Created by: Victor Bergelin and Emelie Karlsson
% 
% Version number: 1.0
% 0.01: minimal usage implementation for one instance and phase
% 1.0: Clean and commented code


% Calculate different cost functions
costDependencies = DependencyCost(data,tempSolution);
costOverlap = OverlapCost(data,tempSolution);
costBounds = BoundsCost(data,tempSolution);

% Calculate costs with weights
cost.dep = weights(1)*costDependencies;
cost.over = weights(2)*costOverlap;
cost.bound = weights(3)*costBounds;
cost.total = cost.dep + cost.over + cost.bound;
end

