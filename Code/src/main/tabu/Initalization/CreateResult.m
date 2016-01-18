function [fileobject,resultId] = CreateResult(resultParameters,dataParameters,logfile)
%% CreateResult file for this test instance
% By initiating a file and passing its object, results can continously be
% logged to it.
%
% Created by: Victor Bergelin and Emelie Karlsson
%
% Version: 1.0 
% 0.01: file setup done, needs implementation and error handling!
% 0.02: functional implementation with error handling and status
% 1.0: clean and commented code
% 

% 1. Get path
resultPath = resultParameters.path;
resultId = resultParameters.id;

% 2. Create result file
filename = strsplit(dataParameters.path,'/');
resultPath = [resultPath,'/T_',char(filename(end-1))];

try
    fileobject = fopen(resultPath, 'w');
    fprintf(logfile, ['Result file created: ', resultPath, ...
        '\n\n']);
    status = 1;
catch err
    status = -1;
    rethrow(err)
end

% Return file object and it's id

end
