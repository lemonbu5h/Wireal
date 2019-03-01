 load('MDB.mat');

 path = 'data';
 date = '\17.10.18\';
 %motion = {'sitdown','standup','liedown','squat','fallface','fallarm','walking'};
 motion = {'sitdown','standup','liedown','squat','fallface','fallarm'};
 %name = {'zjh','lbw','lt','zyf','zx','sly','hmm','wyt','zdd'};
 name = {'lt','zyf','zx','sly'};
 format = '.dat';
 DBnum = length(MDB.fallface(:,1,1));
 
 Vtemp = zeros(1,length(motion));
 V = zeros(length(motion),DBnum);
 Cmatrix = zeros(length(motion));
 amount = 0;
 amountC = 0;
 
tic
   for M=1:length(motion)
     for I=6:10
         for N=1:length(name)             
             
             amount = amount+1;
             flag = 0;
             %percentage = amount/(length(motion)*length(name)*8)*100
            
            c1 = read_bf_file([path,date,char(motion(M)),char(name(N)),num2str(I),format]);

                datalength = length(c1); 
                csi_trace=c1(1:datalength,1);
                Mdatalength=3000;
                package1 = zeros(30,Mdatalength);
                package2 = zeros(30,Mdatalength);
                package3 = zeros(30,Mdatalength);
                fs=1000; %采样频率

                countlack = 0;ff=0;
                amp = zeros(1,datalength);
                for i=7501:10500
                    csi_entry = csi_trace{i};
                    csi = get_scaled_csi_sm(csi_entry);
                    [u,v,~]=size(csi);
                    thr_antenna=reshape(csi,u*v,30).';
                    a_antenna=thr_antenna; %第二根天线发出的不同子载波（第2到4个子载波）
                    temp = abs(a_antenna);
                    package1(:,i-7500)=temp(:,1);
                    package2(:,i-7500)=temp(:,2);
                    package3(:,i-7500)=temp(:,3); 
                end

                s1 = 0;
                s2 = 0;
                s3 = 0;

                Wp = 1/(fs/2); %通带截止频率,这个自定大致定义
                Ws = 15/(fs/2);%阻带截止频率,这个自定大致定义
                Rp = 2; %通带内的衰减不超过Rp,这个自定大致定义
                Rs = 40;%阻带内的衰减不小于Rs，这个自定大致定义
                [n,Wn] = buttord(Wp,Ws,Rp,Rs);%巴特沃斯数字滤波器最小阶数选择函数
                [b,a] = butter(n,Wn);%巴特沃斯数字滤波器

                filterdata = ones(30,Mdatalength);
                for i = 1:30
                   filterdata(i,:) = filtfilt(b,a,package1(i,:));
                end
                for i = 1:30
                   s1=s1+filterdata(i,:);     
                end
                s1=s1/30;
                %s1=s1-mean(s1);
%                 s1=100*diff(s1);
%                 s1=[s1,s1(2999)];
                %......此处添加特征代码

               % plot(s1,'b');  %测试一下


                filterdata = ones(30,Mdatalength);
                for i = 1:30
                   filterdata(i,:) = filtfilt(b,a,package2(i,:));
                end    
                for i = 1:30
                   s2=s2+filterdata(i,:);
                end
                s2=s2/30;
                %s2=s2-mean(s2);
%                 s2=100*diff(s2);
%                 s2=[s2,s2(2999)];
                %......此处添加特征代码

                filterdata = ones(30,Mdatalength);
                for i = 1:30
                   filterdata(i,:) = filtfilt(b,a,package3(i,:));
                end
                for i = 1:30
                   s3=s3+filterdata(i,:);
                end
                s3=s3/30;
                %s3=s3-mean(s3);
%                 s3=100*diff(s3);
%                 s3=[s3,s3(2999)];
                s1 = sample(s1,10);
                s2 = sample(s2,10);
                s3 = sample(s3,10);
                

                for i=1:6
                    switch i
                        case 1,s = MDB.Mstd.sitdown;
                        case 2,s = MDB.Mstd.standup;
                        case 3,s = MDB.Mstd.liedown;
                        case 4,s = MDB.Mstd.squat;
                        case 5,s = MDB.Mstd.fallface;
                        case 6,s = MDB.Mstd.fallarm;
                    end
                    %Vtemp(i) = DTW(s(1,:),s1)+DTW(s(2,:),s2)+DTW(s(3,:),s3);
                    %Vtemp(i) = std(s(1,:)-s1)+std(s(2,:)-s2)+std(s(3,:)-s3);
                    Vtemp(i) = norm((s(1,:)-s1),2)+norm((s(2,:)-s2),2)+norm((s(3,:)-s3),2);
                end
                %Vtemp
                [S,i] = min(Vtemp(:));
                Cmatrix(M,i) = Cmatrix(M,i)+1;
                
                 if i==M
                     amountC = amountC+1;
                    if  S<MDB.VarN(M,2)
                        m = [s1;s2;s3];
                        switch M
                            case 1,
                                if find(MDB.sitdown(:,1,1) == s1(1));
                                    continue;
                                else
                                    MDB.Mstd.sitdown = MDB.Mstd.sitdown+(m-reshape(MDB.sitdown(MDB.VarN(M,1),:,:),[3,300]))/DBnum;
                                    MDB.sitdown(MDB.VarN(M,1),:,:) = m;flag = 1;
                                end
                            case 2,
                                if find(MDB.standup(:,1,1) == s1(1));
                                    continue;
                                else
                                    MDB.Mstd.standup = MDB.Mstd.standup+(m-reshape(MDB.standup(MDB.VarN(M,1),:,:),[3,300]))/DBnum;
                                    MDB.standup(MDB.VarN(M,1),:,:) = m;flag = 1;
                                end
                            case 3,
                                if find(MDB.liedown(:,1,1) == s1(1));
                                    continue;
                                else
                                    MDB.Mstd.liedown = MDB.Mstd.liedown+(m-reshape(MDB.liedown(MDB.VarN(M,1),:,:),[3,300]))/DBnum;
                                    MDB.liedown(MDB.VarN(M,1),:,:) = m;flag = 1;
                                end
                            case 4,
                                if find(MDB.squat(:,1,1) == s1(1));
                                    continue;
                                else
                                    MDB.Mstd.squat = MDB.Mstd.squat+(m-reshape(MDB.squat(MDB.VarN(M,1),:,:),[3,300]))/DBnum;
                                    MDB.squat(MDB.VarN(M,1),:,:) = m;flag = 1;
                                end
                            case 5,
                                if find(MDB.fallface(:,1,1) == s1(1));
                                    continue;
                                else
                                    MDB.Mstd.fallface = MDB.Mstd.fallface+(m-reshape(MDB.fallface(MDB.VarN(M,1),:,:),[3,300]))/DBnum;
                                    MDB.fallface(MDB.VarN(M,1),:,:) = m;flag = 1;
                                end
                             case 6,
                                if find(MDB.fallarm(:,1,1) == s1(1));
                                    continue;
                                else
                                    MDB.Mstd.fallarm = MDB.Mstd.fallarm+(m-reshape(MDB.fallarm(MDB.VarN(M,1),:,:),[3,300]))/DBnum;
                                    MDB.fallarm(MDB.VarN(M,1),:,:) = m;flag = 1;
                                end
                        end
                    end
%                  else
%                      Motion = [char(motion(M)),char(name(N)),num2str(I)]
                end
                if flag==1
                    %Motion = [char(motion(M)),char(name(N)),num2str(I)]
                    switch M
                        case 1,s = MDB.Mstd.sitdown; m = MDB.sitdown;
                        case 2,s = MDB.Mstd.standup; m = MDB.standup;
                        case 3,s = MDB.Mstd.liedown; m = MDB.liedown;
                        case 4,s = MDB.Mstd.squat; m = MDB.squat;
                        case 5,s = MDB.Mstd.fallface; m = MDB.fallface;
                        case 6,s = MDB.Mstd.fallarm; m = MDB.fallarm;
                    end
                    for j=1:DBnum
                        %V(M,j) = DTW(s(1,:),reshape(m(j,1,:),[1,3000]))+DTW(s(2,:),reshape(m(j,2,:),[1,3000]))+DTW(s(3,:),reshape(m(j,3,:),[1,3000]));
                        %V(M,j) = std(s(1,:)-reshape(m(j,1,:),[1,3000]))+std(s(2,:)-reshape(m(j,2,:),[1,3000]))+std(s(3,:)-reshape(m(j,3,:),[1,3000]));
                        V(M,j) = norm((s(1,:)-reshape(m(j,1,:),[1,3000])),2)+norm((s(2,:)-reshape(m(j,2,:),[1,3000])),2)+norm((s(3,:)-reshape(m(j,3,:),[1,3000])),2);
                    end
                    [S,i] = max(V(M,:));
                    MDB.VarN(M,1) = i;
                    MDB.VarN(M,2) = S;                    
                 end
         end
     end
   end
toc
   
   save MDB;
   
   accuracy = amountC/amount
   Cmatrix
  


