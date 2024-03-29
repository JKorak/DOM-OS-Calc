function [FI,Peak370,Rel_scatter]=Eval_FI(EEM,Ex,Em,Threshold,Name,plot_flag)

%OVERVIEW
%   Function calculates the fluorescence index and wavelength of peak
%   emission at Excitation 370 nm. Optical surrogates are only calculated
%   if relative noise is less than the specified threshold. User is
%   responsible to determining an appropriate threshold as it may vary
%   between instruments, instrument methods, and samples. The maximum
%   emission wavelength search algorithm is constrained to emission
%   wavelengths <710 nm. Users should assess each sample for
%   appropriateness of search range. Negative values are rejected. If the
%   emission spectra was not collected at the expected wavelength (e.g.,
%   470 and 520 nm), a substitue wavelength within tolerance is identifed. If no
%   subsitute wavelength is identified, NaN is reported.

%INPUTS
%   EEM:       3-D fluorescence data in matrix form. Emission by rows and excitation by columns
%   Ex:        Vector of excitation wavelengths corresponding to EEM
%   Em:        Vector of emission wavelengths corresponding to EEM
%   Threshold  Upper bound for RMSD. Function returns NaN if sample RMSD
%              exceeds threshold
%   Name:      Name to save relative scatter plot, if enabled
%   plot_flag  Enable relative scatter plot (1), or disable (0)

%OUTPUTS
%   FI:       Calculated fluorescence index
%   Peak370   Maximum emission wavelength at excitation = 370 nm
%   Rel_Scatter: Relative scatter for the sample


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Eval_FI: Copyright (C) 2024 Julie A. Korak
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


%Find 370 excitation wavelength indexes
Ex_370_idx = wave_match(Ex,370);

if isempty(Ex_370_idx) %Return NaN if EEM not measured at 370 nm
    FI=NaN;
    Peak370=NaN;
    Rel_scatter=NaN;
    return
end

%Check noise
span=0.2;
Rel_scatter=NoiseCheck(EEM,Ex,Em,370,470,520,span,Threshold,char(strcat(Name,'_FI')),plot_flag);


%Calculate outputs if sample noise is below threshold
if Rel_scatter<Threshold
    %Find vector indexes for each emission wavelength. If emission was not
    %measured at exact wavelength, look for substitute within 1 nm
    
    %Emission = 470 nm
    Em_470_idx=wave_match(Em,470);
    
    %Emission = 520 nm
      Em_520_idx=wave_match(Em,520);
    
%Calculate FI
    if or(isempty(Em_470_idx),isempty(Em_520_idx))
        %Report NaN if sample was not recorded at expected emission wavelengths
        %(or a substitute within 1 nm).
        FI=NaN;
    else  
        %Calculate FI
        int1=EEM(Em_470_idx,Ex_370_idx);
        int2=EEM(Em_520_idx,Ex_370_idx);

        FI=int1/int2;
    
        %Reject negative numbers
        if FI<=0
            FI=NaN;
        end
    
    end
    
    %Peak emission wavelength
    Em_max=2*Ex(Ex_370_idx)-30; %Upper bound maximum to avoid potential impacts of 2nd order scatter
    
    %Check if max emission wavelength is less than Em_max
    if max(Em)<Em_max
        Em_max_idx=length(Em); %Set upper bound for data acquisition maximum
    else
        %Otherwise, find index in Em where Em is closest to upper bound.
        %Searches for closest value for flexibility to different data acquisition parameters
        Em_max_idx=wave_match(Em,Em_max);
    end
    
    %Find peak emission wavelength
    max_int=max(EEM(1:Em_max_idx,Ex_370_idx));
    Peak370=Em(EEM(1:Em_max_idx,Ex_370_idx)==max_int);
    
    %If same maximum fluorescence intensity is recorded at 2 wavelengths,
    %report the lower value.
    if length(Peak370)>1 
        Peak370=Peak370(1);
    end
else
    %If sample RMSD exceeds threshold
    FI=NaN;
    Peak370=NaN;
end
end