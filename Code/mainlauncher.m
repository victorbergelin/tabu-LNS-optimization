function status = mainlauncher(dataParameters, modelParameters)
%MAINLAUNCHER This script is the over all launcher
%   Detailed explanation goes here

% 1. Variable setup:
status.run = 0;
runId=0;

tichandle = tic;

% 2. Functional setup:
try
    % 2.1 Add paths for setup files:
    addpath(genpath('src/main/guitest'))
    [status, logPath, logfile] = CreateLog();
    [status.result, resultPath] = CreateResultStructure();
    % -----------------------------
    
    status.logPath = logPath;
    status.resultPath = resultPath;
    status.run = 1;
catch err
    disp('Fatal error in launcher setup')
    disp(err.stack)
end


% 2.2 Save as struct variables:
logfileParameters = struct('path',logPath);
resultParameters = struct('path',resultPath,'id',0);


% 3. Create run scheme if successful setup:
if status.run    
    % 3.1 if tabu is active, run:
    if modelParameters.tabu.active
        for i = 1:length(dataParameters)
%             Run nr.',num2str(i),' out of ', num2str(length(dataParameters)),
            disp(['================ ', dataParameters{i}.name,' ============================'] );
            try
                % Add path for tabu main files:
                addpath(genpath('src/main/tabu')); %'src/main/tabu';
                runId = runId +1;
                status.tabu = tabumain(dataParameters{i}, ...
                    modelParameters.tabu, ...
                    logfileParameters, ...
                    setfield(resultParameters, ...
                    'id',runId));
                rmpath(genpath('src/main/tabu')); % 'src/main/tabu';
                % -----------------------------

                

            catch err
               fprintf(logfile,['\nFatal error in tabu search,', ...
                   'quiting search run nr: ', ...
                   num2str(runId),'\nContinouing test\n'])
               status.tabu = -1;
            end
        end

    end

    % 3.2 if LNS is active, run:
    if modelParameters.LNS.active
        for i = 1:length(dataParameters)
            try
                runId = runId +1;
                % Add path for LNS main files:
                addpath(genpath('src/main/ampl')); %'src/main/tabu';
                status.LNS = LNSmain(dataParameters{i}, ...
                                     modelParameters.LNS, ...
                                     logfileParameters, ...
                                     setfield(resultParameters, ...
                                            'id',runId));
                rmpath(genpath('src/main/ampl')); % 'src/main/tabu';
                % -----------------------------

            catch err
               fprintf(logfile,['\nFatal error in LNS search,', ...
                   'quiting search run nr: ', ...
                   num2str(runId),'\nContinouing test\n'])
               status.LNS = -1;
            end
        end

    end

    % 3.3 if LNS-list is active, run:
    
    if modelParameters.LNSlist.active
        for i = 1:length(dataParameters)
            try
                runId = runId +1;
                % Add path for LNS main files:
                addpath(genpath('src/main/ampl')); %'src/main/tabu';
                status.LNSlist = LNSlistmain(dataParameters{i}, ...
                                     modelParameters.LNSlist, ...
                                     logfileParameters, ...
                                     setfield(resultParameters, ...
                                            'id',runId));
                rmpath(genpath('src/main/ampl')); % 'src/main/tabu';
                % -----------------------------

            catch err
               fprintf(logfile,['\nFatal error in LNSlist search,', ...
                   'quiting search run nr: ', ...
                   num2str(runId),'\nContinouing test\n'])
               status.LNSlist = -1;
            end
        end

    end
    
    
    
    
    % 3.5 if mathmodel is active, run:
    if modelParameters.MathModel.active
        for i = 1:length(dataParameters)
            try
                runId = runId +1;
                % Add path for ampl main files:
                addpath(genpath('src/main/ampl')); %'src/main/tabu';
                status.MathModel = MathModelmain(dataParameters{i}, ...
                                       modelParameters.MathModel, ...
                                       logfileParameters, ...
                                       setfield(resultParameters, ...
                                            'id',runId));
                rmpath(genpath('src/main/ampl')); % 'src/main/tabu';
                % -----------------------------

            catch err
               fprintf(logfile,['\nFatal error in MathModel search,', ...
                   'quiting search run nr: ', ...
                   num2str(runId),'\nContinouing test\n'])
               status.MathModel = -1;
            end
        end
    end
end   

disp(['Launcher script successfully finished after ',num2str(runId), ...
    ' runs over selected model.']);

toc(tichandle)

status.run = 1

end

