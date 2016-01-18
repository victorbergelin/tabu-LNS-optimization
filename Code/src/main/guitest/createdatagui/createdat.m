%%% Create data file, translates two dat files containing matrices 
%%% into one AMPL .dat file.

function createdat(taskfile, depfile, datafilename)

tasks = load(taskfile);
deps = load(depfile);
taskparams = tasks(:,2:5);
%%%temp sol
depsparams = deps(:,:);
fid=fopen(datafilename,'w');

%%%% temp
deps = zeros(size(deps,1),size(deps,2)+1);
for i = 1:size(deps,1)
    deps(i,1) = i;
end
deps(:,2:end) = depsparams;

%%%%

%%% Get the setdata %%%
number_of_timelines = max(size(unique(tasks(:,4)))); 

number_of_tasks = size(tasks,1);
% Create the timeline vector
G = unique(tasks(:,4));
% for i = 1:number_of_timelines
%     G(i) = i;
% end
I = [];
for k = 1:number_of_tasks
    I(k) = k;
end
% Create the data sets
fprintf(fid,'### SETS ###\n');
fprintf(fid,'set G :=');
fprintf(fid,'%5.0f', G');
fprintf(fid,';\n');
fprintf(fid,'set I :=');
fprintf(fid,'%5.0f', tasks(:,1)');
fprintf(fid,';\n');
fprintf(fid,'set D :=');
fprintf(fid,'%5.0f', deps(:,1)');
fprintf(fid,';\n\n\n');

% Identify which timeline the tasks belong to. I_matrix{1,1} gives the indices
% on timeline 1.
I_matrix = cell(number_of_timelines,1);
for k = 1:number_of_timelines
    for i = 1:number_of_tasks
        if tasks(i,4) == G(k)
            I_matrix{k,1} = [I_matrix{k,1} i];
        end
    end
end

%Print all the I_g sets in the .dat-file
for k = 1:number_of_timelines
    fprintf(fid,'set I_g[');
    fprintf(fid,'%2.0f', G(k));
    fprintf(fid,'] :=');
    fprintf(fid,'%4.0f', I_matrix{k,1});
    fprintf(fid,';\n');
end


fprintf(fid,'\n');
% AMPLmatrix(fid,'',tasks);
% AMPLmatrix(fid,'',deps);
ModifiedAMPLmatrix(fid,'',taskparams,1);
ModifiedAMPLmatrix(fid,'',depsparams(:,2:5),2);
fclose(fid);
end