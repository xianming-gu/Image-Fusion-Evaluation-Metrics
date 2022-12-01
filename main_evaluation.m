clc
clear all

% % % % % % % % % % % % 以下参数可修改 % % % % % % % % % % % % 

%%%%%%%%% easy = 1 / 0 %%%%%%%%%
easy = 0; % easy =1 表示测试运行不费时间的指标, easy=0 表示测试费时间的指标

%%%%%%%%% CT-MRI %%%%%%%%%
% fileFolder=fullfile('E:\Data\MyDatasets\CT-MRI\test\CT'); % CT-MRI图像所在文件夹
% ir_dir = 'E:\Data\MyDatasets\CT-MRI\test\CT'; % CT所在文件夹
% vi_dir = 'E:\Data\MyDatasets\CT-MRI\test\MRI'; % MRI所在文件夹

% %%%%%%%%% PET-MRI %%%%%%%%%
% fileFolder=fullfile('E:\Data\MyDatasets\PET-MRI\test\PET'); % PET-MRI所在文件夹
% ir_dir = 'E:\Data\MyDatasets\PET-MRI\test\PET'; % PET所在文件夹
% vi_dir = 'E:\Data\MyDatasets\PET-MRI\test\MRI'; % MRI所在文件夹

%%%%%%%%% SPECT-MRI %%%%%%%%%
fileFolder=fullfile('E:\Data\MyDatasets\SPECT-MRI\test\SPECT'); % SPECT-MRI所在文件夹
ir_dir = 'E:\Data\MyDatasets\SPECT-MRI\test\SPECT'; % SPECT所在文件夹
vi_dir = 'E:\Data\MyDatasets\SPECT-MRI\test\MRI'; % MRI所在文件夹

%%%%%%%%% 其他 %%%%%%%%%
% fileFolder=fullfile('E:\Data\CT-MRI_new\CT'); % SPECT-MRI所在文件夹
% ir_dir = 'E:\Data\CT-MRI_new\CT'; % SPECT所在文件夹
% vi_dir = 'E:\Data\CT-MRI_new\MRI-T2'; % MRI所在文件夹

%%%%%%%% 图像的文件名列表&后缀名 %%%%%%%%
dirOutput=dir(fullfile(fileFolder,'*.png'));

%%%%%%%% 融合图像所在文件夹 %%%%%%%%
Fused_dir = 'E:\ExperimentData\TransIF\0\SPECT_ssim1_no_bs4'; % 融合图像所在文件夹

%%%%%%%% 写入excel时的文件名及路径 %%%%%%%%
file_name = 'E:\ImageFusionEvaluation\Evaluation-code_Matlab\EvaluationResults\New_Evaluation\MyModel-SPECT_ssim1_no_bs4.xls';
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

names_dir = strsplit(file_name,'\');
names_dir2 = strsplit(names_dir{end},'.');
names = names_dir2{1};

row_name1 = 'row1';
row_data1 = 'row2';


method_name = cellstr(names);
row = 'A';
row_name = strrep(row_name1, 'row', row);  % A1
row_data = strrep(row_data1, 'row', row);  % A2

fileNames = {dirOutput.name};
[m, num] = size(fileNames);

EN_set = [];    SF_set = [];SD_set = [];PSNR_set = [];
MSE_set = [];MI_set = [];VIF_set = []; AG_set = [];
CC_set = [];SCD_set = []; Qabf_set = [];
SSIM_set = []; MS_SSIM_set = [];
Nabf_set = [];FMI_pixel_set = [];
FMI_dct_set = []; FMI_w_set = [];
for j = 1:num
    fileName_source_ir = fullfile(ir_dir, fileNames{j});
    fileName_source_vi = fullfile(vi_dir, fileNames{j}); 
    fileName_Fusion = fullfile(Fused_dir, fileNames{j});
    ir_image = imread(fileName_source_ir);
    vi_image = imread(fileName_source_vi);
    fused_image   = imread(fileName_Fusion);
    if size(ir_image, 3)>2
        ir_image = rgb2gray(ir_image);
    end

    if size(vi_image, 3)>2
        vi_image = rgb2gray(vi_image);
    end

    if size(fused_image, 3)>2
        fused_image = rgb2gray(fused_image);
    end
    [m, n] = size(fused_image);
%     fused_image = fused_image(7:m-6, 7:n-6);
    ir_size = size(ir_image);
    vi_size = size(vi_image);
    fusion_size = size(fused_image);
    if length(ir_size) < 3 && length(vi_size) < 3
        [EN, SF,SD,PSNR,MSE, MI, VIF, AG, CC, SCD, Qabf, Nabf, SSIM, MS_SSIM, FMI_pixel, FMI_dct, FMI_w] = analysis_Reference(fused_image,ir_image,vi_image, easy);
        EN_set = [EN_set, EN];SF_set = [SF_set,SF];SD_set = [SD_set, SD];PSNR_set = [PSNR_set, PSNR];
        MSE_set = [MSE_set, MSE];MI_set = [MI_set, MI]; VIF_set = [VIF_set, VIF];
        AG_set = [AG_set, AG]; CC_set = [CC_set, CC];SCD_set = [SCD_set, SCD];
        Qabf_set = [Qabf_set, Qabf]; Nabf_set = [Nabf_set, Nabf];
        SSIM_set = [SSIM_set, SSIM]; MS_SSIM_set = [MS_SSIM_set, MS_SSIM];
        FMI_pixel_set = [FMI_pixel_set, FMI_pixel]; FMI_dct_set = [FMI_dct_set,FMI_dct];
        FMI_w_set = [FMI_w_set, FMI_w];
    else
        disp('unsucessful!')
        disp( fileName_Fusion)
    end
    fprintf('Fusion Method:%s, Image Name: %s\n', cell2mat(method_name), fileNames{j})
end
if easy ==1
    evaluation_name ={'EN', 'SF','SD','PSNR','MSE', 'MI', 'VIF', 'AG', 'CC', 'SCD', 'Qabf'};
    xlswrite(file_name,evaluation_name)
%     xlswrite(file_name, 'SF')
%     xlswrite(file_name, 'SD') 
%     xlswrite(file_name, 'PSNR')
%     xlswrite(file_name,'MSE')
%     xlswrite(file_name,'MI')
%     xlswrite(file_name,'VIF')
%     xlswrite(file_name,'AG')
%     xlswrite(file_name,'CC')
%     xlswrite(file_name,'SCD')
%     xlswrite(file_name,'Qabf')

    xlswrite(file_name,EN_set','Sheet1','A2')
    xlswrite(file_name,SF_set','Sheet1','B2')
    xlswrite(file_name,SD_set','Sheet1','C2') 
    xlswrite(file_name,PSNR_set','Sheet1','D2')
    xlswrite(file_name,MSE_set','Sheet1','E2')
    xlswrite(file_name,MI_set','Sheet1','F2')
    xlswrite(file_name,VIF_set','Sheet1','G2')
    xlswrite(file_name,AG_set','Sheet1','H2')
    xlswrite(file_name,CC_set','Sheet1','I2')
    xlswrite(file_name,SCD_set','Sheet1','J2')
    xlswrite(file_name,Qabf_set','Sheet1','K2')
else        
    evaluation_name ={'Nabf', 'SSIM', 'MS_SSIM', 'FMI_pixel', 'FMI_dct', 'FMI_w'};
    xlswrite(file_name,evaluation_name,'Sheet1','L1')
%     xlswrite(file_name, method_name,'Nabf',row_name)
%     xlswrite(file_name, method_name,'SSIM',row_name)
%     xlswrite(file_name, method_name,'MS_SSIM',row_name)
%     xlswrite(file_name, method_name,'FMI_pixel',row_name)
%     xlswrite(file_name, method_name,'FMI_dct',row_name)
%     xlswrite(file_name, method_name,'FMI_w',row_name)

    xlswrite(file_name,Nabf_set','Sheet1','L2')
    xlswrite(file_name,SSIM_set','Sheet1','M2')
    xlswrite(file_name,MS_SSIM_set','Sheet1','N2')
    xlswrite(file_name,FMI_pixel_set','Sheet1','O2')
    xlswrite(file_name,FMI_dct_set','Sheet1','P2')
    xlswrite(file_name,FMI_w_set','Sheet1','Q2')
end