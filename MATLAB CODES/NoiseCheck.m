function [Rel_scatter]=NoiseCheck(EEM,Ex,Em,Ex_metric,Em_start,Em_end,span,Threshold,Name,plot_flag)

%OVERVIEW
%This function calculates a coefficient of variation for an emission
%spectra. This code is called by other functions to assess if the data is
%too noisy to calculate a fluorescence index (e.g., HIX, BIX, FI, B_A)

%INPUTS
%   EEM:       2-D fluorescence data. Emission by rows and excitation by columns
%   Ex:        Vector of excitation wavelengths corresponding to EEM
%   Em:        Vector of emission wavelengths corresponding to EEM
%   Ex_metric: Excitation wavelength in nm at which the index is
%              calculated
%   Em_start:  Lower bound of the emission scan for which relative scatter
%              will be calculated
%   Em_end:    Upper bound of the emission scan for which relative scatter
%              will be calculated
%   Span:      Input arguement for smooth function for the LOWESS smoothing
%              algorithm
%   Threshold: Minimum threshold for Rel_Scatter for generating a plot
%   Name:      Name to save plot. If not plotting, enter NaN
%   Plot_Flag: Designate if a plot will be saved for samples where.
%              Rel_Scatter exceeds Threshold. Specify 1 to plot and 0 to
%              skip.
%   
    
%OUTPUT
%   Rel_Scatter: Relative scatter calculated by RMSE/Mean within the
%                designated range of emission wavelengths.

%   Plot:        If activated using Plot_Flag, a plot of the corrected
%                fluorescence spectra, smoothed emission spectra, and calculated
%                relative scatter.
    

%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   NoiseCheck: Copyright (C) 2024 Julie A. Korak
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
   
%Check if spectra was aquired at same excitation wavelength as index
Ex_chk = find(Ex==Ex_metric);
%If spectra did not measure target wavelength directly, then code extracts the nearest value,
%if within 1 nm.

    if isempty(Ex_chk)
        Ex_chk=wave_match(Ex,Ex_metric);
        if isempty(Ex_chk)
           Rel_scatter=NaN;
           return
        end
    
    end    
      
%Determine if spectra was acquired at Em_min. If spectra did not measure
%target wavelength directly, then code extracts the nearest value, if
%within 1 nm.
  Em_min= find(Em==Em_start);
    if isempty(Em_min)
        Em_min=wave_match(Em,Em_start);
        if isempty(Em_min)
           Rel_scatter=NaN;
           return
        end
    
    end
    
%%Determine if spectra was acquired at Em_max. If spectra did not measure
%%target wavelength directly, then code extracts the nearest value,
%if within 1 nm.
  Em_max= find(Em==Em_end);
    if isempty(Em_max)
        Em_max=wave_match(Em,Em_end);
        if isempty(Em_max)
           Rel_scatter=NaN;
           return
        end
    
    end
     
%Smooth the data using LOWESS
    Int=EEM(Em_min:Em_max,Ex_chk); %Extract emission spectra from EEM
    %Extract vector of emission wavelengths between Em_min and Em_max
    Em_wave=Em(Em_min:Em_max); 
    Int_smooth=smooth(Em_wave,Int,span,'lowess'); %Smooth data
    RMSE=sqrt(sum((Int-Int_smooth).^2)/length(Int)); %Calculate RMSE
    Rel_scatter=RMSE/mean(Int); %Calculate ratio of RMSE to mean intensity
    
    if plot_flag==1
        if Rel_scatter>Threshold
            plot(Em_wave,Int,'ko')
            hold on
            plot(Em_wave,Int_smooth,'r-')
            title('Sample exceeds scatter limit')
            ylabel('Intensity (RU)')
            xlabel('Emission Wavelength (nm)')
            pause(1)
            close
            
        end
    end
end