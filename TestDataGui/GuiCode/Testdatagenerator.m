% Created by: Isak Bohman, 2015
function [ TimelineSolution, TimelineAttributeList, DependencyMatrix, DependencyAttribute ] = Testdatagenerator(N, L, T, generatelistoflength, ...
    generatelistofstartingpoints,generateNumberoftasksinTimelinevector, Attributegenerator, ...
    Generatedependencymatrix,Generatedependencyattributes,Ndependencies, variance1, mu1, variance2, mu2, occupancy, genlistoflengths_startpts, ...
    rectify,std1,std2,std3,std4,std5,std6,std7,std8, ...
                std9,mu11,mu21,mu3,mu4,distrib1,distrib2,distrib3,distrib4,distrib5,distrib6,distrib7,distrib8,distrib9,constrain, chains)
% Function which creates a test data solution

% std1, std9 and their corresponding distributions are not in use.

% Creates tasks and time-lines
TimelineSolution = createsolution(N,L,T,generatelistoflength, ...
    generatelistofstartingpoints,generateNumberoftasksinTimelinevector, occupancy, genlistoflengths_startpts, std7, distrib7, distrib8, std8, distrib4, std4);

TimelineAttributeList={};

for n=1:T
    % Creates a timeline attribute for each task
    TimelineAttributeList{n} = createtimelineattribute(TimelineSolution{n}, Attributegenerator, L, variance1, mu1, std3, distrib3, mu11, ...
        distrib5, std5, mu3);
end

% Creates dependencies and their attributes
[DependencyMatrix, DependencyAttribute]=Dependencygenerator(TimelineSolution,Generatedependencymatrix,Generatedependencyattributes, ...
    Ndependencies, variance2, mu2, L, N, T, rectify, distrib6, std6, mu4,std2, distrib2, mu21,constrain, chains);

end

