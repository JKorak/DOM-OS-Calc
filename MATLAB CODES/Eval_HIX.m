function [HIX1999,HIX2002,Peak254,Rel_scatter]=Eval_HIX(EEM,Ex,Em,Threshold,Name,plot_flag)
         
%OVERVIEW
%   Function calculates the humification index (HIX) using two different
%   approaches 
% 
%   HIX2002 is defined by Ohno, T. Environmental Science & Technology 36, 742-746 (2002)
%   with both integrated regions in the denominator.
% 
%   HIX199 is defined by Zsolnay et al. Chemosphere 38, 45–50 (1999) only the low wavelength
%   integrated region in the denominator.
% 
%   If fluorescence is not measured at 254 nm, the EEM is
%   interpolated using griddata to determining emission spectra at Ex=254
%   nm, only if there are excitation wavelengths that bracket 254 nm. A
%   tolerance is used to identify the bounds to integrate. User should use
%   discretion when interpolating. If the relative scatter in a sample
%   exceeds the threshold, HIX is reported as NaN. Negative values are
%   reported as NaN. Uncomment lines 41-45 to visually inspect the
%   interpolated emission spectra at Ex=254 nm.

%INPUTS
%   EEM:       3-D fluorescence data in matrix form. Emission by rows and excitation by columns
%   Ex:        Vector of excitation wavelengths corresponding to EEM
%   Em:        Vector of emission wavelengths corresponding to EEM

%OUTPUTS
%   HIX1999:      Calculated humification index by Zsolnay 1999
%   HIX2002       Calculated humification index by Ohno 2002
%   Peak254:      Maximum emission wavelength at excitation = 254 nm
%   Rel_Scatter:  Relative scatter for the sample


%DISCLAIMER
%   This code is a part of the DOM-OS-Calc toolbox.
%   Eval_HIX: Copyright (C) 2024 Julie A. Korak
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

%Check if Ex=254 was measured directly
Ex254_idx = find(Ex==254);

%Proceed if two emission wavelengths bracket 254 nm
if min(Ex)<=254 && max(Ex)>=254
    
    %Find the two closest excitation wavelengths that bracket 254 nm for interpolation
     if isempty(Ex254_idx)       
        %Nearest excitation wavelength less than 254 nm
        Ex_i1=find((Ex-254)<0,1,'last');
        
        %Nearest excitation wavelength greater than 254 nm
        Ex_i2=find((Ex-254)>0,1,'first');
        
        %Interpolated emission spectra at Ex=254 nm
        Em_254=griddata(Ex(Ex_i1:Ex_i2),Em,EEM(:,Ex_i1:Ex_i2),254,Em,'cubic');
        
        %Plot the interpolated spectra for visual quality control. 
        if plot_flag==1
            plot(Em,EEM(:,Ex_i1))
            hold on
            plot(Em,EEM(:,Ex_i2))
            plot(Em,Em_254,'r')
            xlim([300 600])
            xlabel('Emission Wavelength (nm)')
            ylabel('Intensity')
            pause(1)
            close
        end
    else
        Em_254=EEM(:,Ex254_idx); %Extract emission specta at Ex=254 nm
    end
    
    %Find bounds for emission spectra - use tolerance of +/- 1 nm
    %Find Upper Integral 435-480 nm
    em_435_idx=wave_match(Em,435);
    em_480_idx=wave_match(Em,480);
    
    %Find Lower Integral 300-345 nm
    em_300_idx=wave_match(Em,300);
    em_345_idx=wave_match(Em,345);
    
    
    %Check if data is noisy
    span=0.2;
    [Rel_scatter]=NoiseCheck(Em_254,254,Em,254,300,480,span,Threshold,char(strcat(Name,'_HIX')),plot_flag);
    
    %Define threshold for Rel_Scatter, above which HIX is not reported
    if Rel_scatter>Threshold
        HIX1999=NaN;
        HIX2002=NaN;
    else
        %Calculate HIX by each approach (1999 and 2002 approaches)
        High=trapz(Em(em_435_idx:em_480_idx),Em_254(em_435_idx:em_480_idx));
        Low=trapz(Em(em_300_idx:em_345_idx),Em_254(em_300_idx:em_345_idx));
        HIX2002=High/(High+Low);
        HIX1999=High/(Low);
    end
    
    if HIX1999 <=0 %Reject negative numbers
        HIX1999=NaN;
    end
    
    if HIX2002 <=0 %Reject negative numbers
        HIX2002=NaN;
    end
  

    %Peak emission wavelength
    Em_max=2*Ex(Ex_i1)-30; %Stop 30 nm before second order Rayleigh scatter to find max Em wavelength
                           %Chose Ex_i1 
    %Check if max emission wavelength is less than Em_max
    if max(Em)<Em_max
        Em_max_idx=length(Em); %Set upper bound for data acquisition maximum
    else
        %Otherwise, find index in Em where Em is closest to upper bound.
        %Searches for closest value for flexibility to different data acquisition parameters
        Em_max_idx=wave_match(Em,Em_max);
    end

    %Find peak emission wavelength
    max_int=max(Em_254(1:Em_max_idx));
    Peak254=Em(Em_254(1:Em_max_idx)==max_int);

    %If same maximum fluorescence intensity is recorded at 2 wavelengths,
    %report the lower value.
    if length(Peak254)>1
        Peak254=Peak254(1);
    end
    
else
    %If sample RMSD exceeds threshold
    HIX1999=NaN;
    HIX2002=NaN;
    Peak254=NaN;
    Rel_scatter=NaN;
    
end

end
