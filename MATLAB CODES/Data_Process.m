function DataStruct=Data_Process(NameList,Rows,plot_flag,QC_flag,Out_perc)
%OVERVIEW
%   Functions reads in an input file that lists all the samples for which
%   to calculate the optical surrogates. Please see example files for
%   documentation of input file format and set up. This function also
%   assumes that the files are organized in a systematic file structure as
%   outlined in the example package. 

%   This function calls the subfunctions to calculate both absorbance- and
%   fluorescence-based surrogates. The user specifies in this function
%   whether to apply quality control criteria prior to reporting
%   surrogates.


%INPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information
%   NameList:  Character string with the filename of the input file
%   Row:       Vector of continuous rows in the input file to process
%              Example: [1:100] or [50:250]
%   plot_flag  Integer (1 or 0) to enable (1) or disable (0) plotting
%   QC_flag    Integer (1 or 0) to enable (1) or disable (0) application of
%              QC criteria
%   Out_perc   Scalar (0 to 100) to exclude outliers based on a data
%              percentile. A value of 0 retains all data


%OUTPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information and saved in
%              rootpath/Output folder
%   

%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Data_Process: Copyright (C) 2024 Julie A. Korak

%   This m-file was published as an article supplement. If used,
%   please cite the original article:

%       Korak, J.A. and McKay G. (2024) Meta-Analysis of Optical Surrogates for the
%       Characterization of Dissolved Organic Matter. Environmental Science and
%       Technology. 
% 
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   any later version.
% 
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
% 
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <https://www.gnu.org/licenses/>.
%__________________________________________________________________________


% Set QC thresholds
if QC_flag==1
    %NOTE: Users are responsible to assessing appropriate QC thresholds for
    %instrument, method, and sample context and updating these thresholds as
    %appropriate.
    QC.Abs=0.005; %Minimum absorbance threshold
    QC.HIX=0.04;  %Maximum RSMD 
    QC.BIX=0.008;
    QC.FI=0.009;
    QC.PkA=0.02;
    QC.PkB=0.16;
    QC.PkC=0.008;
    QC.PkT=0.02;
else
    %Set all fluorescence to very large, unrealistic numbers. Set Abs to
    %zero
    QC.Abs=0;
    QC.HIX=1e6;
    QC.BIX=1e6;
    QC.FI=1e6;
    QC.PkA=1e6;
    QC.PkB=1e6;
    QC.PkC=1e6;
    QC.PkT=1e6;
end

%%
%Root file location
%UPDATE THIS SECTION FOR DIFFERENT PROJECT-SPECIFIC DIRECTORY STRUCTURE
CodePath=cd;
cd ..
RootPath=cd;
RootPath=strcat(RootPath,filesep);
cd(CodePath)
fclose('all');
%Read in Input File
Input_List=strcat(RootPath,'Input Files',filesep,NameList,'.txt');


%%
fid=fopen(Input_List);
Headers=textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s',1);
InputMat=textscan(fid,'%s%s%s%n%n%n%n%s%s%n%n%n%n%n%n%n%s%s%s%s%s','headerlines',1);
row_num=size(InputMat{1,1},1); %Number of rows in the input file



%Build Input Data Structure
DataStruct=BuildStruct(Headers,InputMat);%DataStruct variable is created

%Initialize Variables
DataStruct=Initialize_Variable(DataStruct,row_num); %Initializes variables in the output structure

%Add QC thresholds to structure
%USER TO DEFINE THRESHOLDS. Different Thresholds can be applied based on different metadata 
try
    DataStruct=DefineQCThresholds(DataStruct,'Abs',QC.Abs,'all');
    DataStruct=DefineQCThresholds(DataStruct,'HIX',QC.HIX,'all');
    DataStruct=DefineQCThresholds(DataStruct,'BIX',QC.BIX,'all');
    DataStruct=DefineQCThresholds(DataStruct,'FI',QC.FI,'all');
    DataStruct=DefineQCThresholds(DataStruct,'PkA',QC.PkA,'all');
    DataStruct=DefineQCThresholds(DataStruct,'PkB',QC.PkB,'all');
    DataStruct=DefineQCThresholds(DataStruct,'PkC',QC.PkC,'all');
    DataStruct=DefineQCThresholds(DataStruct,'PkT',QC.PkT,'all');
    
    %Define project specific thresholds. Uncomment the lines below to
    %enable.
        %DataStruct=DefineQCThresholds(DataStruct,'Abs',0.02,'Project_Name','Coagulation');
        %DataStruct=DefineQCThresholds(DataStruct,'Abs',0.02,'Project_Name','State_CO');

catch ME
    msg=['Error defining QC thresholds']
    getReport(ME)
    return
end
    

%Step through Rows
count=0;
for i=Rows
close all
        
    %Process Absorbance Data
    try
        DataStruct=AbsProcess(DataStruct,i,RootPath);
    catch ME
       msg=['Abs error on # ' num2str(i)]
       getReport(ME)
       disp('Processing terminating....')
       break
    end

    %Check if sample has fluorescence data
    if ~strcmp(DataStruct.Input.Fluor_Name(i),'NaN')
        try
            DataStruct=FluorProcess(DataStruct,i,RootPath,plot_flag);
        catch ME
            
            msg=['Fluor error on # ' num2str(i)]
            getReport(ME)
            disp('Processing terminating....')
            break
        end
    end

    if mod(i,50)==1
        msg=['Processed # ' num2str(i)];
    end
    count=count+1;
end

%Screen the outliers out
if Out_perc>0
    DataStruct=OutlierScreen(DataStruct,Out_perc);
end

%Save DataStruct
if QC_flag==1
    datatag='_QC';
else
    datatag='_noQC';
end

%Write Data to File
T=[struct2table(DataStruct.Input) struct2table(DataStruct.Abs) struct2table(DataStruct.Fluor) struct2table(DataStruct.QC)];

%Move Sr after SS_350_400
T=movevars(T,"Sr",'After',"SS_350_400");

T=HeaderRename(T);
Output_Filename=strcat(RootPath,filesep,'Output',filesep,NameList,datatag,'.txt');
writetable(T,Output_Filename,'delimiter','\t');


mat_filename=strcat(RootPath,'Output',filesep,NameList,datatag);
eval(strcat('All',datatag,'=DataStruct;'));
save(mat_filename,strcat('All',datatag));


disp([num2str(count),' samples were processed'])

fclose(fid);
