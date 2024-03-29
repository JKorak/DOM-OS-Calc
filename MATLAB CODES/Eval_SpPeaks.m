function [SpA,SpB,SpC,SpT]=Eval_SpPeaks(DataStruct,i,Type)

%OVERVIEW
%   Function calculates the specific fluorescence intensity for each of the
%   four peak regions, which normalizes the fluorescence intensity to the
%   DOC concentration. The user decides if the specific intensities are
%   calculated using the fixed or algorithm peak picking methods. Specific peak
%   intensities are only calculated if relative noise for each peak region
%   is less than the specified threshold as calculated in the preceeding
%   Eval_FixedPeaks function. User is responsible to determining an
%   appropriate threshold as it may vary between instruments, instrument
%   methods, and samples. Negative values are rejected. Specific peak
%   intensity is only calculated if  DOC exceeds 0.5 mg/L.


%INPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information
%   i:         Sample number corresponding to the input spreadsheet
%   Type:      Specify the peak picking approach: 'fixed' or 'algorithm'

%OUTPUTS
%   SpA:      Specific peak intensity for Peak A 
%   SpB:      Specific peak intensity for Peak B
%   SpC:      Specific peak intensity for Peak C
%   SpT:      Specific peak intensity for Peak T
%   


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Eval_SpPeaks: Copyright (C) 2024 Julie A. Korak
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



DOC=DataStruct.Input.DOC(i); %Pull DOC from input spreadsheet
if ~isnan(DOC) %Proceed if DOC input
    if DOC>=0.5 %Proceed if DOC exceed minimum of 0.5 mg/L
        switch Type
            case 'fixed'
                PeakA=DataStruct.Fluor.Afix(i);
                PeakB=DataStruct.Fluor.Bfix(i);
                PeakC=DataStruct.Fluor.Cfix(i);
                PeakT=DataStruct.Fluor.Tfix(i);
                
            case 'algorithm'
                PeakA=DataStruct.Fluor.A_int(i);
                PeakB=DataStruct.Fluor.B_int(i);
                PeakC=DataStruct.Fluor.C_int(i);
                PeakT=DataStruct.Fluor.T_int(i);
                
            otherwise
                disp('Invalid Type arguement for specific peak calculation')
                SpA=NaN;
                SpB=NaN;
                SpC=NaN;
                SpT=NaN;
                return
        end
        
        
        %Specific peak A
        if PeakA>0 %Reject negative values and NaN
            SpA=PeakA/DOC;
        else
            SpA=NaN;
        end
        
        %Specific peak B
        if PeakB>0 %Reject negative values and NaN
            SpB=PeakB/DOC;
        else
            SpB=NaN;
        end
        
        %Specific peak C
        if PeakC>0 %Reject negative values and NaN
            SpC=PeakC/DOC;
        else
            SpC=NaN;
        end
        
        %Specific peak T
        if PeakT>0 %Reject negative values and NaN
            SpT=PeakT/DOC;
        else
            SpT=NaN;
        end
        
    else %DOC<0.5 mg/L
        SpA=NaN;
        SpB=NaN;
        SpC=NaN;
        SpT=NaN;
    end
else %No DOC value provided
    SpA=NaN;
    SpB=NaN;
    SpC=NaN;
    SpT=NaN;
    
end

end