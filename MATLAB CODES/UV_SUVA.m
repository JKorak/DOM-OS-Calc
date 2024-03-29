function [Abs,SUVA]=UV_SUVA(Wave_vec,Abs_vec,Wave_metric,DOC,pathlength,QC_Threshold)

%OVERVIEW
%   Function extracts the absorbance at a target wavelength and calculates
%   the SUVA at that wavelength. The wave_match function is called to
%   determine if the absorbance spectra was measured at or within 1 nm of
%   the target wavelength. Since the Abs_Process function normalizes the
%   absorbance vector (Abs) to a pathlength of 1 cm, this code multiplies Abs
%   by the pathlength to assess if the as-measured absorbance exceeds the
%   QC threshold. No absorbance metrics are calculated if absorbance
%   as-measured was less than the threshold. As-measured absorbance values
%   >1.5 are not reported.
%   SUVA is calculated if the measured DOC was greater than 0.5 mgC/L.


%INPUTS
%   Wave_vec:       Vector of wavelengths in absorbance spectra
%   Abs_vec:        Vector of absorbance in absorbance spectra corresponding to
%                   Wave_vec
%   Wave_metric:    Wavelength at which to calculate absorbance and SUVA
%   DOC:            DOC concentration in mgC/L
%   pathlength:     Pathlength in cm at which absorbance spectra was
%                   measured
%   QC_Threshold:   As-measured absorbance below which absorbance metric is
%                   not reported


%OUTPUTS
%   Abs             Absorbance normalized to 1 cm pathlength at Wave_metric
%   SUVA            Absorbance normalized to DOC concentration and a 1 m
%                   pathlength


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   UV_SUVA: Copyright (C) 2024 Julie A. Korak
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


wave_idx=wave_match(Wave_vec,Wave_metric); %Find index in Wave_vec corresponds to Wave_metric
if isempty(wave_idx) %If abs was not measured at or within tolerance of target wavelength
    Abs=NaN; %Do not report Abs
    SUVA=NaN; %Do not repot SUVA
else %Absorbance was measured at or within tolerance of target wavelength
    
    %Check if absorbance "as measured" is greater than threshold.
    %Absorbance is multiplied by pathlength because AbsProcess.m already
    %normalized to 1 cm
    if Abs_vec(wave_idx)*pathlength>QC_Threshold 
        Abs=Abs_vec(wave_idx); %Extract absorbance normalized to pathlength of 1 cm
        if Abs>1.5
            Abs=NaN;
            SUVA=NaN;
        else
            if ~isnan(DOC) && DOC > 0.5 %Check if there is a DOC concentration
                SUVA=Abs/DOC*100; %Calculate SUVA if DOC exists
            else
                SUVA=NaN; %If no DOC or DOC< 0.5 mg/L, report NaN for SUVA
            end
        end
    else %If Abs < QC threshold
        Abs=NaN; %Report NaN if Abs does not exceed threshold
        SUVA=NaN; %Do not repot SUVA if threshold for absorbance is not met
    end
    
end
  
end
  
   
