% Created by: Isak Bohman, 2015
function [ TimelineAttribute ] = createtimelineattribute(TimelineSolution,Attributegenerator,L, variance, mu, std3, distrib3, mu11, ...
        distrib5, std5, mu3)
% Creates time-line attributes, i.e. the allowed intervals where task may
% be placed on a time-line.

% Attributes should be constrained to the time-line.

% std3, distrib3, mu11 are for minimum, the other ones for the maximum time
% dsitribution.

TimelineAttribute = zeros(length(TimelineSolution(:,1)),2);

for i=1:length(TimelineSolution(:,1))
    
    x=0;
    
    while x==0
        TimelineAttribute_prel = generate_attribute(TimelineSolution(i,:),L,mu11,std3,distrib3,mu3,std5,distrib5);
        % Check if the candidate attribute is admissible.
        if TimelineAttribute_prel(1) >= 0 && TimelineAttribute_prel(2) <= L
            TimelineAttribute(i,:) = TimelineAttribute_prel;
            x=1;
        end
    end
end

