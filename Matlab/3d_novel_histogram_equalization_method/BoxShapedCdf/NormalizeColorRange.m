function output_img = NormalizeColorRange(input_img)
red_channel = double(input_img(:,:,1));
green_channel = double(input_img(:,:,2));
blue_channel = double(input_img(:,:,3));
max_red = double(max(red_channel(:)));
max_green = double(max(green_channel(:)));
max_blue = double(max(blue_channel(:)));
min_red = double(min(red_channel(:)));
min_green = double(min(green_channel(:)));
min_blue = double(min(blue_channel(:)));
if(min_red < 0)
    red_channel = red_channel + abs(min_red);
    max_red = max_red + abs(min_red);
end
if(min_green < 0)
    green_channel = green_channel + abs(min_green);
    max_green = max_green + abs(min_green);
end
if(min_blue < 0)
    blue_channel = blue_channel + abs(min_blue);
    max_blue = max_blue + abs(min_blue);
end
red_channel = 255*(red_channel./max_red);
green_channel = 255*(green_channel./max_green);
blue_channel = 255*(blue_channel./max_blue);
output_img(:,:,1) = uint8(red_channel);
output_img(:,:,2) = uint8(green_channel);
output_img(:,:,3) = uint8(blue_channel);
end




