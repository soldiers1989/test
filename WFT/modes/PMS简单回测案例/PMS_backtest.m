%ע��:ʹ��ʱ���뽫����ĩβ����Owner=w0814497�޸ĳ��Լ����˺ţ�����w.wupf����ʹ�õ�������Ƹĳ��Լ���PMSϵͳ�д������������
%������ĩβ�� w.wupf('pmsbacktest',test_date,select_list,volume_list,price_list,'Owner=w0814497;Direction=Long;HedgeType=Spec;')

%����API�ӿ�
w=windmatlab;
% ��ȡȫ��A��
wset_temp=w.wset('SectorConstituent','date=20150601;sectorId=a001010100000000') ;
stockList=wset_temp(:,2)
%��ȡ���ֵ���������
[w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays('2015-02-01','2015-12-24','Period=M')

%�ز���ԣ�����������ѭ������ÿһ�����ڽ���ѡ��
for i=1: length(w_tdays_data)
    disp(w_tdays_data(i))
    %��ȡ��ǰ��������
    test_date=datestr(w_tdays_data(i),'yyyymmdd');
    [date_temp,~,~,~,w_tdays_errorid,~]=w.tdaysoffset(-1,w_tdays_data(i));
    pre_date=datestr(date_temp,'yyyymmdd');
    disp(pre_date)
    %���Բ��֣��˴���һ���򵥲���Ϊ��
    %�ò���ѡ��ǰһ����ͣ�����ֵ��տ���Ϊ��ͣ�����ڵ��������������Ĺ�Ʊ����������Ʊ�����е���һ�ε���
    [w_wss_data1,~,~,~,w_wss_errorid1,~]=w.wss(stockList,'pct_chg','tradeDate',pre_date,'cycle=D');
    [w_wss_data2,~,~,~,w_wss_errorid2,~]=w.wss(stockList,'swing,vwap','tradeDate',test_date,'cycle=D');
    
    select_list={}; %���ѡ���Ĺ�Ʊ
    price_list={}; %��Ŷ�Ӧ�ĳɽ�����
    volume_list={}; %��Ŷ�Ӧ�ĳֹ�����
    for j=1: length(stockList)
        % ������ǰһ���ǵ�������9.9%���ж�Ϊ��ͣ�������յ��������1%���ж�Ϊ���������. ��������������20ֻ��Ʊ
        if(~isempty(w_wss_data1(j)) && ~isempty(w_wss_data2(j,1)))
            if(w_wss_data1(j)>9.9) && (w_wss_data2(j,1)>1.0)
                if(length(select_list)>=20)
                    %����Ѿ�ѡ��20ֻ��Ʊ�ˣ���ô�ò��ټ���ѡ��
                    break;
                end
                select_list(length(select_list)+1)=stockList(j);
                price_list(length(price_list)+1)={w_wss_data2(j,2)};
                volume_list(length(volume_list)+1)={1000};
            end
        end
    end
    %ͨ��wupf�����ϴ��ε������ڵĳֲ�
    %ע�����ڸ�ʽ����ת��������20151224���ָ�ʽ
    if(~isempty(select_list))
        w.wupf('pmsbacktest',test_date,select_list,volume_list,price_list,'Owner=w0814497;Direction=Long;HedgeType=Spec;')
    end
end



