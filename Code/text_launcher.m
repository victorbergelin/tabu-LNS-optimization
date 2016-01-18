% TEST LAUNCHER - non-graphical
% Created by Victor Bergelin
% 1.0: Stable for running tabu searches on a variety of data and models
% Currently working only for Tabu

% Linköping University, Linköping


% clc; close all; clear all;

%-------------------------------------------------------------------------
% BasicModel:
M_Base = [1,2];
%-------------------------------------------------------------------------
% ModA:
MA = [3,4];
%-------------------------------------------------------------------------
% ModB:
MB = [5,6];
%-------------------------------------------------------------------------
% ModC:
MC = [7,8];
%-------------------------------------------------------------------------
% ModD:
MD = [9,10,11];

%-------------------- M1 models: Neighbourhood & phases ------------------

% "Normal" model.
M1_1 = [101,102];

% Testing three stages of step length: long, mid, short
M1_2 = [103,104,105];

%------------------- M2 models: Tabu list representation -----------------

% Tabu list with solutions
M2_1 = [201, 202];

%----------------------- M3 models: Tabu list length ---------------------

% Tabu list length 10
M3_1 = [301,302];

% Tabu list length numberOfTasks/2 + 10
M3_2 = [303,304];

%-------- M4 models: Varying NrOfBadIterationsBeforExit -----------------

% NrOfBadIterationsBeforExit short in both phases
M4_1 = [401,402];

% NrOfBadIterationsBeforExit long in both phases
M4_2 = [403,404];

%-------------- M5 models: No of it. before weight update -----------------

% Updated weights after 25 iterations in both phases
M5_1 = [501,502];

% Updated weights after 10 iterations in both phases
M5_2 = [503,504];

% No dynamic weights
M5_3 = [505,506];

%-------------------------------------------------------------------------

% 2. Create models when user selects them:
modelParameters = struct( ...
    'tabu', struct('active',1,'initial',1,'phases',M5_3), ...
    'LNS' , struct('active',0,'initial',1,'phases',[1]), ...
    'LNSlist' , struct('active',0,'initial',1,'phases',[1]), ...
    'MathModel', struct('active',0,'initial',1,'phases',[1]));


disp('------------------ OPTIMORE LAUNCHED ------------------')
disp('please select one option bellow by entering a number:')
disp('1. Create data gui. 2. Launch main GUI')
disp('3. Launch a fix solution sequence. 4. Print latest result.')
disp('5. Quit. 6. Create model (beta). 7. Save plot to target.')
disp('-------------------------------------------------------')
noQuit = 1;

while noQuit
    try
        data_not_found = true;
        prompt = 'Select one option: ';
        nr = input(prompt,'s');
        disp(' ');
        switch num2str(nr)
            case '1',
                addpath(genpath('src/main/guitest/createdatagui'));
                GUI
                rmpath(genpath('src/main/guitest/createdatagui'));
            case '2',
                test_maingui;
            case '3',
                
                while data_not_found
                    
                    prompt = 'Select data (A, B, C, D: 1-50: as A0,B20 etc.): ';
                    selected_data = input(prompt,'s');
                    pathdir = 'src/test/testdata/';
                    DataDir=dir([pathdir,'*_*']);
                    pathname = [];
                    filename = [];
                    for i = 1:length({DataDir.name})
                        thisfilename = cellstr(getfield(DataDir,{i},'name'));
                        pathname = [pathname; strcat(pathdir,thisfilename,'/')];
                        filename = [filename; thisfilename];
                    end
                    
                    dataParameters = struct('name',{},'path',{});
                    foundstr = 0;
                    
                    for ii=1:length(filename)
                        name = strtok(filename(ii),'_');
                        if numel(char(name)) == numel(char(selected_data)) && ...
                                all(lower(char(name)) == lower(char(selected_data)))
                            dataObj.name = char(filename(ii));
                            dataObj.path = char(pathname(ii));
                            dataParameters{1} = dataObj;
                            foundstr=1;
                        end
                    end
                    
                    if foundstr
                        % 3. run launcher
                        status = mainlauncher(dataParameters, modelParameters);
                        % 4. Print errors if they occure:
                        SNames = fieldnames(status);
                        nFields = length(SNames);
                        
                        for i = 1:nFields
                            % SNames{i}
                            if (status.(SNames{i})==-1)
                                type(status.logPath);
                            end
                        end
                        data_not_found = false;
                        
                    else
                        disp(['No data found for: ',selected_data,'. Try again.'])
                    end
                end
                
            case '4',
                disp('Printing results:')
                respath = 'target/results/';
                d=dir([respath,'results*']);
                [~, index] = max([d.datenum]);
                dirpath = [respath,d(index).name];
                files = {ls(dirpath)};
                filepath=[dirpath,'/',strtrim(files{1})];
                type(filepath)
                
            case '5',
                disp('Quitting');
                pause(0.5);
                close all;
                clc;
                noQuit = 0;
            case '6',
                disp('Creating new model: enter model iterator id: (THIS IS NOT IMPLEMENTED YET)');
                try
                    selected_data = str2num(input(prompt,'s'));
                catch err
                    disp('wrong')
                end
                
                noQuit = 0;
            case '7',
                printfilename = ['target/resultplots/tabu_', ...
                    datestr(now(),'yyyy-mm-ddTHH-MM-SS')];
                print(figure(1),'-dpng',printfilename);
                disp(['File saved: ',printfilename])
            otherwise,
                disp('Error input')
                noQuit = 1;
        end
    catch err
        disp(err.stack)
    end
end

