function [water, bone] = threshold_based_weighting(image,T1,T2)
% THRESHOLD_BASED_WEIGHTING
% apply weight function to the image based on given two threshold

    if nargin < 3
        error('Missing arguments')
    end

    w_bone = single(image - T1) / (T2 - T1);
    w_bone = clip(w_bone, 0 , 1);
    bone = w_bone .* single(image);

    w_water = single(T2 - image) / (T2 - T1);
    w_water = clip(w_water, 0, 1);
    water = w_water .* single(image);
    
end

function clipped = clip(a,minimum,maximum)
    clipped = a;
    clipped(a > maximum) = maximum;
    clipped(a < minimum) = minimum;
end