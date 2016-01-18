% Created by: Isak Bohman, 2015
function [ DependencyMatrix ] = Generatedependencymatrix(TimelineSolution, Ndependencies, rectify,constrain,L, chains)
% A function for generating a dependency matrix. Many different cases, and
% could probably be reduced a lot in size.

% Randomly pick out which elements to receive dependencies. A single taks may be involved in several dependencies.
% No duplicate dependencies allowed.

Tsol = [];

% Convert a time-line solution into something more useable; flatten the
% cell array.
for j=1:length(TimelineSolution)
    Tsol = [Tsol; TimelineSolution{j}, j*ones(size(TimelineSolution{j},1),1)];
    % size(TimelineSolution{j},1)
end


DependencyMatrix = zeros(Ndependencies,4);
% DependencyMatrix = [];

% Vector with ending times.
ending_times = Tsol(:,1)+Tsol(:,2);
starting_times = Tsol(:,1);

Ntasks = 0;

% Randomly select which task to be included in a dependency.
for i=1:length(TimelineSolution)
    Ntasks = Ntasks + size(TimelineSolution{i},1);
end

% Tasks without any dependencies
tasks_left = Tsol;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Minimum length of a chain
min_chain_length = 3;
% Maximum length of a chain
max_chain_length = 10;
% Average length of a chain
avg_chain_len = ceil((min_chain_length+max_chain_length)/2);

% Are we at the first pass (i.e. we must prioritize that every task
% partakes in at least one dependency)?
if Ntasks<=Ndependencies
    first_pass = 1;
else
    first_pass = 0;
end


all_connected = 0;
if Ndependencies >= Ntasks
    all_connected = 1;
end
i=1;

pot_jump = 0;

while i <= Ndependencies
    
    x=0;
    
    p = randi(avg_chain_len,1,1);
    % Needs special case when tasks_left is empty.
    if ~isempty(tasks_left)
%         disp('A')
        % Current task
        cur_task = ConvertLongIndex(find(ismember(Tsol,tasks_left(1,:),'rows'),1));
%         cur_task = tasks_left(1,:)
    else
        % Calculate probabilities based on task lengths?
        if rectify == 1
            test_length = sum(Tsol(:,2));
        end
        
        
        if rectify == 0
%             disp('B')
            cur_task = ConvertLongIndex(generate_candidate(Ntasks));
%             cur_task = [TimelineSolution{cur_task_index(2)}(cur_task_index(2),1),cur_task_index(2)];
        else
%             disp('C')
            cur_task = ConvertLongIndex(convert_to_index(generate_candidate(test_length),Tsol(:,2)));
%             cur_task = [TimelineSolution{cur_task_index(2)}(cur_task_index(2),1),cur_task_index(2)];
        end
    end
    
    
    
%     cur_index = find(ismember(TimelineSolution{cur_task(end)},cur_task(1:2)),1)


    cur_index = cur_task(1);

    % The number of times we have jumped across time-lines, which is
    % important for chains of dependencies.
    timeline_jumps = 0;
    
    % No possibilities of creating chains?
    no_admissible_chain = 0;
    direction = 1;
    % The conditions below must be changed based upon the ratio Ndeps/Ntasks...
    if p>=avg_chain_len-2 && chains==1
        
        if ~isempty(tasks_left)
            % Remove an element from the list
            tasks_left = subtract_element(tasks_left,cur_task(1),cur_task(2));
%             disp('Tasks left has shrunk.')
%             size(tasks_left,1)
        end
        
        %         disp('Creating chain')
        chain_length = randi(max_chain_length-min_chain_length+1,1,1)+min_chain_length-1;
        chain_bool = 1;
        j=2; % The current task in the dependency. cur_task is considered to already be included.
        
        % Determine whether to create a forward-going chain or a
        % backward-going one.
        %         admissible_set = create_admissible_set(constrain,cur_task,first_pass, direction, timeline_jumps);
        
        %         cur_task
        %         TimelineSolution{cur_task(end)}(cur_index,:)
        
        % But if all tasks in the forward driection have been used up, this
        % must be alleviated.
        % Create an alleviate variable or something? Alleviate only
        % applicable if first_pass == 1!!
        admissible_set = create_admissible_set(constrain,[TimelineSolution{cur_task(end)}(cur_task(1),:),cur_task(end)],first_pass, direction, timeline_jumps, pot_jump);
        if isempty(admissible_set)
            direction=2;
            admissible_set = create_admissible_set(constrain,[TimelineSolution{cur_task(end)}(cur_task(1),:),cur_task(end)],first_pass, direction, timeline_jumps, pot_jump);
%             if isempty(admissible_set)
%                 admissible_set = create_admissible_set(constrain,[TimelineSolution{cur_task(end)}(cur_task(1),:),cur_task(end)],0, direction, timeline_jumps, pot_jump);
%             end
        end
        
        
        if ~isempty(admissible_set)
            % Create a chain in the wanted direction.
            % Assumes that admissible_set is created in a "good" way.
            % Just randomize. Will depend on rectify!
            while chain_bool == 1
                % Add an element in the dependency matrix.
                % Find a task with an admissible starting time.
                
                bool = 0;
                admissible_set = [];
                % Determine the direction of the chain.
                check_iterator =1;
                
                %                 candidate = [cur_index,cur_task(end)]
                
                candidate = [cur_task(1),cur_task(2)];
                
                % first_pass depends on a few things... As well as timeline jumps!
                % create_admissible_set(constrain, cur_task, first_pass, direction, timeline_jumps)
                % Remember to update tasks left!
                
                if Ndependencies < Ntasks
                    % Every taks cannot partake in a dependency, so not
                    % applicable
                    first_pass = 0;
                    
                else
                    if Ntasks <= Ndependencies && ~isempty(tasks_left)
                        first_pass = 1;
                    else
                        first_pass = 0;
                    end
                    
                end
                
                if j<=avg_chain_len-1
                    % jump only within the time-line
                    pot_jump = 0;
                else
                    % Possibly jump between time-lines.
                    pot_jump = 1;
                end
                
                % Create an admissible set with the desired characteristics
                admissible_set = create_admissible_set(constrain,[TimelineSolution{cur_task(end)}(cur_task(1),:),cur_task(end)],first_pass, direction, timeline_jumps, pot_jump);
                %                 admissible_set = create_admissible_set(constrain,candidate,direction, direction, timeline_jumps);
                
%                 admissible_set
                
                if isempty(admissible_set)
                    chain_bool = 0;
                end
%                 chain_bool
                %%%%%%%%%%%%%%%%%%%
                % Create chain
                %                 while chain_bool == 1
%                 disp('A1')
%                 isempty(admissible_set)
%                 j
%                 max_chain_length
%                 disp('iteration')
                bool = 0;
                %                     admissible_set = [];
                
                % The following is used for finding tasks nearby, so that
                % the chain can be long enough.
                %                     while bool == 0
                
                
                if ~isempty(admissible_set) && j <= max_chain_length
%                     disp('A2')
                    bool =1;
                    % Add the dependency
                    
                    if rectify == 1
                        admissible_set_lengths = [];
                        for it3=1:size(admissible_set,1)
                            
                            % Convert into a (task number, time-line)
                            % coordinate
                            candidate3 = ConvertLongIndex(admissible_set(it3));
                            
                            admissible_set_lengths = [admissible_set_lengths; TimelineSolution{candidate3(2)}(candidate3(1),2)];
                        end
                    end
                    
                    % The currently dependent upon set
                    currently_dependent_upon = find(ismember(DependencyMatrix(:,1:2),candidate,'rows'));
                    currently_dependent_upon_set = DependencyMatrix(currently_dependent_upon,3:4);
                    
                    % This if is unnecessary, this should be handled in the
                    % way that admissible_set is created, probably.
                    %                                 if size(admissible_set,1) > size(currently_dependent_upon,1)
                    % Create dependency
                    bool = 1;
                    if rectify == 0
                        % Randomize based on task numbers
                        test_length = size(admissible_set,1);
                    else
                        % Randomize based on task lengths
                        test_length = sum(admissible_set_lengths);
                    end
                    %                             while y==0
                    % Generate a task in the admissible set.
                    if rectify == 0
                        candidate2 = ConvertLongIndex(admissible_set(generate_candidate(test_length)));
                    else
                        candidate2 = ConvertLongIndex(admissible_set(convert_to_index(generate_candidate(test_length),admissible_set_lengths)));
                    end
                    % This gives the index for the index in admissible_set.
                    %                                 if isempty(find(ismember(currently_dependent_upon_set,candidate2,'rows')))
                    % If admissible
                    %                             y = 1;
                    
                    % Different cases depending on direction!
                    if direction==1
                        DependencyMatrix(i,:) = [cur_task, candidate2];
%                         disp('Added via chain')
%                         candi=[cur_task, candidate2]
                    else
                        DependencyMatrix(i,:) = [candidate2, cur_task];
%                         disp('Added via chain')
%                         candi=[candidate2, cur_task]
                        
                    end
                    
                    
                    % We have expended our chance to jump.
                    if cur_task(2) ~= candidate2(2)
                        timeline_jumps = 1;
                    end
                    
                    cur_task = candidate2;
                    
                    % If we find candidate2 in
                    % tasks_remining, update tasks
                    % remaining.
                    
                    
                    %                             to_be_removed = find(ismember(DependencyMatrix(:,1:2),candidate2,'rows'));
                    tasks_left = subtract_element(tasks_left, candidate2(1),candidate2(2));
                    % Update j, tasks remaining
                    
                    j=j+1;
                    i=i+1;
                else
                    chain_bool = 0;
                end
                if j > max_chain_length
                    chain_bool = 0;
                end
                %                 end
                
                %%%%%%%%%%%%%%%%%%%
            end
        end
    else
        
        while x==0
            
            % Randomize a task in a dep.
            
            if all_connected == 0 || i > Ntasks
                if rectify == 1
                    test_length = sum(Tsol(:,2));
                end
                
                
                if rectify == 0
                    candidate = ConvertLongIndex(generate_candidate(Ntasks));
                else
                    candidate = ConvertLongIndex(convert_to_index(generate_candidate(test_length),Tsol(:,2)));
                end
            else
                candidate = ConvertLongIndex(i);
                
                %             % Everyone can't partake in a dependency
                %             if candidate == prev_candidate
                %                 all_connected = 1;
                %             end
                %
                %             prev_candidate = candidate;
            end
            
            y=0;
            
            
            if constrain == 1
                % Only select from this time-line
                start_times = TimelineSolution{candidate(2)}(:,1);
                end_times = TimelineSolution{candidate(2)}(:,1)+TimelineSolution{candidate(2)}(:,2);
                admissible_set1 = find(end_times <= TimelineSolution{candidate(2)}(candidate(1),1));
                admissible_set2 = find(start_times >= TimelineSolution{candidate(2)}(candidate(1),1)+ ...
                    TimelineSolution{candidate(2)}(candidate(1),2));
                admissible_set = [admissible_set1; admissible_set2];
                if ~isempty(admissible_set)
                    % Must account for that the current time-line is not
                    % the first one.
                    admissible_set = admissible_set+prev_indices(candidate(2));
                end
                
            else
                
                admissible_set1 = find(ending_times <= TimelineSolution{candidate(2)}(candidate(1),1));
                admissible_set2 = find(starting_times >= TimelineSolution{candidate(2)}(candidate(1),1)+ ...
                    TimelineSolution{candidate(2)}(candidate(1),2));
                admissible_set = [admissible_set1; admissible_set2];
            end
            
            if rectify == 1
                admissible_set_lengths = [];
                for it3=1:size(admissible_set,1)
                    
                    candidate3 = ConvertLongIndex(admissible_set(it3));
                    
                    admissible_set_lengths = [admissible_set_lengths; TimelineSolution{candidate3(2)}(candidate3(1),2)];
                end
            end
            % Which tasks we are already in a dependency with.
            currently_dependent_upon1 = find(ismember(DependencyMatrix(:,3:4),candidate,'rows'));
            currently_dependent_upon_set1 = DependencyMatrix(currently_dependent_upon1,1:2);
            currently_dependent_upon2 = find(ismember(DependencyMatrix(:,1:2),candidate,'rows'));
            currently_dependent_upon_set2 = DependencyMatrix(currently_dependent_upon2,3:4);
            currently_dependent_upon = [currently_dependent_upon1; currently_dependent_upon2];
            currently_dependent_upon_set = [currently_dependent_upon_set1; currently_dependent_upon_set2];
            
            if size(admissible_set,1) > size(currently_dependent_upon,1)
                % Create a dependency
                x = 1;
                if rectify == 0
                    test_length = size(admissible_set,1);
                else
                    test_length = sum(admissible_set_lengths);
                end
                
                while y==0
                    % Randomize a task in the admissible set.
                    if rectify == 0
                        candidate2 = ConvertLongIndex(admissible_set(generate_candidate(test_length)));
                    else
                        candidate2 = ConvertLongIndex(admissible_set(convert_to_index(generate_candidate(test_length),admissible_set_lengths)));
                    end
                    
                    % Gives the index for the index in admissible_set.
                    
                    % Must check if the task is before or after.
                    task1_start = TimelineSolution{candidate(2)}(candidate(1),1);
                    task1_end = TimelineSolution{candidate(2)}(candidate(1),1)+TimelineSolution{candidate(2)}(candidate(1),2);
                    task2_start = TimelineSolution{candidate2(2)}(candidate2(1),1);
                    task2_end = TimelineSolution{candidate2(2)}(candidate2(1),1)+TimelineSolution{candidate2(2)}(candidate2(1),2);
                    
                    if isempty(find(ismember(currently_dependent_upon_set,candidate2,'rows'))) && task2_end <= task1_start
                        % If admissible
                        y = 1;
                        
                        dep_cand = [candidate2, candidate];
                        if isempty(find(dep_cand==0))
                            % Depends on if dir=1 or 2.
                            % This should probably be corrected to
                            % DependencyMatrix(i,:) = dep_cand!
                            DependencyMatrix = [DependencyMatrix; dep_cand];
                            %                         DependencyMatrix(i,:) = [candidate2, candidate];
                            tasks_left = subtract_element(tasks_left, candidate2(1),candidate2(2));
                            tasks_left = subtract_element(tasks_left, candidate(1),candidate(2));
                            
                            i=i+1;
                            
                        end
                    elseif isempty(find(ismember(currently_dependent_upon_set,candidate2,'rows'))) && task1_end <= task2_start
                        % If admissible
                        y = 1;
                        
                        % Quick-fix.
                        dep_cand = [candidate, candidate2];
                        if isempty(find(dep_cand==0))
                            % This should probably be corrected to
                            % DependencyMatrix(i,:) = dep_cand!
                            DependencyMatrix = [DependencyMatrix; dep_cand];
                            
                            tasks_left = subtract_element(tasks_left, candidate2(1),candidate2(2));
                            tasks_left = subtract_element(tasks_left, candidate(1),candidate(2));
                            
                            i=i+1;

                        end
                        
                    end
%                     disp('Added')
%                     dep_cand
                    % Remove from tasks left.
                    %                     tasks_left = subtract_row(tasks_left, ConvertToLong(candidate2(1),candidate2(2)));

                end
            end
        end
    end
end

%     function bool = admissile_candidate(candidate)
%
%         % Find those tasks which can partake in a dependency
%         % Find tasks which are already in a dependency with candidate.
%         % Find a set from which an admissible dependency can be
%         % randomized
%
%     end


    % Generates a random task index
    function task_index = generate_candidate(Ntasks)
        task_index = randi(Ntasks,1,1);
    end

    % Converts a long index (number) into a (number, timeline) one
    function candidate = ConvertLongIndex(index)
        ind = 1;
        indexiterator = 1;
        boo=0;
        while boo==0 %indexiterator < index
            
            
            number =  index-indexiterator+1;
            if  number <= size(TimelineSolution{ind},1)
                % in the first case continue, in the second one cancel.
                boo=1;
            else
                
                indexiterator = indexiterator + size(TimelineSolution{ind},1);
                ind = ind+1;
            end
            
        end
        timeline = ind;
        candidate = [number, timeline];
    end

    % Converts a short index into a long
    function longindex = ConvertToLong(number, timeline)
        longindex = 1;
        for k=1:timeline-1
            longindex = longindex+size(TimelineSolution{k},1);
        end
        longindex = longindex + number-1;
    end

    % Uses time steps (discretization) instead.
    function long_index = convert_to_index(index, admissible_set_lengths)
        ind = 1;
        indexiterator = 1;
        boo=0;
        while boo==0 %indexiterator < index
            
            
            number =  index-indexiterator+1;
            if  number <= admissible_set_lengths(ind)
                
                boo=1;
            else
                
                indexiterator = indexiterator + admissible_set_lengths(ind);
                ind = ind+1;
            end
            
        end
        timeline = ind;
        long_index = timeline;
    end

    % Indices before the current
    function prev_ind = prev_indices(ind)
        prev_ind = 0;
        if ind ~= 1
            for k=1:ind-1
                
                prev_ind = prev_ind+size(TimelineSolution{k},1);
                
            end
        end
    end

    % Deletes an element
    function element = subtract_row(admissible_set, i)
%         i
%         size(admissible_set,1)
        % Becomes four cases
        if i == 1
            element = admissible_set(i+1:end,:);
        elseif i == size(admissible_set,1)
            element = admissible_set(1:i-1,:);

        elseif i > 1 && i < size(admissible_set,1)
            element = [admissible_set(1:i-1,:); admissible_set(i+1:end,:)];
        else
            element = admissible_set;
        end
    end

    % Slight modification of the above
    function tasks_left = subtract_element(task_set, index, timeline)
        
        element_to_remove = Tsol(ConvertToLong(index,timeline),:);
        ax = find(ismember(task_set,element_to_remove,'rows'),1);
        if ~isempty(ax)
            tasks_left = subtract_row(task_set,ax);
        else
            tasks_left = task_set;
            
        end
        
    end

    function output = findseveral(vec,tofind)
        if isempty(vec)
            output=find(vec,tofind);
        else
            output = [];
            for index=1:length(vec)
                if vec(index)==tofind
                    output = [output index];
                end
                
            end
            
        end
    end

% The procedure for removing tasks depends only on if we look at all tasks or if we are only at the current time-line.

% TimelineSolution will look different depending on if we may only be
% dependent upon tasks on the same time-line.

% When first_pass is activated it is prioritized that we create
% dependencies between tasks which don't already partake in a dependency.
% There will be a few extra passes when we remove tasks which already have
% at least one dependency. Or should we do it like that?

% Using which coordinate system is cur_task denoted in? Two ways of describing it.

    function admissible_set = create_admissible_set(constrain, cur_task, first_pass, direction, timeline_jumps, pot_jump)
        % Subtrahera bort cur_task från alla!!
%         cur_task
        task_start = cur_task(1);
        task_length = cur_task(2);
        task_timeline = cur_task(end);
%         timeline_jumps
        
        task_index = find(ismember(TimelineSolution{cur_task(end)},cur_task(1:2)),1);
%         element_being_inspected = [task_index, task_timeline]
        % Forward
        if direction == 1
%             disp('Woohoo1')
            % Tasks may have at most one dependency.
            if first_pass == 1 && i <= Ntasks && size(tasks_left,1) > 0
                % Can only choose from the current time-line.
%                 disp('Woohoo2')
                if  timeline_jumps == 1 || constrain == 1 || pot_jump == 0
%                     disp('Case 1')
                    % This one will be more advanced.
%                     disp('Woohoo3')
%                     task_index = find(ismember(Tsol,cur_task),1);

                    
                    ad_it = 1;
                    ad_count = 1;
                    
                    start_times = TimelineSolution{task_timeline}(:,1);
                    
                    while ad_it == 1
                        
                        admissible_set = find(start_times >= task_start+task_length & ...
                            start_times <= round(ad_count*(L-(task_start+task_length))/max_chain_length));
                        
                        % Subtract away tasks with at least one dependency,
                        % except for the current one.
                        
                        cur_dep_matr_begin = find(DependencyMatrix(:,2)==task_timeline);
                        cur_dep_matr_end = find(DependencyMatrix(:,4)==task_timeline);
                        
                        cur_dep_matr_begin_ind = DependencyMatrix(cur_dep_matr_begin,1);
                        cur_dep_matr_end_ind = DependencyMatrix(cur_dep_matr_end,3);
                        
                        
                        admissible_set = setdiff(admissible_set,cur_dep_matr_begin_ind);
                        admissible_set = setdiff(admissible_set,cur_dep_matr_end_ind);
                        
                        admissible_set = setdiff(admissible_set,task_index);
%                         admissible_set = setdiff(admissible_set,dep_set_begin_ind);
                        
                        if ad_count >= max_chain_length || size(admissible_set,1) > 0
                            ad_it = 0;
                        end
                        
                        ad_count = ad_count+1;
                        
                    end
                    
                    if isempty(admissible_set)
%                         disp('Case 1B')
                        % A second chance. Not as tough conditions to be
                        % satisifed! Now, tasks must not be dependent upon
                        % the current task only.
                        
                        ad_it = 1;
                        ad_count = 1;
                        
                        
                        while ad_it == 1
                            
                            admissible_set = find(start_times >= task_start+task_length & ...
                                start_times <= round(ad_count*(L-(task_start+task_length))/max_chain_length));
                            
                            
                            

                            admissible_set = setdiff(admissible_set,task_index);
                            
                            % Choose tasks from the current time-line,
                            % which the current task is dependent upon.
                            cur_task_deps_left = find(ismember(DependencyMatrix(:,2:4),[task_timeline, task_index, task_timeline],'rows'));
                            cur_task_deps_left_indices = DependencyMatrix(cur_task_deps_left,1);
                            cur_task_deps_right = find(ismember(DependencyMatrix(:,[1:2,4]),[task_index, task_timeline, task_timeline],'rows'));
                            cur_task_deps_right_indices = DependencyMatrix(cur_task_deps_right,3);
                            
                            admissible_set = setdiff(admissible_set,cur_task_deps_left_indices);
                            admissible_set = setdiff(admissible_set,cur_task_deps_right_indices);
                            
                            if ad_count >= max_chain_length || size(admissible_set,1) > 0
                                ad_it = 0;
                            end
                            
                            ad_count = ad_count+1;
                            
                        end
                        
                        
                    end
                    
                    if ~isempty(admissible_set)
                        admissible_set = admissible_set+prev_indices(task_timeline);
                    end
                    
                    
                else
%                     disp('Case 2')
%                     admissible_set = find(starting_times >= cur_task(1)+cur_task(2) && ...
%                         starting_times <= round(check_iterator*(L-(cur_task(1)+cur_task(2)))/max_chain_length));

%                     task_index = find(ismember(Tsol,cur_task),1);
                    
                    ad_it = 1;
                    ad_count = 1;
                    
                    while ad_it == 1
                        
                        admissible_set = find(starting_times >= task_start+task_length & ...
                            starting_times <= round(ad_count*(L-(task_start+task_length))/max_chain_length));
                        
                        % Subtract tasks with at least one dependency,
                        % except for the current one.
                        
                        
                        tasks_in_dep = [];
                        non_zero_dep_matrix = DependencyMatrix;
                        non_zero_dep_matrix(all(non_zero_dep_matrix==0,2),:)=[];
                        if size(non_zero_dep_matrix,1) > 0
                            for titer=1:size(non_zero_dep_matrix,1)
%                                 size(DependencyMatrix,1)
                                tasks_in_dep = [tasks_in_dep; ConvertToLong(non_zero_dep_matrix(titer,1),non_zero_dep_matrix(titer,2))];
                                tasks_in_dep = [tasks_in_dep; ConvertToLong(non_zero_dep_matrix(titer,3),non_zero_dep_matrix(titer,4))];
                            end
                        end
                        
                        % For the current task it must be checked that
                        % there are sufficiently many free tasks to be in a
                        % dependency with.
                        
%                         dep_set = find(DependencyMatrix(:,1:2)==(task_index,task_timeline) || DependencyMatrix(:,3:4)==(task_index,task_timeline));
                        
%                         dep_set_begin = find(ismember(DependencyMatrix(:,1:2),[task_index,task_timeline]),1);
%                         dep_set_begin_ind = DependencyMatrix(dep_set_begin,1);
                        
                        % Unnecessary when looking forward.
%                         dep_set_end = find(ismember(TimelineSolution{task_timeline}(:,3:4),[task_index,task_timeline]),1);
                        

                        
                        
                        admissible_set = setdiff(admissible_set,tasks_in_dep);
%                         size(admissible_set,1)
                        
                        % Subtract current task's dependencies.
                        
                        admissible_set = setdiff(admissible_set,ConvertToLong(task_index,task_timeline));
                        
                        if ad_count >= max_chain_length || size(admissible_set,1) > 0
                            ad_it = 0;
                        end
                        
                        ad_count = ad_count+1;
                        
                    end
                    
                    % If admissible_set is empty
                    if isempty(admissible_set)
%                         disp('Case 2B')
                        
                        ad_it = 1;
                        ad_count = 1;
                        
                        while ad_it == 1
                            
                            admissible_set = find(starting_times >= task_start+task_length & ...
                                starting_times <= round(ad_count*(L-(task_start+task_length))/max_chain_length));
                            
                            
                            admissible_set = setdiff(admissible_set,ConvertToLong(task_index,task_timeline));
                            
                            
                            % Subtract current task's dependencies.
                            
                            cur_task_deps_left = find(ismember(DependencyMatrix(:,3:4),[task_index, task_timeline],'rows'));
                            cur_task_deps_left_indices_prel = DependencyMatrix(cur_task_deps_left,1:2);
                            cur_task_deps_right = find(ismember(DependencyMatrix(:,1:2),[task_index, task_timeline],'rows'));
                            cur_task_deps_right_indices_prel = DependencyMatrix(cur_task_deps_right,3:4);
                            
                            % Convert all indices to long
                            cur_task_deps_left_indices= [];
                            if size(cur_task_deps_left_indices_prel,1) > 0
                                for depit=1:size(cur_task_deps_left_indices_prel,1)
                                    cur_task_deps_left_indices = [cur_task_deps_left_indices; ConvertToLong(cur_task_deps_left_indices_prel(depit,1),cur_task_deps_left_indices_prel(depit,2))];
                                end
                            end
                            
                            cur_task_deps_right_indices= [];
                            if size(cur_task_deps_right_indices_prel,1) > 0
                                for depit=1:size(cur_task_deps_right_indices_prel,1)
                                    cur_task_deps_right_indices = [cur_task_deps_right_indices; ConvertToLong(cur_task_deps_right_indices_prel(depit,1),cur_task_deps_right_indices_prel(depit,2))];
                                end
                            end
                            
                            
                            admissible_set = setdiff(admissible_set,cur_task_deps_left_indices);
                            admissible_set = setdiff(admissible_set,cur_task_deps_right_indices);
                            
                            
                            if ad_count >= max_chain_length || size(admissible_set,1) > 0
                                ad_it = 0;
                            end
                            
                            ad_count = ad_count+1;
                            
                            
                        end
                    end
                    
                end
                
                
                
                %%%%%%%%%%
                % Tasks may have several dependencies (here, we should make
                % it so as we first try to see if we can choose a task
                % without any dependencies, but if that doesn't give results, constraints
                % will have to be alleviated.
                
            else
                
                % Choose only from the current time-line. Sort of like
                % before!
                
                % Must have ad_it here too!!!
                
                if timeline_jumps == 1 || constrain == 1 || pot_jump == 0
%                     disp('Case 3')
                    ad_it = 1;
                    ad_count = 1;
                    
                    while ad_it == 1
                        start_times = TimelineSolution{candidate(2)}(:,1);
                        end_times = TimelineSolution{candidate(2)}(:,1)+TimelineSolution{candidate(2)}(:,2);
                        
                        admissible_set = find(start_times >= task_start+task_length & ...
                            start_times <= round(ad_count*(L-(task_start+task_length))/max_chain_length));
                        
                        if ~isempty(admissible_set)
                            admissible_set = admissible_set+prev_indices(candidate(2));
                        end
                        
%                         admissible_set2 = find(start_times >= TimelineSolution{candidate(2)}(candidate(1),1)+ ...
%                             TimelineSolution{candidate(2)}(candidate(1),2));
%                         admissible_set = admissible_set2;
                        
                        %                         cand = [find(ismember(TimelineSolution{cur_task(end)},cur_task),1) cur_task(end)];
                        cand=[task_index, task_timeline];
% %                         DependencyMatrix
%                         ismember(DependencyMatrix(:,3:4),cand,'rows')'
%                         ismember(DependencyMatrix(:,1:2),cand,'rows')'
                        currently_dep1 = find(ismember(DependencyMatrix(:,3:4),cand,'rows'));
                        currently_dep_set1 = DependencyMatrix(currently_dep1,1:2);
                        currently_dep2 = find(ismember(DependencyMatrix(:,1:2),cand,'rows'));
                        currently_dep_set2 = DependencyMatrix(currently_dep2,3:4);
                        currently_dep = [currently_dep1; currently_dep2];
                        currently_dep_set = [currently_dep_set1; currently_dep_set2];
                        
                        currently_dep_set_aug = [];
                        if ~isempty(currently_dep_set)
                            for xyz=1:size(currently_dep_set,1)
                                currently_dep_set_aug = [currently_dep_set_aug; ConvertToLong(currently_dep_set(xyz,1),currently_dep_set(xyz,2))];
                            end
                        end
                        
                        admissible_set = setdiff(admissible_set,currently_dep_set_aug);
                        admissible_set = setdiff(admissible_set,ConvertToLong(task_index,task_timeline));
                        
                        if ad_count >= max_chain_length || size(admissible_set,1) > 0
                            ad_it = 0;
                        end
                        
                        ad_count = ad_count+1;
                        
                        
                        
                    end
                    
                    % Must exclude current task's deps. 
                    
                else
%                     disp('Case 4')
                    ad_it = 1;
                    ad_count = 1;
                    
                    while ad_it == 1
                        
                        admissible_set = find(starting_times >= task_start+task_length & ...
                            starting_times <= round(ad_count*(L-(task_start+task_length))/max_chain_length));
                        
%                         admissible_set2 = find(starting_times >= TimelineSolution{candidate(2)}(candidate(1),1)+ ...
%                             TimelineSolution{candidate(2)}(candidate(1),2));
%                         admissible_set = admissible_set2;
%                         
                        
                        
%                         cand = [find(ismember(TimelineSolution{cur_task(end)},cur_task),1) cur_task(end)];
                        cand=[task_index, task_timeline];
                        currently_dep1 = find(ismember(DependencyMatrix(:,3:4),cand,'rows'));
%                         a = ismember(DependencyMatrix(:,3:4),cand,'rows');
%                         a'
%                         disp('the sum')
%                         sum(ismember(DependencyMatrix(:,3:4),cand,'rows'))
                        currently_dep_set1 = DependencyMatrix(currently_dep1,1:2);
                        currently_dep2 = find(ismember(DependencyMatrix(:,1:2),cand,'rows'));
                        currently_dep_set2 = DependencyMatrix(currently_dep2,3:4);
                        currently_dep = [currently_dep1; currently_dep2];
                        currently_dep_set = [currently_dep_set1; currently_dep_set2];
                        
                        currently_dep_set_aug = [];
                        if ~isempty(currently_dep_set)
                            for xyz=1:size(currently_dep_set,1)
                                currently_dep_set_aug = [currently_dep_set_aug; ConvertToLong(currently_dep_set(xyz,1),currently_dep_set(xyz,2))];
                            end
                        end
                        
                        admissible_set = setdiff(admissible_set,currently_dep_set_aug);
                        
                        admissible_set = setdiff(admissible_set,ConvertToLong(task_index,task_timeline));
                        
                        
                        
                        if ad_count >= max_chain_length || size(admissible_set,1) > 0
                            ad_it = 0;
                        end
                        
                        ad_count = ad_count+1;
                        
                    end
                    
                end
                % Potential bug: two tasks on different time-lines begin at
                % the same time and have the same length (fixed).

            end
            
            
        % backwards
        else
            % Tasks may have at most one dependency.
            if first_pass == 1 && i <= Ntasks && size(tasks_left,1) > 0
                % Choose tasks from the current time-line
                if timeline_jumps == 1 || constrain == 1 || pot_jump == 0
%                     disp('Case 5')
%                     task_index = find(ismember(Tsol,cur_task),1);

                    
                    ad_it = 1;
                    ad_count = 1;
                    
                    start_times = TimelineSolution{task_timeline}(:,1);
                    end_times = TimelineSolution{task_timeline}(:,1)+TimelineSolution{task_timeline}(:,2);
                    
                    while ad_it == 1
                        
                        
                        admissible_set = find(end_times <= cur_task(1) & ...
                            end_times >= cur_task(1)-round(ad_count*cur_task(1)/max_chain_length));
                        
                        % Subtract tasks with at least one dependency,
                        % except for the current one.
                        
%                         cur_dep_matr_begin = find(ismember(DependencyMatrix(:,2),task_timeline,'rows'),1);
%                         cur_dep_matr_end = find(ismember(DependencyMatrix(:,4),task_timeline,'rows'),1);
                        
                        cur_dep_matr_begin = find(DependencyMatrix(:,2)==task_timeline);
                        cur_dep_matr_end = find(DependencyMatrix(:,4)==task_timeline);
                        
                        
                        cur_dep_matr_begin_ind = DependencyMatrix(cur_dep_matr_begin,1);
                        cur_dep_matr_end_ind = DependencyMatrix(cur_dep_matr_end,3);
                        
                        
                        admissible_set = setdiff(admissible_set,cur_dep_matr_begin_ind);
                        admissible_set = setdiff(admissible_set,cur_dep_matr_end_ind);
                        %                         admissible_set = setdiff(admissible_set,dep_set_begin_ind);
                        
                        admissible_set = setdiff(admissible_set,task_index);
                        
                        if ad_count >= max_chain_length || size(admissible_set,1) > 0
                            ad_it = 0;
                        end
                        
                        ad_count = ad_count+1;
                        
                    end
                    
                    if isempty(admissible_set)
%                         disp('Case 5B')
                        % Repeat without tough restrictions
                        ad_it = 1;
                        ad_count = 1;
                        
                        while ad_it == 1
                            
                            
                            admissible_set = find(end_times <= cur_task(1) & ...
                                end_times >= cur_task(1)-round(ad_count*cur_task(1)/max_chain_length));
                            
                            
                            admissible_set = setdiff(admissible_set,task_index);
                            
                            cur_task_deps_left = find(ismember(DependencyMatrix(:,2:4),[task_timeline, task_index, task_timeline],'rows'));
                            cur_task_deps_left_indices = DependencyMatrix(cur_task_deps_left,1);
                            cur_task_deps_right = find(ismember(DependencyMatrix(:,[1:2,4]), [task_index, task_timeline, task_timeline],'rows'));
                            cur_task_deps_right_indices = DependencyMatrix(cur_task_deps_right,3);
                            
                            admissible_set = setdiff(admissible_set,cur_task_deps_left_indices);
                            admissible_set = setdiff(admissible_set,cur_task_deps_right_indices);
                            
                            if ad_count >= max_chain_length || size(admissible_set,1) > 0
                                ad_it = 0;
                            end
                            
                            ad_count = ad_count+1;
                            
                        end
                        
                    end
                    
                    
                    if ~isempty(admissible_set)
                        admissible_set = admissible_set+prev_indices(task_timeline);
                    end
                else
%                     disp('Case 6')
                    
                    ad_it = 1;
                    ad_count = 1;
                    
                    while ad_it == 1
                        
                        admissible_set = find(ending_times <= cur_task(1) & ...
                            ending_times >= cur_task(1)-round(ad_count*cur_task(1)/max_chain_length));
                        
                        
                        tasks_in_dep = [];
                        non_zero_dep_matrix = DependencyMatrix;
                        non_zero_dep_matrix(all(non_zero_dep_matrix==0,2),:)=[];
                        if size(non_zero_dep_matrix,1) > 0
                            for titer=1:size(non_zero_dep_matrix,1)
                                
                                tasks_in_dep = [tasks_in_dep; ConvertToLong(non_zero_dep_matrix(titer,1),non_zero_dep_matrix(titer,2))];
                                tasks_in_dep = [tasks_in_dep; ConvertToLong(non_zero_dep_matrix(titer,3),non_zero_dep_matrix(titer,4))];
                            end
                        end
                        
                        admissible_set = setdiff(admissible_set,tasks_in_dep);
                        
                        admissible_set = setdiff(admissible_set,ConvertToLong(task_index,task_timeline));
                        
                        if ad_count >= max_chain_length || size(admissible_set,1) > 0
                            ad_it = 0;
                        end
                        
                        ad_count = ad_count+1;
                        
                    end
                    
                    if isempty(admissible_set)
%                         disp('Case 6B')
                        % Remake with mitigated restrictions.
                        
                        ad_it = 1;
                        ad_count = 1;
                        
                        while ad_it == 1
                            
                            admissible_set = find(ending_times <= cur_task(1) & ...
                                ending_times >= cur_task(1)-round(ad_count*cur_task(1)/max_chain_length));
                            
                            
                            
                            admissible_set = setdiff(admissible_set,ConvertToLong(task_index,task_timeline));
                            
                            % Subtract away current task's dependencies.
                            
                            cur_task_deps_left = find(ismember(DependencyMatrix(:,3:4),[task_index, task_timeline],'rows'));
                            cur_task_deps_left_indices_prel = DependencyMatrix(cur_task_deps_left,1:2);
                            cur_task_deps_right = find(ismember(DependencyMatrix(:,1:2),[task_index, task_timeline],'rows'));
                            cur_task_deps_right_indices_prel = DependencyMatrix(cur_task_deps_right,3:4);
                            
                            % Convert all indices to long.
                            cur_task_deps_left_indices= [];
                            if size(cur_task_deps_left_indices_prel,1) > 0
                                for depit=1:size(cur_task_deps_left_indices_prel,1)
                                    cur_task_deps_left_indices = [cur_task_deps_left_indices; ConvertToLong(cur_task_deps_left_indices_prel(depit,1),cur_task_deps_left_indices_prel(depit,2))];
                                end
                            end
                            
                            cur_task_deps_right_indices= [];
                            if size(cur_task_deps_right_indices_prel,1) > 0
                                for depit=1:size(cur_task_deps_right_indices_prel,1)
                                    cur_task_deps_right_indices = [cur_task_deps_right_indices; ConvertToLong(cur_task_deps_right_indices_prel(depit,1),cur_task_deps_right_indices_prel(depit,2))];
                                end
                            end
                            
                            
                            admissible_set = setdiff(admissible_set,cur_task_deps_left_indices);
                            admissible_set = setdiff(admissible_set,cur_task_deps_right_indices);
                            
                            
                            
                            
                            if ad_count >= max_chain_length || size(admissible_set,1) > 0
                                ad_it = 0;
                            end
                            
                            ad_count = ad_count+1;
                            
                        end
                        
                        
                    end
                    
                end
            else
                % This one is simpl, as we have as good as done it already.
                % The only difference is that we shall sibtract more
                % elements. Choose tasks from this time-line.
                if timeline_jumps == 1 || constrain == 1 || pot_jump == 0
%                     disp('Case 7')
                    ad_it = 1;
                    ad_count = 1;
                    
                    while ad_it == 1
                        start_times = TimelineSolution{candidate(2)}(:,1);
                        end_times = TimelineSolution{candidate(2)}(:,1)+TimelineSolution{candidate(2)}(:,2);
                        admissible_set = find(end_times <= cur_task(1) & ...
                            end_times >= cur_task(1)-round(ad_count*cur_task(1)/max_chain_length));
                        
                        
                        %%%%%%%%%%%%%%%% Nytt %%%%%%%%%%%%%%%%%
                        cur_task_deps_left = find(ismember(DependencyMatrix(:,2:4),[task_timeline, task_index, task_timeline],'rows'));
                        cur_task_deps_left_indices = DependencyMatrix(cur_task_deps_left,1);
                        cur_task_deps_right = find(ismember(DependencyMatrix(:,[1:2,4]),[task_index, task_timeline, task_timeline],'rows'));
                        cur_task_deps_right_indices = DependencyMatrix(cur_task_deps_right,3);
                        
                        admissible_set = setdiff(admissible_set,cur_task_deps_left_indices);
                        admissible_set = setdiff(admissible_set,cur_task_deps_right_indices);
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        admissible_set = setdiff(admissible_set,task_index);
                        
                        if ad_count >= max_chain_length || size(admissible_set,1) > 0
                            ad_it = 0;
                        end
                        
                        ad_count = ad_count+1;
                        
                        if ~isempty(admissible_set)
                            admissible_set = admissible_set+prev_indices(candidate(2));
                        end
                        
                    end
                    

                    % Must exclude ucrrent task's dependencies. Find all
                    % which begin and end, respectively.
                    
                else
%                     disp('Case 8')
                    ad_it = 1;
                    ad_count = 1;
                    
                    while ad_it == 1
                        
                        admissible_set = find(ending_times <= cur_task(1) & ...
                            ending_times >= cur_task(1)-round(ad_count*cur_task(1)/max_chain_length));
                        
                        
                        %                         cand = [find(ismember(TimelineSolution{cur_task(end)},cur_task),1) cur_task(end)];
                        cand=[task_index, task_timeline];
%                       
                        currently_dep1 = find(ismember(DependencyMatrix(:,3:4),cand,'rows'));
%                         ismember(DependencyMatrix(:,3:4),cand,'rows')'
                        currently_dep_set1 = DependencyMatrix(currently_dep1,1:2);
                        currently_dep2 = find(ismember(DependencyMatrix(:,1:2),cand,'rows'));
                        currently_dep_set2 = DependencyMatrix(currently_dep2,3:4);
                        currently_dep = [currently_dep1; currently_dep2];
                        currently_dep_set = [currently_dep_set1; currently_dep_set2];
                        
                        currently_dep_set_aug = [];
                        if ~isempty(currently_dep_set)
                            for xyz=1:size(currently_dep_set,1)
                                currently_dep_set_aug = [currently_dep_set_aug; ConvertToLong(currently_dep_set(xyz,1),currently_dep_set(xyz,2))];
                            end
                        end
                        
                        % Remove tasks we are currently dependent upon.
                        admissible_set = setdiff(admissible_set,currently_dep_set_aug);
                        
                        admissible_set = setdiff(admissible_set,ConvertToLong(task_index,task_timeline));
                        
                        if ad_count >= max_chain_length || size(admissible_set,1) > 0
                            ad_it = 0;
                        end
                        
                        ad_count = ad_count+1;
                        
                    end
                    
                end
            end
            
        end
        
        
        
    end


% This should not be needed with the fix of adding dependencies using
% indices instead of appending them at the end.
DependencyMatrix(all(DependencyMatrix==0,2),:)=[];

within_timeline_deps = 0;

for iter2=1:size(DependencyMatrix,1)
    if DependencyMatrix(iter2,2) == DependencyMatrix(iter2,4)
        within_timeline_deps = within_timeline_deps + 1;
    end
end
% within_timeline_deps
% intra_timeline_deps = size(DependencyMatrix,1)-within_timeline_deps

% DependencyMatrix
% 
% [u,I,J] = unique(DependencyMatrix, 'rows', 'first')
% hasDuplicates = size(u,1) < size(DependencyMatrix,1)
% ixDupRows = setdiff(1:size(DependencyMatrix,1), I)
% dupRowValues = DependencyMatrix(ixDupRows,:)
% tasks_remaining = size(tasks_left,1)

end



