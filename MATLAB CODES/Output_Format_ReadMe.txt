Column Heading	Description																																																																									
TopFolder	String with name of folder at the same directory as MATLAB CODES folder																																																																									
Subfolder	String with name of subfolder within the corresponding TopFolder																																																																									
Abs_Name	String with name of .csv absorbance file																																																																									
Wave_min	Scalar for starting wavelength of absorbance spectra																																																																									
Wave_max	Scalar for ending wavelength of absorbance spectra																																																																									
Wave_inc	Scalar for wavelength increment of absorbance spectra																																																																									
Pathlength	Scalar for the absorbance cuvette pathlength in units of cm																																																																									
Fluor_Name	String with name of .xls fluorescence file																																																																									
Flipped	Y or N designating if the excitation wavelengths (corresponding to columns) are in ascending order (N) or descending order (Y)																																																																									
Ex_min	Scalar for starting wavelength of fluorescence excitation 																																																																									
Ex_max	Scalar for ending wavelength of fluorescence excitation vector																																																																									
Ex_inc	Scalar for wavelength increment of fluorescence excitation vector																																																																									
Em_min	Scalar for starting wavelength of fluorescence emission vector																																																																									
Em_max	Scalar for ending wavelength of fluorescence emission vector																																																																									
Em_inc	Scalar for wavelength increment of fluorescence emission vector																																																																									
DOC	Scalar for dissolved organic carbon (DOC) concentration in units of mgC/L. Enter NaN if unknown.																																																																									
MetaData1	String in input file for MetaData1																																																																									
MetaData2	String in input file for MetaData2																																																																									
MetaData3	String in input file for MetaData3																																																																									
MetaData4	String in input file for MetaData4																																																																									
MetaData5	String in input file for MetaData5																																																																									
UV254	Absorbance at 254 nm normalized to a pathlength of 1 cm																																																																									
UV280	Absorbance at 280 nm normalized to a pathlength of 1 cm																																																																									
UV320	Absorbance at 320 nm normalized to a pathlength of 1 cm																																																																									
UV370	Absorbance at 370 nm normalized to a pathlength of 1 cm																																																																									
SUVA254	Specific ultraviolet absorbance at 254 nm in units of L/mgC/m																																																																									
SUVA280	Specific ultraviolet absorbance at 280 nm in units of L/mgC/m																																																																									
SUVA320	Specific ultraviolet absorbance at 320 nm in units of L/mgC/m																																																																									
SUVA370	Specific ultraviolet absorbance at 370 nm in units of L/mgC/m																																																																									
E2E3_250	E2:E3 calculated as A250/A365																																																																									
E2E3_254	E2:E3 calculated as A254/A365																																																																									
E4E6	E4:E6 calculated as A465/A665																																																																									
SS_300_700	Spectral slope by non-linear regression between 300-600 nm																																																																									
SS_300_700_Frac	Fraction of absorbance measurements over the absorbance QC threshold for S300-700																																																																									
SS_300_650	Spectral slope by non-linear regression between 300-650 nm																																																																									
SS_300_650_Frac	Fraction of absorbance measurements over the absorbance QC threshold for S300-650																																																																									
SS_300_600	Spectral slope by non-linear regression between 300-600 nm																																																																									
SS_300_600_Frac	Fraction of absorbance measurements over the absorbance QC threshold for S300-600																																																																									
SS_275_295	Spectral slope of linearized data between 275-295 nm																																																																									
SS_275_295_Frac	Fraction of absorbance measurements over the absorbance QC threshold for S275-295																																																																									
SS_350_400	Spectral slope of linearized data between 350-400 nm																																																																									
SS_350_400_Frac	Fraction of absorbance measurements over the absorbance QC threshold for S350-400																																																																									
Sr	Spectral slope ratio (S275-295/S350-400)																																																																									
FI	Fluorescence index using Cory et al. (2010) method																																																																									
Peak370	Maximum emission wavelength at excitation 370 nm																																																																									
HIX1999	Humification index following Zsolnay (1999)																																																																									
HIX2002	Humification index following Ohno (2002) on scale of 0 to 1																																																																									
Peak254	Maximum emission wavelength at excitation 254 nm																																																																									
B_A	Beta over alpha (see supporting information for equation)																																																																									
BIX	Biological index (see supporting information for equation)																																																																									
Peak310	Maximum emission wavelength at excitation 310 nm																																																																									
Afix	Fluorescence intensity for Peak A at fixed wavelength																																																																									
Bfix	Fluorescence intensity for Peak B at fixed wavelength																																																																									
Cfix	Fluorescence intensity for Peak C at fixed wavelength																																																																									
Tfix	Fluorescence intensity for Peak T at fixed wavelength																																																																									
A_Ex	Excitation wavelength of maximum fluorescence intesity in Peak A region (see Eval_FixedPeaks for range)																																																																									
A_Em	Emission wavelength of maximum fluorescence intesity in Peak A region (see Eval_FixedPeaks for range)																																																																									
A_int	Maximum fluorescence intesity in Peak A region (see Eval_FixedPeaks for range)																																																																									
B_Ex	Excitation wavelength of maximum fluorescence intesity in Peak B region (see Eval_FixedPeaks for range)																																																																									
B_Em	Emission wavelength of maximum fluorescence intesity in Peak B region (see Eval_FixedPeaks for range)																																																																									
B_int	Maximum fluorescence intesity in Peak B region (see Eval_FixedPeaks for range)																																																																									
C_Ex	Excitation wavelength of maximum fluorescence intesity in Peak C region (see Eval_FixedPeaks for range)																																																																									
C_Em	Emission wavelength of maximum fluorescence intesity in Peak C region (see Eval_FixedPeaks for range)																																																																									
C_int	Maximum fluorescence intesity in Peak C region (see Eval_FixedPeaks for range)																																																																									
T_Ex	Excitation wavelength of maximum fluorescence intesity in Peak T region (see Eval_FixedPeaks for range)																																																																									
T_Em	Emission wavelength of maximum fluorescence intesity in Peak T region (see Eval_FixedPeaks for range)																																																																									
T_int	Maximum fluorescence intesity in Peak T region (see Eval_FixedPeaks for range)																																																																									
OFI	Overall fluorescence intensity. Excitation range 240-450 nm and emission range 300-560 nm.																																																																									
SpA	Specific peak intensity for Peak A																																																																									
SpB	Specific peak intensity for Peak B																																																																									
SpC	Specific peak intensity for Peak C																																																																									
SpT	Specific peak intensity for Peak T																																																																									
PkC_UV320	Ratio of fixed Peak C intensity to absorbance at 320 nm																																																																									
PkC_UV280	Ratio of fixed Peak C intensity to absorbance at 280 nm																																																																									
AbsStdDev	Standard deviation of absorbance spectra at wavelengths > 600 nm																																																																									
HIX_QC	CVrmsd at excitation wavelength for HIX																																																																									
FI_QC	CVrmsd at excitation wavelength for FI																																																																									
BIX_QC	CVrmsd at excitation wavelength for BIX																																																																									
PkA_QC	CVrmsd at excitation wavelength for Peak A																																																																									
PkB_QC	CVrmsd at excitation wavelength for Peak B																																																																									
PkC_QC	CVrmsd at excitation wavelength for Peak C																																																																									
PkT_QC	CVrmsd at excitation wavelength for Peak T																																																																									