%This function calculates the PDF of the luminosity levels of a given image
%and displays the PDF graph
function pdf = CalculateLuminancePdf(image, name)
L = 256;
image_size = size(image);
width = image_size(1,1);
height = image_size(1,2);
pdf = zeros(1,3*L,'double');
luminance_levels = (1:3*L);
for i=1:width
    for j=1:height
        red = int32(image(i,j,1));
        green = int32(image(i,j,2));
        blue = int32(image(i,j,3));        
        luminance = red + green + blue;        
        pdf(1,luminance+1) = pdf(1,luminance+1) + double(1);        
    end   
end
pdf = pdf / (width*height);
figure('Name', name,'NumberTitle','off');
stem(luminance_levels,pdf);
end