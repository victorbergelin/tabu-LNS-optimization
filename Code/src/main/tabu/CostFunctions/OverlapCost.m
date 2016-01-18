function C=OverlapCost(data,tempSolution)
%% Calculate OverlapCost
% Calulates cost for tasks that are overlapping on timeline
% Compares the starting and ending time of all tasks in the data.
% Accumulates result in C. One time unit overlap is one cost unit in C.
% 
% Created by: Victor Bergelin and Emelie Karlsson
% 
% Version number: 1.0
% 0.01: minimal usage implementation
% 1.0: Clean and commented code
% 


% Initially 0 cost
C = 0;
overlap= 0;

% Loop over all tasks
[no_tasks, m] = size(data.tasks);

try
    for i=1:no_tasks-1
        
        timeline1 = data.tasks(i,4);
        % Column 6: current solution
        start_task1 = tempSolution(i,2);
        length_task1 = data.tasks(i,5);
        end_task1 = start_task1 + length_task1;
        
        for j=i+1:no_tasks
            timeline2 = data.tasks(j,4);
            
            % Compare tasks on the same timeline
            if timeline1 == timeline2
                start_task2 = tempSolution(j,2);
                length_task2 =  data.tasks(j,5);
                end_task2 = start_task2 + length_task2;
                
                % If task two starts after task one - two cases of overlap
                if start_task2 >= start_task1 && start_task2 <= end_task1
                    if end_task2 >= end_task1
                        overlap = abs(end_task1 - start_task2);
                    elseif end_task2 <= end_task1
                        
                        % find closest edge and calculate distance 
                        totaloverlapaddition = ...
                            min(abs(end_task1-end_task2), ...
                               (abs(start_task1-start_task2)));
                        
                        overlap = length_task2 + totaloverlapaddition;
                        
                    end
                    
                    % If task two starts before task one - two cases of overlap
                elseif start_task2 <= start_task1
                    if end_task2 >= start_task1 && end_task2 <= end_task1
                        overlap = abs(end_task2 - start_task1);
                    elseif end_task2 >= end_task1
                        
                        totaloverlapaddition = ...
                            min(abs(end_task1-end_task2), ...
                               (abs(start_task1-start_task2)));
                        
                        overlap = length_task1 + totaloverlapaddition;
                        
                    end
                end
                C = C + overlap;
            end
        end
        
    end
catch err
    fprintf(obj.Logfile, getReport(err,'extended'));
    rethrow(err)
end


end