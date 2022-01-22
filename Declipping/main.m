
close all
clear
clc

addpath('Tools')
addpath('DGTtool-main')
addpath('edited_TIMIT')

rng(0)

%% Setting parameters

param.wtype = 'hann';
param.w = 1024;
param.a = param.w/4;
param.M = param.w;
param.Ls = param.a*64; % about 1s & mod(shiftLen) = 0

param.inputSDR = [1 3 5 10 15];
N = length(param.inputSDR);

Sounds = dir('edited_TIMIT/*.wav');
NN = length(Sounds);
data = cell(NN,1);
info = audioinfo(Sounds(1).name);
Fs = info.SampleRate;
for n = 1:NN
    data{n} = audioread(Sounds(n).name);
end
% for n = 1:NN
%     audio = audioread(Sounds(n).name);
%     ind = detectSpeech(audio, Fs);
%     if isempty(ind)
%         idx = randi(length(audio) - param.Ls - 1);
%         signal = audio(idx:idx + param.Ls - 1);
%     else
%         speechLen = ind(:,2) - ind(:,1);
%         enoughLen = find(speechLen>param.Ls);
%         if isempty(enoughLen)
%             [num, idx] = max(speechLen);
%             if ind(idx,1) > ceil(param.Ls - num)
%                 signal = audio(ind(idx,1) - ceil(param.Ls - num) + 1:ind(idx,2));
%             elseif ind(idx,2) < length(audio) - ceil(param.Ls - num)
%                 signal = audio(ind(idx,1):ind(idx,2) + ceil(param.Ls - num) - 1);
%             end
%         else
%             enie = randi([1 length(enoughLen)]);
%             signal = audio(ind(enoughLen(enie),2) - param.Ls + 1:ind(enoughLen(enie),2));
%         end
%     end
%     signal_pad = [zeros(param.a,1);signal(param.a+1:end-param.a);zeros(param.a,1)];
%     data{n} = signal_pad/abs(max(signal_pad));
%     audiowrite(['test_data_',num2str(n),'.wav'],data{n},Fs,'BitsPerSample',32);
% end

%% 

% control, which methods to use in the default settings
turnon = logical([ 0,... %  1. ASPAIN
                   0,... %  2. SS-PEW
                   1,... %  3. PWL1
                   0,... %  4. Const.-IHT
                   0,... %  5. APPLADE
                   0,... %  6. DNN
                   ]);
               
solution.ASPADE  = cell(N,NN);
solution.SSPEW   = cell(N,NN);
solution.PWL1    = cell(N,NN);
solution.APPLADE = cell(N,NN);
solution.CIHT    = cell(N,NN);
solution.DNN     = cell(N,NN);

theta = zeros(N,NN);
trueSDR = zeros(N,NN);
percentage = zeros(N,NN);

deltaSDR = NaN(N,NN,sum(turnon));
PESQ     = NaN(N,NN,sum(turnon));
STOI     = NaN(N,NN,sum(turnon));
ESTOI    = NaN(N,NN,sum(turnon));

% clip_SDR = NaN(N,NN);
% clip_PESQ     = NaN(N,NN);
% clip_STOI     = NaN(N,NN);
% clip_ESTOI    = NaN(N,NN);

%% 

iter = 0;

for nn = 1:NN
    
    sig = data{nn};
    calcSDR = @(result) sdr(sig, result);
    calcPESQ = @(result) pesq2(sig, result, Fs);
    calcSTOI = @(result) taal2011(sig, result, Fs);
    calcESTOI = @(result) estoi(sig, result, Fs);
    
    for n = 1:N
        
        [clip, param.masks, theta(n,nn), trueSDR(n,nn), percentage(n,nn)] = clip_sdr_mine(sig, param.inputSDR(n));
        
%         clip_SDR(n,nn) = calcSDR(clip);
%         clip_PESQ(n,nn) = calcPESQ(clip);
%         clip_STOI(n,nn) = calcSTOI(clip);
%         clip_ESTOI(n,nn) = calcESTOI(clip);
        
%         audiowrite(['clipped_data/clipped_',num2str(nn),num2str(n),'.wav'],clip,Fs,'BitsPerSample',32);
        
        if turnon(1)
            iter = iter + 1;
%             waitbar(iter/N/NN/sum(turnon),f,'ASPADE...');
            tic
            fprintf('\nASPADE...\n');
            solution.ASPADE{n,nn} = main_spade(sig, clip, Fs, param);
            audiowrite(['Results_waves/',D,'/ASPADE_',num2str(nn),num2str(n),'.wav'],solution.ASPADE{n,nn},Fs,'BitsPerSample',32);
            deltaSDR(n,nn,1) = calcSDR(solution.ASPADE{n,nn}) - calcSDR(clip);
            PESQ(n,nn,1) = calcPESQ(solution.ASPADE{n,nn});
            STOI(n,nn,1) = calcSTOI(solution.ASPADE{n,nn});
            ESTOI(n,nn,1) = calcESTOI(solution.ASPADE{n,nn});
            toc
        end
        
        if turnon(2)
            iter = iter + 1;
%             waitbar(iter/N/NN/sum(turnon),f,'SSPEW...');
            tic
            fprintf('\nSSPEW...\n');
            solution.SSPEW{n,nn} = main_Social_Sparsity(sig, clip, Fs, param, theta(n,nn));
            audiowrite(['Results_waves/',D,'/SSPEW_',num2str(nn),num2str(n),'.wav'],solution.SSPEW{n,nn},Fs,'BitsPerSample',32);
            deltaSDR(n,nn,2) = calcSDR(solution.SSPEW{n,nn}) - calcSDR(clip);
            PESQ(n,nn,2) = calcPESQ(solution.SSPEW{n,nn});
            STOI(n,nn,2) = calcSTOI(solution.SSPEW{n,nn});
            ESTOI(n,nn,2) = calcESTOI(solution.SSPEW{n,nn});
            toc
        end
        
        if turnon(3)
            iter = iter + 1;
%             waitbar(iter/N/NN/sum(turnon),f,'PWL1...');
            tic
            fprintf('\nPWL1...\n');
            solution.PWL1{n,nn} = main_l1_relaxation(sig, clip, Fs, param);
            audiowrite(['Results_waves/',D,'/PWL1_',num2str(nn),num2str(n),'.wav'],solution.PWL1{n,nn},Fs,'BitsPerSample',32);
            deltaSDR(n,nn,3) = calcSDR(solution.PWL1{n,nn}) - calcSDR(clip);
            PESQ(n,nn,3) = calcPESQ(solution.PWL1{n,nn});
            STOI(n,nn,3) = calcSTOI(solution.PWL1{n,nn});
            ESTOI(n,nn,3) = calcESTOI(solution.PWL1{n,nn});
            toc
        end
        
        if turnon(4)
            iter = iter + 1;
%             waitbar(iter/N/NN/sum(turnon),f,'CIHT...');
            tic
            fprintf('\nCIHT...\n');
            solution.CIHT{n,nn} = main_IHT(sig, clip, Fs, param);
            audiowrite(['Results_waves/',D,'/CIHT_',num2str(nn),num2str(n),'.wav'],solution.CIHT{n,nn},Fs,'BitsPerSample',32);
            deltaSDR(n,nn,4) = calcSDR(solution.CIHT{n,nn}) - calcSDR(clip);
            PESQ(n,nn,4) = calcPESQ(solution.CIHT{n,nn});
            STOI(n,nn,4) = calcSTOI(solution.CIHT{n,nn});
            ESTOI(n,nn,4) = calcESTOI(solution.CIHT{n,nn});
            toc
        end
        
        if turnon(5)
            iter = iter + 1;
%             waitbar(iter/N/NN/sum(turnon),f,'APPLADE...');
            tic
            fprintf('\nAPPLADE...\n');
%             net = load("C:\Users\acoust\Downloads\APPLADE_main\APPLADE\DLNET\05-Aug-2021\dlnet_400.mat");
            net = load("C:/Users/acoust/Downloads/APPLADE_main/APPLADE_from_BPC/DLNET/2021-Oct-02-02/parameters200Epochs.mat");
%             state = load("C:/Users/acoust/Downloads/APPLADE_main/APPLADE_from_BPC/DLNET/2021-Sep-15-22/state100Epochs.mat");
%             dlnet = net.dlnet;
            parameters = net.parameters;
            param.lambda = 30*percentage(n,nn)/100;
%             state = state.state;
%             solution.APPLADE{n,nn} = main_APPLADE(sig, clip, Fs, param, dlnet);
            solution.APPLADE{n,nn} = main_APPLADE(sig,clip,Fs,param,parameters);
%             solution.APPLADE{n,nn} = main_T_APPLADE(sig,clip,Fs,param);
%             audiowrite(['Results_waves/',D,'/APPLADE_',num2str(nn),num2str(n),'.wav'],solution.APPLADE{n,nn},Fs,'BitsPerSample',32);
            deltaSDR(n,nn,5) = calcSDR(solution.APPLADE{n,nn}) - calcSDR(clip);
            PESQ(n,nn,5) = calcPESQ(solution.APPLADE{n,nn});
            STOI(n,nn,5) = calcSTOI(solution.APPLADE{n,nn});
            ESTOI(n,nn,5) = calcESTOI(solution.APPLADE{n,nn});
            toc
        end
        
        if turnon(6)
            iter = iter + 1;
            tic
            fprintf('\nDNN...\n');
            net = load("C:/Users/acoust/Downloads/APPLADE_main/APPLADE_from_BPC/DLNET/2021-Oct-02-02/parameters200Epochs.mat");
            parameters = net.parameters;
            
            F = DGTtool('windowShift',param.a,'windowLength',param.w,'FFTnum',param.M,'windowName','h');
            F.makeWindowTight;

            X = F(clip);
            lX = abs(X);
            inputX = dlarray(lX(1:end-1,:),'SSBC');
            mask = double(gather(extractdata(model(parameters,inputX))));
            mask = vertcat(mask,zeros(1,size(mask,2)));
            preX = mask.*sign(X);
            
            solution.DNN{n,nn} = F.H(preX);

            deltaSDR(n,nn,6) = calcSDR(solution.DNN{n,nn}) - calcSDR(clip);
            PESQ(n,nn,6) = calcPESQ(solution.DNN{n,nn});
            STOI(n,nn,6) = calcSTOI(solution.DNN{n,nn});
            ESTOI(n,nn,6) = calcESTOI(solution.DNN{n,nn});
            toc
        end
        
    end
end

LINE_Notify("APPLADE_Optim Done")

%% 

% leg = {'ASPADE','SS-PEW','PWL1','Const.-IHT','APPLADE'};
% 
% figure,plot(squeeze(mean(deltaSDR(1:N,1:NN,1:4),2)))
% legend(leg(turnon)), ylabel('deltaSDR'), xlabel('inputSDR'), xticks([1 2 3 4 5]), xticklabels(param.inputSDR)
% 
% figure,plot(squeeze(mean(PESQ(1:N,1:NN,1:4),2)))
% legend(leg(turnon)), ylabel('PESQ'), xlabel('inputSDR'), xticks([1 2 3 4 5]), xticklabels(param.inputSDR)
% 
% figure,plot(squeeze(mean(STOI(1:N,1:NN,1:4),2)))
% legend(leg(turnon)), ylabel('STOI'), xlabel('inputSDR'), xticks([1 2 3 4 5]), xticklabels(param.inputSDR)
% 
% figure,plot(squeeze(mean(ESTOI(1:N,1:NN,1:4),2)))
% legend(leg(turnon)), ylabel('ESTOI'), xlabel('inputSDR'), xticks([1 2 3 4 5]), xticklabels(param.inputSDR) 
% 
%% 

save(['Results/',D,'/param.mat'],'param')
save(['Results/',D,'/theta.mat'],'theta')
save(['Results/',D,'/trueSDR.mat'],'trueSDR')
save(['Results/',D,'/percentage.mat'],'percentage')
save(['Results/',D,'/deltaSDR.mat'],'deltaSDR')
save(['Results/',D,'/PESQ.mat'],'PESQ')
save(['Results/',D,'/STOI.mat'],'STOI')
save(['Results/',D,'/ESTOI.mat'],'ESTOI')
