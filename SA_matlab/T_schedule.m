function [ T ] = T_schedule( To , no_iter )
%T_SCHEDULE Summary of this function goes here
%   Detailed explanation goes here

%exponential cooling
% k = 0.98;
% T = k * To;

%numerical recipes in C recipe
k = 0.98;
N = 1;
if rem(no_iter,100*N) == 0
    T = k * To;
else
    T = To;
end

end

