function DataStruct=OutlierScreen(DataStruct,ptile)

%OVERVIEW
%   This function identifies and excludes outliers based on a percentile. The
%   code steps through each optical surrogate and enters a NaN if the
%   surrogate falls in the upper or lower percentile specified. If identified,
%   only the value for that surrogate is excluded, not all surrogates for that
%   sample.

%INPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information
%   ptile      Scalar as a percent for the upper and lower percentiles to
%              exclude (e.g., 0.5 excludes the the upper and lower 0.5%)
%   
    
%OUTPUT
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information
    

%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   OutlierScreen: Copyright (C) 2024 Julie A. Korak
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
   


%Function screens out the outliers (positive and negative) based on a
%percentile.

Tier1names=fieldnames(DataStruct);
idx_op=and(and(~strcmp(Tier1names,'Input'),~strcmp(Tier1names,'QC')),~strcmp(Tier1names,'QC_th')); %Tier 1 fields to exclude
idx_op_pos=find(idx_op==1); 


for i=1:sum(idx_op)

Tier2Names=fieldnames(DataStruct.(Tier1names{idx_op_pos(i)}));

if strcmp(Tier1names{idx_op_pos(i)},'Fluor')
    %For the algorithmic peak picking, the wavelengths are only reported if the
    %corresponding intensity is reported. The percentiles are not applied to
    %the wavelengths.
    T2_ex={'A_Ex','A_Em','B_Ex','B_Em','C_Ex','C_Em','T_Ex','T_Em'}; %Tier 2 field names to exlude
    idx_ex=zeros(length(Tier2Names),1);

    for k=1:length(T2_ex)
        idx=find(strcmp(Tier2Names,T2_ex{k}));
        idx_ex(idx,1)=1;
    end
    jvec=find(idx_ex~=1)';

else
    jvec=1:length(Tier2Names);
end


for j=jvec
    vec=DataStruct.(Tier1names{idx_op_pos(i)}).(Tier2Names{j});
    cutoff=prctile(vec(:,1),[ptile,100-ptile]);
    low=vec(:,1)<=cutoff(1);
    high=vec(:,1)>=cutoff(2);
    U=logical(low+high);
    vec(U,1)=NaN;
    DataStruct.(Tier1names{idx_op_pos(i)}).(Tier2Names{j})=vec;
end

%Censor the peak wavelengths if the intensity is censored

%Find censored peak A intensities
vec=DataStruct.Fluor.A_int;
idx_cnsr=isnan(vec);
%Censor peak wavelengths
DataStruct.Fluor.A_Ex(idx_cnsr)=NaN;
DataStruct.Fluor.A_Em(idx_cnsr)=NaN;

%Find censored peak B intensities
vec=DataStruct.Fluor.B_int;
idx_cnsr=isnan(vec);
%Censor peak wavelengths
DataStruct.Fluor.B_Ex(idx_cnsr)=NaN;
DataStruct.Fluor.B_Em(idx_cnsr)=NaN;

%Find censored peak C intensities
vec=DataStruct.Fluor.C_int;
idx_cnsr=isnan(vec);
%Censor peak wavelengths
DataStruct.Fluor.C_Ex(idx_cnsr)=NaN;
DataStruct.Fluor.C_Em(idx_cnsr)=NaN;

%Find censored peak T intensities
vec=DataStruct.Fluor.T_int;
idx_cnsr=isnan(vec);
%Censor peak wavelengths
DataStruct.Fluor.T_Ex(idx_cnsr)=NaN;
DataStruct.Fluor.T_Em(idx_cnsr)=NaN;

end

end
