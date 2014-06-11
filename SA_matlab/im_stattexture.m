function [ t ] = im_stattexture( im, scale )
%IM_STATTEXTURE Summary of this function goes here
%   Detailed explanation goes here

%See if the user input a scale
if nargin == 1
    scale(1:6) = 1;
else
    scale = scale(:)';
end

%Obtain histogram and normalize it
h = imhist(im);
h = h./numel(im);
L = length(h);

%Compute the first three moments of the image (un-normalized)
[v, unv] = im_statmoments(h,3);

%Compute the six textures measure
%Average gray level
t(1) = v(1);
%Standard deviation
t(2) = unv(2)^0.5;
%Smoothness
%First normalize the variance
varn = unv(2)/(L-1)^2;
t(3) = 1 - (1 / (1+varn));
%Third moment (normalized)
t(4) = unv(3)/(L-1)^2;
%Uniformity
t(5) = sum(h.^2);
%Entropy
t(6) = -sum(h.*(log2(h+eps)));

%Scale the values
t = t.*scale;

end

