function SimplifiedGaborFilter()
counter = 1;
pattern_size = 5;
pattern_image_size = 2*round(pattern_size/2) + 1;
sgw_patterns = zeros(pattern_image_size,pattern_image_size,2,4);
for i=1:2
    for j=1:4
        switch(i)
            case 1
                w = 0.3*pi;
            case 2
                w = 0.5*pi;
            otherwise
                break;
        end
        theta = pi*((j-1)/4);
        sigma = 1/w;
        if(sigma*w > 1)
            fprintf('w*sigma should be <= 1\n');
        else
            S = GenerateGaborKernel(pattern_size,w,sigma,theta);
            %S = S';
            %set(gcf,'Visible','off');
            S = (S-min(S(:)))./(max(S(:))-min(S(:))); %normalizes the image, same as imagesc
            sgw_patterns(:,:,i,j) = S;
            subplot(3,3,counter); imshow(S);
            %colormap(gray);
            %imagesc(S);
            counter=counter+1;
        end
    end
end
%quantize masks
% test = images(:,:,1);%imresize(images(:,:,1),[512, 512]);
% figure('Name','test');
% imshow(test);
% max_mag = max(test(:));
% n = 2;
% quantization_levels = (2*n) + 1;
% for k=1:quantization_levels
%     q(k) = (max_mag/quantization_levels)*2*k;
% end
% tresh = multithresh(test,4);
% tresh
% test2 = imquantize(test,q);
% imagesc(test2);
I = imread('lena.tif');
%figure();
%imshow(I);
image_size = size(I);
image_width = image_size(1,1);
image_height = image_size(1,2);
pixel_features = zeros(1,8);
T1 = 0.5;
T2 = 1;
pattern_center_x = round(pattern_size/2);
pattern_center_y = round(pattern_size/2);
output_image = zeros(image_width,image_height);
for x=1:image_width
    for y=1:image_height
        if(x>pattern_size && y>pattern_size && x < (image_width-pattern_size) && y < (image_height-pattern_size))
            counter = 1;
            for i=1:2
                for j=1:4
                    current_pattern = sgw_patterns(:,:,i,j);
                    %Quantize the patterns before?
                    max_mag = max(current_pattern(:));
                    n = 2;
                    quantization_levels = (2*n) + 1;
                    q = zeros(quantization_levels);
                    for k=1:quantization_levels
                        q(k) = (max_mag/quantization_levels)*2*k;
                    end
                    q = q - q(3);
                    q2 = q(5);
                    q1 = q(4);
                    switch(i)
                        case 1
                            switch(j)
                                case 1
                                    pixel_features(counter) = q1*(I(x-1,y+1)+I(x+1,y+1)-I(x-1,y-1)-I(x+1,y-1)) + q2*((I(x,y+1) - I(x,y-1)));
                                case 2
                                case 3
                                case 4
                            end
                        case 2
                            switch(j)
                                case 1
                                case 2
                                case 3
                                case 4
                            end
                    end
                    counter = counter + 1;
                    output_image(x,y) = pixel_features(1);
                end
            end
        end
    end
end
figure()
imshow(output_image);
end