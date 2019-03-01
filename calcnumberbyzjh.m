csi_trace = read_bf_file('sample_data\zjhdata\100HZ\experiment\20160807\drawingroom_afternoon_activity3_location1_A_holder_L_4.dat');
csi_entry = csi_trace{1,1};
csi = get_scaled_csi(csi_entry);    