function [ E ] = SA_energyfcn( s )
%SA_ENERYFCN Summary of this function goes here
%   Detailed explanation goes here

global no_tiles;
global Xtiles;
global Ytiles;

%im_gray = rgb2gray(s);

% (1) This energy fcn uses patches'mean and smoothness over a neighborhood
% of patches as parameters. These values are statistics values of the
% image's texture
% E(s) = A*Summatory_over_neigh{mu_i - mu_j} - B*Summatory_over_neigh{1/R}
% where R is the smoothness

A = 10;
B = 10;
E = 0;

mu_tiles = zeros(1,no_tiles);
%Compute the mean of all the patches in order to avoid recalculations
for tile = 1 : no_tiles
    chosen_tile = s(:,:,:,tile);
    gray_tile = rgb2gray(chosen_tile);
    thist = imhist(gray_tile);
    thist = thist./numel(gray_tile);
    Lt = length(thist);
    thist = thist(:);
    z = 0:(Lt-1);
    mu = z * thist;
    mu_tiles(tile) = mu/(Lt-1);
end

for tile = 1 : no_tiles
    
    %Precomputations------
    %Determine pos of the tile in the image
    im_pos = zeros(1,2);
    im_pos(1) = rem(tile,Xtiles);
    if rem(tile,Xtiles) == 0
        im_pos(1) = Xtiles;
    end
    im_pos(2) = uint8(ceil(tile / Xtiles));
    
    %Save an array with means of the tiles in the neighborhood
    mu_array = mu_tiles(tile)*ones(1,10);
    %Determine which tiles are neighbors and build a patch
    row_patch = [];
    patch = [];
    patch_c = 2;
    for i = -1 : 1
        for j = -1 : 1 
            new_pos = [im_pos(1)+j im_pos(2)+i];
            if new_pos(1) > 0 && new_pos(1) <= Xtiles
                if new_pos(2) > 0 && new_pos(2) <= Ytiles
                    tile_pos = (new_pos(2)-1)*Xtiles + new_pos(1);
                    row_patch = [row_patch s(:,:,:,tile_pos)];
                    mu_array(patch_c) = mu_tiles(tile_pos);
                end
            end
            patch_c = patch_c +1;
        end
        patch = [patch; row_patch];
        row_patch = [];
    end
    %------------------------
    
    %Compute the first element
    mu_dif_sum = 0;
    for i = 2 : length(mu_array)
        mu_dif_sum = mu_dif_sum + abs(mu_array(i)-mu_array(1));
    end
    
    %Compute the 2nd element
    gray_patch = rgb2gray(patch);
    phist = imhist(gray_patch);
    phist = phist./numel(gray_patch);
    Lp = length(phist);
    phist = phist(:);
    z = 0:Lp-1;
    mu = z*phist;
    z = z - mu;
    varn = ( (z*(Lp-1)).^2 )*phist;
    varn = varn/((Lp-1)^2);
    R = 1 - (1 / (1+varn));
    
    % Add up the 2 elements
    E = E + (A * mu_dif_sum - B * (1/R));
    

end

end

