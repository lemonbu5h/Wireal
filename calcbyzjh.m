%c1 = read_bf_file('sample_data/tmpzou.dat');
c1 = read_bf_file('sample_data/201604_1000HZ/zou.dat');
%csi_trace=c1(513:16384,1);
csi_trace=c1(513:1024,1);
%csi_trace=c1(513:5000,1);
package=[];j=0;count=0;
for i=1:length(csi_trace)
  csi_entry = csi_trace{i};
  csi = get_scaled_csi(csi_entry);
  [u,v,w]=size(csi);
  if (u == 1)
      j = i;
      count = count +1;
  end
  thr_antenna=reshape(csi,u*v,30).';
  a_antenna=thr_antenna(1:3,3);       
  temp=(db(abs(a_antenna)));
  package=[package,temp];
end 
y1=package(1,:);   
y2=package(2,:);
y3=package(3,:);
%y4=package(4,:);
N=10;
M=100/N;
L=length(y1)/N;
for i=1:L
 %%   package=[];
    if(i*N<=100)
           plot(1:i*N,y1(1:i*N),'r');hold on
           plot(1:i*N,y2(1:i*N),'g');hold on
           plot(1:i*N,y3(1:i*N),'b');hold on
           %plot(1:i*N,y4(1:i*N));
           axis([0 100 0 40]);
           xlabel('Package index');
           ylabel('SNR [dB]');
           legend('Subcarrier A1','Subcarrier A2','Subcarrier A3');
    else 
            plot((i-M)*N+1:i*N,y1((i-M)*N+1:i*N),'r');hold on 
            plot((i-M)*N+1:i*N,y2((i-M)*N+1:i*N),'g');hold on 
            plot((i-M)*N+1:i*N,y3((i-M)*N+1:i*N),'b');hold on 
            %plot((i-M)*N+1:i*N,y4((i-M)*N+1:i*N));
            axis([(i-M)*N+1 i*N 0 40]);
            xlabel('Package index');
            ylabel('SNR [dB]');
            legend('Subcarrier A1','Subcarrier A2','Subcarrier A3');
    end
 %% legend('Subcarrier A1','Subcarrier A2','Subcarrier A3','Subcarrier A4'); 
  xlabel('Package index');
  ylabel('SNR [dB]');
  drawnow;
  %pause(0.5);
end
