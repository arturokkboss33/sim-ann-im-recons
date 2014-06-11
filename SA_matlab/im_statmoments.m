function [ v, unv ] = im_statmoments( im_hist , no_moments )
%IM_STATMOMENTS Summary of this function goes here
%   Detailed explanation goes here

Lh = length(im_hist);

%Make sure the histogram is normalized
im_hist = im_hist / sum(im_hist);
im_hist = im_hist(:);
%Vector with all possible values of the random variable
z = 0:(Lh-1);

%The mean
m = z*im_hist;
%Center random variables around the mean
z = z - m;

%Compute the central moments
v = zeros(1,no_moments);
v(1) = m/(Lh-1);
for i = 2 : no_moments
    v(i) = (z.^i)*im_hist;
end

%Compute the un-normalized moments
unv = zeros(1,no_moments);
unv(1) = m;
for i = 2 : no_moments
    unv(i) = ( (z*(Lh-1)).^i )*im_hist;
end

end

