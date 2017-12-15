DataFolder = 'C:\Users\Niklas Brake\Documents\01 Education\School\040 Computer Science\COMP 551\Project 4';
%%%%%%%%%%%%%%%%%%%%%% Training Data %%%%%%%%%%%%%%%%%%%%%%
% [offset] [type]          [value]          [description] 
% 0000     32 bit integer  0x00000803(2051) magic number 
% 0004     32 bit integer  60000            number of images 
% 0008     32 bit integer  28               number of rows 
% 0012     32 bit integer  28               number of columns 
% 0016     unsigned byte   ??               pixel 
% 0017     unsigned byte   ??               pixel 
% ........ 
% xxxx     unsigned byte   ??               pixel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(fullfile(DataFolder,'MNIST','train-images.idx3-ubyte'));
info = fread(fid,4,'int32','b');
training_data = fread(fid,[info(3)*info(4) info(2)],'uint8','b')';

% Normalize each vector
for i = 1:info(2)
	training_data(i,:) = training_data(i,:)/norm(training_data(i,:)) * 28;
end

%%%%%%%%%%%%%%%%%%%%% Training Labels %%%%%%%%%%%%%%%%%%%%%
% [offset] [type]          [value]          [description] 
% 0000     32 bit integer  0x00000801(2049) magic number (MSB first) 
% 0004     32 bit integer  60000            number of items 
% 0008     unsigned byte   ??               label 
% 0009     unsigned byte   ??               label 
% ........ 
% xxxx     unsigned byte   ??               label
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(fullfile(DataFolder,'MNIST','train-labels.idx1-ubyte'));
info = fread(fid,2,'int32','b');
training_labels = fread(fid,'uint8','b');


%%%%%%%%%%%%%%%%%%%%%%%% Test Data %%%%%%%%%%%%%%%%%%%%%%%%
% [offset] [type]          [value]          [description] 
% 0000     32 bit integer  0x00000803(2051) magic number 
% 0004     32 bit integer  10000            number of images 
% 0008     32 bit integer  28               number of rows 
% 0012     32 bit integer  28               number of columns 
% 0016     unsigned byte   ??               pixel 
% 0017     unsigned byte   ??               pixel 
% ........ 
% xxxx     unsigned byte   ??               pixel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(fullfile(DataFolder,'MNIST','t10k-images.idx3-ubyte'));
info = fread(fid,4,'int32','b');
test_data = fread(fid,[info(3)*info(4) info(2)],'uint8','b')';

% Normalize each vector
for i = 1:info(2)
	test_data(i,:) = test_data(i,:)/norm(test_data(i,:)) * 28;
end

%%%%%%%%%%%%%%%%%%%%%%% Test Labels %%%%%%%%%%%%%%%%%%%%%%%
% [offset] [type]          [value]          [description] 
% 0000     32 bit integer  0x00000801(2049) magic number (MSB first) 
% 0004     32 bit integer  10000            number of items 
% 0008     unsigned byte   ??               label 
% 0009     unsigned byte   ??               label 
% ........ 
% xxxx     unsigned byte   ??               label
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(fullfile(DataFolder,'MNIST','t10k-labels.idx1-ubyte'));
info = fread(fid,2,'int32','b');
test_labels = fread(fid,'uint8','b');

