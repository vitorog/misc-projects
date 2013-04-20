function eq_image = RGBHistogramEqualization(image)
L = 256;
try
info = imfinfo(image_path);
catch
    fprintf('Could not read image info!\n')
end
R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);
p = CalculateProbabilities(R,L);
s = CalculateOutputProbabilities(p,L);
r_ieq = EqualizeHistogram(R,s);
image_size = size(image);
m = image_size(1,1);
n = image_size(1,2);

p = CalculateProbabilities(G,L);
s = CalculateOutputProbabilities(p,L);
g_ieq = EqualizeHistogram(G,s);

p = CalculateProbabilities(B,L);
s = CalculateOutputProbabilities(p,L);
b_ieq = EqualizeHistogram(B,s);

eq_image = cat(3, r_ieq,g_ieq,b_ieq);
end