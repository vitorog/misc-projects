function RGBIndependentEqualization(image_path)
image = imread(image_path);
R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);
pdf = CalculateChannelPdf(R);
cdf = CalculateChannelCdf(pdf);
r_ieq = EqualizeChannelHistogram(R,cdf);

pdf = CalculateChannelPdf(G);
cdf = CalculateChannelCdf(pdf);
g_ieq = EqualizeChannelHistogram(G,cdf);

pdf = CalculateChannelPdf(B);
cdf = CalculateChannelCdf(pdf);
b_ieq = EqualizeChannelHistogram(B,cdf);

output_image = cat(3, r_ieq,g_ieq,b_ieq);
figure('Name','RGB Independent Equalization', 'NumberTitle', 'off');
imshow(output_image);
addpath('../IsoLuminance');
output_luminance_pdf = CalculateLuminancePdf(output_image,'RGB Independent PDF');
CalculateLuminanceCdf(output_luminance_pdf, 'RGB Independent CDF');
end