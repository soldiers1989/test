function [cost,margin]=ArbitrageCostMargin(option1,option2)%option1Ϊ�Ϲ���option2Ϊ�Ϲ�;
w=windmatlab;
Tem=w.wss(option1,'lasttradingdate,exe_price');
future=['IH',datestr(Tem(1),'yymm'),'.cfe'];
data=w.wsq([option1,',',option2,',',future],'rt_latest');
arbitrageP=(Tem{2}+data(1)-data(2))*300000-data(3)*300;
cost1=-abs(arbitrageP)+876+data(3)*151.8/10000;
cost2=-abs(arbitrageP)+876+data(3)*6072/10000;
cost=[cost1,cost2];
display('������ϼ۸�ת��Ϊ����ʱΪ��ֵ����ӯ�����㹫ʽΪ��ƽ��ʱ������ϼ۸�-����ʱ������ϼ۸�');
display(['���ǵ���ƽ�֣���������ϳɱ��۸�',num2str(cost1),';','���򣬳ɱ��۸�',num2str(cost2)]);
if arbitrageP >0
    margin=data(3)*300*0.21+w.wss(option1,'maint_margin')*30; 
else
    margin=data(3)*300*0.21+w.wss(option2,'maint_margin')*30;
end
display(['���������֤��Ϊ��',num2str(margin)]);
end