function [B_A,BIX,Peak310,Rel_scatter]=Eval_Fresh(EEM,Ex,Em,Threshold,Name,plot_flag)

%OVERVIEW
%   Function calculates the freshness index by 2 methods and the wavelength
%   of peak emission at Excitation 310 nm. The first method is Beta/Alpha
%   (B_A) and the second is BIX, both defined in the accompanying
%   manuscript. Optical surrogates are only calculated if relative noise is
%   less than the specified threshold. User is responsible to determining
%   an appropriate noise threshold as it may vary between instruments, instrument
%   methods, and samples. The maximum emission wavelength search algorithm
%   is constrained to emission wavelengths <590 nm. Users should assess
%   each sample for appropriateness of search range. Negative values are
%   rejected. If the emission spectra was not collected at the expected
%   wavelength (e.g., 380 and 430 nm), a substitue wavelength within
%   tolerance is identifed. If no subsitute wavelength is identified, NaN is
%   reported.

%INPUTS
%   EEM:       3-D fluorescence data in matrix form. Emission by rows and excitation by columns
%   Ex:        Vector of excitation wavelengths corresponding to EEM
%   Em:        Vector of emission wavelengths corresponding to EEM
%   Threshold  Upper bound for RMSD. Function returns NaN if sample RMSD
%              exceeds threshold
%   Name:      Name to save relative scatter plot, if enabled
%   plot_flag  Enable relative scatter plot (1), or disable (0)

%OUTPUTS
%   B_A:       Calculated Beta/alpha index (method 1)
%   BIX        Biological index (method 2)
%   Peak310    Maximum emission wavelength at excitation = 310 nm
%   Rel_Scatter: Relative scatter for the sample



%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Eval_Fresh: Copyright (C) 2024 Julie A. Korak
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


%Find 310 excitation wavelength index
Ex_310_idx = find(Ex==310);

if isempty(Ex_310_idx) %Return NaN if EEM not measured at 310 nm
    B_A=NaN;
    BIX=NaN;
    Rel_scatter=NaN;
    return
end

%Check noise
span=0.2;
Rel_scatter=NoiseCheck(EEM,Ex,Em,310,380,435,span,Threshold,char(strcat(Name,'_BIX')),plot_flag);

%Calculate outputs if sample noise is below threshold
if Rel_scatter<Threshold
    
    %Find vector indexes for each emission wavelength
    
    %Emission = 380 nm
    Em_380_idx=wave_match(Em,380);
        
    %Emission = 420 nm
    Em_420_idx=wave_match(Em,420);
    
    %Emission = 430 nm
    Em_430_idx=wave_match(Em,430);
    
    %Emission = 435 nm
    Em_435_idx=wave_match(Em,435);


    %Calculate beta/alpha
    if isempty(Em_380_idx) || isempty(Em_420_idx) || isempty(Em_435_idx)
        %Report NaN if sample was not recorded at expected emission wavelengths
        %(or a substitute within 1 nm).
        B_A=NaN;
    else
        %Calculate beta/alpha
        int1=EEM(Em_380_idx,Ex_310_idx);
        int2=max(EEM(Em_420_idx:Em_435_idx,Ex_310_idx));
        
        B_A=int1/int2;
        
        %Reject negative numbers
        if B_A<=0
            B_A=NaN;
        end
    end

    %Calculate BIX
    if isempty(Em_380_idx) || isempty(Em_430_idx)
        %Report NaN if sample was not recorded at expected emission wavelengths
        %(or a substitute within 1 nm).
        BIX=NaN;
    else
        %Calculate BIX
        int1=EEM(Em_380_idx,Ex_310_idx);
        int2=EEM(Em_430_idx,Ex_310_idx);
        
        BIX=int1/int2;
        
        %Reject negative numbers
        if BIX<=0
            BIX=NaN;
        end
    end
    
    %Peak emission wavelength
    Em_max=2*Ex(Ex_310_idx)-30; %Stop 30 nm before second order Rayleigh scatter to find max Em wavelength
    
    %Check if max emission wavelength is less than Em_max
    if max(Em)<Em_max
        Em_max_idx=length(Em); %Set upper bound for data acquisition maximum
    else
        %Otherwise, find index in Em where Em is closest to upper bound.
        %Searches for closest value for flexibility to different data acquisition parameters
        Em_max_idx=wave_match(Em,Em_max);
    end
    
    %Find peak emission wavelength
    max_int=max(EEM(1:Em_max_idx,Ex_310_idx));
    Peak310=Em(EEM(1:Em_max_idx,Ex_310_idx)==max_int);
    
    %If same maximum fluorescence intensity is recorded at 2 wavelengths,
    %report the lower value.
    if length(Peak310)>1
        Peak310=Peak310(1);
    end
    
else
    %If sample RMSD exceeds threshold
    B_A=NaN;
    BIX=NaN;
    Peak310=NaN;
    
end
end