function FigFormat(FigureH,pwidth,pheight,fontsize)

%OVERVIEW
%   Function formats figures based on user input and standard conventions.
%   The user passes the handle for the figure as the first input argument
%   followed by the figure width, height, and font size.
%   The function also sets all text to font Arial and color black. The color
%   of the graph axes are also set to true black.

%INPUTS
%   FigureH    Handle for figure. User could use gcf for 'get current figure'
%   pwidth     Scalar specifying the figure width in inches
%   pheight    Scalar specifying the figure height in inches
%   fontsize   Scalar specifyin the fontsize

%OUTPUTS
%   none       The figure is formatted

%   Note: This function was adapted from a function written by T. Zearley

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

%---Inputs--- 
if nargin < 1, error('Specify figure handle'); end
if nargin < 2, pwidth   = 3.33; end
if nargin < 3, pheight  = 2; end
if nargin < 4, fontsize = 8; end

%---Changes font sizes---
allText   = findall(FigureH, 'type', 'text'); %Finds all text
allAxes   = findall(FigureH, 'type', 'axes');
allFont   = [allText; allAxes];
set(allFont,'FontSize',fontsize)
set(allFont,'Fontname','Arial')
%set(allFont,'color',[0,0,0])
set(allText,'Color',[0 0 0])
set(allAxes,'GridColor',[0 0 0],'MinorGridColor',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],'box','on')
   
%---Sets limits to figures size etc.
    set(FigureH,'PaperPosition',[0 0 pwidth pheight])
    set(FigureH,'PaperSize',[pwidth pheight])
    set(FigureH,'Units','inches')
    figpos = get(FigureH,'Position'); set(FigureH,'Position',[figpos(1:2)-.01 pwidth pheight])
    set(FigureH,'Color','w') 
    