function [Ap,Bp,Cp,Tp]=Eval_Peaks(DataStruct,EEM,Ex,Em,i)
%OVERVIEW
%   Function calculates the fluorescence peak intensity and the wavelength
%   combination where the peak intensity was found. Peak intensities are
%   only calculated if relative noise for each peak region is less than the
%   specified threshold as calculated in the preceeding Eval_FixedPeaks
%   function. User is responsible to determining an appropriate threshold
%   as it may vary between instruments, instrument methods, and samples.
%   Negative values are rejected. If the EEM data acquisition settings are
%   do not align with the fixed wavelength combinations for the bounds of
%   the region, then a substitute within tolerance was not collected at the
%   expected wavelength (e.g., Ex = 260 and Em = 426 nm), a substitue
%   wavelength within tolerance is queried. If no subsitute wavelength is
%   identified, NaN is reported. If the maximum intensity is measured at
%   multiple wavelength wavelength combinations. The combination at the
%   lower excitation wavelength is retained.


%   The fixed peak locations are:
%   Peak A: Ex = 250-270 nm, Em = 380-470 nm
%   Peak B: Ex = 260-290 nm, Em = 300-320 nm
%   Peak C: Ex = 300-340 nm, Em = 400-480 nm
%   Peak T: Ex = 260-290 nm, Em = 326-350 nm

%INPUTS
%   DataStruct Data structure that contains input information, optical
%              surrogates, and quality control information
%   EEM:       3-D fluorescence data in matrix form. Emission by rows and excitation by columns
%   Ex:        Vector of excitation wavelengths corresponding to EEM
%   Em:        Vector of emission wavelengths corresponding to EEM
%   Threshold  Upper bound for RMSD. Function returns NaN if sample RMSD
%              exceeds threshold
%   Name:      Name to save relative scatter plot, if enabled
%   plot_flag  Enable relative scatter plot (1), or disable (0)

%OUTPUTS
%   Ap:       Vector for peak A with [lambda_Ex lambda_Em Intensity] 
%   Bp:       Vector for peak B with [lambda_Ex lambda_Em Intensity] 
%   Cp:       Vector for peak C with [lambda_Ex lambda_Em Intensity] 
%   Tp:       Vector for peak T with [lambda_Ex lambda_Em Intensity] 
%   


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Eval_Peaks: Copyright (C) 2024 Julie A. Korak
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


%%Peak Picking

%Peak A: Ex: 250-270 Em: 380-470
%Check Noise - If spectra was too noisy for the fixed peak evaluation, then do not conduct algorithm approach.
if ~isnan(DataStruct.Fluor.Afix(i,1))
    
    ExAstart=wave_match(Ex,250);
    ExAend=wave_match(Ex,270);
    EmAstart=wave_match(Em,380);
    EmAend=wave_match(Em,470);
    
    if ~isempty(ExAstart) && ~isempty(ExAend) && ~isempty(EmAstart) && ~isempty(EmAend) %Proceed if wavelengths matched
        A=EEM(EmAstart:EmAend,ExAstart:ExAend); %Extract peak region
        
        [EmA,ExA] = find(A==max(A(:)));
        
        Aint=A(EmA,ExA);
        
        EmAp=Em(EmAstart+EmA-1); %Extract peak emission wavelength from Em vector given index relative to start index of peak range
        ExAp=Ex(ExAstart+ExA-1); %Extract peak excitation wavelength from Ex vector given index relative to start index for peak range
        
        Ap=[ExAp(1) EmAp(1) Aint];
        
        %Reject negative values
        if Aint<=0
            Ap=[NaN NaN NaN];
        end
    else
        Ap=[NaN NaN NaN]; %Suitable EEM region not found
    end
else
    Ap=[NaN NaN NaN]; %If noise exceeds acceptable threshold
end

%Peak B: Ex: 260-290 Em: 300-320
%Check Noise - If spectra was too noisy for the fixed peak evaluation, then do not conduct algorithm approach.
if ~isnan(DataStruct.Fluor.Bfix(i,1))
    
    ExBstart=wave_match(Ex,260);
    ExBend=wave_match(Ex,290);
    
    EmBstart=wave_match(Em,300);
    EmBend=wave_match(Em,320);
    
    
    if ~isempty(ExBstart) && ~isempty(ExBend) && ~isempty(EmBstart) && ~isempty(EmBend) %Proceed if wavelengths matched
        B=EEM(EmBstart:EmBend,ExBstart:ExBend); %Extract peak region
        
        [EmB,ExB] = find(B==max(B(:)));
        
        Bint=B(EmB,ExB);
        
        EmBp=Em(EmBstart+EmB-1); %Extract peak emission wavelength from Em vector given index relative to start index of peak range
        ExBp=Ex(ExBstart+ExB-1); %Extract peak excitation wavelength from Ex vector given index relative to start index for peak range
        Bp=[ExBp(1) EmBp(1) Bint];
        
        %Reject negative numbers
        if Bp<=0
            Bp=[NaN NaN NaN];
        end
    else
        Bp=[NaN NaN NaN]; %Suitable EEM region not found
    end
    
else
    Bp=[NaN NaN NaN]; %If noise exceeds acceptable threshold
end


%Peak C: Ex: 300-340 Em: 400-480
%Check Noise - If spectra was too noisy for the fixed peak evaluation, then do not conduct algorithm approach.
if ~isnan(DataStruct.Fluor.Cfix(i,1))
    
    ExCstart=wave_match(Ex,300);
    ExCend=wave_match(Ex,340);
    
    EmCstart=wave_match(Em,400);
    EmCend=wave_match(Em,480);
    
    if ~isempty(ExCstart) && ~isempty(ExCend) && ~isempty(EmCstart) && ~isempty(EmCend) %Proceed if wavelengths matched
        C=EEM(EmCstart:EmCend,ExCstart:ExCend); %Extract peak region
        
        [EmC,ExC] = find(C==max(C(:)));
        
        Cint=C(EmC,ExC);
        
        EmCp=Em(EmCstart+EmC-1); %Extract peak emission wavelength from Em vector given index relative to start index of peak range
        ExCp=Ex(ExCstart+ExC-1); %Extract peak excitation wavelength from Ex vector given index relative to start index for peak range
        Cp=[ExCp(1) EmCp(1) Cint];
        
        %Reject negative values
        if Cint<=0
            Cp=[NaN NaN NaN];
        end
    else
        Cp=[NaN NaN NaN]; %Suitable EEM region not found
    end
    
else
    Cp=[NaN NaN NaN]; %If noise exceeds acceptable threshold
end


%Peak T: Ex:260-290 Em: 326-350
%Check Noise - If spectra was too noisy for the fixed peak evaluation, then do not conduct algorithm approach.
if ~isnan(DataStruct.Fluor.Tfix(i,1))
    ExTstart=wave_match(Ex,260);
    ExTend=wave_match(Ex,290);
    EmTstart=wave_match(Em,326);
    EmTend=wave_match(Em,350);
    
    
    if ~isempty(ExTstart) && ~isempty(ExTend) && ~isempty(EmTstart) && ~isempty(EmTend) %Proceed if wavelengths matched
        T=EEM(EmTstart:EmTend,ExTstart:ExTend); %Extract peak region
        
        [EmT,ExT] = find(T==max(T(:)));
        Tint=T(EmT,ExT);
        
        EmTp=Em(EmTstart+EmT-1); %Extract peak emission wavelength from Em vector given index relative to start index of peak range
        ExTp=Ex(ExTstart+ExT-1); %Extract peak excitation wavelength from Ex vector given index relative to start index for peak range
        Tp=[ExTp(1) EmTp(1) Tint];
        
        %Reject negative values
        if Tp<=0
            Tp=[NaN NaN NaN];
        end
    else
        Tp=[NaN NaN NaN]; %Suitable EEM region not found
    end
else
    Tp=[NaN NaN NaN]; %If noise exceeds acceptable threshold
    
end
   