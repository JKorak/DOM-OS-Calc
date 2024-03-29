function DataStruct=BuildStruct(Headers,InputMat)

%OVERVIEW
%   Function initializes the data structure and creates the Input field.
%   Each table header is added as a sub field of X.Input.


%INPUTS
%   Headers:    Cell array of field names read in from the input table
%   InputMat:   Cell array containing the contents of the input file



%OUTPUTS
%   DataStruct Data structure that contains input information, optical 
%              surrogates, and quality control information and saved in rootpath/Output folder


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   BuildStruct: Copyright (C) 2024 Julie A. Korak
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

[col]=size(InputMat,2);
X=[];
for i=1:col
    string=strcat('X.Input.',char(Headers{1,i}),'=InputMat{1,i}(:);');
    eval(string)
end

DataStruct=X;
end