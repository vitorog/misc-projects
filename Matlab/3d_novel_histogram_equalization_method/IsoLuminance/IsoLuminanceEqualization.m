%This function applies the 3D Histogram Equalization with 1D Uniform
%GrayScale Histogram
function IsoLuminanceEqualization(image_path)
orig_img = imread(image_path);
orig_img = orig_img(:,:,1:3);
orig_img_size = size(orig_img);
width = orig_img_size(1,1);
height = orig_img_size(1,2);
L = 256;
figure('Name', 'Original Image','NumberTitle','off');
imshow(orig_img);
orig_image_pdf = CalculateLuminancePdf(orig_img,'Original Image PDF');
original_image_cdf = CalculateLuminanceCdf(orig_image_pdf, 'Original Image CDF');
output_img = orig_img;
for i=1:width
    for j=1:height
        red = int32(orig_img(i,j,1));
        green = int32(orig_img(i,j,2));
        blue = int32(orig_img(i,j,3));
        input_intensity = red + green + blue;        
        output_intensity = round(3*double(L*original_image_cdf(input_intensity + 1)));     
        if(input_intensity~=0)                 
            alfa = double(output_intensity)/double(input_intensity);        
        else            
            alfa = 0;
        end        
        if(alfa <= 1)                      
            output_red = alfa*red;          
            output_green = alfa*green;
            output_blue = alfa*blue;
        else          
            y_red = (L-1) - red;          
            y_green = (L-1) - green;         
            y_blue = (L-1) - blue;         
            y_input_intensity = y_red + y_green + y_blue;                     
            y_output_intensity = 3*(L-1) - (output_intensity);            
            if(y_input_intensity ~= 0)
                y_alfa = double(y_output_intensity)/double(y_input_intensity);
            else
                y_alfa = 0;
            end            
            y_output_red = y_alfa*y_red;
            y_output_green = y_alfa*y_green;
            y_output_blue = y_alfa*y_blue;

            output_red = (L-1) - y_output_red;
            output_green = (L-1) - y_output_green;
            output_blue = (L-1) - y_output_blue;     
        end
        output_img(i,j,1) = output_red;
        output_img(i,j,2) = output_green;
        output_img(i,j,3) = output_blue;
    end   
end
figure('Name', 'Iso-Luminance Equalized Image','NumberTitle','off');
imshow(output_img);
equalized_image_pdf = CalculateLuminancePdf(output_img, 'Iso-Luminance Equalized Image PDF');
CalculateLuminanceCdf(equalized_image_pdf, 'Iso-Luminance Equalized Image CDF');
end

