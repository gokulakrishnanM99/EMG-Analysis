clc;
clear all;
close all;
%READ EMG WITHOUT LOAD DATA
file_NL= 'Location\EMG_Without_Load.xlsx';
range_NL='B28:B10027';
emg_NL=xlsread(file_NL,range_NL);
emg_NL=detrend(emg_NL,0);
%Read emg with load data
file_L='Location\EMG_Load.xlsx';
range_L='B28:B1048576';
emg_L=xlsread(file_L,range_L);
emg_L=detrend(emg_L,0);
n1=length(emg_NL);
n2=length(emg_L);
T=300;
f1=n1/T;
f2=n2/T;
t1=0:(1/f1):((n1-1)/f1);
t2=0:(1/f2):((n2-1)/f2);
figure();
subplot(2,1,1);
plot(t1,emg_NL);
xlabel('time(s)');
ylabel('amplitude(V)');
title('Raw EMG without load data');
subplot(2,1,2);
plot(t2,emg_L);
xlabel('time(s)');
ylabel('amplitude(V)');
title('Raw EMG with load data');
fs=1/0.0005;

EMG_NL=periodogram(emg_NL);
N1=length(EMG_NL);
wpsd_nl=0:((fs/2)/N1):(fs/2)-(((fs/2)/N1));
figure();
subplot(2,1,1);
plot(wpsd_nl,EMG_NL);%Periodogram of raw emg without load signal
xlabel('Frequency(Hz)');
ylabel('Power (dB/Hz)');
title('Power Spectral Density of without load data');
EMG_L=periodogram(emg_L);
N2=length(EMG_L);
wpsd_l=0:((fs/2)/N2):(fs/2)-(((fs/2)/N2));
subplot(2,1,2);
plot(wpsd_l,EMG_L);%Periodogram of raw emg with load signal
xlabel('Frequency(Hz)');
ylabel('Power (dB/Hz)');
title('Power Spectral Density of with load data');

%Bandpass filtering
f=1500;
rp=3;rs=15;
fp1=20;fp2=500;
fs1=15;fs2=550;
wp1=(2.*fp1)/f;
wp2=(2.*fp2)/f;
ws1=(2.*fs1)/f;
ws2=(2.*fs2)/f;
w1=[wp1 wp2];
w2=[ws1 ws2];
[N,wn]=buttord(w1,w2,rp,rs);
[b,a]=butter(N,wn,'bandpass');
bp1=filtfilt(b,a,emg_NL);
BP1=periodogram(bp1);
%BP1=BP1/abs(max(BP1)); %Normalizatio
bp2=filtfilt(b,a,emg_L);
BP2=periodogram(bp2);
%BP2=BP2/abs(max(BP2)); %Normalizatio
figure();
sgtitle('Bandpass filtered EMG signal');
subplot(2,1,1);
plot(t1,bp1);
title('Without load');
xlabel('Time (ms)');
ylabel('Amplitude (V)');
subplot(2,1,2);
plot(t2,bp2);
title('With load');
xlabel('Time (ms)');
ylabel('Amplitude (V)');
figure();
sgtitle('Power spectral density of Bandpass filtered EMG signal');
subplot(2,1,1);
plot(wpsd_nl,BP1);
title('Without load');
xlabel('Frequency (Hz)');
ylabel('Power (dB/Hz)');
subplot(2,1,2);
plot(wpsd_l,BP2);
title('With load');
xlabel('Frequency (Hz)');
ylabel('Power (dB/Hz)')