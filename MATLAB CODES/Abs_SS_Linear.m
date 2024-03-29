function [SS,Frac]=Abs_SS_Linear(Waves,Abs,wave1,wave2,pathlength,QC_Threshold)

%OVERVIEW
%   Function calculates the spectral slope using a linearized spectra
%   between two wavelengths. The wave_match function is called to find an
%   exact match or a measured wavelength within 3 nm. Decadic absorbance
%   values are converted to napierian absorption coefficient with units of
%   m^{-1} using equation 2 of Stedmon et al. (2000) and Helms et al.
%   (2008) by linearizing by calculating the natural log. Spectral
%   slope is reported as NaN if the absorbance at wave2 is less than
%   QC_Threshold at the as-measured pathlength. If absorbance spectra in the
%   target wavelength range is negative, the linear regression could be
%   rank deficient due to the screening of negative values. Applying a QC
%   threshold is recommended. Since the Abs_Process function normalizes the
%   absorbance vector (Abs) to a pathlength of 1 cm, this code multiplies
%   Abs by the pathlength to assess if the as-measured absorbance exceeds
%   the QC threshold.


%INPUTS
%   Waves:          Vector of wavelengths in absorbance spectra
%   Abs:            Vector of absorbance in absorbance spectra corresponding to
%                   Waves
%   wave1:          Scalar for the lower bound for wavelength to calculate the slope
%   wave2:          Scalar for the upper bound for wavelength to calculate the slope
%   pathlength:     Pathlength in cm at which absorbance spectra was
%                   measured
%   QC_Threshold:   Threshold for as-measured absorbance based on
%                   signal-to-noise analysis


%OUTPUTS
%   SS              Linearized spectral slope. Negative of value is
%                   reported assuming exponential decay.
%   Frac            Fraction of absorbance data between wave1 and wave2 that
%                   is above QC_Threshold


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Abs_SS_Linear: Copyright (C) 2024 Julie A. Korak
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


%Convert decadic absorbance to Naperian absorption coefficient 
a=2.303*Abs/0.01; %Pathlength is already normalized to 1 cm in the AbsProcess function (line 62)

%Set negative values to NaN to avoid complex numbers
a(a<=0)=NaN;

%Natural log transform the absorbance data
alog=log(a);

if Waves(end)>=wave2
    idx_start=wave_match(Waves,wave1); %Index of starting wavelength
    idx_stop=wave_match(Waves,wave2);  %Index of ending wavelength
    
    %Check if spectra wavelength range and increment aligns with target wavelength range.
    if ~isempty(idx_start) && ~isempty(idx_stop) 
        wave_S=Waves(idx_start:idx_stop); %Extract subset of wavelength vector
        alog_S=alog(idx_start:idx_stop);  %Extract subset of absorbance vector
        
        %Check if absorbance at wave2 is above QC Threshold
        %Data is divided by pathlength in AbsProcess file. Therefore, data is
        %multiplied by pathlength for "as measured".
        if Abs(idx_stop)*pathlength>QC_Threshold
            
            mdl=fitlm(wave_S,alog_S,'linear'); %Fit linear regression
            
            SS=-mdl.Coefficients{2,1}; %Extract slope from model output. Report the negative of value assuming exponential decay.
            Abs_S=Abs(idx_start:idx_stop); %Extract subset from original spectra
            
            %Calculate fraction of abs data above abs threshold "as measured".
            %Data is divided by pathlength in AbsProcess file. Therefore, data is
            %multiplied by pathlength for "as measured".
            Index=Abs_S*pathlength>QC_Threshold;
            num=length(Abs_S);
            Frac=sum(Index)/num;
            
        else
            SS=NaN;
            Frac=NaN;
        end
        
    else %Target wavelengths not found
        SS=NaN;
        Frac=NaN;
    end
    
else %If spectra was not measured out to wave2
    SS=NaN;
    Frac=NaN;
    
end

end