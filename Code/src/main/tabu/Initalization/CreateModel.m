function model=CreateModel(tabuParameters,resultfile,logfile)
%% Combind models from parameters
% This function creates a model from given parameters
% Created by: Victor Bergelin
% Date created: 28/10/2015
%
% Version number
% 0.01: file setup
% 0.02: minor development, not tested
% 0.03: has everything but error handling, still needed!
% 1.0: Stable for running tabu searches on a variety of data and models
%
% Link?ping University, Link?ping

nrTasks = tabuParameters.nrTasks;
model.initialSolution = tabuParameters.initial;
model.phaseChanges = [];
model.phases = tabuParameters.phases;
model.activePhaseIterator = 1;
instanceIterator = 1;
try
    model.instance = struct('name',{},'id',{},'instance',{});
    for inst = model.phases
        switch inst
            % Basic model
            case 1,
                instance.name = 'BASIC_1';
                instance.instance = BASIC_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 2,
                instance.name = 'BASIC_2';
                instance.instance = BASIC_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % MA model
            case 3,
                instance.name = 'MA_1';
                instance.instance = MA_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 4,
                instance.name = 'MA_2';
                instance.instance = MA_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % MB model
            case 5,
                instance.name = 'MB_1';
                instance.instance = MB_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 6,
                instance.name = 'MB_2';
                instance.instance = MB_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % MC model    
            case 7,
                instance.name = 'MC_1';
                instance.instance = MC_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 8,
                instance.name = 'MC_2';
                instance.instance = MC_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % MD model
            case 9,
                instance.name = 'MD_1';
                instance.instance = MD_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 10,
                instance.name = 'MD_2';
                instance.instance = MD_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 11,
                instance.name = 'MD_3';
                instance.instance = MD_3(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % M1_1 model
            case 101,
                instance.name = 'C1_1';
                instance.instance = C1_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 102,
                instance.name = 'C1_2';
                instance.instance = C1_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            
            % M1_2 model
            case 103,
                instance.name = 'C1_10';
                instance.instance = C1_10(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 104,
                instance.name = 'C1_20';
                instance.instance = C1_20(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 105,
                instance.name = 'C1_30';
                instance.instance = C1_30(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;

            % Model M2_1
            case 201,
                instance.name = 'C2_1';
                instance.instance = C2_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 202,
                instance.name = 'C2_2';
                instance.instance = C2_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % Model M3_1
            case 301,
                instance.name = 'C3_1';
                instance.instance = C3_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 302,
                instance.name = 'C3_2';
                instance.instance = C3_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % Model M3_2
            case 303,
                instance.name = 'C3_10';
                instance.instance = C3_10(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 304,
                instance.name = 'C3_20';
                instance.instance = C3_20(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % Model M4_1    
            case 401,
                instance.name = 'C4_1';
                instance.instance = C4_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 402,
                instance.name = 'C4_2';
                instance.instance = C4_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % Model M4_2
            case 403,
                instance.name = 'C4_10';
                instance.instance = C4_10(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 404,
                instance.name = 'C4_20';
                instance.instance = C4_20(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % Model M5_1
            case 501,
                instance.name = 'C5_1';
                instance.instance = C5_1(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 502,
                instance.name = 'C5_2';
                instance.instance = C5_2(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % Model M5_2
            case 503,
                instance.name = 'C5_10';
                instance.instance = C5_10(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 504,
                instance.name = 'C5_20';
                instance.instance = C5_20(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            % Model M5_3
            case 505,
                instance.name = 'C5_100';
                instance.instance = C5_100(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
            case 506,
                instance.name = 'C5_200';
                instance.instance = C5_200(resultfile,logfile,nrTasks);
                model.instance{instanceIterator} = instance;
                
            %case *,
                
            otherwise,
                disp(['instance ', num2str(inst), ' not active.'])
        end
        instanceIterator = instanceIterator + 1;
    end
catch err
    rethrow(err)
end