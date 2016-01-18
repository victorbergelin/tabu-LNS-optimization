function [status, logpath,logfile] = CreateLog()
%% Create one log file for each test
% This function creates a log file and returns a path to the file
% Created by: Victor Bergelin
% Date created: 28/10/2015
% Version number 
% 0.01: file setup
% Linköping University, Linköping


status.createlog = 1;
% 1. Get path and name:
relativeLogPath = 'target/logs/';

dateName = datestr(now(),'yyyy-mm-ddTHH-MM-SS');
logpath = ['log_',dateName];
logpath = [relativeLogPath,logpath];


% 2. Create file
try
     logfile=fopen(logpath, 'w');
catch err
     rethrow(err)
end

% 3. Return file path and name

end

