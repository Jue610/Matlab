% 清除当前绘图窗口、变量和关闭所有图形窗口
clc; 
clear; 
close all;

% 随机数生成
rng(16)

% 创建窗口，设置坐标
a = 200;
figure('Units','normalized', 'Position',[.3,.1,.6,.75], 'Color', hsv2rgb([215 100 18]./[360,100,100]));
ax = gca; % 获取当前坐标轴
ax.NextPlot = 'add'; % 设置绘图模式为添加
ax.DataAspectRatio = [1,1,a]; % 设置数据比例以保持z轴与x,y轴的比例
ax.Position = [-1/6, -1/4, 1 + 1/3, 1 + 1/2]; % 设置坐标轴位置

% 加载月亮表面数据
load moonsurface.mat

% 生成用于地形高度缩放的矩阵
b = (.5:a)'/a;
c = (-cos(b*2*pi) + 1).^.2;
d = ones(a);
f = b - .5;
r = f'.^2 + f.^2;

% 计算山地高度
m = 50;
H = abs(ifftn(exp(7i*rand(a))./r.^.9)).*(c*c')*30;
l = (m:-1:1)/m;

% 画出山脉
hold on
for n = 1:m
    surf(b,b', d*n, d + cat(3,1,1,1), 'EdgeA',0, 'FaceA',max(.2,l(n))./m.^1.2);
end
zlim([-a/2, 1.2*a])
shading flat

% 地形颜色映射
CList = [144,157,205; 7,17,27]./255;
LM = [min(min(H)),max(max(H))];
CM1(:,:,1) = interp1(LM, CList(:,1), H, 'pchip');
CM1(:,:,2) = interp1(LM, CList(:,2), H, 'pchip');
CM1(:,:,3) = interp1(LM, CList(:,3), H, 'pchip');
surf(b,b', H, 'CData', CM1, 'EdgeColor','none')

% 画月
[X,Y,Z0]=sphere(30);
surf(X./20 + .8, Y./20 + .6, Z0.*a./20 + .7.*a,'FaceColor','texturemap',...
    'CData',moonalb20c,'EdgeColor','none','FaceAlpha',.5)
CM2 = gray;
CM2 = CM2(120:end,:).*[253,252,222]./255.*1.2;
CM2(CM2 > 1) = 1;
colormap(CM2)

% 添加主题文字
text(0.5, 0.5, '风雨同舟，砥砺前行。', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
   'FontSize', 16, 'FontWeight', 'bold', 'Color', 'white', 'Units', 'normalized');
text(0.525, 0.475, '————庆祝新中国成立75周年！', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
   'FontSize', 16, 'FontWeight', 'bold', 'Color', 'white', 'Units', 'normalized');

% 关闭坐标轴显示
axis off

% 相机视图视野
camva(5); view(35, 35);

% 循环改变视角
for i = 1:5000
    view(35 + i./5, 35); pause(.01)
end