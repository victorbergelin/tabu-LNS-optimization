function [status, data] = GetData(dataParameters,logfile)
%% Load data from parameter paths
%
% Created by: Victor Bergelin and Emelie Karlsson
% 
% Version number: 1.0
% 0.01: file setup
% 1.0: Clean and commented code

% Link?ping University, Link?ping

status.data = 0;
try
    
    % 1. Load data
    Dependencies = load( ...
        [dataParameters.path,'Dependencies.dat']);
        
    Tasks = load( ...
        [dataParameters.path,'Tasks.dat']);
 
    % 2. Create task representation
    nrtasks = size(Tasks,1);
    data.taskcolumnname = {'id','first start time','last end time', ...
        'timeline id', 'task length', ...
        'actual start time placement (so that the task can move; =0 now)'};
      
    data.tasks = Tasks(:,1:5);
    data.dependencies = Dependencies(:,2:5);
    
    data.tasks(:,6) = 0;
    
    status.data = 1;
    
catch err
    % disp('error'); %err.stack.name)
    fprintf(logfile, 'Error loading data');
    fprintf(logfile, getReport(err,'extended'));
    rethrow(err);
    
    status.data = -1;
end

function id = GetId(taskandtimeline,alltasks)
    % search and extract all tasks for the matching timeline:
    selecttl = alltasks(find(alltasks(:,4)==taskandtimeline(2)),:);
    id = selecttl(taskandtimeline(1),1);
