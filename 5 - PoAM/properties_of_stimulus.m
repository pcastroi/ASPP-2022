close all
clear

% Parameters
fs = 20000;
dur = 1;
len = dur * fs;

fhigh=4000;


bw = [3,30,300,3000];
% bw = 30;

avg_num = 1000;


flow1=fhigh-bw(1);
flow2=fhigh-bw(2);
flow3=fhigh-bw(3);
flow4=fhigh-bw(4);

t=linspace(0,dur,len);

out3=zeros(avg_num,len);
out30=zeros(avg_num,len);
out300=zeros(avg_num,len);
out3000=zeros(avg_num,len);

for idx = 1:avg_num
    out3(idx,:) = bpnoise(len,flow1,fhigh,fs);
    out30(idx,:) = bpnoise(len,flow2,fhigh,fs);
    out300(idx,:) = bpnoise(len,flow3,fhigh,fs);
    out3000(idx,:) = bpnoise(len,flow4,fhigh,fs);
end

%% plot temporal waveform
% figure
% hold on
% for idx=1:length(bw)
%     plot(t,out(idx,:))
% end
% hold off
%% plot power spectrum of waveform
X1 = zeros(1,size(out3,2));
X2 = zeros(1,size(out30,2));
X3 = zeros(1,size(out300,2));
X4 = zeros(1,size(out3000,2));

for idx = 1:avg_num

    N = size(t,2);
    dF = fs/N;                      % hertz
    f = -fs/2:dF:fs/2-dF;           % hertz

    X1 = X1 + 10*log10((abs(fftshift(fft(out3(idx,:)))).^2)/1000);
    X2 = X2 + 10*log10((abs(fftshift(fft(out30(idx,:)))).^2)/1000);
    X3 = X3 + 10*log10((abs(fftshift(fft(out300(idx,:)))).^2)/1000);
    X4 = X4 + 10*log10((abs(fftshift(fft(out3000(idx,:)))).^2)/1000);

end

X1 = X1./avg_num;
X2 = X2./avg_num;
X3 = X3./avg_num;
X4 = X4./avg_num;

X1(X1==-inf)=min(X1(X1>-inf));
X2(X2==-inf)=min(X2(X2>-inf));
X3(X3==-inf)=min(X3(X3>-inf));
X4(X4==-inf)=min(X4(X4>-inf));

figure('Name','Pow Spec Bandpass Noise','NumberTitle','off'); 
hold on
% for idx=1:length(bw)
  
    
%     plot(f,10*log10((abs(X)/N).^2));
    plot(f,X1);
    plot(f,X2);
    plot(f,X3);
    plot(f,X4);
%     plot(f(4000:end),[0 X4(4001:end)]);
    xlabel('Frequency [Hz]');
    ylabel('Power [dB]')
    legend('3 Hz', '30 Hz', '300 Hz', '3000 Hz','Location','northwest')
    title('Power Spectrum Bandpass filtered Noise');

% end
hold off
set(gca, 'XScale', 'log')
xlim([900 4400])
ylim([-25 50])
grid on


%% plot envelope


for idx = 1:avg_num
    h_env_3(idx,:) = abs(hilbert(out3(idx,:)));
    h_env_30(idx,:) = abs(hilbert(out30(idx,:)));
    h_env_300(idx,:) = abs(hilbert(out300(idx,:)));
    h_env_3000(idx,:) = abs(hilbert(out3000(idx,:)));
end
% figure
% hold on
% for idx=1:length(bw)
%     plot(t,h_env(idx,:))
% end
% hold off

%% plot power spectrum of envelope
X1 = zeros(1,size(h_env_3,2));
X2 = zeros(1,size(h_env_30,2));
X3 = zeros(1,size(h_env_300,2));
X4 = zeros(1,size(h_env_3000,2));

for idx = 1:avg_num

    N = size(t,2);
    dF = fs/N;                      % hertz
    f = -fs/2:dF:fs/2-dF;           % hertz

%     X1 = X1 + 10*log10((abs(fftshift(fft(h_env_3(idx,:)))).^2)/1000);
%     X2 = X2 + 10*log10((abs(fftshift(fft(h_env_30(idx,:)))).^2)/1000);
%     X3 = X3 + 10*log10((abs(fftshift(fft(h_env_300(idx,:)))).^2)/1000);
%     X4 = X4 + 10*log10((abs(fftshift(fft(h_env_3000(idx,:)))).^2)/1000);

    X1 = X1 + ((abs(fftshift(fft(h_env_3(idx,:)))).^2)/1000);
    X2 = X2 + ((abs(fftshift(fft(h_env_30(idx,:)))).^2)/1000);
    X3 = X3 + ((abs(fftshift(fft(h_env_300(idx,:)))).^2)/1000);
    X4 = X4 + ((abs(fftshift(fft(h_env_3000(idx,:)))).^2)/1000);

end

X1 = 10*log10(X1./avg_num);
X2 = 10*log10(X2./avg_num);
X3 = 10*log10(X3./avg_num);
X4 = 10*log10(X4./avg_num);
% 
% X1 = X1./avg_num;
% X2 = X2./avg_num;
% X3 = X3./avg_num;
% X4 = X4./avg_num;

figure('Name','Pow Spec Bandpass Noise Envelope','NumberTitle','off'); 
hold on
% for idx=1:length(bw)
  

%     plot(f,10*log10((abs(X)/N).^2));
plot(f,X1);
plot(f,X2);
plot(f,X3);
plot(f,X4);
%     plot(f(4000:end),[0 X4(4001:end)]);
xlabel('Frequency [Hz]');
ylabel('Envelope Power [dB]')
legend('3 Hz', '30 Hz', '300 Hz', '3000 Hz','Location','northeast')
    title('Envelope Power Spectrum Bandpass filtered Noise');

% end
hold off
set(gca, 'XScale', 'log')
xlim([1 fs/2])
ylim([-50 50])
grid on


%% Add amplitude modulation to band-pass noise

% n = out;
f_m = 2500;
m = 0.5;
s3 = out3 .* (1 + m*cos(2*pi*f_m*t));
s30 = out30 .* (1 + m*cos(2*pi*f_m*t));
s300 = out300 .* (1 + m*cos(2*pi*f_m*t));
s3000 = out3000 .* (1 + m*cos(2*pi*f_m*t));

% %% plot temporal waveform
% figure
% hold on
% for idx=1:length(bw)
%     plot(t,s(idx,:))
% end
% hold off
%% plot power spectrum of waveform
X1 = zeros(1,size(s3,2));
X2 = zeros(1,size(s30,2));
X3 = zeros(1,size(s300,2));
X4 = zeros(1,size(s3000,2));

for idx = 1:avg_num

    N = size(t,2);
    dF = fs/N;                      % hertz
    f = -fs/2:dF:fs/2-dF;           % hertz

    X1 = X1 + 10*log10((abs(fftshift(fft(s3(idx,:)))).^2)/1000);
    X2 = X2 + 10*log10((abs(fftshift(fft(s30(idx,:)))).^2)/1000);
    X3 = X3 + 10*log10((abs(fftshift(fft(s300(idx,:)))).^2)/1000);
    X4 = X4 + 10*log10((abs(fftshift(fft(s3000(idx,:)))).^2)/1000);

end

X1 = X1./avg_num;
X2 = X2./avg_num;
X3 = X3./avg_num;
X4 = X4./avg_num;

figure('Name','Pow Spec Bandpass Noise AM','NumberTitle','off'); 
hold on
% for idx=1:length(bw)
  

%     plot(f,10*log10((abs(X)/N).^2));
plot(f,X1);
plot(f,X2);
plot(f,X3);
plot(f,X4);
%     plot(f(4000:end),[0 X4(4001:end)]);
xlabel('Frequency [Hz]');
ylabel('Power [dB]')
legend('3 Hz', '30 Hz', '300 Hz', '3000 Hz','Location','northwest')
title(['Power Spectrum Bandpass modulated Noise (f_{mod} = ' num2str(f_m) ' Hz)']);

% end
hold off
set(gca, 'XScale', 'log')
xlim([800 4600])
ylim([-25 50])
grid on

%% plot envelope

for idx = 1:avg_num
    h_env_3(idx,:) = abs(hilbert(s3(idx,:)));
    h_env_30(idx,:) = abs(hilbert(s30(idx,:)));
    h_env_300(idx,:) = abs(hilbert(s300(idx,:)));
    h_env_3000(idx,:) = abs(hilbert(s3000(idx,:)));
end

% figure
% hold on
% for idx=1:length(bw)
%     plot(t,h_env(idx,:))
% end
% hold off

%% plot power spectrum of envelope


X1 = zeros(1,size(h_env_3,2));
X2 = zeros(1,size(h_env_30,2));
X3 = zeros(1,size(h_env_300,2));
X4 = zeros(1,size(h_env_3000,2));

for idx = 1:avg_num

    N = size(t,2);
    dF = fs/N;                      % hertz
    f = -fs/2:dF:fs/2-dF;           % hertz

    X1 = X1 + 10*log10((abs(fftshift(fft(h_env_3(idx,:)))).^2)/1000);
    X2 = X2 + 10*log10((abs(fftshift(fft(h_env_30(idx,:)))).^2)/1000);
    X3 = X3 + 10*log10((abs(fftshift(fft(h_env_300(idx,:)))).^2)/1000);
    X4 = X4 + 10*log10((abs(fftshift(fft(h_env_3000(idx,:)))).^2)/1000);

end

X1 = X1./avg_num;
X2 = X2./avg_num;
X3 = X3./avg_num;
X4 = X4./avg_num;

figure('Name','Pow Spec Bandpass Noise AM Envelope','NumberTitle','off'); 
hold on
% for idx=1:length(bw)
  

%     plot(f,10*log10((abs(X)/N).^2));
plot(f,X1);
plot(f,X2);
plot(f,X3);
plot(f,X4);
xline(f_m,LineStyle="--",Label=['f_{mod} =' num2str(f_m) ' Hz'],LabelVerticalAlignment="bottom");
%     plot(f(4000:end),[0 X4(4001:end)]);
xlabel('Frequency [Hz]');
ylabel('Envelope Power [dB]')
legend('3 Hz', '30 Hz', '300 Hz', '3000 Hz','Location','northeast')
    title('Envelope Power Spectrum Bandpass modulated Noise');

% end
hold off
set(gca, 'XScale', 'log')
xlim([1 fs/2])
ylim([-50 50])
grid on

