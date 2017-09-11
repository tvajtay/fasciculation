function [] = fftavg2( start_directory )
%UNTITLED3 wiggle wiggle
%   Is she wiggling? 

function [fold_detect,file_detect] = detector(path)
        cd(path)
        b = dir();
        files = dir('*.whiskers');
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

function[] = wrapper(path)
    cd(path);
    x = dir('*.whiskers');              
                                
    for j = 1:length(x)
        nam = sprintf('%smat',x(j).name(1:18));
        data_array = load(nam);
        data_array = struct2array(data_array);
        c = nanmean(data_array(1:400,:));                      %select first 400 points from each column and finds average of each column
        t = data_array(1:400,:);                               %first 400 points for each column
        F = bsxfun(@minus,t,c);                                %function to subtract vector average from array
        F = notFourier(F); %#ok<NASGU>
        fname = sprintf('fft-%s.mat',x(j).name);
        save(fname,'F');
    end
end

tstart = tic;
working_directory = cd;
addpath(cd)
addpath(start_directory);
cd (start_directory);

[fold,fil] = detector(start_directory);
if fil > 0
    wrapper(start_directory);
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
        fprintf('Checking %s for mat files\n', currpath);
        if fil > 0
            wrapper(currpath);
        end
    end
end

finish = datestr(now);
fprintf('FFT completed at %s\n', finish);
cd(working_directory);
telapsed = toc(tstart);
fprintf('FFT ran for %.2f seconds\n', telapsed);               
end