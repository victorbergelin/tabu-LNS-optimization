% Created by: Isak Bohman, 2015
function [TimelineSolution] = createsolution(N, L, T,generateNumberoftasksinTimelinevector, occupancy, ...
    genlistoflengths_startpts, std7, distrib7, distrib8, std8, distrib4, std4)
% Creates a time-line solution cell array, consisting of lists of tasks.

% Determine the number of tasks on each time-line.
NumberoftasksinTimelinevector = generateNumberoftasksinTimelinevector(N,T, distrib8, std8);

TimelineSolution = {};

% Create an element, to be inserted into the TimelineSolution.
for n=1:T
    
	N=NumberoftasksinTimelinevector(n);
%     listofstartingpoints= generatelistofstartingpoints(L, N);
    % size(listofstartingpoints,1)
    % genlistoflength should be modded a bit.
%     listoflength=generatelistoflength(listofstartingpoints,L);
    [listofstartingpoints, listoflength] = genlistoflengths_startpts(L, N, occupancy, distrib4, std4, std7, distrib7);

    TimelineSolution{n} = [listofstartingpoints, listoflength];
end

end


