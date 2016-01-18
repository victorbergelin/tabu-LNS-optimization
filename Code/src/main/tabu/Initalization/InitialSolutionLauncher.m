function [status,data] = InitialSolutionLauncher(model,data,logfile)
%% This launcher initiates a given starting solution from a function call
%
% Created by: Victor Bergelin and Emelie Karlsson
%
% Requested features for next version:
% - More initial solutions
% 
% Version number: 1.0
% 0.01: minimal usage implementation for one initial solution
% 1.0: Clean and commented code

try
    switch model.initialSolution
        case {1}
            [status,data] = SimpleSortAndPlace(data);
        case {2}
            msg = 'No initial solution for id 2 exist';
            disp(msg);
            error(msg);
        otherwise
            disp('unknown instance');
    end
catch err
   fprintf(logfile, 'Error in Starting Condition Launcher, aborting.\n'); 
   fprintf(logfile, getReport(err,'extended')); 
   rethrow(err)
end


end

