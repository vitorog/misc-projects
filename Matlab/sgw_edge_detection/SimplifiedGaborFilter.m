%The total number of patterns, by varying the w and phi parameters:
%We have w = 0.3*pi and 0.5*pi and for all these w, we have phi = j*pi/4,
%j=1...3;
clear all
close all
total_patterns = 8;
sgw_pattern_size = 3;
sgw_pattern_image_size = 2*round(sgw_pattern_size/2) + 1;
sgw_patterns = zeros(sgw_pattern_image_size,sgw_pattern_image_size,2,4);
%This generates the patterns described in the paper
figure('Name','SGW Patterns','Numbertitle','off');
counter = 1;
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
        sigma = 0.6;
        S = GenerateGaborKernel(sgw_pattern_size,w,sigma,theta);
        sgw_patterns(:,:,i,j) = S(:,:);
        S = S';
        subplot(3,3,counter); imagesc(S); colormap(gray);
        counter = counter + 1;
    end
end
%Now we have to quantize the patterns
nl = 2;
total_quantization_levels = (2*nl) + 1;
phi_q = zeros(2,4,nl);
q = zeros(1,total_quantization_levels);
for i=1:2
    for j=1:4
        curr_pattern = sgw_patterns(:,:,i,j);
        A = max(curr_pattern(:));
        for k=1:total_quantization_levels
            %As defined in the paper
            q(1,k) = (A/(total_quantization_levels))*2*k;
        end
        q_center = ceil(total_quantization_levels/2);
        q = q - q(q_center); %We shift the q vector so that the q0 is the middle element
        phi_q(i,j,nl) = abs(q(1,1)); %q2
        phi_q(i,j,nl-1) = abs(q(1,2)); %q1
    end
end
%Now we apply the kernel by convolving them with the image
Ioriginal = imread('lena.tif');
I = double(rgb2gray(Ioriginal));
figure('Name','Original Image','Numbertitle','off');
imagesc(I);colormap(gray)
image_size = size(I);
image_width = image_size(1,1);
image_height = image_size(1,2);
%The threshold limits
T1 = 3;
T2 = 2*T1;
phi = zeros(image_width,image_height,2,4);
output_image = zeros(image_width,image_height);
for x=1:image_width
    for y=1:image_height
        px = y;
        py = x;
        is_edge = 0;
        %We can only apply the kernel if the current position allows it
        %TODO(?) Maybe duplicate the border lines of the image...
        if(x>sgw_pattern_size && y>sgw_pattern_size && x < (image_width-sgw_pattern_size) && y < (image_height-sgw_pattern_size))
            %First we calculate Phi(0,0) and Phi(0,2), using the equations
            %described in the paper
            q2 = phi_q(1,1,2);
            q1 = phi_q(1,1,1);
            phi(px,py,1,1) = q1*(I(px-1,py+1) + I(px+1,py+1) - I(px-1,py-1) - I(px+1,py-1)) + q2*(I(px,py+1) - I(px,py-1));
            
            q2 = phi_q(1,3,2);
            q1 = phi_q(1,3,1);
            phi(px,py,1,3) = q1*(I(px+1,py-1) + I(px+1,py+1) - I(px-1,py-1) - I(px-1,py+1)) + q2*(I(px+1,py) - I(px-1,py));
            
            if(abs(phi(px,py,1,1)) < T1 && abs(phi(px,py,1,3) < T1))
                is_edge = 0;
            else
                if(abs(phi(px,py,1,1)) + abs(phi(px,py,1,3)) > T2)
                    is_edge = 1;
                else                    
                    q2 = phi_q(1,2,2);
                    q1 = phi_q(1,2,1);
                    phi(px,py,1,2) = q1*(I(px,py+2) + I(px+2,py) - I(px,py-2) - I(px-2,py)) + q2*(I(px,py+1) + I(px+1,py) + I(px+1,py+1) - I(px,py-1) - I(px-1,py) - I(px-1,py-1));                    
                    
                    q2 = phi_q(1,4,2);
                    q1 = phi_q(1,4,1);
                    phi(px,py,1,4) = q1*(I(px,py-2) + I(px+2,py) - I(px-2,py) - I(px,py+2)) + q2*(I(px,py-1) + I(px+1,py) + I(px+1,py-1) - I(px-1,py) - I(px-1,py+1) - I(px,py+1));
                    
%                     if(abs(phi(px,py,1,2)) + abs(phi(px,py,1,4)) > T2)
%                         is_edge = 1;
%                     end
                    
                    q2 = phi_q(2,1,2);
                    phi(px,py,2,1) = q2*(I(px,py+1) - I(px,py-1));
                    
                    q2 = phi_q(2,3,2);
                    phi(px,py,2,3) = q2*(I(px+1,py) - I(px-1,py));
                    
%                     if(abs(phi(px,py,2,1)) + abs(phi(px,py,2,3)) > T2)
%                         is_edge = 1;
%                     end
                    
                    q2 = phi_q(2,2,2);
                    phi(px,py,2,2) = q2*(I(px,py+1) + I(px+1,py) - I(px,py-1) - I(px-1,py));                          
                    
                    q2 = phi_q(2,4,2);
                    q1 = phi_q(2,4,1);
                    phi(px,py,2,4) = q2*(I(px,py-1) + I(px+1,py+1) - I(px,py+1) - I(px-1,py));
                    
%                     if(abs(phi(px,py,2,2)) + abs(phi(px,py,2,4)) > T2)
%                         is_edge = 1;
%                     end
                end
            end
        end
        if(is_edge == 1)            
            output_image(px,py) = max( abs(phi(px,py,:)) );
        end
    end
end

figure,subplot(2,4,1), imagesc(phi(:,:,1,1)), colormap(gray);
subplot(2,4,2), imagesc(phi(:,:,1,2)), colormap(gray);
subplot(2,4,3), imagesc(phi(:,:,1,3)), colormap(gray);
subplot(2,4,4), imagesc(phi(:,:,1,4)), colormap(gray);
subplot(2,4,5), imagesc(phi(:,:,2,1)), colormap(gray);
subplot(2,4,6), imagesc(phi(:,:,2,2)), colormap(gray);
subplot(2,4,7), imagesc(phi(:,:,2,3)), colormap(gray);
subplot(2,4,8), imagesc(phi(:,:,2,4)), colormap(gray);
figure('Name','Output Image','Numbertitle','off');
test = max(output_image(:));
output_image = output_image / test;
imshow(output_image);