function pdf = Calculate3dPdf(image, L)
pdf = zeros(L,L,L);
image_size = size(image);
width = image_size(1,1);
height = image_size(1,2);
for i=1:width
    for j=1:height
        red = image(i,j,1);
        green = image(i,j,2);
        blue = image(i,j,3);
        pdf(red + 1,green + 1,blue + 1) = pdf(red + 1,green + 1,blue + 1) + double(1);
    end
end
pdf = double(pdf)/ double(width*height);
end