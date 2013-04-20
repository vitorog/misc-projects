function HistogramEq(image_path)
orig_img = imread(image_path);
orig_img_size = size(orig_img);
width = orig_img_size(1,1);
height = orig_img_size(1,2);
L = 256;
intensity_pdf = zeros(1,3*L,'double');
values = [1:3*L];
for i=1:width
    for j=1:height
        red = int32(orig_img(i,j,1));
        green = int32(orig_img(i,j,2));
        blue = int32(orig_img(i,j,3));        
        ni = red + green + blue;           
        intensity_pdf(1,ni+1) = intensity_pdf(1,ni+1) + double(1);        
    end   
end
intensity_pdf = intensity_pdf / (width*height);
figure('Name', 'Original Image PDF','NumberTitle','off');
stem(values,intensity_pdf);
intensity_cdf = zeros(1,3*L,'double');
for i=1:3*L
    if(i==1)
        intensity_cdf(i) = intensity_pdf(i);
    else
        intensity_cdf(i) = intensity_cdf(i-1) + intensity_pdf(i);
    end    
end
figure('Name', 'Original Image CDF','NumberTitle','off');
plot(values,intensity_cdf);
output_img = orig_img;
for i=1:width
    for j=1:height
        red = int32(orig_img(i,j,1));
        green = int32(orig_img(i,j,2));
        blue = int32(orig_img(i,j,3));
        input_intensity = red + green + blue;        
        output_intensity = round(3*double(L*intensity_cdf(input_intensity + 1)));     
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
figure('Name', 'Original Image','NumberTitle','off');
imshow(orig_img);
figure('Name', 'Equalized Image','NumberTitle','off');
imshow(output_img);
output_intensity_pdf = zeros(1,3*L,'double');
for i=1:width
    for j=1:height
        red = int32(output_img(i,j,1));
        green = int32(output_img(i,j,2));
        blue = int32(output_img(i,j,3));        
        ni = red + green + blue;           
        output_intensity_pdf(1,ni+1) = output_intensity_pdf(1,ni+1) + double(1);        
    end   
end
output_intensity_pdf = output_intensity_pdf / (width*height);
figure('Name', 'Output Image PDF','NumberTitle','off');
stem(values,output_intensity_pdf);
output_intensity_cdf = zeros(1,3*L,'double');
for i=1:3*L
    if(i==1)
        output_intensity_cdf(i) = output_intensity_pdf(i);
    else
        output_intensity_cdf(i) = output_intensity_cdf(i-1) + output_intensity_pdf(i);
    end    
end
figure('Name', 'Output Image CDF','NumberTitle','off');
plot(values,output_intensity_cdf);

end

