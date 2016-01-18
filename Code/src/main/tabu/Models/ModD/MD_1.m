classdef MD_1 < handle
    % Model MD
    % MD_1: Long steps with parameters specified for D data
    
    % Created by: Victor Bergelin and Emelie Karlsson
    % Date created: 15/12/2015
    % Version number 1.0
    
    % Linköping University, Linköping   
    
    properties(GetAccess = 'public', SetAccess = 'private')
        
        Name
        TabuList
        Logfile
        Resultfile
        NrTasks
        CostList
        LowestCost = [0, inf]
        NrOfBadIterationsBeforExit=5
        % dep overlap bounds
        CostWeight = [5 1 1]
    end
    
    methods
        % Create Tabu List
        function TabuList = CreateTabuList(obj)
            if(nargin > 0)
                try
                    listlength = min(10,obj.NrTasks-10);
                    TabuList = zeros(listlength,1);
                catch err
                    disp('error')
                    fprintf(obj.Logfile, getReport(err,'extended'));
                    TabuList=[];
                    rethrow(err);
                end
            end
        end
        
        % Constructor:
        function obj = MD_1(resultfile,logfile,nrTasks)
            name = class(obj);
            disp(['Running: ', num2str(name)])
            obj.Name = name;
            obj.NrTasks = nrTasks;
            obj.Logfile = logfile;
            obj.Resultfile = resultfile;
            obj.CostList = repmat(inf,obj.NrOfBadIterationsBeforExit,1);
            obj.TabuList = obj.CreateTabuList();
        end
        
        % Get Action list and do action
        function [data,obj] = GetAndPerformAction(obj,data,iterationId)
            % Iterate over and save posible solutions:
            try
                % Dynamic weights calculated
                % *** 50 can be changed
                if mod(iterationId,25) == 0
                    obj.SetWeights(data);
                end
                
                posibleTaskActions = [-1.5E8, -0.75E8,  0.75E8, 1.5E8];
                nrTasks = size(data.tasks,1);
                nrActions = length(posibleTaskActions);
                actionId = 1;
                
                % Create empty actionList and costList:
                actionList = struct('cost',{},'actionSolution',{});
                costList = zeros(nrActions*nrTasks,1);
                
                for i = 1:nrTasks
                    for ii = 1:nrActions
                        
                        % Find new solution:
                        % Copy all task positions
                        tempSolution = zeros(nrTasks,2);
                        tempSolution(:,1) = data.tasks(:,1);
                        tempSolution(:,2) = data.tasks(:,6);
                        % Move one solution
                        tempSolution(i,2) = tempSolution(i,2)+posibleTaskActions(ii);
                        
                        
                        % Calculate cost
                        action.cost = CostFunction(data,tempSolution,obj.CostWeight);  
                        action.actionSolution = tempSolution;
                        
                        % Save action to actionlist
                        actionList{actionId} = action;
                        costList(actionId) = action.cost.total;
                        costListdep(actionId) = action.cost.dep;
                        costListbound(actionId) = action.cost.bound;
                        costListover(actionId) = action.cost.over;
                        
                        % Increase iterator
                        actionId = actionId + 1;
                    end
                end
                % coststruct=struct('overlap',costListover,'dependency',costListdep,'bound',costListbound)
            catch err
                fprintf(obj.Logfile, getReport(err,'extended'));
                rethrow(err)
            end
            
            
            % Do Action:
            try
                [sortedCosts, indexes] = sort(costList);
                
                % Loop through min-solutions in ascending order
                for i = 1:length(costList)
                                        
                    notintabu = 1;
                    index = indexes(i);
                    actionSolution = actionList{index}.actionSolution(:,2);
                    
                    % Find changed task
                    currentSolution = data.tasks(:,6);
                    changedTask = find(actionSolution - currentSolution);
                                        
                    % Compare solution with tabu list solutions
                    for j = 1:size(obj.TabuList,1)
                        tabuTask = obj.TabuList(j);
                        
                        % Break if action in tabulist
                        if isequal(tabuTask, changedTask) == 1
                            % disp(['Tabu hit!', obj.Name]);
                            if costList(index) < obj.LowestCost(2)
                                % Aspiration criteria
%                                 disp(['Asipiration criteria: ', obj.Name, ' tabu: ', ...
%                                     num2str(costList(index)),' cost: ', ...
%                                     num2str(obj.LowestCost(2))])
                            else
                                notintabu = 0;
                                break;
                            end
                        end
                    end
                    
                        
                        if notintabu == 1
                            
                            % Add action to tabu list
                            obj.TabuList(2:end) = obj.TabuList(1:end-1);
                            obj.TabuList(1) = changedTask;
                            
                            % Perform action
                            lowestCost = costList(indexes(i)); %sortedCosts(i);
                            lowestDep = costListdep(indexes(i));
                            lowestBound = costListbound(indexes(i));
                            lowestOver = costListover(indexes(i));
                            
                            % save cost list
                            obj.CostList(2:end) = obj.CostList(1:end-1);
                            obj.CostList(1) = lowestCost;
                            
                            data.tasks(:,6) = actionSolution;
                            
                            if lowestCost < obj.LowestCost(2)
                                obj.LowestCost = [iterationId,lowestCost];
                            end
                            
                            % Log results
                            timenow = toc;
                            fprintf(obj.Resultfile, [num2str(iterationId),',', ...
                                num2str(lowestCost),',', ...
                                num2str(timenow), ',', ...
                                num2str(lowestDep),',', ...
                                num2str(lowestBound),',', ...
                                num2str(lowestOver), ...
                                '\n']);
                            %obj.IterationId = obj.IterationId + 1;
                            
                            break;
                        end
                end
                
                    catch err
                        disp('ERROR in do action class')
                        disp(err.stack)
                        rethrow(err)
                end
            end
            
            % Get stopping criteria:
            function [model,obj] = GetStoppingCriteria(obj, model)
                
                % If solution getting worse...
                if diff(obj.CostList)<=0
                    
                    % ... move to next phase
                    nrPhases = size(model.phases,2);
                    model.activePhaseIterator= ...
                        mod(model.activePhaseIterator,nrPhases)+1;
                    
                    % Reset in new phase
                    obj.CostList = repmat(inf,obj.NrOfBadIterationsBeforExit,1);
                    model.instance{model.activePhaseIterator}. ...
                        instance.SetTabulistCost(obj.TabuList, ...
                        obj.LowestCost);
                    % *** Print
                    disp(['Switched from ',num2str(obj.Name), ' at iteration ',num2str(model.iterations)])
                end
            end
            
            function [obj] = SetTabulistCost(obj,tabulist, lowestcost)
                
                obj.TabuList = tabulist;
                obj.LowestCost = lowestcost;
                
            end
            
            % Are conditions met 
            function [model, obj] = AreConditionsMet(obj,model)
                try
                    % obj.LowestCost
                    if obj.LowestCost(2)==0
                        model.conditionsAreNotMet = 0;
                    end
                catch err
                    rethrow(err)
                end
            end
            
            % Dynamic weight changing function
            function [obj] = SetWeights(obj,data)
                
                curSolution = zeros(obj.NrTasks,2);
                curSolution(:,1) = data.tasks(:,1);
                curSolution(:,2) = data.tasks(:,6);
                
                costStruct = CostFunction(data,curSolution,obj.CostWeight);
                
                weightDep = max(0.01, costStruct.dep/costStruct.total);
                weightOver = max(0.01, costStruct.over/costStruct.total);
                weightBound = max(0.01, costStruct.bound/costStruct.total);
                
                obj.CostWeight = [weightDep, weightOver, weightBound];
            end
            
            % Get Cost
            function [costVec, obj] = GetCost(obj,data)
                
                curSolution = zeros(obj.NrTasks,2);
                curSolution(:,1) = data.tasks(:,1);
                curSolution(:,2) = data.tasks(:,6);
                
                costStruct = CostFunction(data,curSolution,obj.CostWeight);
                costVec = [costStruct.total,costStruct.over,costStruct.dep,costStruct.bound];
            end
        end
    end
    
    %%