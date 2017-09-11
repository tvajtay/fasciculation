function [] = fftavg2( start_directory )
%UNTITLED3 wiggle wiggle
%   Is she wiggling? 

function [fold_detect,file_detect] = detector(path)
        cd(path)
        b = dir();
        files = dir('*.mat');
        isub = [b(:).isdir];
        nameFolds = {b(isub).name}';
        nameFolds(ismember(nameFolds,{'.','..'})) = [];
        fold_detect = size(nameFolds, 1);
        file_detect = size(files, 1);
        fprintf('Detecting\n');
end %detector function

function [P1] = notFourier(F) 
        Y = fft(F);                            %fft
        P2 = abs(Y/400);                       %not a clue
        P1 = P2(1:400/2,:);                    %fughetaboutit
        P1(2:end-1,:) = 2*P1(2:end-1,:);       %now you're just fucking with me
end

function[] = plotsave(avg)
        Fs = 500;                                 %sampling frequency
        f = Fs*(1:400/2)/400;                    %stuff
        
        plot(f,avg)                                          %plotting the fft analysis for each whisker
        axis([0 75 0 1]);                                    %[xmin xmax ymin ymax]
        title('Single-Sided Amplitude Spectrum of F(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Power|')
       
        fprintf('Data spans %.2f seconds\n', T);
        folder = cd;
        jj = sprintf('%s',folder(end-2:end)); %Folder name for cumulative graph
        figname = sprintf('%s-fft',jj);
        saveas(gcf, figname, 'fig');  %ERROR in saving due to lines 43 - 51 changing size of name
        saveas(gcf, figname, 'png');
        close all;
end %the fft function

tstart = tic;
working_directory = cd;
addpath(cd)
addpath matlab
addpath(start_directory);
cd (start_directory);

[fold,fil] = detector(start_directory);
if fil > 0
    
    clacker(face_hint, start_directory, whisknum);
elseif fil == 0
    fprintf('No mat files in the start directory\n');
end

if fold > 0
    target = [start_directory '\**\*.'];
    fprintf('Scanning all subdirectories from starting directory\n');
    D = rdir(target);             %// List of all sub-directories
    for k = 1:length(D)
        currpath = D(k).name;
        [~,fil] = detector(currpath);
        fprintf('Checking %s for tif files\n', currpath);
        if fil > 0
            
            
        end
    end

p = dir('jit*.mat');                          %directory of jit mat files
jitlength = length(p);                        %length of directory of jit files
x = dir('*.mat');                             %directory of all .mat files including jit
    if jitlength > 0                          %if there are jit files present
        x = x(1:jitlength);                   %returns just .mat files w/o jit
    end                                 
fil = length(x);                              %length of directory of .mat files w/o jit files

    if fil < 1
     fprintf('error: no files found.\n');
    end

data_array = load(x(1).name);
data_array = struct2array(data_array);
[~,numWhiskers] = size(data_array); 

    if fil == 1
        c = nanmean(data_array(1:400,:));                              %select first 400 points from each column and finds average of each column
        t = data_array(1:400,:);                                       %first 400 points for each column
        rawData = bsxfun(@minus,t,c);                                  %function to subtract vector average from array
        A = notFourier(rawData);
        plotsave(A);

        else if fil > 1 
                avgData = [];
                for yy=1:numWhiskers
                    oneWhisker = [];
                    for ii=1:fil
                      data_array = load(x(ii).name);  
                      data_array = struct2array(data_array);
                      c = nanmean(data_array(1:400,yy));                      %select first 400 points from each column and finds average of each column
                      t = data_array(1:400,yy);                               %first 400 points for each column
                      F = bsxfun(@minus,t,c);                                %function to subtract vector average from array
                      F = notFourier(F);
                      oneWhisker = [oneWhisker,F];                     
                    end
                    avg = mean(oneWhisker,2);
                    avgData = [avgData,avg];  
                end
                plotsave(avgData);
             end
    end
end
