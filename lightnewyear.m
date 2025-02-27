axes(Color='k',DataA=[1,1,1])
hold
a=315;
b=(0:.01:pi)';
[x,y,z]=sphere(a-1);
v=(abs(sin(20*b))+3)/4;
v(1:60)=nan;
A=ones(a).*v.*cat(3,1,0,0).*sin(b);
B=ones(a,a,3).*cat(3,1,1,0);
surf(x.*v,y.*v,z,A);
surf(x/2,y/2,z/2,B); 
shading flat
r=@rand;
plot3(r(9)*5-3,r(9)*6+4,r(9)*6+1,'w.');
view([0,-35])
camva(2)
hold
a=315;
b=(0:.01:pi)';
[x,y,z]=sphere(a-1);
v=(abs(sin(20*b))+3)/4;
v(1:65)=nan;
A=ones(a).*v.^2.*cat(3,1,0,0).*sin(b).^2;
l=linspace(-1.6,2,15).^2;
for n=1:10
  s=2-n/8;
  surf(x.*v/s+n*2.8,y.*v/s,z/s+l(n)*3,A/s,EdgeA=0);
end
axis equal
view([78,-15]) 
set(gca,'color','k')
zlim([-60,63]);
camva(.25)