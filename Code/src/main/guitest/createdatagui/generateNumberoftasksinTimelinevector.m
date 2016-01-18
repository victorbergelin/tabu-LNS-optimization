% Created by: Isak Bohman, 2015
function [ NumberoftasksinTimelinevector ] = generateNumberoftasksinTimelinevector( Ntasks, Ntimelines, distrib8, std8 )
% Generates the number of tasks for every time-line.
x=0;

% Expected value of tasks per time-line
mu = Ntasks/Ntimelines;

% Standard deviation
std = std8*mu;

NumberoftasksinTimelinevector = [];

if Ntimelines == 1
    NumberoftasksinTimelinevector = Ntasks;
else
    
    %     while x==0
    %         % Make an approximation already at this stage.
    %
    %         numbers_vector = sort(randi(Ntasks,Ntimelines-1,1));
    %         NumberoftasksinTimelinevector = [numbers_vector(1); diff(numbers_vector); Ntasks-numbers_vector(end)];
    %         if min(NumberoftasksinTimelinevector) >
    %         floor(Ntasks/Ntimelines/1.5) % arbitrarily chosen ATM.
    %             x=1;
    %         end
    %     end
    
    for i=1:Ntasks
        x=0;
        % create numbers using the distribtuion distrib8, with mu and std8
        while x==0
            NumberoftasksinTimelinevector_element = round(distrib8(mu,std)); % Calibrate this!
            
            % Must have a minimum number of tasks per time-line.
            if NumberoftasksinTimelinevector_element > max(1,floor(Ntasks/Ntimelines/5)) % arbitrarily chosen ATM.
                x=1;
                NumberoftasksinTimelinevector = [NumberoftasksinTimelinevector; NumberoftasksinTimelinevector_element];
            end
        end
    end
    
    
end

end

