% Created by: Isak Bohman, 2015
function [DependencyMatrix, DependencyAttribute] = Dependencygenerator(TimelineSolution,Generatedependencymatrix,Generatedependencyattributes, ...
    Ndependencies, L, N, T, rectify, distrib6, std6, mu4, std2, distrib2, mu2,constrain, chains)

% Calls for the creation of a dependency matrix and a dependency attributes
% matrix.

DependencyMatrix=Generatedependencymatrix(TimelineSolution, Ndependencies, rectify,constrain,L, chains);


% if 
% something is wrong with  DependencyMatrix
% then send warning and go to repeat1
% repeat2
DependencyAttribute=Generatedependencyattributes(TimelineSolution, DependencyMatrix, L, N, T, distrib6, std6, mu4, std2, distrib2, mu2);


% if 
% something is wrong with DependencyAttribute
% then send warning and go to repeat2
% end:


end

