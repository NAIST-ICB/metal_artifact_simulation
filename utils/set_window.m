function img = set_window(img, vmin, vmax)
img(img>vmax) = vmax;
img(img<vmin) = vmin;
img = (255/(vmax-vmin))*(img-vmin);
img = cast(img,'uint8');
end

