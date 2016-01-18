% Created by: Isak Bohman, 2015
function [DependencyAttribute] = Generatedependencyattributes(TimelineSolution, DependencyMatrix, L, N, T, distrib6, std6, mu4, std2, distrib2, mu2)
% Generates dependency attributes with the desired characteristics.

% This is simple, given a dependency. Very similar to the other attributes
% generator.

% distrib6 = min time.

% Allocate space to improve performance.
DependencyAttribute = zeros(size(DependencyMatrix,1),2);

% Scaling = ceil(L/4); % dividerar ej med antalet tasks, ska vara i förhållande till tidslinjens längd.

% for every element in DependencyMatrix, create a corresponding attribute.
for i=1:size(DependencyMatrix,1)
%     i
%     DependencyMatrix(i,1)
%     DependencyMatrix(i,2)
    
    % Short scale
    scale_factor1 = TimelineSolution{DependencyMatrix(i,2)}(DependencyMatrix(i,1),2);
    
    % Long scale
    scale_factor3 = floor(L/2);
    
    % Medium scale
    scale_factor2 = floor(sqrt(scale_factor1*scale_factor3));
    
    % With 25 % probability, use short and long intervals, with 50 % probability use
    % medium length intervals.
    p=randi(4,1,1);
    switch p
        case 1
            Scaling = scale_factor1;
        case 2
            Scaling = scale_factor2;
        case 3
            Scaling = scale_factor2;
        case 4
            Scaling = scale_factor3;
    end
    
    % Ending time of first task
    task1_end = TimelineSolution{DependencyMatrix(i,2)}(DependencyMatrix(i,1),1) + ...
        TimelineSolution{DependencyMatrix(i,2)}(DependencyMatrix(i,1),2);
    
    % Starting time of second task
    task2_begin = TimelineSolution{DependencyMatrix(i,4)}(DependencyMatrix(i,3),1);
    
    % Ending time of second task
    task2_end = TimelineSolution{DependencyMatrix(i,4)}(DependencyMatrix(i,3),1) + ...
        TimelineSolution{DependencyMatrix(i,4)}(DependencyMatrix(i,3),2);
    
%     rand1 = randi(Scaling,1,1)-1;
%     rand2 = randi(Scaling,1,1)-1;

    x=0;
    
    % Modified scaling so that the current solution always is admissible,
    % i.e. fdmin cannot be greater than than the distance between the two
    % tasks.
    mod_scaling = min(Scaling,task2_begin-task1_end);
    while x==0
        rand1 = distrib6(mod_scaling*mu4,mod_scaling*std6);
        fdmin = task2_begin-task1_end-rand1;
        if fdmin >= 0
            x=1;
        end
        
    end
    x=0;
    % Generate the maximum time allowed between tasks.
    while x==0
        rand2 = distrib2(Scaling*mu2,Scaling*std2);
        
        fdmax = min(L-(task2_end-task2_begin),task2_begin-task1_end+rand2);
        if fdmax > fdmin
            x=1;
        end
    end
    
    DependencyAttribute(i,:) = [fdmin, fdmax];
    
end

% Obtain the first task in the dependency. Find its ending time.
% Obtain the second task in the dependency. Find its starting/ending time.

% Calculate differences and subtract and add random numbers.

end

