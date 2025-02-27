function  roseBouquet_M()
%  @author  :  slandarer

%  生成花朵数据
[xr,tr]=meshgrid((0:24)./24,(0:0.5:575)./575.*20.*pi+4*pi);
p=(pi/2)*exp(-tr./(8*pi));
ur=1-(1-mod(3.6*tr,2*pi)./pi).^4./2+sin(15*tr)/150;
yr=2*(xr.^2-xr).^2.*sin(p);
rr=ur.*(xr.*sin(p)+yr.*cos(p));
hr=ur.*(xr.*cos(p)-yr.*sin(p));

tb=linspace(0,2,151);
rb=(0:.01:1)'*((abs((1-mod(tb*5,2))))/2+.3)./2.5;
xb=rb.*cos(tb*pi);
yb=rb.*sin(tb*pi);
hb=(-cos(rb*1.2*pi)+1).^.2;

%  配色数据
cL=[.33  .33  .69;.68  .42  .63;.78  .42  .57;.96  .73  .44];
%  cL=[.02  .04  .39;.02  .06  .69;.01  .26  .99;.17  .69  1];
cMr=sH(hr,cL);
cMb=sH(hb,cL.*.4+.6);
%  旋转矩阵生成
yz=72*pi/180;
Rz=@(n)[cos(yz/n),-sin(yz/n),0;sin(yz/n),cos(yz/n),0;0,0,1];
Rx=@(n)[1,0,0;0,cos(n),-sin(n);0,sin(n),cos(n)];
Rz1=Rz(1);Rz2=Rz(2);Rz3=Rz(3);
Rx1=Rx(pi/8);Rx2=Rx(pi/9);
%  图形绘制
hold  on
cp={'EdgeAlpha',0.05,'EdgeColor','none','FaceColor','interp','CData',cMr};
surface(rr.*cos(tr),rr.*sin(tr),hr+0.35,cp{:})
[U,V,W]=rT(rr.*cos(tr),rr.*sin(tr),hr+0.35,Rx1);
V=V-.4;
for  k=1:5
        [U,V,W]=rT(U,V,W,Rz1);
        surface(U,V,W-.1,cp{:})
        dS(U,V,W-.1)
end
[u1,v1,w1]=rT(xb,yb,hb./2.5+.32,Rx2);
v1=v1-1.35;
[u2,v2,w2]=rT(u1,v1,w1,Rz2);
[u3,v3,w3]=rT(u1,v1,w1,Rz3);
[u4,v4,w4]=rT(u3,v3,w3,Rz3);
U={u1,u2,u3,u4};
V={v1,v2,v3,v4};
W={w1,w2,w3,w4};
for  k=1:5
        for  b=1:4
                [ut,vt,wt]=rT(U{b},V{b},W{b},Rz1);
                U{b}=ut;V{b}=vt;W{b}=wt;
                surface(U{b},V{b},W{b},cp{3:7},cMb)
                dS(U{b},V{b},W{b})
        end
end
a=gca;axis  off
a.Position=[0,0,1,1]+[-1,-1,2,2]./6;
axis  equal
view(2,35);
        %  配色插值函数
        function  c=sH(H,cL)
                X=rescale(H,0,1);
                x=rescale(1:size(cL,1),0,1);
                c=interp1(x,cL,X);
        end
        %  旋转矩阵应用至数据点
        function  [U,V,W]=rT(X,Y,Z,R)
                U=X;V=Y;W=Z;
                for  i=1:numel(X)
                        v=[X(i);Y(i);Z(i)];
                        n=R*v;U(i)=n(1);V(i)=n(2);W(i)=n(3);
                end
        end
        %  贝塞尔函数插值生成花杆并绘制
        function  dS(X,Y,Z)
                [m,n]=find(Z==min(min(Z)));m=m(1);n=n(1);
                x1=X(m,n);y1=Y(m,n);z1=Z(m,n)+.03;
                x=[x1,0,(x1.*cos(pi/3)-y1.*sin(pi/3))./3].';
                y=[y1,0,(y1.*cos(pi/3)+x1.*sin(pi/3))./3].';
                z=[z1,-.7,-1.5].';
                P=[x,y,z];
                t=(1:50)/50;
                q=size(P,1)-1;
                c1=factorial(q)./factorial(0:q)./factorial(q:-1:0);
                c2=((t).^((0:q)')).*((1-t).^((q:-1:0)'));
                P=(P'*(c1'.*c2))';
                plot3(P(:,1),P(:,2),P(:,3),'Color',[88,130,126]./255,'LineWidth',1)
        end
end