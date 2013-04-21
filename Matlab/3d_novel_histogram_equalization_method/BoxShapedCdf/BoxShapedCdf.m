function BoxShapedCdf(image_path)
orig_img = imread(image_path);
img_size = size(orig_img);
width = img_size(1,1);
height = img_size(1,2);
orig_img_pdf = Calculate3dPdf(orig_img);
orig_img_pdf(224,129,105)

%file_id = fopen('pdf.txt','w');
%fprintf(file_id,'%f',orig_img_pdf);
% orig_img_cdf = Calculate3dCdf(orig_img_pdf);
% output_img = orig_img;
% L = 256;
% figure(1)
% imshow(orig_img);
% orig_img_pdf(224,129,105)
% orig_img_cdf(224,129,105)
% for i=1:width
%     for j=1:height
%         red = orig_img(i,j,1);
%         green = orig_img(i,j,2);
%         blue = orig_img(i,j,3);
%         cin_rgb = orig_img_cdf(red,green,blue);       
%         P = double((double(red + 1)*double(green + 1)*double(blue + 1)))/double(L^3);     
%         if(P~=cin_rgb)            
%             counter = 0;
%             if(cin_rgb > P)            
%                 while(P < cin_rgb)                     
%                     if(counter == 0)
%                         red = red + 1;
%                     end
%                     if(counter == 1)
%                         green = green + 1;
%                     end
%                     if(counter == 2)
%                         blue = blue + 1;
%                     end
%                     counter = counter +1;
%                     if(counter > 2)
%                         counter = 0;
%                     end                    
%                     P = double((double(red + 1)*double(green + 1)*double(blue + 1)))/double(L^3);   
%                     if(red == 255 && green == 255 && blue == 255)
%                         break;
%                     end
%                 end            
%                 output_red = red;
%                 output_green = green;
%                 output_blue = blue;
%             else              
%                 while(P > cin_rgb)                     
%                     if(counter == 0)
%                         red = red - 1;
%                     end
%                     if(counter == 1)
%                         green = green - 1;
%                     end
%                     if(counter == 2)
%                         blue = blue - 1;
%                     end
%                     counter = counter + 1;
%                     if(counter > 2)
%                         counter = 0;
%                     end                    
%                     P = double((double(red + 1)*double(green + 1)*double(blue + 1)))/double(L^3);
%                     if(red == 0 && green == 0 && blue == 0)
%                         break;
%                     end
%                 end               
%                 output_red = red;
%                 output_green = green;
%                 output_blue = blue;
%             end           
%         else
%             output_red = red;
%             output_green = green;
%             output_blue = blue;
%         end      
%         output_img(i,j,1) = output_red;
%         output_img(i,j,2) = output_green;
%         output_img(i,j,3) = output_blue;
%     end
% end
% figure(2);
% imshow(output_img);
end