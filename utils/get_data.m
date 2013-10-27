% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% Written (W) 2012 Heiko Strathmann, Arthur Gretton

% Generates data according to the information in the data_params struct
function [X,Y]=get_data(m, data_params)

% generate mean, var, sine data from genArtificialData.m
if strcmp(data_params.which_data, 'mean') || strcmp(data_params.which_data, 'var') || ...
    strcmp(data_params.which_data, 'sine')

    % generate struct with artificial data parameters that can be
    % directly passed to genArtificialData function
    params.meanShift = data_params.difference;
    params.stdScale = data_params.difference;
    params.nuArr = data_params.difference;
    
    if strcmp(data_params.which_data, 'sine')
        params.dim=1;
    else
        params.dim = data_params.dimension;
    end
    [X,Y] = genArtificialData(m,1,data_params.which_data,params);
end

% grid of Gaussian with different shape
if strcmp(data_params.which_data, 'blobs')
    params.stretch=data_params.stretch;
    params.angle=data_params.angle;
    params.blob_distance=data_params.blob_distance;
    params.num_blobs=data_params.num_blobs;
    
    X=gaussian_blobs(params.stretch,pi/params.angle,params.blob_distance,params.num_blobs,m);
    Y=gaussian_blobs(1,0,params.blob_distance,params.num_blobs,m);
end

if strcmp(data_params.which_data, 'selection')
    dim=data_params.dimension;
    relevant=data_params.relevant;
    difference=data_params.difference;
    
    X=randn(m,dim);
    Y=randn(m,dim);

    % randomly add difference in one of the dims on Y with equal probability
    change=zeros(m, relevant);
    for i=1:m
        idx=randi(relevant);
        change(i,idx)=difference;
    end
    Y=[Y(:,1:relevant)+change, Y(:,relevant+1:dim)];

end

% amplitude modulated data
if strcmp(data_params.which_data, 'am')
    % load data into global memory to avoid performing the am in every test
    % iteration
    
    % first check whether music data is already in memory
    global global_X_am;
    global global_filename1_am;
    global global_window_length1_am;
    global global_Y_am;
    global global_filename2_am;
    global global_window_length2_am;
    
    % code readability
    N=data_params.window_length;
    
    filename1=strcat(data_params.wav_dir, data_params.wav1, '.wav');
    if isempty(global_X_am) || ~strcmp(filename1, global_filename1_am) ||...
            data_params.window_length~=global_window_length1_am
        
        % load wav files
        fprintf('loading wav file: %s\n', filename1);
        [song1,fs,~] = wavread(filename1);
        
        %ensure unit standard deviation for both songs
        song1 = song1/std(song1);
        song1 = mean(song1,2);
        
        fprintf('performing am\n');
        song1AM = genAMsig(song1,fs,data_params.f_multiple,data_params.f_transmit_multiple,data_params.offset,data_params.envelope_scale);
        song1AM = song1AM + data_params.added_noise*randn(size(song1AM,1),1);
        
        % reshape the audio signals into sample matrix
        X= song1AM(1:floor(length(song1AM)/N)*N);
        X=reshape(X,N,floor(length(song1AM)/N));
        
        % save to global variables 
        global_X_am=X';
        global_filename1_am=filename1;
        global_window_length1_am=data_params.window_length;
        
        %DEBUG: check the sound
        % sound(song1,fs);
    end
    
    
    filename2=strcat(data_params.wav_dir, data_params.wav2, '.wav');
    if isempty(global_Y_am) || ~strcmp(filename2, global_filename2_am) || ...
            data_params.window_length~=global_window_length2_am
        
        % load wav files
        fprintf('loading wav file: %s\n', filename2);
        [song2,fs,nbits] = wavread(filename2);
        song2 = song2/std(song2); %ensure unit standard deviation for both songs
        song2 = mean(song2,2);
        fprintf('performing am\n');
        song2AM = genAMsig(song2,fs,data_params.f_multiple,data_params.f_transmit_multiple,data_params.offset,data_params.envelope_scale);
        song2AM = song2AM + data_params.added_noise*randn(size(song2AM,1),1);
                
        % reshape the audio signals into sample matrix
        Y= song2AM(1:floor(length(song2AM)/N)*N);
        Y=reshape(Y,N,floor(length(song2AM)/N));
        
        % save to global variables 
        global_Y_am=Y';
        global_filename2_am=filename2;
        global_window_length2_am=data_params.window_length;
        
        %DEBUG: check the sound
        %sound(song2,fs);
    end
    
    % sample without replacement
    fprintf('sampling %d of %d data, %f percent\n',...
        m, size(global_X_am,1), m/size(global_X_am,1));
    inds_X=randperm(size(global_X_am,1));
    inds_X=inds_X(1:m);
    
    inds_Y=randperm(size(global_Y_am,1));
    inds_Y=inds_Y(1:m);
    
    X=global_X_am(inds_X, :);
    Y=global_Y_am(inds_Y, :);
end

if ~exist('X', 'var')
    fprintf('\"%s\" is an unsupported data type\n', data_params.which_data);
end
