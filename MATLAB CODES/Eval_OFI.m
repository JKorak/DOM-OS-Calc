function OFI=Eval_OFI(EEM,Ex,Em)

%OVERVIEW
%   Function calculates the overall fluorescence intensity across a standard
%   region: Ex 240-450 nm and Em 300-560 nm. Users could change the range.
%   Function looks for a match within tolerance of the desired range - otherwise
%   returns NaN. Function returns NaN if EEM range is smaller than standard area.
%   An integration method is used to calculate integrated volume to account for
%   differences in wavelength increments used between samples.

%INPUTS
%   EEM:       3-D fluorescence data in matrix form. Emission by rows and excitation by columns
%   Ex:        Vector of excitation wavelengths corresponding to EEM
%   Em:        Vector of emission wavelengths corresponding to EEM


%OUTPUTS
%   OFI:       Overall fluorescence intensity



%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Eval_OFI: Copyright (C) 2024 Julie A. Korak
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


Ex_start=wave_match(Ex,240);
Ex_end=wave_match(Ex,450);
Em_start=wave_match(Em,300);
Em_end=wave_match(Em,560);

if ~isempty(Ex_start) && ~isempty(Ex_end) && ~isempty(Em_start) && ~isempty(Em_end)
    
    EEMsub=EEM(Em_start:Em_end,Ex_start:Ex_end);
    
    x=Ex(Ex_start:Ex_end);
    y=Em(Em_start:Em_end);
    
    OFI=trapz(y,trapz(x,EEMsub,2),1);
    
    %Reject negative values
    if OFI<0
        OFI=NaN;
    end
    
else %Wavelengths not found
    OFI=NaN;
end


end
