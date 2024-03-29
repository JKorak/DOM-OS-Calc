function [A,B,C,T,Ascat,Bscat,Cscat,Tscat]=Eval_FixedPeaks(EEM,Ex,Em,Threshold,Name,plot_flag)

%OVERVIEW
%   Function calculates the fluorescence peak intensity at fixed locations
%   in an EEM. Peak intensities are only calculated if relative noise for
%   each peak region is less than the specified threshold. User is
%   responsible to determining an appropriate threshold as it may vary
%   between instruments, instrument methods, and samples. Negative values
%   are rejected. If the EEM data acquisition settings do not align
%   with the fixed wavelength combinations, then a substitute within
%   tolerance was not collected at the expected wavelength (e.g., Ex = 260 and Em = 426 nm).
%   If no subsitute wavelength is identified, NaN is reported and user should refer to the
%   algorithmic peak peaking approach: Eval_Peaks.m


%   The fixed peak locations are:
%   Peak A: Ex = 260 nm, Em = 426 nm
%   Peak B: Ex = 280 nm, Em = 310 nm
%   Peak C: Ex = 320 nm, Em = 440 nm
%   Peak T: Ex = 280 nm, Em = 338 nm

%INPUTS
%   EEM:       3-D fluorescence data in matrix form. Emission by rows and excitation by columns
%   Ex:        Vector of excitation wavelengths corresponding to EEM
%   Em:        Vector of emission wavelengths corresponding to EEM
%   Threshold  Upper bound for RMSD. Function returns NaN if sample RMSD
%              exceeds threshold
%   Name:      Name to save relative scatter plot, if enabled
%   plot_flag  Enable relative scatter plot (1), or disable (0)

%OUTPUTS
%   FI:       Calculated fluorescence index
%   Peak370   Maximum emission wavelength at excitation = 370 nm
%   Rel_Scatter: Relative scatter for the sample


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Eval_FixedPeaks: Copyright (C) 2024 Julie A. Korak
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



%Parse Thresholds
A_Threshold=Threshold(1);
B_Threshold=Threshold(2);
C_Threshold=Threshold(3);
T_Threshold=Threshold(4);

%Define Fixed Peaks
    %Peak A
    ExA=260; %Excitation in nm
    EmA=426; %Emission in nm
    
    %Peak B
    ExB=280; %Excitation in nm
    EmB=310; %Emission in nm
    
    %Peak C
    ExC=320; %Excitation in nm
    EmC=440; %Emission in nm
    
    %Peak T
    ExT=280; %Excitation in nm
    EmT=338; %Emission in nm


    %%Peak Picking
    
    %Peak A
    %Check Noise
    span=0.2;
    Ascat=NoiseCheck(EEM,Ex,Em,ExA,376,476,span,A_Threshold,char(strcat(Name,'_PkA')),plot_flag);
    
    %Find peak intensity if below RMSD threshold
    if Ascat<A_Threshold
        
        %Vector index for Ex and Em
        ExA_idx=wave_match(Ex,ExA);
        EmA_idx=wave_match(Em,EmA);
        
        if ~isempty(ExA_idx) && ~isempty(EmA_idx)
            %Extract peak intensity
            A=EEM(EmA_idx,ExA_idx);
            
            %Screen and reject negative values
            if A<=0
                A=NaN;
            end
        else
            A=NaN; %Wavelengths not matched
        end
        
    else
        A=NaN;
    end
    
    %Peak B
    %Check Noise
    span=0.3;
    Bscat=NoiseCheck(EEM,Ex,Em,ExB,300,320,span,B_Threshold,char(strcat(Name,'_PkB')),plot_flag);
    
    %Find peak intensity if below RMSD threshold
    if Bscat<B_Threshold
        
        %Vector index for Ex and Em
        ExB_idx=wave_match(Ex,ExB);
        EmB_idx=wave_match(Em,EmB);
        
        
        if ~isempty(ExB_idx) && ~isempty(EmB_idx)
            %Extract peak intensity
            B=EEM(EmB_idx,ExB_idx);
            
            %Screen and reject negative values
            if B<=0
                B=NaN;
            end
        else
            B=NaN; %Wavelength not matched
        end
    else
        B=NaN;
    end
    
    %Peak C
    %Check Noise
    span=0.2;
    Cscat=NoiseCheck(EEM,Ex,Em,ExC,390,490,span,C_Threshold,char(strcat(Name,'_PkC')),plot_flag);
    
    %Find peak intensity if below RMSD threshold
    if Cscat<C_Threshold
        
        %Vector index for Ex and Em
        ExC_idx=wave_match(Ex,ExC);
        EmC_idx=wave_match(Em,EmC);
        
        
        if ~isempty(ExC_idx) && ~isempty(EmC_idx)
            %Extract peak intensity
            C=EEM(EmC_idx,ExC_idx);
            
            %Screen and reject negative values
            if C<=0
                C=NaN;
            end
        else
            C=NaN;
        end
    else
        C=NaN;
    end
    
    %Peak T
    %Check Noise
    span=0.3;
    Tscat=NoiseCheck(EEM,Ex,Em,ExT,328,348,span,T_Threshold,char(strcat(Name,'_PkT')),plot_flag);
    
    %Find peak intensity if below RMSD threshold
    if Tscat<T_Threshold
        
        %Vector index for Ex and Em
        ExT_idx=wave_match(Ex,ExT);
        EmT_idx=wave_match(Em,EmT);
        
        
        if ~isempty(ExT_idx) && ~isempty(EmT_idx)
            
            %Extract peak intensity
            T=EEM(EmT_idx,ExT_idx);
            
            %Screen and reject negative values
            if T<=0
                T=NaN;
            end
            
        else
            T=NaN;
        end
        
    else
        T=NaN;
    end
    
end
 