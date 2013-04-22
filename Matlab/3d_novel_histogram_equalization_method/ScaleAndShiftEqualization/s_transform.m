function r = s_transform(d1,d2,m,n,x)
if(x<=m)
    f1 = double(x-d1);
    f2 = double(m-d1);
    f3 = double(f1/f2);
    f4 = f3^n;
    r = double(d1 + ((m - d1))*f4);
else
    f1 = double(d2-x);
    f2 = double(d2-m);
    f3 = double(f1/f2);
    f4 = f3^n;
    r = double(d2 - ((d2 - m))*f4);
    
end
end