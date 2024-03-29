function wave_idx=wave_match(vector,target)

%OVERVIEW
%   Function finds the index location of a target wavelength in a vector of
%   wavelengths. If an exact match is not identified, a substitute within 1
%   nm is identified. If two equivalent substitutes are identified (e.g.,
%   target is 370 nm and vector contains 369 nm and 371 nm), the lower
%   value is retained. If no match is found, the function returns an empty
%   variable.

%INPUTS
%   vector:    Vector of excitation or emission wavelengths in ascending
%              order
%   target:    Target wavelength to find in the vector


%OUTPUTS
%   wave_idx:  Index of target (or substitute) in the vector 


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Copyright (C) 2024 Julie A. Korak

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
%__________________________________________________________________________


    wave_idx = find(vector==target);
    
    %Look for substitute, if needed
    if isempty(wave_idx)
        idx_match=find((vector-target)==min(abs(vector-target)));
        if abs(vector(idx_match)-target)<=1
            wave_idx=idx_match(1); %Defaults to the lower wavelength if multiple matches
        else
            wave_idx=[];
        end
    end


end