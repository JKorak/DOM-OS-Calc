function DataStruct=AbsProcess(DataStruct,i,RootPath)

%OVERVIEW
%   Function reads in an absorbance file, normalizes absorbance to a
%   pathlength of 1 cm, and baseline corrects the data. Baseline correction
%   uses the last 25 nm if the maximum wavelength measured is <700nm and
%   the last 50 nm is the maximum wavelength measured is >700 nm. The
%   spectra is not baseline corrected if the maximum mwavelength is <600
%   nm. The standard deviation of the spectral range used for baseline
%   correction is recorded in the data structure to assess noise. This
%   function calls additional functions to calculate the absorbance based
%   optical surrogates, including SUVA, absorbance ratios and spectral
%   slopes.

%   The data import functions assume the source files have a format that
%   matches the example files. Data read commands may need to be modified
%   if source files have a different format.

%INPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information
%   i:         Sample number corresponding to the input spreadsheet
%   RootPath:  Path location to project folder - determined in the
%              Data_Process.m


%OUTPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   AbsProcess: Copyright (C) 2024 Julie A. Korak
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


  
%% Read in and baseline correct file
%Absorbance File Location
Abs_File=strcat(RootPath,char(DataStruct.Input.TopFolder(i)),filesep,char(DataStruct.Input.Subfolder(i)),filesep,char(DataStruct.Input.Abs_Name(i)),'.csv');

%Read pathlength from data structure
pathlength=DataStruct.Input.Pathlength(i);

%Check if Abs data has a header row
fid=fopen(Abs_File);
header=textscan(fid,'%n%n',1);
  
%Determine the start row for reading in data depending on if header has
%numbers or text
if isempty(header{1,1})
    Abs=csvread(Abs_File,1,0);
else
    Abs=csvread(Abs_File,0,0);
end
  
%Extract absorption wavelength vectors
Wave=Abs(:,1);

%Extract absorbance vector and normalize pathlength to 1 cm
Abs=Abs(:,2)/pathlength;

%Check if UV wavelengths are in ascending or descending order
Diff=Wave(2)-Wave(1);

if Diff<0 %Flip vectors if descending order
    Wave=flipud(Wave);
    Abs=flipud(Abs);
end

%Check if the wavelength vector in the input spreadsheet matches the
%imported data.
Wave_input=[DataStruct.Input.Wave_min(i):DataStruct.Input.Wave_inc(i):DataStruct.Input.Wave_max(i)]';
if all(size(Wave_input)==size(Wave))
    match=Wave==Wave_input;
else
    match=0;
end

if match==0
    disp(['For file #',num2str(i),', Absorbance wavelengths in input file do not match spectra file.'])
    disp('Wavelengths in spectra file used.')
end

%Baseline Correct Abs Data 
%Find maximum wavelength
Wave_max=Wave(end);
  
if Wave_max<600
    disp(['Abs sample #',num2str(i),' was not baseline corrected'])
elseif Wave_max<=700
    idx_end=wave_match(Wave,Wave_max-25);
    BL=mean(Abs(idx_end:end));
    Abs=Abs-BL;
    DataStruct.QC.AbsStdDev(i)=std(Abs(idx_end:end));
else
    idx_end=wave_match(Wave,Wave_max-50);
    BL=mean(Abs(idx_end:end));
    Abs=Abs-BL;
    DataStruct.QC.AbsStdDev(i)=std(Abs(idx_end:end));
end
  

%% Calculate absorbance based optical metrics 

QC_Threshold=DataStruct.QC_th.Abs(i);
DOC=DataStruct.Input.DOC(i);

%Calculate Abs and SUVA
%254 nm
[Abs254,SUVA254]=UV_SUVA(Wave,Abs,254,DOC,pathlength,QC_Threshold);
DataStruct.Abs.UV254(i)=Abs254; %Enter into data structure
DataStruct.Abs.SUVA254(i)=SUVA254; %Enter into data structure

%280 nm
[Abs280,SUVA280]=UV_SUVA(Wave,Abs,280,DOC,pathlength,QC_Threshold);
DataStruct.Abs.UV280(i)=Abs280; %Enter into data structure
DataStruct.Abs.SUVA280(i)=SUVA280; %Enter into data structure

%320 nm
[Abs320,SUVA320]=UV_SUVA(Wave,Abs,320,DOC,pathlength,QC_Threshold);
DataStruct.Abs.UV320(i)=Abs320; %Enter into data structure
DataStruct.Abs.SUVA320(i)=SUVA320; %Enter into data structure

%370 nm
[Abs370,SUVA370]=UV_SUVA(Wave,Abs,370,DOC,pathlength,QC_Threshold);
DataStruct.Abs.UV370(i)=Abs370; %Enter into data structure
DataStruct.Abs.SUVA370(i)=SUVA370; %Enter into data structure
 
%Calculate Absorbance Ratios
[E2E3_250]=UVratios(Wave,Abs,250,365,pathlength,QC_Threshold);
DataStruct.Abs.E2E3_250(i)=E2E3_250;

[E2E3_254]=UVratios(Wave,Abs,254,365,pathlength,QC_Threshold);
DataStruct.Abs.E2E3_254(i)=E2E3_254;

[E4E6]=UVratios(Wave,Abs,465,665,pathlength,QC_Threshold);
DataStruct.Abs.E4E6(i)=E4E6;

 
%Spectral Slope
%The QC criterium is applied to the longest wavelength for the linearized
%calculations. All slopes are reported for the non-linear fits.
 
 %Linearized spectral slope from 275-295 nm (Helms 2008, 2013 (linear reg),
 %Fichot 2012 (log linearized))
 [SS1,Frac1]=Abs_SS_Linear(Wave,Abs,275,295,pathlength,QC_Threshold);
 DataStruct.Abs.SS_275_295(i,:)=[SS1,Frac1];
 
 
 %Linearized spectral slope from 350-400 nm 
 [SS2,Frac2]=Abs_SS_Linear(Wave,Abs,350,400,pathlength,QC_Threshold);
 DataStruct.Abs.SS_350_400(i,:)=[SS2,Frac2];
 
  %Calculated slope ratio
  if ~isnan(SS1) && ~isnan(SS2)
      DataStruct.Abs.Sr(i)=SS1/SS2;
  else
      DataStruct.Abs.Sr(i)=NaN;
  end
 
  
  %Non-linear spectral slope. All fitted parameters are reported. No QC
  %Threshold is applied. NaN is reported if solver failed to converge.
  
  %Non-linear spectral slope from 300 - 700 nm (Helms 2008, Helms 2013)
  [SS,Frac1,Flag]=Abs_SS_Exp(Wave,Abs,300,700,pathlength,QC_Threshold);
  
  if Flag==1
      DataStruct.Abs.SS_300_700(i,:)=[SS,Frac1];
  end
  
  
  %Non-linear spectral slope from 300-650 nm (Stedmon 2000, Kowalczuk 2005)
  
  [SS,Frac2,Flag]=Abs_SS_Exp(Wave,Abs,300,650,pathlength,QC_Threshold);
  if Flag==1
      DataStruct.Abs.SS_300_650(i,:)=[SS,Frac2];
  end
  
  %Non-linear spectral slope from 300-600 nm for least common denominator
  %between meta-analysis datasets.
  [SS,Frac3,Flag]=Abs_SS_Exp(Wave,Abs,300,600,pathlength,QC_Threshold);
  if Flag==1
      DataStruct.Abs.SS_300_600(i,:)=[SS,Frac3];
  end
end