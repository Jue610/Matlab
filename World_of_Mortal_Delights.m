function World_of_Mortal_Delights(STR)

% 设置默认文字
if nargin<1
    STR={'这盛世','如你所愿','热烈庆祝','新中国成立75周年'};
end

% 加载烟花的声音数据
fwSound=load('splat.mat');

% 循环遍历输入的字符串数组，构建文段矩阵
% 获取当前字符串
for i = 1:length(STR)
    string = STR{i}; 
    % 初始化矩阵用于存储字符的像素信息
    CaptionMat = zeros(25 * length(string), 25);    
    % 循环遍历字符串中的每个字符
    for j = 1:length(string)
        % 调用 getWordMatrix 函数获取字符的像素矩阵，并填充 CaptionMat
        CaptionMat(25 * (j - 1) + 1:25 * j, :) = getWordMatrix(string(j));
    end

    % 使用 find 函数找到非零元素的位置
    [XMesh,YMesh]=find(CaptionMat~=0);
    sizeSTRM=size(CaptionMat);

    % 计算并存储字符的 X 和 Y 坐标
    STRMX{i}=(XMesh-sizeSTRM(1)/2)./12.5;
    STRMY{i}=(YMesh-sizeSTRM(2)/2)./12.5;
end

%  创建 GUI 窗口
fig=figure('units','normalized','position',[.1,.1,.5,.8],...
    'UserData','By Zhan Yijue.');
% 创建绘图区域
axes('parent',fig,'NextPlot','add','Color',[0,0,0],...
    'DataAspectRatio',[1,1,1],'XLim',[-100,100],'YLim',[0,220],'Position',[0,0,1,1]);
% 作者署名
disp(char(fig.UserData))

% 绘制一些静态装饰
if true
% 生成星星并绘制
starX=rand(1,50).*200-100;
starY=rand(1,50).*110+90;
% 大星星
scatter(starX,starY,50,'white','filled','MarkerEdgeColor','none','MarkerFaceAlpha',.1)
% 小星星
scatter(starX,starY,5,'white','filled','MarkerEdgeColor','none','MarkerFaceAlpha',.9)

% 绘制摩天大楼
for i=1:20
    skyscraper(5+i*10-110+2,rand([1,1])*20+30,[47,46,70]./255./4,[253,243,177]./255./4)
    skyscraper(5+i*10-110,rand([1,1])*25+15,[47,46,70]./255,[253,243,177]./255)
end
 end

% 使烟花效果在特定的迭代点出现
for i=length(STR)+1:99
    indSTRM=mod(i-1,length(STR)+2)+1;
    % 判断是否播放烟花
    if length(STR)+1==indSTRM||length(STR)+2==indSTRM
        drawFireworks()
    else
        drawWordMatrix(indSTRM)
    end
end

% 绘制摩天大楼的函数
    function skyscraper(X,Y,C1,C2)

        % 定义大楼宽度和高度
        W=4.6;H=50;

        % 绘制大楼主体
        fill([X-W,X+W,X+W,X-W],[Y,Y,Y+H,Y+H]-H,C1)

         % 绘制窗户，随机亮不同房间的窗户
        [XW,YW]=meshgrid([-1.9,1.9],linspace(.5,50-1.5,15));
        CMat=C2.*(rand([length(XW(:)),1])>.5);
        scatter(XW(:)+X,YW(:)+Y-H-1.5,35,'filled','CData',CMat,'Marker','s','MarkerEdgeColor','none')
    end

% 文字动态效果函数
    function drawWordMatrix(N)

        % 绘制子弹效果
        drawBullet(0,140,[1,1,1]);

        % 动态绘制文字
        wordHdl1=scatter(STRMX{N},STRMY{N}+140,15,'filled','CData',[1,1,1],'Marker','s','MarkerEdgeColor','none','MarkerFaceAlpha',.5);
        wordHdl2=scatter(STRMX{N},STRMY{N}+140,15,'filled','CData',[1,1,1],'Marker','s','MarkerEdgeColor','none');
        set(gca,'Color',[1,1,1]./8);

        % 文字动画
        for ii=linspace(2,30,30)
           wordHdl1.XData=STRMX{N}.*(ii-1);
           wordHdl1.YData=STRMY{N}.*(ii-1)+140;
           wordHdl2.XData=STRMX{N}.*ii;
           wordHdl2.YData=STRMY{N}.*ii+140;
           set(gca,'Color',[1,1,1]./8*(1-ii/30));
           drawnow;pause(.1)
        end
        delete(wordHdl1)
        delete(wordHdl2)
    end

    % 绘制子弹效果函数
    function drawBullet(X,Y,C)
        YY=linspace(0,-12,20);
        XX=sin(YY)./8;XX=XX-XX(1)+X;
        Alp=linspace(1,.01,20);
        Siz=linspace(45,8,20);
        bulletHdl=scatter(XX,YY,'filled','CData',C,'AlphaData',Alp,'SizeData',Siz,'MarkerFaceAlpha','flat');

        % 设置烟花炸开的声音
        sound(fwSound.y(1:7200),fwSound.Fs/1.2)
        for ii=linspace(0,Y,30)
            YY=linspace(0,-12,20)+ii;
            XX=sin(linspace(0,-12,20)+ii/2)./8;XX=XX-XX(1)+X;
            bulletHdl.XData=XX;
            bulletHdl.YData=YY;
            drawnow;pause(.06)
        end
        delete(bulletHdl)
        sound(fwSound.y(7201:10001),fwSound.Fs)
    end

    % 烟花效果函数
    function drawFireworks(~,~)
        % 初始化烟花发射图形
        YY=linspace(0,-12,20);
        XX=sin(YY)./8;XX=XX-XX(1);
        X=rand([3,1]).*200-100;
        Y=rand([3,1]).*80+90;
        C=rand(3,3)./2+.5;
        Alp=linspace(1,.01,20);
        Siz=linspace(45,8,20);

        % 创建3个烟花的图形
        bulletHdl1=scatter(XX+X(1),YY,'filled','CData',C(1,:),'AlphaData',Alp,'SizeData',Siz,'MarkerFaceAlpha','flat');
        bulletHdl2=scatter(XX+X(2),YY,'filled','CData',C(2,:),'AlphaData',Alp,'SizeData',Siz,'MarkerFaceAlpha','flat');
        bulletHdl3=scatter(XX+X(3),YY,'filled','CData',C(3,:),'AlphaData',Alp,'SizeData',Siz,'MarkerFaceAlpha','flat');

         % 播放烟花发射的声音
        sound(fwSound.y(1:7200),fwSound.Fs/1.2)

        % 动态更新烟花位置
        for ii=linspace(0,1,30)
            YY1=linspace(0,-12,20)+ii*Y(1);XX1=sin(linspace(0,-12,20)+ii*Y(1)/2)./8;XX1=XX1-XX1(1)+X(1);
            YY2=linspace(0,-12,20)+ii*Y(2);XX2=sin(linspace(0,-12,20)+ii*Y(2)/2)./8;XX2=XX2-XX2(1)+X(2);
            YY3=linspace(0,-12,20)+ii*Y(3);XX3=sin(linspace(0,-12,20)+ii*Y(3)/2)./8;XX3=XX3-XX3(1)+X(3);
            bulletHdl1.XData=XX1;bulletHdl1.YData=YY1;
            bulletHdl2.XData=XX2;bulletHdl2.YData=YY2;
            bulletHdl3.XData=XX3;bulletHdl3.YData=YY3;
            drawnow;pause(.05)
        end
        delete(bulletHdl1);delete(bulletHdl2);delete(bulletHdl3)
        sound(fwSound.y(7201:10001),fwSound.Fs)

         % 生成烟花的散点
        T = rand([1, 300]) * 2 * pi; % 随机生成角度
        R = rand([1, 300]) * 1 + 1; % 随机生成半径
        XF = cos(T) .* R; YF = sin(T) .* R; % 极坐标转直角坐标
        K = linspace(1, 2, 10)'; % 爆炸范围
        Alp = linspace(.01, .1, 10)' .* ones(1, 100); Alp = Alp(:); % 透明度渐变
        Siz = linspace(4, 40, 10)' .* ones(1, 100); Siz = Siz(:); % 粒子大小渐变
        R2 = (XF .* K).^2 + (YF .* K).^2; % 粒子爆炸范围
        % 粒子位置
        XXF=XF.*K;
        YYF=YF.*K-R2./90;
        XXF1=XXF(:,1:100);XXF1=XXF1(:);YYF1=YYF(:,1:100);YYF1=YYF1(:);
        XXF2=XXF(:,101:200);XXF2=XXF2(:);YYF2=YYF(:,101:200);YYF2=YYF2(:);
        XXF3=XXF(:,201:300);XXF3=XXF3(:);YYF3=YYF(:,201:300);YYF3=YYF3(:);

        % 创建3个烟花爆炸的图形
        fireworksHdl1=scatter(XXF1+X(1),YYF1+Y(1),'filled','CData',C(1,:),'AlphaData',Alp,'SizeData',Siz,'MarkerFaceAlpha','flat');
        fireworksHdl2=scatter(XXF2+X(2),YYF2+Y(2),'filled','CData',C(2,:),'AlphaData',Alp,'SizeData',Siz,'MarkerFaceAlpha','flat');
        fireworksHdl3=scatter(XXF3+X(3),YYF3+Y(3),'filled','CData',C(3,:),'AlphaData',Alp,'SizeData',Siz,'MarkerFaceAlpha','flat');

        set(gca,'Color',(C(1,:)+C(1,:)+C(1,:))./30);

        % 动态更新烟花点
        for ii=linspace(1,20,30)
            XXF(1:end-1,:)=XXF(2:end,:);
            XXF(end,:)=XF.*ii;
            R2=(XF.*ii).^2+(YF.*ii).^2;
            YYF(1:end-1,:)=YYF(2:end,:);
            YYF(end,:)=YF*ii-R2./90;
            XXF1=XXF(:,1:100);XXF1=XXF1(:);
            YYF1=YYF(:,1:100);YYF1=YYF1(:);
            XXF2=XXF(:,101:200);XXF2=XXF2(:);
            YYF2=YYF(:,101:200);YYF2=YYF2(:);
            XXF3=XXF(:,201:300);XXF3=XXF3(:);
            YYF3=YYF(:,201:300);YYF3=YYF3(:);
            % 更新烟花爆炸图形
            fireworksHdl1.XData=XXF1+X(1);fireworksHdl1.YData=YYF1+Y(1);
            fireworksHdl2.XData=XXF2+X(2);fireworksHdl2.YData=YYF2+Y(2);
            fireworksHdl3.XData=XXF3+X(3);fireworksHdl3.YData=YYF3+Y(3);
            set(gca,'Color',(C(1,:)+C(1,:)+C(1,:))./30*(1-ii/20));
            drawnow;pause(.02)
        end
        delete(fireworksHdl1);delete(fireworksHdl2);delete(fireworksHdl3)
    end

    % 将输入的字符CHAR转换为像素矩阵
    function wordMatrix=getWordMatrix(CHAR)
        
        % 创建一个160x160像素的图像
        figGWM=figure('units','pixels','position',[20 20 160 160],...
            'Numbertitle','off','Color',[1 1 1],'resize','off',...
            'visible','off','menubar','none');
        axGWM=axes('Units','pixels','parent',figGWM,'Color',[1 1 1],...
            'Position',[0 0 160 160],'XLim',[0 16],'YLim',[0 16],...
            'XColor',[1 1 1],'YColor',[1 1 1],'NextPlot','add');

        % 在图像中央绘制字符，字体大小为120
        text(axGWM,8,8.5,CHAR,'HorizontalAlignment','center','FontSize',120)

        % 保存并读取图像
        saveas(figGWM,['.\',CHAR,'.png']);pic=imread(['.\',CHAR,'.png']);

        % 清理临时文件和图像窗口
        delete(['.\',CHAR,'.png']);delete(axGWM);set(figGWM,'Visible','on');
        close all

        % 获取图片大小
        [rowMax,colMax,~] = size(pic);

        % 将像素小于125的标记为1
        picData = pic(:,:,1) < 125;

        % 初始化wordMatrix
        wordMatrix = zeros(25,25);

        % 根据25x25的矩阵计算像素值
        for ii=1:25
            rowLim=round([ii-1,ii]./25.*rowMax);
            rowLim(rowLim==0)=1;
            for jj=1:25
                colLim=round([jj-1,jj]./25.*colMax);
                colLim(colLim==0)=1;
                wordMatrix(ii,jj)=sum(sum(picData(rowLim(1):rowLim(2),colLim(1):colLim(2))));
            end
        end
        wordMatrix(wordMatrix<10)=0;
        wordMatrix=wordMatrix';
        wordMatrix=wordMatrix(:,end:-1:1);
    end
end