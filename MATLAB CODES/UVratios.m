function [Ratio]=UVratios(Wave_vec,Abs_vec,Wave_low,Wave_high,pathlength,QC_Threshold)

%OVERVIEW
%   Function extracts the absorbance at a target wavelengths and calculates
%   the ratio of absorbance measurements. The wave_match function is called
%   to determine if the absorbance spectra was measured at or within 1 nm
%   of the target wavelengths. Next, the absorbance at the longer
%   wavelength and measured pathlength is compared to the QC Threshold. No
%   absorbance metrics are calculated if absorbance as-measured was less
%   than the threshold. 


%INPUTS
%   Wave_vec:       Vector of wavelengths in absorbance spectra
%   Abs_vec:        Vector of absorbance in absorbance spectra corresponding to
%                   Wave_vec
%   Wave_low:       Lower wavelength for ratio numerator
%   Wave_high:      Higher wavelength for ratio denominator
%   pathlength:     Pathlength in cm at which absorbance spectra was
%                   measured
%   QC_Threshold:   As-measured absorbance below which absorbance metric is
%                   not reported


%OUTPUTS
%   Ratio           Ratio of absorbance measurements


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   UVratios: Copyright (C) 2024 Julie A. Korak
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

idx_low=wave_match(Wave_vec,Wave_low);
idx_high=wave_match(Wave_vec,Wave_high);
  

if ~isempty(idx_low) && ~isempty(idx_high) %Proceed if absorbance is measured at or within the tolerance of the target wavelengths
    %Check if absorbance "as measured" is greater than threshold.
    %Data is divided by pathlength in AbsProcess file. Therefore, data is
    %multiplied by pathlength for "as measured".
    if Abs_vec(idx_high)*pathlength<QC_Threshold %Absorbance is multiplied by pathlength because AbsProcess.m already
    %normalized to 1 cm (Line 62)
        Ratio=NaN; %Absorbance is too low at Wave_high to be calculated
    else
        if Abs_vec(idx_low)<1.5 && Abs_vec(idx_high)<1.5
            Ratio=Abs_vec(idx_low)/Abs_vec(idx_high);
        else
            Ratio=NaN;
        end
    end
else
    Ratio=NaN; %Spectra not measured at or within tolerance of the target wavelengths
end
   
end
   