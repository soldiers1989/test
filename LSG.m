function LSG(stock)
w=windmatlab;
data=w.wsd(stock,'open,close,high,low','ED-1000TD',today-1,'Fill=Previous','PriceAdj=F');
open=data(:,1);
close=data(:,2);
high=data(:,3);
low=data(:,4);
L=length(open);
upline=zeros(1,L);
downline=zeros(1,L);
atr=zeros(1,L);
ema3=zeros(1,L);
ema25=zeros(1,L);
for i=31:L %��ȡ���ߣ����ߣ�atr����ֵ,emaֵ
    upline(i)=max(high(i-6:i));
    downline(i)=min(low(i-6:i));
    atr0=zeros(1,9);
    for j=0:8
        atr1=high(i-j)-low(i-j);
        atr2=abs(close(i-j-1)-high(i-j));
        atr3=abs(close(i-j)-low(i-j));
        atr0(j+1)=max([atr1,atr2,atr3]);
    end 
    atr(i)=mean(atr0);
    ema3(i)=mean(close(i-2:i));
    ema25(i)=mean(close(i-24:i));
end
Popen=0; %���ּ۸�
Pstop=0; %ֹ��۸�
Return=zeros(1,L-25);
for i=31:L %��ʼ�ز�
    if Popen==0 && ema3(i)>ema25(i) && high(i)>upline(i-1) %���㿪������
        Popen=upline(i)+0.01;     
        Pstop=upline(i)-2.5*atr(i);
    end
    if Popen~=0 
        if low(i)<Pstop % �˴�ֹ���������Ӧ�üӼ���ֹӯ����������
            returnTem=(Pstop-Popen)/Popen;
            Return(i)=returnTem;
            Pstop=0;
            Popen=0;
        else 
            returnTem=(close(i)-Popen)/Popen;
            Return(i)=returnTem;
        end
    end
    if Popen==0 && Return(i-1)~=0
        Return(i)=Return(i-1);
    end   
end

plot(Return); %�����ʽ�����

end