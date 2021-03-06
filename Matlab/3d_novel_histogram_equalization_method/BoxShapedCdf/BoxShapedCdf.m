function BoxShapedCdf(image_path)
L = 256;
orig_img = imread(image_path);
img_size = size(orig_img);
width = img_size(1,1);
height = img_size(1,2);
pdf = Calculate3dPdf(orig_img,L);
orig_img_cdf = Calculate3dCdf(pdf);
figure('Name','Original Image', 'Numbertitle','off');
imshow(orig_img);
input_luminance_pdf = CalculateLuminancePdf(orig_img,'Original PDF');
CalculateLuminanceCdf(input_luminance_pdf, 'Original CDF');
output_image = zeros(width,height,3,'int32');
for i=1:width
    for j=1:height
        red = int32(orig_img(i,j,1));
        green = int32(orig_img(i,j,2));
        blue = int32(orig_img(i,j,3));      
        cin_rgb = double(orig_img_cdf(red+1,green+1,blue+1));
        P = double((double(red + 1)*double(green + 1)*double(blue + 1)))/double(L^3);
        if(P~=cin_rgb)
            color = 0;
            if(cin_rgb > P)
                while(P < cin_rgb)
                    switch color
                        case 0
                            red = red + 1;
                        case 1
                            green = green + 1;
                        case 2
                            blue = blue + 1;
                    end
                    color = color +1;
                    if(color > 2)
                        color = 0;
                    end
                    P = double((double(red + 1)*double(green + 1)*double(blue + 1)))/double(L^3);
%                     if(red == 255 && green == 255 && blue == 255)
%                         break;
%                     end
                end
            else
                while(P > cin_rgb)                    
                    switch color
                        case 0
                            red = red - 1;
                        case 1
                            green = green - 1;
                        case 2
                            blue = blue - 1;
                    end
                    color = color + 1;
                    if(color > 2)
                        color = 0;
                    end
                    P = double((double(red + 1)*double(green + 1)*double(blue + 1)))/double(L^3);
%                     if(red == 0 && green == 0 && blue == 0)
%                         break;
%                     end
                end
            end
        end
        output_red = red;
        output_green = green;
        output_blue = blue;      
        output_image(i,j,1) = output_red;
        output_image(i,j,2) = output_green;
        output_image(i,j,3) = output_blue;
    end
end
output_image = uint8((output_image));
figure('Name','Box Shaped CDF Equalized', 'Numbertitle','off');
imshow(output_image);
output_luminance_pdf = CalculateLuminancePdf(output_image,'Box Shaped Equalization PDF');
CalculateLuminanceCdf(output_luminance_pdf, 'Box Shaped Equalization CDF');
end