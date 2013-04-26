function SimplifiedGaborFilter()
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
        theta = 0 + ((j-1)*pi)/4;
        s = (1 / w) * 0.5;
        S = GenerateGaborKernel(5,5,w,s,theta);
        Ss = imresize(S,[256,256]);
        figure(i*j);
        imshow(Ss);       
    end
end
end