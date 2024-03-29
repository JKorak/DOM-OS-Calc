function DataStruct=DefineQCThresholds(DataStruct,QC_Var,threshold,varargin)
%OVERVIEW
%   Functions assigns the user-specified QC thresholds to each sample in
%   the input file. Thresholds can be assigned uniformily to each sample,
%   or to categories of samples using the metadata.


%INPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information and saved in
%              rootpath/Output folder
%   QC_Var:    Character string with the optical surrogate name 
%   threshold  Scalar value for the threshold
%   varargin   String. user can specify 'all' to assign threshold to all
%              samples or use a name-value pair to assign threshold to a subset of
%              data based on field in the input file (e.g., 'Project_Name','State_CO')


%OUTPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information
%   


%EXAMPLE
%   DataStruct=DefineQCThresholds(DataStruct,'Abs',QC.Abs,'all');
%   DataStruct=DefineQCThresholds(DataStruct,'Abs',0.02,'Project_Name','State_CO');




%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   DefineQCThresholds: Copyright (C) 2024 Julie A. Korak
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


if nargin<4
    disp('Not enough input arguments')
    return
end

vararg_len=length(varargin);
%Check input arguments for compatability
if vararg_len==1 %Only 1 input argument is specified
    %Check if input argument is 'all'
    if ~strcmp(varargin,'all')
        error('Invalid input argument to define QC thresholds. Must specify "all" if not called using name-value pairs')
        return
    else
        DataStruct.QC_th.(QC_Var)(:)=threshold;
    end
    

else
    %Check if odd number is input for name-value pairs
    if rem(vararg_len,2)~=0
        error('Invalid number of input arguments for name-value pairs')
        return
    end
    
    name_vec=varargin(1:2:end-1);
    value_vec=varargin(2:2:end);
    
    Input_names=fieldnames(DataStruct.Input);
    
    %Check if name_vec matches input metadata
    if ~all(ismember(name_vec,Input_names))
        error('Mismatch between name argument and input metadata fields')
        return
    end
    
    Samp_num=size(DataStruct.Input.Abs_Name,1);
    
    idx=zeros(Samp_num,1);
    
    for i=1:length(name_vec)
        name=name_vec(i);
        idx_i=strcmp(DataStruct.Input.(name_vec{i}),value_vec{i});
        if sum(idx_i)==0
            error('Value not found for name-value pair')
        else
            idx=idx+idx_i;
        end
    end
    
    idx_QC=(idx==length(name_vec));
    if ~any(idx_QC)
        error('No samples matching all name-value pairs found')
    else
    DataStruct.QC_th.(QC_Var)(idx_QC)=threshold;
    end
end
    
   
end