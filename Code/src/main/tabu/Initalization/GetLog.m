function [status, logfile] = GetLog(logfileParameters)
%% Get log file from path
% This function fetches the log and prepare it for logging test runs
%
% Created by: Victor Bergelin and Emelie Karlsson
%
% Version number: 1.0
% 0.01: file setup
% 0.02: minor improvements
% 1.0 Clean and commented code


status.tabulog = 0;
try
    logfile = fopen(logfileParameters.path,'a+');
    fprintf(logfile,['---------------------------------------\n', ...
        'Tabu-log initiated: ', datestr(now()), '\n\n']);
    status.tabulog = 1;
catch err
    disp(err.stack);
    status.tabulog = -1;
end

