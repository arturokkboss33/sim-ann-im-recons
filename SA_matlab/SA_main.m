%Main file for Simulated Annealing
load('shuffledImageEasy.mat');
global so;
global patches_size;
global no_tiles;
global Xtiles;
global Ytiles;
global tiles_array;


%------ Initialization ----- %
%Choose a starting temperature
To = 3000;
Tthresh = 10;
in_params = size(RGBtilesShuffled);
patches_size = [in_params(1) in_params(2)];
no_tiles = in_params(4);
Xtiles = tilesY;
Ytiles = tilesX;
tiles_array = RGBtilesShuffled;
%Choose randomly and initial microstate
so = RGBtilesShuffled;
%Order the given tiles randomly
% used_tiles = zeros(1,no_tiles);
% nofree_tiles = no_tiles;
% stitch_row = [];
% im_shuffle = [];
% row_counter = 0;
% for tile = 1 : no_tiles
%     rand_tile = uint8(floor(1 + (nofree_tiles-1)*rand()));
%     free_tiles = find(used_tiles == 0);
%     %chosen_tile = free_tiles(rand_tile);
%     chosen_tile = tile;
%     used_tiles(chosen_tile) = 1;
%     nofree_tiles = nofree_tiles-1;
%     
%     if tile == no_tiles
%         stitch_row = [stitch_row RGBtilesShuffled(:,:,:,chosen_tile)];
%         im_shuffle = [im_shuffle; stitch_row];
%         stitch_row = [];
%     elseif row_counter < Xtiles
%         row_counter = row_counter +1;
%         stitch_row = [stitch_row RGBtilesShuffled(:,:,:,chosen_tile)];
%     else
%         im_shuffle = [im_shuffle; stitch_row];
%         stitch_row = [];
%         stitch_row = [stitch_row RGBtilesShuffled(:,:,:,chosen_tile)];
%         row_counter = 1;
%     end
% end

% ----- ----- ----- %


T = To;
sprev = so;
Eprev = SA_energyfcn(sprev);
no_iter = 1;

while T > Tthresh
    % ----- Call T-schedule ----- %
    T = T_schedule(T,no_iter);
    no_iter = no_iter+1;
    % ----- ----- ----- %
    % ----- Choose another candidate s* -----%
    snew = sprev;
    %swap_tiles = uint8( floor(1 + (no_tiles-1*rand(1,2))) );
    rposx = uint8(floor(2 + (Xtiles-1-2)*rand(1,2)));
    rposy = uint8(floor(2 + (Ytiles-1-2)*rand(1,2)));
    swap_tiles = ((rposy-1).*Xtiles)+rposx;
    if swap_tiles(1) > 204 || swap_tiles(2) > 204
        a = 1;
    end
    snew(:,:,:,swap_tiles(1)) = sprev(:,:,:,swap_tiles(2));
    snew(:,:,:,swap_tiles(2)) = sprev(:,:,:,swap_tiles(1));
    % ----- ----- ----- %
    % ----- Compute the new Energy and accept/reject the new state -----%
    Enew = SA_energyfcn(snew);
    if Enew < Eprev
        sprev = snew;
        Eprev = Enew;
%     else
%         paccept = exp((Eprev-Enew)/T);
%         uni_sample = rand();
%         if paccept > uni_sample
%             sprev = snew;
%             Eprev = Enew;
%         end
    end
    % ----- ----- ----- %
end

%Reconstruct final image from the last microstate
row_counter = 0;
stitch_row = [];
im_final = [];
for tile = 1 : no_tiles
    if tile == no_tiles
        stitch_row = [stitch_row sprev(:,:,:,tile)];
        im_final = [im_final; stitch_row];
        stitch_row = [];
    elseif row_counter < Xtiles
        row_counter = row_counter +1;
        stitch_row = [stitch_row sprev(:,:,:,tile)];
    else
        im_final = [im_final; stitch_row];
        stitch_row = [];
        stitch_row = [stitch_row sprev(:,:,:,tile)];
        row_counter = 1;
    end
end
