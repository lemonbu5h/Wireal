 path = 'data';
 date = '/17.10.18/';
 %motion = {'sitdown','standup','liedown','squat','fallface','fallarm','walking'};
 motion = {'sitdown','standup','liedown','squat','fallface','fallarm'};
 % who join this experiment
 name = {'lt','zyf','zx','sly'};
 % name = {'zjh','lbw','lt','zyf','zx','sly','hmm','wyt','zdd'};
 format = '.dat';
 % num represents the tail id without which some files will have the
 % same filename. eg. "sitdownxxx1.dat, sitdownxxx2.dat"
 num = 5;
 MDB = struct('sitdown',zeros(length(name)*num,3,3000),'standup',zeros(length(name)*num,3,3000),'liedown',zeros(length(name)*num,3,3000),'squat',zeros(length(name)*num,3,3000),'fallface',zeros(length(name)*num,3,3000),'fallarm',zeros(length(name)*num,3,3000));
 %MDB = zeros(num,length(motion),3,3000);
 %Mst = zeros(length(motion),3,3000);
 
  for M=1:length(motion)
     for N=1:length(name)
         for I=1:num
            c1 = read_bf_file([path,date,char(motion(M)),char(name(N)),num2str(I),format]);
            datalength = length(c1); 
            csi_trace=c1(1:datalength,1);
            % motion happens roughly at 7.501s - 10.500s 
            % 3000 = 10500 - 7501
            Mdatalength=3000;
            package1 = zeros(30,Mdatalength);
            package2 = zeros(30,Mdatalength);
            package3 = zeros(30,Mdatalength);
            fs=1000; 

            countlack = 0;ff=0;
            amp = zeros(1,datalength);
            for i=7501:10500
                csi_entry = csi_trace{i};
                csi = get_scaled_csi_sm(csi_entry);
                [u,v,~]=size(csi);
                thr_antenna=reshape(csi,u*v,30).';
                a_antenna=thr_antenna; 
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

            filterdata = ones(30,Mdatalength);
            for i = 1:30
               filterdata(i,:) = filtfilt(b,a,package2(i,:));
            end    
            for i = 1:30
               s2=s2+filterdata(i,:);
            end
            s2=s2/30;

            filterdata = ones(30,Mdatalength);
            for i = 1:30
               filterdata(i,:) = filtfilt(b,a,package3(i,:));
            end
            for i = 1:30
               s3=s3+filterdata(i,:);
            end
            s3=s3/30;
            
            % si is the average value of all subcarriers in ith stream
            switch M
                case 1,
                    MDB.sitdown((N-1)*num+I,1,:) = s1';
                    MDB.sitdown((N-1)*num+I,2,:) = s2';
                    MDB.sitdown((N-1)*num+I,3,:) = s3';
                case 2,
                    MDB.standup((N-1)*num+I,1,:) = s1';
                    MDB.standup((N-1)*num+I,2,:) = s2';
                    MDB.standup((N-1)*num+I,3,:) = s3';
                case 3,
                    MDB.liedown((N-1)*num+I,1,:) = s1';
                    MDB.liedown((N-1)*num+I,2,:) = s2';
                    MDB.liedown((N-1)*num+I,3,:) = s3';
                case 4,
                    MDB.squat((N-1)*num+I,1,:) = s1';
                    MDB.squat((N-1)*num+I,2,:) = s2';
                    MDB.squat((N-1)*num+I,3,:) = s3';
                case 5,
                    MDB.fallface((N-1)*num+I,1,:) = s1';
                    MDB.fallface((N-1)*num+I,2,:) = s2';
                    MDB.fallface((N-1)*num+I,3,:) = s3';
                case 6,
                    MDB.fallarm((N-1)*num+I,1,:) = s1';
                    MDB.fallarm((N-1)*num+I,2,:) = s2';
                    MDB.fallarm((N-1)*num+I,3,:) = s3';
            end              
         end
     end
  end
 
tic
MDB.Mstd = struct('sitdown',zeros(3,3000),'standup',zeros(3,3000),'liedown',zeros(3,3000),'squat',zeros(3,3000),'fallface',zeros(3,3000),'fallarm',zeros(3,3000));
for i=1:N*num
    % divided by N*num means reducing effect of individuals and times
    MDB.Mstd.sitdown = MDB.Mstd.sitdown+reshape(MDB.sitdown(i,:,:),[3,3000])/(N*num);
    MDB.Mstd.standup = MDB.Mstd.standup+reshape(MDB.standup(i,:,:),[3,3000])/(N*num);
    MDB.Mstd.liedown = MDB.Mstd.liedown+reshape(MDB.liedown(i,:,:),[3,3000])/(N*num);
    MDB.Mstd.squat = MDB.Mstd.squat+reshape(MDB.squat(i,:,:),[3,3000])/(N*num);
    MDB.Mstd.fallface = MDB.Mstd.fallface+reshape(MDB.fallface(i,:,:),[3,3000])/(N*num);
    MDB.Mstd.fallarm = MDB.Mstd.fallarm+reshape(MDB.fallarm(i,:,:),[3,3000])/(N*num);
end

V = zeros(M,num);
MDB.VarN = zeros(M,2);
percentage = 0;
for i=1:M
    switch i
        case 1,s = MDB.Mstd.sitdown; m = MDB.sitdown;
        case 2,s = MDB.Mstd.standup; m = MDB.standup;
        case 3,s = MDB.Mstd.liedown; m = MDB.liedown;
        case 4,s = MDB.Mstd.squat; m = MDB.squat;
        case 5,s = MDB.Mstd.fallface; m = MDB.fallface;
        case 6,s = MDB.Mstd.fallarm; m = MDB.fallarm;
    end
    for j=1:N*num
        %percentage = percentage+100/(M*N*num)
        %V(i,j) = DTW(s(1,:),reshape(m(j,1,:),[1,3000]))+DTW(s(2,:),reshape(m(j,2,:),[1,3000]))+DTW(s(3,:),reshape(m(j,3,:),[1,3000]));
        %V(i,j) = std(s(1,:)-reshape(m(j,1,:),[1,3000]))+std(s(2,:)-reshape(m(j,2,:),[1,3000]))+std(s(3,:)-reshape(m(j,3,:),[1,3000]));
        V(i,j) = norm((s(1,:)-reshape(m(j,1,:),[1,3000])),2)+norm((s(2,:)-reshape(m(j,2,:),[1,3000])),2)+norm((s(3,:)-reshape(m(j,3,:),[1,3000])),2);
    end
end
for j=1:M
    [S,i] = max(V(j,:));
    MDB.VarN(j,1) = i;
    MDB.VarN(j,2) = S;
end
toc
save MDB;
