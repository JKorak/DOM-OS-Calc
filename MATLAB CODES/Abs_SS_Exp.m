function [SS,Frac,Flag]=Abs_SS_Exp(Waves,Abs,wave1,wave2,pathlength,QC_Threshold)

%OVERVIEW
%   Function calculates the spectral slope using a non-linear regression of
%   an exponential function between two wavelengths. The wave_match
%   function is called to find an exact match or a measured wavelength
%   within tolerance. Since the Abs_Process function normalizes the absorbance
%   vector (Abs) to a pathlength of 1 cm, this code multiplies Abs by the
%   pathlength to assess if the as-measured absorbance exceeds the QC
%   threshold.


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
%   SS              Non-linear spectral slope. Negative of value is
%                   reported assuming exponential decay.
%   Frac            Fraction of absorbance data between wave1 and wave2 that
%                   is above QC_Threshold
%   Flag            Indicator if non-linear solver converged (1)


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Abs_SS_Exp: Copyright (C) 2024 Julie A. Korak
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


%Find index of wavelengths that correspond with upper and lower bound
idx_start=wave_match(Waves,wave1);
idx_stop=wave_match(Waves,wave2);

%Check if spectra wavelength range and increment aligns with target wavelength range.
if ~isempty(idx_start) && ~isempty(idx_stop) 
    wave_S=Waves(idx_start:idx_stop); %Extract subset of wavelength vector
    Adata1=Abs(idx_start:idx_stop); %Extract subset of absorbance vector
    
    if Adata1(1)*pathlength>QC_Threshold
        
        %Define initial guess
        S0=0.02; %Initial guess for solver
        
        %Set convergence tolerance
        options=optimset('TolX',1e-8,'TolFun',1e-8);
        
        %Search algorithm to find minimum.
        [SS,~,Flag]=fminsearch('ExpSpectra',S0,options,Adata1,wave_S);
        
        %Calculate fraction of abs data above abs threshold "as measured".
        %Data is divided by pathlength in AbsProcess file. Therefore, data is
        %multiplied by pathlength for "as measured".
        Threshold=QC_Threshold;
        
        Index=Adata1*pathlength>Threshold;
        num=length(Adata1);
        Frac=sum(Index)/num;
    else
        SS=NaN;
        Frac=NaN;
        Flag=0;
    end
else
    SS=NaN;
    Frac=NaN;
    Flag=0;
end

end






