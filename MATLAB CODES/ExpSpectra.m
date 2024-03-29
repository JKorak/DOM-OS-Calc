function SSE=ExpSpectra(S,adata,waves)
%OVERVIEW
%   Objective function for solving for the spectral slope using the
%   non-linear equation. The sum-squared error is calculated between the
%   model and measured data. The function assumes a reference wavelength of
%   350 nm. 


%INPUTS
%   S:         Scalar value of spectral slope
%   adata:     Vector of absorbance in absorbance spectra corresponding to
%              waves
%   waves:     Vector of wavelengths in absorbance spectra



%OUTPUTS
%   SSE        Scalar with sum-squared error between the model and data


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   ExpSpectra: Copyright (C) 2024 Julie A. Korak
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

%Define reference wavelength
lambda=350; % in nm

%Confirm that absorbance spectra was measured at or within 1 nm of
%lambda
idx_ref=wave_match(waves,lambda);


if isempty(idx_ref)
    disp('Redefine reference wavelength for spectral slope')
    SSE=NaN;
else
    aref=adata(idx_ref);
    a_model=aref*exp(-S*(waves-lambda));
    Err=a_model-adata;
    SSE=Err'*Err;
end

end