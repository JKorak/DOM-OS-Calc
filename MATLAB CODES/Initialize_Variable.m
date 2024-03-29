function DataStruct=Initialize_Variable(DataStruct,row_num)

%OVERVIEW
%This function initializes the output variables in the data structure that
%will store all the optical surrogates that are extracted and calculated
%during the corrections process.


%INPUTS OR SCRIPT DEFINITIONS
%   DataStruct:  Data structure storing the inputs and outputs with one
%                sample per row in each field.
%   row_num:     Scalar with the number of samples in the batch to be
%                processed

%OUTPUTS
 %  DataStruct   Data structure is returned with the newly initialized
 %               variables.


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Initialize_Variable: Copyright (C) 2024 Julie A. Korak
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



%Initialize the Absorbance variables
Abs_SUVAname={'UV254','UV280','UV320','UV370','SUVA254','SUVA280','SUVA320','SUVA370'};
Abs_RatioNames={'E2E3_250','E2E3_254','E4E6','Sr'};
Abs_SSNames={'SS_300_700','SS_300_650','SS_300_600','SS_275_295','SS_350_400'};

for i=1:length(Abs_SUVAname)
DataStruct.Abs.(Abs_SUVAname{i})=nan(row_num,1);
end

for i=1:length(Abs_RatioNames)
DataStruct.Abs.(Abs_RatioNames{i})=nan(row_num,1);
end

for i=1:length(Abs_SSNames)
DataStruct.Abs.(Abs_SSNames{i})=nan(row_num,2);
end

for i=1:length(Abs_SSNames)
DataStruct.Abs.(Abs_SSNames{i})=nan(row_num,2);
end



%Initialize the Fluorescence variables
%Define vectors with names by category.
Fluor_Idx_Names={'FI','Peak370','HIX1999','HIX2002','Peak254','B_A','BIX','Peak310'};
Fluor_Pks_Names={'Afix','Bfix','Cfix','Tfix','A_Ex','A_Em','A_int','B_Ex','B_Em','B_int','C_Ex','C_Em','C_int','T_Ex','T_Em','T_int','OFI'};
Fluor_Sp_Names={'SpA','SpB','SpC','SpT'};
Fluor_F_A_Names={'PkC_UV320','PkC_UV280'};
 
%Step through each variable in names array and initialize variable for the
%number of samples
for i=1:length(Fluor_Idx_Names)
    DataStruct.Fluor.(Fluor_Idx_Names{i})=nan(row_num,1);
end

for i=1:length(Fluor_Pks_Names)
    DataStruct.Fluor.(Fluor_Pks_Names{i})=nan(row_num,1);
end

for i=1:length(Fluor_Sp_Names)
    DataStruct.Fluor.(Fluor_Sp_Names{i})=nan(row_num,1);
end

for i=1:length(Fluor_F_A_Names)
    DataStruct.Fluor.(Fluor_F_A_Names{i})=nan(row_num,1);
end


%Initialize variables that save a QC metric for each sample (e.g., Relative
%Scatter of fluorescence spectra or Absorbance standard deviation)
QC_Names={'AbsStdDev','HIX_QC','FI_QC','BIX_QC','PkA_QC','PkB_QC','PkC_QC','PkT_QC'};

for i=1:length(QC_Names)
    DataStruct.QC.(QC_Names{i})=nan(row_num,1);
end

%Initialize variables to save sample-specific QC thresholds
QCth_Names={'Abs','HIX','FI','BIX','PkA','PkB','PkC','PkT'};

for i=1:length(QC_Names)
    DataStruct.QC_th.(QCth_Names{i})=nan(row_num,1);
end
  
end