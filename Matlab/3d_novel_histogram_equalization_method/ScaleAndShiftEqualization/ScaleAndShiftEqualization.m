function ScaleAndShiftEqualization(image_path)
input_img = imread(image_path);
input_luminance_pdf = CalculateLuminancePdf(input_img,'Original Image Luminance PDF');
CalculateLuminanceCdf(input_luminance_pdf,'Original Image Luminance CDF');
figure('Name','Original Image','Numbertitle','off')
imshow(input_img);
image_size = size(input_img);
width = image_size(1,1);
height = image_size(1,2);
output_img = input_img;
L = 256;
d1 = 0;
d2 = 3*L;
m = 0.5*3*L;
n = 2;
for i=1:width
    for j=1:height
        red = int32(input_img(i,j,1));
        green = int32(input_img(i,j,2));
        blue = int32(input_img(i,j,3));
        input_intensity = red + green + blue;                
        output_intensity = s_transform(d1,d2,m,n,input_intensity);
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
figure('Name','Scale-and-Shifiting Equalized Image', 'Numbertitle', 'off');
imshow(output_img);
output_luminance_pdf = CalculateLuminancePdf(output_img,'Scale-and-Shifiting Equalized Image Luminance PDF');
CalculateLuminanceCdf(output_luminance_pdf,'Scale-and-Shifiting Equalized Image Luminance CDF');
end