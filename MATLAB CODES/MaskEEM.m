function EEM_Out=MaskEEM(EEMin,ex,em)

%OVERVIEW
% This function masks the EEM for 1st and 2nd order scatter.
%Intensities at emission wavelengths below 1st order Rayleigh scattering
%are set to NaN. Then, the masked areas at emission wavelengths greater than
%1st order Rayleigh scattering peak are interpolated.

%INPUTS
% EEMin     2D matrix with corrected intensities (EEM) formatted with rows as
%           emission wavelength and columns as excitation wavelength, both in ascending order
% ex        Vector of excitation wavelengths
% em        Vector of emission wavelengths


%OUTPUTS
% EEM_Out   Masked and interpolated EEM formatted with rows as
%           emission wavelength and columns as excitation wavelength.



%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   MaskEEM: Copyright (C) 2024 Julie A. Korak
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


%Set the masking criteria. These values can be modified for specific
%methods. The margins for masking depend on the bandpass in the method and
%may be different for 1st and 2nd order scatter.

Ray1=12; %Margin for first order Rayleigh scattering
Ray2=16; %Margin for second order Rayleigh scattering

%Set any previously masked intensities to NaN
idx=(EEMin==0);
EEMin(idx)=NaN;

%Mask corrected EEM
for j=1:length(ex) %Loop that increments through each excitation wavelength
    L_ex=ex(j); %Extract excitation wavelength
      
    %Find index locations for the emission wavelengths at and below 1st
    %order Rayleigh scattering
    idx=(em<=L_ex+Ray1);

    %Set intensities equal to zero
    EEMin(idx,j)=0;

    %Find index locations for 2nd order Rayleigh scatter and set to NaN
    idx=(em<=2*L_ex+Ray2) & (em>=2*L_ex-Ray2);

    %Set intensities equal to zero
    EEMin(idx,j)=NaN;

end


%Interpolate the 2nd order scatter. Sort and reshape the data from 2D
%matrix to 1D vectors. 

%Initialize vectors

    %Vectors for measured intensities
    Ex_vec=[]; %Excitation vector
    Em_vec=[]; %Emission vector
    I_vec=[];  %Intensity vector
    
    %Vectors for wavelength combinations to interpolate
    Ex_query=[]; %Excitation vector
    Em_query=[]; %Emission vector


%Sort measurement
for i=1:length(ex)
    for j=1:length(em)
        if ~isnan(EEMin(j,i)) %Measured intensities added to vectors for fitting
            Ex_vec=[Ex_vec;ex(i)]; %Appends values to end of existing vector
            Em_vec=[Em_vec;em(j)];
            I_vec=[I_vec;EEMin(j,i)];
        else %Wavelength combination with missing values added to query vectors
            Ex_query=[Ex_query;ex(i)];
            Em_query=[Em_query;em(j)];
        end
    end
end

%Interpolate for missing data
I_interp=griddata(Ex_vec,Em_vec,I_vec,Ex_query,Em_query,'cubic');


%Insert interpolate values back into the EEM
for i=1:length(I_interp)
    j=find(ex==Ex_query(i)); %index location for excitation wavelengh
    k=find(em==Em_query(i)); %index location for emission wavelengh
    EEMin(k,j)=I_interp(i);    %Insert value and overwrite NaN
end

EEM_Out=EEMin;

end