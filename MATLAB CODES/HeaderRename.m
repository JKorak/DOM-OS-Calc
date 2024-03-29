function Tout=HeaderRename(T)
%OVERVIEW
%   Functions renames variables in table to add specificity


%INPUTS
%   T          Concatenated table of all input, metric, and QC information



%OUTPUTS
%   Tout       Table with renamed headers


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   HeaderRename: Copyright (C) 2024 Julie A. Korak
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

%Split the variables that are 2 columns
T=splitvars(T,'SS_300_700');
T=splitvars(T,'SS_300_650');
T=splitvars(T,'SS_300_600');
T=splitvars(T,'SS_275_295');
T=splitvars(T,'SS_350_400');


%Rename the variables
T=renamevars(T,'SS_300_700_1','SS_300_700');
T=renamevars(T,'SS_300_700_2','SS_300_700_Frac');

T=renamevars(T,'SS_300_650_1','SS_300_650');
T=renamevars(T,'SS_300_650_2','SS_300_650_Frac');

T=renamevars(T,'SS_300_600_1','SS_300_600');
T=renamevars(T,'SS_300_600_2','SS_300_600_Frac');

T=renamevars(T,'SS_275_295_1','SS_275_295');
T=renamevars(T,'SS_275_295_2','SS_275_295_Frac');

T=renamevars(T,'SS_350_400_1','SS_350_400');
T=renamevars(T,'SS_350_400_2','SS_350_400_Frac');
Tout=T;

end
