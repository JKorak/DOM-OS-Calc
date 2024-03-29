function DataStruct=FluorProcess(DataStruct,i,RootPath,plot_flag)

%OVERVIEW
%   Function reads in an already corrected EEM, applies a uniform masking
%   and interpolation for Rayleigh and Raman scattering. If the plot flag
%   is enabled, then a copy of the EEM is saved for visual quality
%   control. This function calls additional functions to calculate the
%   fluorescence based optical surrogates, including fluorescence index,
%   humification index, freshness index (2 methods), peak picking (2
%   methods), specific peak intensities, overall fluorescence intensity,
%   and absorbance-to-fluorescence ratios. 

%   The data read in functions assume the source files have a format that
%   matches the example files. Data import commands may need to be modified
%   if source files have a different format.

%INPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information
%   i:         Sample number corresponding to the input spreadsheet
%   RootPath:  Path location to project folder - determined in the
%              Data_Process.m
%   plot_flag  Enable relative scatter plot (1), or disable (0)


%OUTPUTS

%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   FluorProcess: Copyright (C) 2024 Julie A. Korak
%   Julie Korak
%   University of Colorado Boulder
%   Boulder, CO
%   korak@colorado.edu

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

%VERSION
%   1.0 March 2024 - First release

%__________________________________________________________________________

%Generate path and file name string for corrected EEM
EEM_File=strcat(RootPath,char(DataStruct.Input.TopFolder(i)),filesep,char(DataStruct.Input.Subfolder(i)),filesep,char(DataStruct.Input.Fluor_Name(i)),'.xls');

%Read in EEM file
if isfile(EEM_File) %Proceed if file exists as xls
    EEM=dlmread(EEM_File,'\t',0,0); %Assumes data starts in upper left cell (no row or column headers).
    if sum(EEM(:,end))==0 %trim if last column contains all zeros
        EEM=EEM(:,1:end-1); %Removes the last column of NaN values
    end
else
    %Try to import a csv with the same name
    EEM_File=strcat(RootPath,char(DataStruct.Input.TopFolder(i)),filesep,char(DataStruct.Input.Subfolder(i)),filesep,char(DataStruct.Input.Fluor_Name(i)),'.csv');
    EEM=csvread(EEM_File,0,0); %Assumes data starts in upper left cell (no row or column headers).
end

%Flip the EEM if data acquisition used descending excitation wavelengths
if strcmp(DataStruct.Input.Flipped{i},"Y")
    EEM=fliplr(EEM); %Assumes EEM file format has excitation wavelength by column and emission wavelengths by row
end

%Generate Vectors for Excitation and Emission Wavelengths for sample
%based on input spreadsheet
Ex=DataStruct.Input.Ex_min(i):DataStruct.Input.Ex_inc(i):DataStruct.Input.Ex_max(i);
Em=DataStruct.Input.Em_min(i):DataStruct.Input.Em_inc(i):DataStruct.Input.Em_max(i);

%Check if the size of the EEM matches the Ex and Em vectors
EEM_size=size(EEM);
size_comp=(EEM_size==[length(Em),length(Ex)]);
if size_comp==[logical(0),logical(0)]
    error(['For file #',num2str(i),', Both fluorescence wavelength vectors in input file do not match size of EEM.'])
elseif size_comp==[logical(0),logical(1)]
    error(['For file #',num2str(i),', Fluorescence emission wavelength vector in input file does not match size of EEM.'])
elseif size_comp==[logical(1),logical(0)]
    error(['For file #',num2str(i),', Fluorescence excitation wavelength vector in input file does not match size of EEM.'])

end

%Rayleigh Masking and Interpolation
EEM=MaskEEM(EEM,Ex,Em);

%Plot EEM if flag is enabled.
if plot_flag==1
    %Plot EEM and Save for QA/QC
    contourf(Em,Ex,EEM',15)
    xlabel('Emission Wavelength (nm)')
    ylabel('Excitation Wavelength (nm)')
    colorbar
    title(char(DataStruct.Input.Fluor_Name(i)))
    FigFormat(gcf,3,3,8) %Format figure size and font size
    
    %Save as pdf in subfolder in original EEM location
    savepath=char(strcat(RootPath,DataStruct.Input.TopFolder(i),filesep,DataStruct.Input.Subfolder(i)));
    
    %Make subfolder if it does not exist
    if not(isfolder(char(strcat(savepath,filesep,'EEM_Images',filesep))))
        mkdir(char(strcat(savepath,filesep,'EEM_Images',filesep)))
    end

    print(gcf,char(strcat(savepath,filesep,'EEM_Images',filesep,DataStruct.Input.Fluor_Name(i),'_EEM')),'-dpdf')
    
    %Save as .xls in subfolder in original EEM location
    %Make subfolder if it does not exist
    if not(isfolder(char(strcat(savepath,filesep,'Interp_EEM_Files',filesep))))
        mkdir(char(strcat(savepath,filesep,'Interp_EEM_Files',filesep)))
    end

    pathname=char(strcat(RootPath,DataStruct.Input.TopFolder(i),filesep,DataStruct.Input.Subfolder(i),filesep,'Interp_EEM_Files',filesep,DataStruct.Input.Fluor_Name(i),'_EEM.xls'));
    save(pathname,'EEM','-ascii','-double','-tabs')
end

%FileName for Noise outputs (if enabled)
NoiseName=strcat(DataStruct.Input.Fluor_Name(i),'_Noise');


%Calculate Indices
    %Fluorescence Index
    FI_Threshold=DataStruct.QC_th.FI(i);
    [FI,Em370,Rel_Scatter]=Eval_FI(EEM,Ex,Em,FI_Threshold,NoiseName,plot_flag);
    DataStruct.Fluor.FI(i,1)=FI;
    DataStruct.Fluor.Peak370(i,1)=mean(Em370); %average the emission wavelength if multiple wavelengths identified as peak.
    DataStruct.QC.FI_QC(i)=Rel_Scatter;

    %Humification index
    HIX_Threshold=DataStruct.QC_th.HIX(i);
    [HIX1999,HIX2002,Peak254,Rel_Scatter]=Eval_HIX(EEM,Ex,Em,HIX_Threshold,NoiseName,plot_flag);
    DataStruct.Fluor.HIX1999(i,1)=HIX1999;
    DataStruct.Fluor.HIX2002(i,1)=HIX2002;
    DataStruct.QC.HIX_QC(i,1)=Rel_Scatter;
    DataStruct.Fluor.Peak254(i,1)=mean(Peak254); %average the emission wavelength if multiple wavelengths identified as peak.
    %DataStruct.QC.HIX_QC(i)=Rel_Scatter;
    
    %B_A and BIX indices
    Fresh_Threshold=DataStruct.QC_th.BIX(i);
    [B_A,BIX,Peak310,Rel_Scatter]=Eval_Fresh(EEM,Ex,Em,Fresh_Threshold,NoiseName,plot_flag);
    DataStruct.Fluor.B_A(i,1)=B_A;
    DataStruct.Fluor.BIX(i,1)=BIX;
    DataStruct.Fluor.Peak310(i,1)=mean(Peak310); %average the emission wavelength if multiple wavelengths identified as peak.
    DataStruct.QC.BIX_QC(i)=Rel_Scatter;


    %Peak picking (Fixed)
    Peaks_Threshold=[DataStruct.QC_th.PkA(i), DataStruct.QC_th.PkB(i), DataStruct.QC_th.PkC(i) DataStruct.QC_th.PkT(i)];%order is [A B C T]
    [Afix,Bfix,Cfix,Tfix,Ascat,Bscat,Cscat,Tscat]=Eval_FixedPeaks(EEM,Ex,Em,Peaks_Threshold,NoiseName,plot_flag);
    DataStruct.Fluor.Afix(i,1)=Afix;
    DataStruct.Fluor.Bfix(i,1)=Bfix;
    DataStruct.Fluor.Cfix(i,1)=Cfix;
    DataStruct.Fluor.Tfix(i,1)=Tfix;
    DataStruct.QC.PkA_QC(i)=Ascat; %Save relative scatter for peak A
    DataStruct.QC.PkB_QC(i)=Bscat; %Save relative scatter for peak B
    DataStruct.QC.PkC_QC(i)=Cscat; %Save relative scatter for peak C
    DataStruct.QC.PkT_QC(i)=Tscat; %Save relative scatter for peak T

    %Peak Picking (Algorithm)
    [A,B,C,T]=Eval_Peaks(DataStruct,EEM,Ex,Em,i);
    DataStruct.Fluor.A_Ex(i,1)=A(1);DataStruct.Fluor.A_Em(i,:)=A(2);DataStruct.Fluor.A_int(i,:)=A(3);
    DataStruct.Fluor.B_Ex(i,1)=B(1);DataStruct.Fluor.B_Em(i,:)=B(2);DataStruct.Fluor.B_int(i,:)=B(3);
    DataStruct.Fluor.C_Ex(i,1)=C(1);DataStruct.Fluor.C_Em(i,:)=C(2);DataStruct.Fluor.C_int(i,:)=C(3);
    DataStruct.Fluor.T_Ex(i,1)=T(1);DataStruct.Fluor.T_Em(i,:)=T(2);DataStruct.Fluor.T_int(i,:)=T(3);

    %Specific Peak Intensities
    [SpA,SpB,SpC,SpT]=Eval_SpPeaks(DataStruct,i,'fixed'); %User can defined fixed or algorithm approach
    DataStruct.Fluor.SpA(i)=SpA;
    DataStruct.Fluor.SpB(i)=SpB;
    DataStruct.Fluor.SpC(i)=SpC;
    DataStruct.Fluor.SpT(i)=SpT;

    %Overall Fluorescence Intensity
    DataStruct.Fluor.OFI(i,1)=Eval_OFI(EEM,Ex,Em);

    %Pseudo QY
    DataStruct.Fluor.PkC_UV320(i,1)=DataStruct.Fluor.Cfix(i,1)/ DataStruct.Abs.UV320(i);
    DataStruct.Fluor.PkC_UV280(i,1)=DataStruct.Fluor.Cfix(i,1)/ DataStruct.Abs.UV370(i);
end