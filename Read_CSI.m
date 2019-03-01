tic;
clear
%intel 5300 netcard
%从文件中读取数据
HG_c1 = read_bf_file('E:/Project/data/17.12.20/fallarmlt2.dat');
toc;
HG_datalength = length(HG_c1);
HG_fs=50;
Num_subcarrier=30;
Num_Rx=3;
Num_Tx=1;
Num_CSI_stream=Num_Rx*Num_Tx*Num_subcarrier;
package=zeros(Num_CSI_stream,HG_datalength);
RSSI_package=zeros(Num_Rx,HG_datalength);
for i=1:HG_datalength
    RSSI_package(1,i)=HG_c1{i}.rssi_a;
    RSSI_package(2,i)=HG_c1{i}.rssi_b;
    RSSI_package(3,i)=HG_c1{i}.rssi_c;
    csi = get_scaled_csi(HG_c1{i});
    row=0;
    for j1=1:Num_Tx
        for j2=1:Num_Rx
            for j3=1:Num_subcarrier
                row=row+1;
                package(row,i)=csi(j1,j2,j3);
            end
        end
    end
end
package=db(package);
toc;

