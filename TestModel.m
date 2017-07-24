function TestModel
tic;
sw1=0;%get data from model;
sw2=1;randArray=0; %sort for results according to data analysis and different days;

transferM_M='E:\Trade\R_Matrix';     % transfer between matlab;
transferM_P='E:\Trade\Matlab_Python'; % transfer between matlab and python;
%% get data from model;
if sw1
    global high low close open vol;
    try
        load allStocks1;
        load allStocks2;
        load allStocks3;
    catch
        w=windmatlab;
        dataTem=w.wset('sectorconstituent','a001010100000000');
        stocks=dataTem(:,2);
        Lt=length(stocks);
        Date=w.tdays('ED-3000TD',today-1);
        opens=[];
        closes=[];
        highs=[];
        lows=[];
        vols=[];
        turns=[];
        for i=1:400:Lt
            if i+399<=Lt
                iend=i+399;
            else
                iend=Lt;
            end
            while 1
                openT=w.wsd(stocks(i:iend),'open','ED-3000TD',today-1,'Fill=Previous','PriceAdj=F');
                if length(openT)>1
                    break;
                end
            end
            while 1
                closeT=w.wsd(stocks(i:iend),'close','ED-3000TD',today-1,'Fill=Previous','PriceAdj=F');
                if length(closeT)>1
                    break;
                end
            end
            while 1
                highT=w.wsd(stocks(i:iend),'high','ED-3000TD',today-1,'Fill=Previous','PriceAdj=F');
                if length(highT)>1
                    break;
                end
            end
            while 1
                lowT=w.wsd(stocks(i:iend),'low','ED-3000TD',today-1,'Fill=Previous','PriceAdj=F');
                if length(lowT)>1
                    break;
                end
            end
            while 1
                volT=w.wsd(stocks(i:iend),'volume','ED-3000TD',today-1,'Fill=Previous','PriceAdj=F');
                if length(volT)>1
                    break;
                end
            end     
            while 1
                turnT=w.wsd(stocks(i:iend),'free_turn','ED-3000TD',today-1,'Fill=Previous','PriceAdj=F');
                if length(turnT)>1
                    break;
                end
            end  
            opens=[opens,openT];
            closes=[closes,closeT];
            highs=[highs,highT];
            lows=[lows,lowT];
            vols=[vols,volT];
            turns=[turns,turnT];
        end    
        save allStocks1 stocks Date opens closes;
        save allStocks2 highs lows;
        save allStocks3 vols turns;
    end
    Lstocks=size(opens,2);
    Rall=zeros(2000000,5);
    dateAll=cell(2000000,1);
    Matrix=zeros(2000000,21); % for indicators
    iRall=0;
    Radd=[];
    DaysAdd=0;

    iStart=1;
    iEnd=Lstocks;%1980
    % iStart=100; % draw picture;
    % iEnd=500;
    keyTest=0;

    if iEnd-iStart<50
        fig=1;
    else
        fig=0;
    end
    listCorr=[];
    for i=iStart:iEnd
    % for i=1:1
    %     w=windmatlab;
    %     endStr=datestr(today-1,'yyyymmdd');
    %     [dataTem,~,~,Date]=w.wsi('zn.shf','open,close,high,low,volume','20140101 09:00:00',[endStr,'15:01:00'],...
    %         'periodstart=09:00:00;periodend=15:01:00;Fill=Previous;PriceAdj=F','BarSize=15');
    %     opens=dataTem(:,1);
    %     closes=dataTem(:,2);
    %     highs=dataTem(:,3);
    %     lows=dataTem(:,4);    
    %     vols=dataTem(:,5);
    % %     if i>1329
    % %         continue;
    % %     end
        open=opens(:,i);
        close=closes(:,i);
        high=highs(:,i);
        low=lows(:,i);
        vol=vols(:,i);   
        turn=turns(:,i);
        datei=Date;
        indTem=~isnan(open);
        open=open(indTem);
        close=close(indTem);
        high=high(indTem);
        low=low(indTem);
        vol=vol(indTem);
        turn=turn(indTem);
        datei=datei(indTem);

        L=length(high);
        indTarget=[];
        Target=[];
        Ri=[];
        indAdd={};
        Add={};

        maN=zeros(L,1);
        ma10=zeros(L,1);
        for ii=11:L
            maN(ii)=mean(close(ii-3:ii));
            ma10(ii)=mean(close(ii-10:ii));        
        end

        for ii=15:L-5
            if close(ii-1)<low(ii-1)+(high(ii-1)-low(ii-1))*0.25 &&close(ii)/close(ii-1)<1.095&&high(ii)>low(ii)...%&&close(ii)>low(ii)+(high(ii)-low(ii))*0.1
                    &&close(ii)>low(ii)+(high(ii)-low(ii))*0.5                   
                iRall=iRall+1;
                Rall(iRall,:)=[close(ii+1)/close(ii),close(ii+2)/close(ii),close(ii+3)/close(ii),close(ii+2)/close(ii+1),close(ii+3)/close(ii+1)]-1;
                dateAll(iRall)=datei(ii);   
                Matrix(iRall,:)=[ high(ii)/high(ii-1),high(ii)/open(ii-1),high(ii)/low(ii-1),high(ii)/close(ii-1),...
                               low(ii)/high(ii-1),low(ii)/open(ii-1),low(ii)/low(ii-1),low(ii)/close(ii-1),...
                               open(ii)/high(ii-1),open(ii)/open(ii-1),open(ii)/low(ii-1),open(ii)/close(ii-1),...
                               close(ii)/high(ii-1),close(ii)/open(ii-1),close(ii)/low(ii-1),close(ii)/close(ii-1),...
                               mean(close(ii-4:ii+1))/mean(close(ii-9:ii+1)),mean(high(ii-4:ii+1))/mean(high(ii-9:ii+1)),...
                               std(close(ii-4:ii+1))/std(close(ii-9:ii+1)),std(high(ii-4:ii+1))/std(high(ii-9:ii+1)),...
                               std([ close(ii),open(ii),high(ii),low(ii) ])/std([close(ii-1),open(ii-1),high(ii-1),low(ii-1)]) ];  
            end
        end
    end
    Rall=Rall(1:iRall,:);
    dateAll=dateAll(1:iRall);
    Matrix=Matrix(1:iRall,:);
    save(transferM_M,'Rall','dateAll','Matrix');
%     dlmwrite('D:\Trading\hmmMatlabIn.txt',MatrixSpring,'delimiter',',','precision','%.5f','newline','pc');
%     msgbox('Needed data is prepared now,please run ''D:\Trading\Python\machinelearning\hmmSpring.py'' to train model and select good type CTA!');
%     figure;
%     statisticTrading(RTem);
%% show results according to different days;
elseif sw2
    tem=load(transferM_M);
    Rall=tem.Rall;
    dateAll=tem.dateAll;
    Matrix=tem.Matrix;
    if randArray
        tem=randperm(length(dateAll));
        Rall=Rall(tem,:);
        dateAll=dateAll(tem);
        Matrix=Matrix(tem,:);
    end
    Nsort=6;Nfit=100;
    Lt=size(Matrix,2);
    
%     Rall=Rall(1:20000,1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Matrix=Matrix(1:20000,:);
    
    for i=1:2%Lt
        i
        Matx=Matrix(:,i);
        save(transferM_P,'Matx');
%         system(['python D:\Trade\Python\machinelearning\TestModel.py ',num2str(Nsort),' ',num2str(Nfit)]);
        system(['python D:\JuXin-master\Python\machinelearning\TestModel.py ',num2str(Nsort),' ',num2str(Nfit)]);
        flag=load(transferM_P);
        flag=flag.flag;
        item=mod(i,3);
        if item==1
            figure;
            set(gcf,'position',[20,50,1300,600]);
        elseif item==0
            item=3;
        end
        subplot(1,3,item);
        hold on;
        flagUnique=unique(flag);
        Lt2=length(flagUnique);
        Lines=[];
        Leges={};      
        for i2=1:Lt2
            tem=flag==flagUnique(i2);
            RallTem=Rall(tem,1);
            [Line,Lege]=statisticTrading(RallTem);
            Lines=[Lines,Line];
            Leges=[Leges,Lege];
        end
        legend(Lines,Leges,'location','northoutside','orientation','vertical');
        hold off;
        toc;
    end
    toc;
    return;
    
    
    

    figure;
    set(gcf,'position',[50,100,1800,900]);
    weekDays=weekday(dateAll);
    months=month(dateAll);
    monthDays=day(dateAll);

    Lt=length(Rall);
    R=Rall;
    Rtem=[];
    for i=1:Lt
        if ismember(weekDays(i),[2,3,4])  && (ismember(monthDays(i),[10,16,17,25,30]) && ismember(months(i),[6,9]))
            R(i)=-2;
            Rtem=[Rtem,Rall(i)];
        end
    end   
    fprintf(2,'orders:%d;IR:%.4f;winRatio:%.2f%%;profitP:%.2f%%\n',length(Rtem),mean(Rtem)/std(Rtem),sum(Rtem>0)*100/length(Rtem),mean(Rtem)*100);    
    R=R(R>-1);
    if ~isempty(R)
        statisticTrading(R);
        xlabel('Rall Selected');
    end
    
    figure;
    set(gcf,'position',[50,100,1800,900]);
    for i=1:6 % Rall and Rweekday;
        subplot(2,3,i);
        if i==1
            R=Rall;  
            R=R(indTem);
        else
            indTem=weekDays==i;
            R=Rall(indTem);
        end
        if ~isempty(R)
            statisticTrading(R);
            if i==1
                xlabel('Rall Test');
            else
                xlabel(['week day: ',num2str(i-1)]);
            end
        else
            toc;
            return;
        end
    end
    for i=1:12 % Rmonth;
        iMod=mod(i,6);
        if iMod==1
            figure;
            set(gcf,'position',[50,100,1800,900]);
        elseif iMod==0
            iMod=6;
        end
        subplot(2,3,iMod);
        indTem=months==i;
        R=Rall(indTem); 
        if ~isempty(R)
            statisticTrading(R);
            xlabel(['month: ',num2str(i)]);
        end
    end
    for i=1:31 % Rmonthday;    
        iMod=mod(i,6);
        if iMod==1
            figure;
            set(gcf,'position',[50,100,1800,900]);
        elseif iMod==0
            iMod=6;
        end
        subplot(2,3,iMod);
        indTem=monthDays==i;
        R=Rall(indTem);
        if ~isempty(R)
            statisticTrading(R);
            xlabel(['monthday: ',num2str(i)]);
        end
    end
end

% if ~isempty(Radd)
%     statisticTrading(Radd,DaysAdd);
% end
toc;
end

function [Line,Lege]=statisticTrading(R)
Lt=length(R);
IR=mean(R)/std(R);
winRatio=sum(R>0)/Lt;
ratioWL=-mean(R(R>0))/mean(R(R<0));
R=cumsum(R);
maxDraw=0;
indDraw=1;
pointDraw=0;
for i=2:Lt
    drawTem=max(R(1:i))-R(i);
    if drawTem>maxDraw
        maxDraw=drawTem;
        indDraw=i;
        pointDraw=R(i);
    end
end
Line=plot(R);
try
    plot(indDraw,pointDraw,'r*');
end
Lege=sprintf('Orders:%d; IR:%.4f; winRatio(ratioWL):%.2f%%(%.2f);\nmaxDraw:%.2f%%; profitP: %.4f%%'...
    ,Lt,IR,winRatio*100,ratioWL,maxDraw*100,R(end)*100/length(R));
grid on;
end


