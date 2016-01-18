% Created by: Isak Bohman, 2015
function [start_time_list, length_list] = genlistoflengths_startpts(L, N, occupancy, distrib4, std4, std7, distrib7)
% Generates a list of lengths of tasks for a time-line.

% std4 = std4/(1+std4);
% std7 = std7/(1+std7);

% check if these formulae are correct.

corr =1;

% Expected length of a task
A = occupancy*L/N/corr;

% Expected length of the time between tasks.
B = (1-occupancy)*L/(N+1)/corr;

start_time_list = [];
length_list = [];

face_factor = 1;

% Task length standard deviation
std1 = face_factor*std4*L/N;

% Time between tasks standard deviation
std2 = std7*L/N;

% std1 = A*std4;
% std2 = A*std7;

time_it = 1;
previous = 1;
while time_it < L
    if previous == 0
        % Use std4, distrib4 here.
        rand1 = distrib4(A,std1);
        
%         while rand1 < max(1,A/50) || rand1 > L/3

        % The number must be neither too long, nor too short
        while rand1 < 2 || rand1 > L/3
            rand1 = distrib4(A,std1);
        end
        % rand1 = randi(floor(2*A),1,1);
        
        % We add a task
        length_list = [length_list; min(L-time_it,rand1)];
        time_it = time_it+rand1;
        previous = 1;
    else
        % Use std7, distrib7 here.
        rand2 = distrib7(B,std2);
        
        % The number must be neither too long, nor too short
        while rand2 < 2 || rand2 > L/3
%         while rand2 < max(2,B/50) || rand2 > L/3
            rand2 = distrib7(B,std2);
        end
        % rand2 = randi(floor(2*B),1,1);
        
        % If we can start a new task, add a new starting time after the
        % pause.
        if time_it+rand2 < L
            start_time_list = [start_time_list; time_it+rand2];
        end
        time_it = time_it+rand2;
        previous = 0;
    end
end
% disp('size of start time list')
% size(start_time_list,1)
% disp('size of length list')
% size(length_list,1)

