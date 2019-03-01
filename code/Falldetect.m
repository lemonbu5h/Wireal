function [ state,l,r ] = Falldetect( X,template,t )
    load('X0.mat');
    X = [X0;X];

    Wp = 1/(fs/2); %通带截止频率,这个自定大致定义
    Ws = 15/(fs/2);%阻带截止频率,这个自定大致定义
    Rp = 2; %通带内的衰减不超过Rp,这个自定大致定义
    Rs = 40;%阻带内的衰减不小于Rs，这个自定大致定义
    [n,Wn] = buttord(Wp,Ws,Rp,Rs);%巴特沃斯数字滤波器最小阶数选择函数
    [b,a] = butter(n,Wn);%巴特沃斯数字滤波器
    
    s = zeros(3,length(X(1,1,:)));
    for i=1:3
        for j=1:30
            s(i,:) = s(i,:) + filtfilt(b,a,X(i,j,:))/30;
        end
    end
    e0 = 100000000000000000;
    for i=1:length(X(1,1,:))-299
        e = norm(s(1,i:i+299)-template(1,:),2)+norm(s(2,i:i+299)-template(2,:),2)+norm(s(3,i:i+299)-template(3,:),2);
        if e<t*300
            state = ture;
            if e<=e0
                l0 = i; r0 = i+299;e0 = e;
            else
                l = l0; r = r0;
            end
        end
    end
    if state == false
        X0 = X(:,:,length(X(1,1,:))-299:length(X(1,1,:)));
    end
    save X0;
end

