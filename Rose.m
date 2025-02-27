function Rose
f = 500;
h = -250;
ax = gca;
ax.NextPlot = 'add';
ax.DataAspectRatio = [1,1,1];
ax.YDir = 'reverse';
ax.XColor = 'none';
ax.YColor = 'none';
function V = calc(a,b,c)
if c > 60 
 V.x=sin(a.*7).*(13+5./(.2+power(b.*4,4)))-sin(b).*50;
 V.y=b.*f+50;
 V.z=625+cos(a.*7).*(13+5./(.2+power(b.*4,4)))+b.*400;
 V.r=a-b./2;
 V.g=a;
else
    A=a.*2-1;
    B=b.*2-1;
    ind=A.*A+B.*B<1;
    a=a(ind);b=b(ind);
    A=A(ind);B=B(ind);
    if c > 37
        j = double(bitand(int32(c),1));
        n = double(j.*6+~j.*4);
        o = .5./(a+.01)+cos(b.*125).*3-a.*300;
        w = b.*h;
        V.x = o.*cos(n)+w.*sin(n)+j.*610-390;
        V.y = o.*sin(n)-w.*cos(n)+550-j.*350;
        V.z = 1180+cos(B+A).*99-j.*300;
        V.r = .4-a.*.1+power(1-B.*B,-h.*6).*.15-a.*b.*.4+cos(a+b)./5+...
            power(cos((o.*(a+1)+(B>0).*w-(B<=0).*w)./25),30).*.1.*(1-B.*B);
        V.g = o./1e3+.7-o.*w.*3e-6;
    elseif c > 32
    c = c.*1.16-.15;
    o = a.*45-20;
    w = b.*b.*h;
    V.z = o.*sin(c)+w.*cos(c)+620;
    V.x = o.*cos(c)-w.*sin(c);
    V.y = 28+cos(B.*.5).*99-b.*b.*b.*60-V.z./2-h;
    V.r = (b.*b.*.3+power((1-(A.*A)),7).*.15+.3).*b;
    V.g = b.*.7;
 else
    o = A.*(2-b).*(80-c.*2);
    w = 99-cos(A).*120-cos(b).*(-h-c.*4.9)+cos(power(1-b,7)).*50+c.*2;
    V.z = o.*sin(c)+w.*cos(c)+700;
    V.x = o.*cos(c)-w.*sin(c);
    V.y = B.*99-cos(power(b,7)).*50-c./3-V.z./1.35+450;
    V.r = (1-b./1.2).*.9+a.*.1;
    V.g = power((1-b),20)./4+.05;
    end
end
end
zBuffer = zeros(f,f);
for k = 1:25
    for i = 0:45
        V = calc(rand(1,5e3),rand(1,5e3),i./.74);
        z = round(V.z+0.5);
        x = int32(V.x.*f./z-h+0.5);
        y = int32(V.y.*f./z-h+0.5);
        ind2=y<f;
        x=x(ind2);y=y(ind2);z=z(ind2);
        V.r=V.r(ind2);V.g=V.g(ind2);
        zBufferIndex=y.*f+x;
        zBufferBool=(~zBuffer(zBufferIndex))|zBuffer(zBufferIndex)>z;
    zBuffer(zBufferIndex(zBufferBool))=z(zBufferBool);
    RGB=[bitcmp(int32(V.r.*h));
        bitcmp(int32(V.g.*h));
        bitcmp(int32(-V.r.*V.r.*80))].';
        RGB(RGB<0)=0;
        RGB(RGB>255)=255;
        RGB=double(RGB)./255;
        scatter(x(zBufferBool),y(zBufferBool),5,'filled',...
        'CData',RGB(zBufferBool,:),'MarkerEdgeColor','none',...
        'MarkerFaceAlpha',.7)
    end
    drawnow
end
end