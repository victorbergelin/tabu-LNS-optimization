function [status,data] = SimpleSortAndPlace(data,model)
%% SimpleSortAndPlace initial solution solver
% Put the task in the middle of the allowed area
%
% Created by: Victor Bergelin and Emelie Karlsson
% 
% Version number: 1.0
% 0.01: simplest possible, lacks status/error handling
% 0.02: error and status handling implemented
% 1.0: Clean and commented code

status = 0;

try
    % Put tasks in place
    nrtasks = size(data.tasks,1);
    for i = 1:nrtasks
        meanplace = mean(data.tasks(i,2:3));
        length = data.tasks(i,5);
        data.tasks(i,6) = round(meanplace-length/2);
    end
    
    status = 1;
catch err
    rethrow(err)
    status = -1;
end
