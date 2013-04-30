function SimplifiedGaborFilter()
counter = 1;
%The total number of patterns, by varying the w and phi parameters:
%We have w = 0.3*pi and 0.5*pi and for all these w, we have phi = j*pi/4,
%j=1...3;
total_patterns = 8;
sgw_pattern_size = 5;
sgw_pattern_image_size = 2*round(sgw_pattern_size/2) + 1;
sgw_patterns = zeros(sgw_pattern_image_size,sgw_pattern_image_size,2,4);
%This generates the patterns described in the paper
figure('Name','SGW Patterns','Numbertitle','off');
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
            S = GenerateGaborKernel(sgw_pattern_size,w,sigma,theta);
            S = S';
            %S = (S-min(S(:)))./(max(S(:))-min(S(:))); %normalizes the image, same as imagesc
            sgw_patterns(:,:,i,j) = S;
            subplot(3,3,counter); imshow(S);
            counter = counter + 1;
        end
    end
end
%Now we have to quantize the patterns
nl = 2;
total_quantization_levels = (2*nl) + 1;
sgw_patterns_quantization = zeros(2,4,total_quantization_levels);
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
        sgw_patterns_quantization(i,j,:) = q; %We store the quantization for each gabor pattern
    end
end
%Now we apply the kernel by convolving them with the image
I = imread('lena.tif');
figure('Name','Original Image','Numbertitle','off');
imshow(I);
image_size = size(I);
image_width = image_size(1,1);
image_height = image_size(1,2);
%The threshold limits
T1 = 9.5;
T2 = 2*T1;
sgw_features = zeros(2,4,'double');
output_image = zeros(image_width,image_height);
for x=1:image_width
    for y=1:image_height
        %We can only apply the kernel if the current position allows it
        %TODO(?) Maybe duplicate the border lines of the image...
        is_edge = 0;
        if(x>sgw_pattern_size && y>sgw_pattern_size && x < (image_width-sgw_pattern_size) && y < (image_height-sgw_pattern_size))
            %First we calculate Phi(0,0) and Phi(0,2), using the equations
            %described in the paper
            
            %We consider only 5 quantization levels (-q2,-q1,0,q1,q1)
            %TODO: Generalize later?
            q2 = sgw_patterns_quantization(1,1,total_quantization_levels);
            q1 = sgw_patterns_quantization(1,1,total_quantization_levels - 1);
            
            sgw_features(1,1) = q1*double((I(x-1,y+1) + I(x+1,y+1) - I(x-1,y-1) - I(x+1,y-1))) + q2*double((I(x,y+1) - I(x,y-1)));
            sgw_features(1,3) = q1*double((I(x+1,y-1) + I(x+1,y+1) - I(x-1,y-1) - I(x-1,y+1))) + q2*double((I(x+1,y) - I(x-1,y)));
            
            if(abs(sgw_features(1,1)) > T1 || abs(sgw_features(1,3)) > T1 || (abs(sgw_features(1,1)) + abs(sgw_features(1,3)) > T2) )
                is_edge = 1;
%             else
%                 %TODO: Invesgate how to properly use the other features
%                 sgw_features(1,2) = q1*double( I(x,y+2) + I(x+2,y) - I(x,y-2) - I(x-2,y)) + q2*double( I(x,y+1) + I(x+1,y) + I(x+1,y+1) - I(x,y-1) + I(x-1,y) - I(x-1,y-1) );
%                 sgw_features(1,4) = q1*double( I(x,y-2) + I(x+2,y) - I(x-2,y) - I(x,y+2)) + q2*double( I(x,y-1) + I(x+1,y) + I(x+1,y-1) - I(x-1,y) - I(x-1,y+1) - I(x,y+1) );
%                 if(abs(sgw_features(1,2)) > T1 || abs(sgw_features(1,4)) > T1 || (abs(sgw_features(1,2)) + abs(sgw_features(1,4)) > T2) )
%                     is_edge = 1;
%                 else
%                     if( abs(sgw_features(2,1)) > T1 || abs(sgw_features(2,2)) > T1 || (abs(sgw_features(2,1)) + abs(sgw_features(2,3)) > T2) )
%                         is_edge = 1;
%                     else
%                         if( abs(sgw_features(2,2)) > T1 || abs(sgw_features(2,4)) > T1 || (abs(sgw_features(2,2)) + abs(sgw_features(2,4)) > T2) )
%                             is_edge = 1;
%                         end
%                     end
%                 end                
            end
            if(is_edge == 1)
                output_image(x,y) = max(sgw_features(:));
            end
            
        end
    end
end
figure('Name','Output Image','Numbertitle','off');
imshow(output_image);
end