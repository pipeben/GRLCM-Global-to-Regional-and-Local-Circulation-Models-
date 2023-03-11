# This R-script provides the codes and explanation of GIS tools needed to 
# perform Bathymetric Projection (BP) on environmental ocean variables measured 
# as vertical layers throughout the depth profile (depth dimension) of the ocean
# The result of BP is an ocean only-bottom layer appropriate to characterize benthic
# environments

# For more detailed information on the method please read Benavides et al (2023)
# "Improving spatiotemporal models for marine shrimp species by appropriately
# "projecting benthic environmental conditions" (Cite here)

# Please note that this is an exemplifying and simplyfied script using only two 
# environmental # variables: clorophyl-a (chl) and pH trough 25 
# depth classes (0.5 - 108.03 m depth)
# For your personal purposes, you can set any configuration of variables and depths 


# Required files are included in the Bathymetric GitHub Repository 
# (https://github.com/pipeben/Bathymetric-Projection)

#__________________________________________________________________________________________________________________
# Load required packages
library(ncdf4)
library(raster)
library(sf)
library(gstat)
#__________________________________________________________________________________________________________________



#__________________________________________________________________________________________________________________
# Load Required Data -----------------------------------------------------------
# Load NetCdf File
env_vars = nc_open("env_vars.nc")

# Source of this NetCdf file is Marine Copernicus product GLOBAL_MULTIYEAR_BCG_001_029
# https://data.marine.copernicus.eu/product/GLOBAL_MULTIYEAR_BGC_001_029/description 

# Explore object "env_vars". Check variable names, depths
# Time span, spatial and temporal resolution, projection and extent.
# Make sure that set up works for you
env_vars

# Load Bathymetric layer
bat = raster("bat.tif")

#__________________________________________________________________________________________________________________


#:: So far we have loaded the required files. Now we move forward trough the 6
# Steps of BP



#__________________________________________________________________________________________________________________
# STEP 1 chl------------------------------------------------------------------
# Select environmental variables and depths. Crop stud area, resample, extract
# and set months apart

# Select chl as our target variable for depth 1 (0-0.45 m depth)
chl1 = brick("env_vars.nc",varname = "chl",level=1)
plot(chl1)

# 1.1 Crop the resulting raster brick "chl1" to the target study area. Here the study 
# Area is the Coast of the Colombian Pacific Ocean (0.5 to 108.03 m depth)
ext = c(-80, -76, 1, 8)
chl1 = crop(chl1,ext)
plot(chl1)

# We also need to crop the Bathymetric layer
bat = crop (bat,chl1)
plot(bat)

# 1.2 Extract target months. For that purpose we create sequences to extract the index 
# position of for each month within the chl1 raster brick. Pay attention to how
# months are included in your full time series and use this value as the length
# of the sequence each 12 months.

env_vars # 36 months - 3 years

seq_jan = seq(1,36,12) 
seq_feb = seq(2,36,12) 
seq_mar = seq(3,36,12)
seq_apr = seq(4,36,12) 
seq_may = seq(5,36,12) 
seq_jun = seq(6,36,12)
seq_jul = seq(7,36,12) 
seq_aug = seq(8,36,12) 
seq_sep = seq(9,36,12) 
seq_oct = seq(10,36,12)
seq_nov = seq(11,36,12)
seq_dec = seq(12,36,12)

# 1.3 Use the resulting seq_jan sequence to extract all Januaries from chl1
chl1_jan = chl1[[seq_jan]]
#__________________________________________________________________________________________________________________




#__________________________________________________________________________________________________________________
# STEP 2 chl------------------------------------------------------------------
# 2.1 Calculate multiannual monthly means 
chl1_jan = calc(chl1, fun = mean, na.rm=T)
plot(chl1_jan)
# :: The reulting raster is the multiannual monthly mean of variable chl1
# for depth 1 (0.5 - 108.03 m depth)

# 2.2 Resample chl_1jan to the same resolution of the bathymetric layer
chl1_jan = resample(chl1_jan,bat,method="bilinear")
plot(chl1_jan)


# 2.3 Repeat the process for all months
#feb
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_feb = chl1[[seq_feb]] ; chl1_feb = calc(chl1_feb,mean,na.rm=T); chl1_feb = resample(chl1_feb,bat)
#mar
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_mar = chl1[[seq_mar]] ; chl1_mar = calc(chl1_mar,mean,na.rm=T); chl1_mar = resample(chl1_mar,bat)
#apr
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_apr = chl1[[seq_apr]] ; chl1_apr = calc(chl1_apr,mean,na.rm=T); chl1_apr = resample(chl1_apr,bat)
#may
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_may = chl1[[seq_may]] ; chl1_may = calc(chl1_may,mean,na.rm=T); chl1_may = resample(chl1_may,bat)
#jun
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_jun = chl1[[seq_jun]] ; chl1_jun = calc(chl1_jun,mean,na.rm=T); chl1_jun = resample(chl1_jun,bat)
#jul
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_jul = chl1[[seq_jul]] ; chl1_jul = calc(chl1_jul,mean,na.rm=T); chl1_jul = resample(chl1_jul,bat)
#aug
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_aug = chl1[[seq_aug]] ; chl1_aug = calc(chl1_aug,mean,na.rm=T); chl1_aug = resample(chl1_aug,bat)
#sep
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_sep = chl1[[seq_sep]] ; chl1_sep = calc(chl1_sep,mean,na.rm=T); chl1_sep = resample(chl1_sep,bat)
#oct
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_oct = chl1[[seq_oct]] ; chl1_oct = calc(chl1_oct,mean,na.rm=T); chl1_oct = resample(chl1_oct,bat)
#nov
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_nov = chl1[[seq_nov]] ; chl1_nov = calc(chl1_nov,mean,na.rm=T); chl1_nov = resample(chl1_nov,bat)
#dec
chl1 = brick("env_vars.nc",varname = "chl",level=1) ; chl1 = crop(chl1,ext) ; chl1_dec = chl1[[seq_dec]] ; chl1_dec = calc(chl1_dec,mean,na.rm=T); chl1_dec = resample(chl1_dec,bat)


#:: Restulting rasters (chl1_feb to chl1_dec) are the multiannual monthly mean layers of chl for each month in depth 1


# 2.4 Repeat the process for all depths
#depth2
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_jan = chl2[[seq_jan]] ; chl2_jan = calc(chl2_jan,mean,na.rm=T); chl2_jan = resample(chl2_jan,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_feb = chl2[[seq_feb]] ; chl2_feb = calc(chl2_feb,mean,na.rm=T); chl2_feb = resample(chl2_feb,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_mar = chl2[[seq_mar]] ; chl2_mar = calc(chl2_mar,mean,na.rm=T); chl2_mar = resample(chl2_mar,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_apr = chl2[[seq_apr]] ; chl2_apr = calc(chl2_apr,mean,na.rm=T); chl2_apr = resample(chl2_apr,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_may = chl2[[seq_may]] ; chl2_may = calc(chl2_may,mean,na.rm=T); chl2_may = resample(chl2_may,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_jun = chl2[[seq_jun]] ; chl2_jun = calc(chl2_jun,mean,na.rm=T); chl2_jun = resample(chl2_jun,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_jul = chl2[[seq_jul]] ; chl2_jul = calc(chl2_jul,mean,na.rm=T); chl2_jul = resample(chl2_jul,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_aug = chl2[[seq_aug]] ; chl2_aug = calc(chl2_aug,mean,na.rm=T); chl2_aug = resample(chl2_aug,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_sep = chl2[[seq_sep]] ; chl2_sep = calc(chl2_sep,mean,na.rm=T); chl2_sep = resample(chl2_sep,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_oct = chl2[[seq_oct]] ; chl2_oct = calc(chl2_oct,mean,na.rm=T); chl2_oct = resample(chl2_oct,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_nov = chl2[[seq_nov]] ; chl2_nov = calc(chl2_nov,mean,na.rm=T); chl2_nov = resample(chl2_nov,bat)
chl2 = brick("env_vars.nc",varname = "chl",level=2) ; chl2 = crop(chl2,ext) ; chl2_dec = chl2[[seq_dec]] ; chl2_dec = calc(chl2_dec,mean,na.rm=T); chl2_dec = resample(chl2_dec,bat)
#depth3
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_jan = chl3[[seq_jan]] ; chl3_jan = calc(chl3_jan,mean,na.rm=T); chl3_jan = resample(chl3_jan,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_feb = chl3[[seq_feb]] ; chl3_feb = calc(chl3_feb,mean,na.rm=T); chl3_feb = resample(chl3_feb,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_mar = chl3[[seq_mar]] ; chl3_mar = calc(chl3_mar,mean,na.rm=T); chl3_mar = resample(chl3_mar,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_apr = chl3[[seq_apr]] ; chl3_apr = calc(chl3_apr,mean,na.rm=T); chl3_apr = resample(chl3_apr,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_may = chl3[[seq_may]] ; chl3_may = calc(chl3_may,mean,na.rm=T); chl3_may = resample(chl3_may,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_jun = chl3[[seq_jun]] ; chl3_jun = calc(chl3_jun,mean,na.rm=T); chl3_jun = resample(chl3_jun,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_jul = chl3[[seq_jul]] ; chl3_jul = calc(chl3_jul,mean,na.rm=T); chl3_jul = resample(chl3_jul,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_aug = chl3[[seq_aug]] ; chl3_aug = calc(chl3_aug,mean,na.rm=T); chl3_aug = resample(chl3_aug,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_sep = chl3[[seq_sep]] ; chl3_sep = calc(chl3_sep,mean,na.rm=T); chl3_sep = resample(chl3_sep,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_oct = chl3[[seq_oct]] ; chl3_oct = calc(chl3_oct,mean,na.rm=T); chl3_oct = resample(chl3_oct,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_nov = chl3[[seq_nov]] ; chl3_nov = calc(chl3_nov,mean,na.rm=T); chl3_nov = resample(chl3_nov,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_dec = chl3[[seq_dec]] ; chl3_dec = calc(chl3_dec,mean,na.rm=T); chl3_dec = resample(chl3_dec,bat)
chl3 = brick("env_vars.nc",varname = "chl",level=3) ; chl3 = crop(chl3,ext) ; chl3_dec = chl3[[seq_dec]] ; chl3_dec = calc(chl3_dec,mean,na.rm=T); chl3_dec = resample(chl3_dec,bat)
#depth4
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_jan = chl4[[seq_jan]] ; chl4_jan = calc(chl4_jan,mean,na.rm=T); chl4_jan = resample(chl4_jan,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_feb = chl4[[seq_feb]] ; chl4_feb = calc(chl4_feb,mean,na.rm=T); chl4_feb = resample(chl4_feb,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_mar = chl4[[seq_mar]] ; chl4_mar = calc(chl4_mar,mean,na.rm=T); chl4_mar = resample(chl4_mar,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_apr = chl4[[seq_apr]] ; chl4_apr = calc(chl4_apr,mean,na.rm=T); chl4_apr = resample(chl4_apr,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_may = chl4[[seq_may]] ; chl4_may = calc(chl4_may,mean,na.rm=T); chl4_may = resample(chl4_may,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_jun = chl4[[seq_jun]] ; chl4_jun = calc(chl4_jun,mean,na.rm=T); chl4_jun = resample(chl4_jun,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_jul = chl4[[seq_jul]] ; chl4_jul = calc(chl4_jul,mean,na.rm=T); chl4_jul = resample(chl4_jul,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_aug = chl4[[seq_aug]] ; chl4_aug = calc(chl4_aug,mean,na.rm=T); chl4_aug = resample(chl4_aug,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_sep = chl4[[seq_sep]] ; chl4_sep = calc(chl4_sep,mean,na.rm=T); chl4_sep = resample(chl4_sep,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_oct = chl4[[seq_oct]] ; chl4_oct = calc(chl4_oct,mean,na.rm=T); chl4_oct = resample(chl4_oct,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_nov = chl4[[seq_nov]] ; chl4_nov = calc(chl4_nov,mean,na.rm=T); chl4_nov = resample(chl4_nov,bat)
chl4 = brick("env_vars.nc",varname = "chl",level=4) ; chl4 = crop(chl4,ext) ; chl4_dec = chl4[[seq_dec]] ; chl4_dec = calc(chl4_dec,mean,na.rm=T); chl4_dec = resample(chl4_dec,bat)
#depth5
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_jan = chl5[[seq_jan]] ; chl5_jan = calc(chl5_jan,mean,na.rm=T); chl5_jan = resample(chl5_jan,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_feb = chl5[[seq_feb]] ; chl5_feb = calc(chl5_feb,mean,na.rm=T); chl5_feb = resample(chl5_feb,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_mar = chl5[[seq_mar]] ; chl5_mar = calc(chl5_mar,mean,na.rm=T); chl5_mar = resample(chl5_mar,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_apr = chl5[[seq_apr]] ; chl5_apr = calc(chl5_apr,mean,na.rm=T); chl5_apr = resample(chl5_apr,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_may = chl5[[seq_may]] ; chl5_may = calc(chl5_may,mean,na.rm=T); chl5_may = resample(chl5_may,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_jun = chl5[[seq_jun]] ; chl5_jun = calc(chl5_jun,mean,na.rm=T); chl5_jun = resample(chl5_jun,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_jul = chl5[[seq_jul]] ; chl5_jul = calc(chl5_jul,mean,na.rm=T); chl5_jul = resample(chl5_jul,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_aug = chl5[[seq_aug]] ; chl5_aug = calc(chl5_aug,mean,na.rm=T); chl5_aug = resample(chl5_aug,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_sep = chl5[[seq_sep]] ; chl5_sep = calc(chl5_sep,mean,na.rm=T); chl5_sep = resample(chl5_sep,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_oct = chl5[[seq_oct]] ; chl5_oct = calc(chl5_oct,mean,na.rm=T); chl5_oct = resample(chl5_oct,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_nov = chl5[[seq_nov]] ; chl5_nov = calc(chl5_nov,mean,na.rm=T); chl5_nov = resample(chl5_nov,bat)
chl5 = brick("env_vars.nc",varname = "chl",level=5) ; chl5 = crop(chl5,ext) ; chl5_dec = chl5[[seq_dec]] ; chl5_dec = calc(chl5_dec,mean,na.rm=T); chl5_dec = resample(chl5_dec,bat)
#depth6
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_jan = chl6[[seq_jan]] ; chl6_jan = calc(chl6_jan,mean,na.rm=T); chl6_jan = resample(chl6_jan,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_feb = chl6[[seq_feb]] ; chl6_feb = calc(chl6_feb,mean,na.rm=T); chl6_feb = resample(chl6_feb,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_mar = chl6[[seq_mar]] ; chl6_mar = calc(chl6_mar,mean,na.rm=T); chl6_mar = resample(chl6_mar,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_apr = chl6[[seq_apr]] ; chl6_apr = calc(chl6_apr,mean,na.rm=T); chl6_apr = resample(chl6_apr,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_may = chl6[[seq_may]] ; chl6_may = calc(chl6_may,mean,na.rm=T); chl6_may = resample(chl6_may,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_jun = chl6[[seq_jun]] ; chl6_jun = calc(chl6_jun,mean,na.rm=T); chl6_jun = resample(chl6_jun,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_jul = chl6[[seq_jul]] ; chl6_jul = calc(chl6_jul,mean,na.rm=T); chl6_jul = resample(chl6_jul,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_aug = chl6[[seq_aug]] ; chl6_aug = calc(chl6_aug,mean,na.rm=T); chl6_aug = resample(chl6_aug,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_sep = chl6[[seq_sep]] ; chl6_sep = calc(chl6_sep,mean,na.rm=T); chl6_sep = resample(chl6_sep,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_oct = chl6[[seq_oct]] ; chl6_oct = calc(chl6_oct,mean,na.rm=T); chl6_oct = resample(chl6_oct,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_nov = chl6[[seq_nov]] ; chl6_nov = calc(chl6_nov,mean,na.rm=T); chl6_nov = resample(chl6_nov,bat)
chl6 = brick("env_vars.nc",varname = "chl",level=6) ; chl6 = crop(chl6,ext) ; chl6_dec = chl6[[seq_dec]] ; chl6_dec = calc(chl6_dec,mean,na.rm=T); chl6_dec = resample(chl6_dec,bat)
#depth7
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_jan = chl7[[seq_jan]] ; chl7_jan = calc(chl7_jan,mean,na.rm=T); chl7_jan = resample(chl7_jan,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_feb = chl7[[seq_feb]] ; chl7_feb = calc(chl7_feb,mean,na.rm=T); chl7_feb = resample(chl7_feb,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_mar = chl7[[seq_mar]] ; chl7_mar = calc(chl7_mar,mean,na.rm=T); chl7_mar = resample(chl7_mar,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_apr = chl7[[seq_apr]] ; chl7_apr = calc(chl7_apr,mean,na.rm=T); chl7_apr = resample(chl7_apr,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_may = chl7[[seq_may]] ; chl7_may = calc(chl7_may,mean,na.rm=T); chl7_may = resample(chl7_may,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_jun = chl7[[seq_jun]] ; chl7_jun = calc(chl7_jun,mean,na.rm=T); chl7_jun = resample(chl7_jun,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_jul = chl7[[seq_jul]] ; chl7_jul = calc(chl7_jul,mean,na.rm=T); chl7_jul = resample(chl7_jul,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_aug = chl7[[seq_aug]] ; chl7_aug = calc(chl7_aug,mean,na.rm=T); chl7_aug = resample(chl7_aug,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_sep = chl7[[seq_sep]] ; chl7_sep = calc(chl7_sep,mean,na.rm=T); chl7_sep = resample(chl7_sep,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_oct = chl7[[seq_oct]] ; chl7_oct = calc(chl7_oct,mean,na.rm=T); chl7_oct = resample(chl7_oct,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_nov = chl7[[seq_nov]] ; chl7_nov = calc(chl7_nov,mean,na.rm=T); chl7_nov = resample(chl7_nov,bat)
chl7 = brick("env_vars.nc",varname = "chl",level=7) ; chl7 = crop(chl7,ext) ; chl7_dec = chl7[[seq_dec]] ; chl7_dec = calc(chl7_dec,mean,na.rm=T); chl7_dec = resample(chl7_dec,bat)
#depth8
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_jan = chl8[[seq_jan]] ; chl8_jan = calc(chl8_jan,mean,na.rm=T); chl8_jan = resample(chl8_jan,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_feb = chl8[[seq_feb]] ; chl8_feb = calc(chl8_feb,mean,na.rm=T); chl8_feb = resample(chl8_feb,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_mar = chl8[[seq_mar]] ; chl8_mar = calc(chl8_mar,mean,na.rm=T); chl8_mar = resample(chl8_mar,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_apr = chl8[[seq_apr]] ; chl8_apr = calc(chl8_apr,mean,na.rm=T); chl8_apr = resample(chl8_apr,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_may = chl8[[seq_may]] ; chl8_may = calc(chl8_may,mean,na.rm=T); chl8_may = resample(chl8_may,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_jun = chl8[[seq_jun]] ; chl8_jun = calc(chl8_jun,mean,na.rm=T); chl8_jun = resample(chl8_jun,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_jul = chl8[[seq_jul]] ; chl8_jul = calc(chl8_jul,mean,na.rm=T); chl8_jul = resample(chl8_jul,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_aug = chl8[[seq_aug]] ; chl8_aug = calc(chl8_aug,mean,na.rm=T); chl8_aug = resample(chl8_aug,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_sep = chl8[[seq_sep]] ; chl8_sep = calc(chl8_sep,mean,na.rm=T); chl8_sep = resample(chl8_sep,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_oct = chl8[[seq_oct]] ; chl8_oct = calc(chl8_oct,mean,na.rm=T); chl8_oct = resample(chl8_oct,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_nov = chl8[[seq_nov]] ; chl8_nov = calc(chl8_nov,mean,na.rm=T); chl8_nov = resample(chl8_nov,bat)
chl8 = brick("env_vars.nc",varname = "chl",level=8) ; chl8 = crop(chl8,ext) ; chl8_dec = chl8[[seq_dec]] ; chl8_dec = calc(chl8_dec,mean,na.rm=T); chl8_dec = resample(chl8_dec,bat)
#depth9
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_jan = chl9[[seq_jan]] ; chl9_jan = calc(chl9_jan,mean,na.rm=T); chl9_jan = resample(chl9_jan,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_feb = chl9[[seq_feb]] ; chl9_feb = calc(chl9_feb,mean,na.rm=T); chl9_feb = resample(chl9_feb,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_mar = chl9[[seq_mar]] ; chl9_mar = calc(chl9_mar,mean,na.rm=T); chl9_mar = resample(chl9_mar,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_apr = chl9[[seq_apr]] ; chl9_apr = calc(chl9_apr,mean,na.rm=T); chl9_apr = resample(chl9_apr,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_may = chl9[[seq_may]] ; chl9_may = calc(chl9_may,mean,na.rm=T); chl9_may = resample(chl9_may,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_jun = chl9[[seq_jun]] ; chl9_jun = calc(chl9_jun,mean,na.rm=T); chl9_jun = resample(chl9_jun,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_jul = chl9[[seq_jul]] ; chl9_jul = calc(chl9_jul,mean,na.rm=T); chl9_jul = resample(chl9_jul,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_aug = chl9[[seq_aug]] ; chl9_aug = calc(chl9_aug,mean,na.rm=T); chl9_aug = resample(chl9_aug,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_sep = chl9[[seq_sep]] ; chl9_sep = calc(chl9_sep,mean,na.rm=T); chl9_sep = resample(chl9_sep,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_oct = chl9[[seq_oct]] ; chl9_oct = calc(chl9_oct,mean,na.rm=T); chl9_oct = resample(chl9_oct,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_nov = chl9[[seq_nov]] ; chl9_nov = calc(chl9_nov,mean,na.rm=T); chl9_nov = resample(chl9_nov,bat)
chl9 = brick("env_vars.nc",varname = "chl",level=9) ; chl9 = crop(chl9,ext) ; chl9_dec = chl9[[seq_dec]] ; chl9_dec = calc(chl9_dec,mean,na.rm=T); chl9_dec = resample(chl9_dec,bat)
#depth10
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_jan = chl10[[seq_jan]] ; chl10_jan = calc(chl10_jan,mean,na.rm=T); chl10_jan = resample(chl10_jan,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_feb = chl10[[seq_feb]] ; chl10_feb = calc(chl10_feb,mean,na.rm=T); chl10_feb = resample(chl10_feb,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_mar = chl10[[seq_mar]] ; chl10_mar = calc(chl10_mar,mean,na.rm=T); chl10_mar = resample(chl10_mar,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_apr = chl10[[seq_apr]] ; chl10_apr = calc(chl10_apr,mean,na.rm=T); chl10_apr = resample(chl10_apr,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_may = chl10[[seq_may]] ; chl10_may = calc(chl10_may,mean,na.rm=T); chl10_may = resample(chl10_may,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_jun = chl10[[seq_jun]] ; chl10_jun = calc(chl10_jun,mean,na.rm=T); chl10_jun = resample(chl10_jun,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_jul = chl10[[seq_jul]] ; chl10_jul = calc(chl10_jul,mean,na.rm=T); chl10_jul = resample(chl10_jul,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_aug = chl10[[seq_aug]] ; chl10_aug = calc(chl10_aug,mean,na.rm=T); chl10_aug = resample(chl10_aug,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_sep = chl10[[seq_sep]] ; chl10_sep = calc(chl10_sep,mean,na.rm=T); chl10_sep = resample(chl10_sep,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_oct = chl10[[seq_oct]] ; chl10_oct = calc(chl10_oct,mean,na.rm=T); chl10_oct = resample(chl10_oct,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_nov = chl10[[seq_nov]] ; chl10_nov = calc(chl10_nov,mean,na.rm=T); chl10_nov = resample(chl10_nov,bat)
chl10 = brick("env_vars.nc",varname = "chl",level=10) ; chl10 = crop(chl10,ext) ; chl10_dec = chl10[[seq_dec]] ; chl10_dec = calc(chl10_dec,mean,na.rm=T); chl10_dec = resample(chl10_dec,bat)
#depth11
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_jan = chl11[[seq_jan]] ; chl11_jan = calc(chl11_jan,mean,na.rm=T); chl11_jan = resample(chl11_jan,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_feb = chl11[[seq_feb]] ; chl11_feb = calc(chl11_feb,mean,na.rm=T); chl11_feb = resample(chl11_feb,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_mar = chl11[[seq_mar]] ; chl11_mar = calc(chl11_mar,mean,na.rm=T); chl11_mar = resample(chl11_mar,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_apr = chl11[[seq_apr]] ; chl11_apr = calc(chl11_apr,mean,na.rm=T); chl11_apr = resample(chl11_apr,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_may = chl11[[seq_may]] ; chl11_may = calc(chl11_may,mean,na.rm=T); chl11_may = resample(chl11_may,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_jun = chl11[[seq_jun]] ; chl11_jun = calc(chl11_jun,mean,na.rm=T); chl11_jun = resample(chl11_jun,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_jul = chl11[[seq_jul]] ; chl11_jul = calc(chl11_jul,mean,na.rm=T); chl11_jul = resample(chl11_jul,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_aug = chl11[[seq_aug]] ; chl11_aug = calc(chl11_aug,mean,na.rm=T); chl11_aug = resample(chl11_aug,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_sep = chl11[[seq_sep]] ; chl11_sep = calc(chl11_sep,mean,na.rm=T); chl11_sep = resample(chl11_sep,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_oct = chl11[[seq_oct]] ; chl11_oct = calc(chl11_oct,mean,na.rm=T); chl11_oct = resample(chl11_oct,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_nov = chl11[[seq_nov]] ; chl11_nov = calc(chl11_nov,mean,na.rm=T); chl11_nov = resample(chl11_nov,bat)
chl11 = brick("env_vars.nc",varname = "chl",level=11) ; chl11 = crop(chl11,ext) ; chl11_dec = chl11[[seq_dec]] ; chl11_dec = calc(chl11_dec,mean,na.rm=T); chl11_dec = resample(chl11_dec,bat)
#depth111
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_jan = chl12[[seq_jan]] ; chl12_jan = calc(chl12_jan,mean,na.rm=T); chl12_jan = resample(chl12_jan,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_feb = chl12[[seq_feb]] ; chl12_feb = calc(chl12_feb,mean,na.rm=T); chl12_feb = resample(chl12_feb,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_mar = chl12[[seq_mar]] ; chl12_mar = calc(chl12_mar,mean,na.rm=T); chl12_mar = resample(chl12_mar,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_apr = chl12[[seq_apr]] ; chl12_apr = calc(chl12_apr,mean,na.rm=T); chl12_apr = resample(chl12_apr,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_may = chl12[[seq_may]] ; chl12_may = calc(chl12_may,mean,na.rm=T); chl12_may = resample(chl12_may,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_jun = chl12[[seq_jun]] ; chl12_jun = calc(chl12_jun,mean,na.rm=T); chl12_jun = resample(chl12_jun,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_jul = chl12[[seq_jul]] ; chl12_jul = calc(chl12_jul,mean,na.rm=T); chl12_jul = resample(chl12_jul,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_aug = chl12[[seq_aug]] ; chl12_aug = calc(chl12_aug,mean,na.rm=T); chl12_aug = resample(chl12_aug,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_sep = chl12[[seq_sep]] ; chl12_sep = calc(chl12_sep,mean,na.rm=T); chl12_sep = resample(chl12_sep,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_oct = chl12[[seq_oct]] ; chl12_oct = calc(chl12_oct,mean,na.rm=T); chl12_oct = resample(chl12_oct,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_nov = chl12[[seq_nov]] ; chl12_nov = calc(chl12_nov,mean,na.rm=T); chl12_nov = resample(chl12_nov,bat)
chl12 = brick("env_vars.nc",varname = "chl",level=12) ; chl12 = crop(chl12,ext) ; chl12_dec = chl12[[seq_dec]] ; chl12_dec = calc(chl12_dec,mean,na.rm=T); chl12_dec = resample(chl12_dec,bat)
#depth13
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_jan = chl13[[seq_jan]] ; chl13_jan = calc(chl13_jan,mean,na.rm=T); chl13_jan = resample(chl13_jan,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_feb = chl13[[seq_feb]] ; chl13_feb = calc(chl13_feb,mean,na.rm=T); chl13_feb = resample(chl13_feb,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_mar = chl13[[seq_mar]] ; chl13_mar = calc(chl13_mar,mean,na.rm=T); chl13_mar = resample(chl13_mar,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_apr = chl13[[seq_apr]] ; chl13_apr = calc(chl13_apr,mean,na.rm=T); chl13_apr = resample(chl13_apr,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_may = chl13[[seq_may]] ; chl13_may = calc(chl13_may,mean,na.rm=T); chl13_may = resample(chl13_may,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_jun = chl13[[seq_jun]] ; chl13_jun = calc(chl13_jun,mean,na.rm=T); chl13_jun = resample(chl13_jun,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_jul = chl13[[seq_jul]] ; chl13_jul = calc(chl13_jul,mean,na.rm=T); chl13_jul = resample(chl13_jul,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_aug = chl13[[seq_aug]] ; chl13_aug = calc(chl13_aug,mean,na.rm=T); chl13_aug = resample(chl13_aug,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_sep = chl13[[seq_sep]] ; chl13_sep = calc(chl13_sep,mean,na.rm=T); chl13_sep = resample(chl13_sep,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_oct = chl13[[seq_oct]] ; chl13_oct = calc(chl13_oct,mean,na.rm=T); chl13_oct = resample(chl13_oct,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_nov = chl13[[seq_nov]] ; chl13_nov = calc(chl13_nov,mean,na.rm=T); chl13_nov = resample(chl13_nov,bat)
chl13 = brick("env_vars.nc",varname = "chl",level=13) ; chl13 = crop(chl13,ext) ; chl13_dec = chl13[[seq_dec]] ; chl13_dec = calc(chl13_dec,mean,na.rm=T); chl13_dec = resample(chl13_dec,bat)
#depth14
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_jan = chl14[[seq_jan]] ; chl14_jan = calc(chl14_jan,mean,na.rm=T); chl14_jan = resample(chl14_jan,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_feb = chl14[[seq_feb]] ; chl14_feb = calc(chl14_feb,mean,na.rm=T); chl14_feb = resample(chl14_feb,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_mar = chl14[[seq_mar]] ; chl14_mar = calc(chl14_mar,mean,na.rm=T); chl14_mar = resample(chl14_mar,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_apr = chl14[[seq_apr]] ; chl14_apr = calc(chl14_apr,mean,na.rm=T); chl14_apr = resample(chl14_apr,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_may = chl14[[seq_may]] ; chl14_may = calc(chl14_may,mean,na.rm=T); chl14_may = resample(chl14_may,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_jun = chl14[[seq_jun]] ; chl14_jun = calc(chl14_jun,mean,na.rm=T); chl14_jun = resample(chl14_jun,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_jul = chl14[[seq_jul]] ; chl14_jul = calc(chl14_jul,mean,na.rm=T); chl14_jul = resample(chl14_jul,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_aug = chl14[[seq_aug]] ; chl14_aug = calc(chl14_aug,mean,na.rm=T); chl14_aug = resample(chl14_aug,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_sep = chl14[[seq_sep]] ; chl14_sep = calc(chl14_sep,mean,na.rm=T); chl14_sep = resample(chl14_sep,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_oct = chl14[[seq_oct]] ; chl14_oct = calc(chl14_oct,mean,na.rm=T); chl14_oct = resample(chl14_oct,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_nov = chl14[[seq_nov]] ; chl14_nov = calc(chl14_nov,mean,na.rm=T); chl14_nov = resample(chl14_nov,bat)
chl14 = brick("env_vars.nc",varname = "chl",level=14) ; chl14 = crop(chl14,ext) ; chl14_dec = chl14[[seq_dec]] ; chl14_dec = calc(chl14_dec,mean,na.rm=T); chl14_dec = resample(chl14_dec,bat)
#depth15
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_jan = chl15[[seq_jan]] ; chl15_jan = calc(chl15_jan,mean,na.rm=T); chl15_jan = resample(chl15_jan,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_feb = chl15[[seq_feb]] ; chl15_feb = calc(chl15_feb,mean,na.rm=T); chl15_feb = resample(chl15_feb,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_mar = chl15[[seq_mar]] ; chl15_mar = calc(chl15_mar,mean,na.rm=T); chl15_mar = resample(chl15_mar,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_apr = chl15[[seq_apr]] ; chl15_apr = calc(chl15_apr,mean,na.rm=T); chl15_apr = resample(chl15_apr,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_may = chl15[[seq_may]] ; chl15_may = calc(chl15_may,mean,na.rm=T); chl15_may = resample(chl15_may,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_jun = chl15[[seq_jun]] ; chl15_jun = calc(chl15_jun,mean,na.rm=T); chl15_jun = resample(chl15_jun,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_jul = chl15[[seq_jul]] ; chl15_jul = calc(chl15_jul,mean,na.rm=T); chl15_jul = resample(chl15_jul,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_aug = chl15[[seq_aug]] ; chl15_aug = calc(chl15_aug,mean,na.rm=T); chl15_aug = resample(chl15_aug,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_sep = chl15[[seq_sep]] ; chl15_sep = calc(chl15_sep,mean,na.rm=T); chl15_sep = resample(chl15_sep,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_oct = chl15[[seq_oct]] ; chl15_oct = calc(chl15_oct,mean,na.rm=T); chl15_oct = resample(chl15_oct,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_nov = chl15[[seq_nov]] ; chl15_nov = calc(chl15_nov,mean,na.rm=T); chl15_nov = resample(chl15_nov,bat)
chl15 = brick("env_vars.nc",varname = "chl",level=15) ; chl15 = crop(chl15,ext) ; chl15_dec = chl15[[seq_dec]] ; chl15_dec = calc(chl15_dec,mean,na.rm=T); chl15_dec = resample(chl15_dec,bat)
#depth16
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_jan = chl16[[seq_jan]] ; chl16_jan = calc(chl16_jan,mean,na.rm=T); chl16_jan = resample(chl16_jan,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_feb = chl16[[seq_feb]] ; chl16_feb = calc(chl16_feb,mean,na.rm=T); chl16_feb = resample(chl16_feb,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_mar = chl16[[seq_mar]] ; chl16_mar = calc(chl16_mar,mean,na.rm=T); chl16_mar = resample(chl16_mar,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_apr = chl16[[seq_apr]] ; chl16_apr = calc(chl16_apr,mean,na.rm=T); chl16_apr = resample(chl16_apr,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_may = chl16[[seq_may]] ; chl16_may = calc(chl16_may,mean,na.rm=T); chl16_may = resample(chl16_may,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_jun = chl16[[seq_jun]] ; chl16_jun = calc(chl16_jun,mean,na.rm=T); chl16_jun = resample(chl16_jun,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_jul = chl16[[seq_jul]] ; chl16_jul = calc(chl16_jul,mean,na.rm=T); chl16_jul = resample(chl16_jul,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_aug = chl16[[seq_aug]] ; chl16_aug = calc(chl16_aug,mean,na.rm=T); chl16_aug = resample(chl16_aug,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_sep = chl16[[seq_sep]] ; chl16_sep = calc(chl16_sep,mean,na.rm=T); chl16_sep = resample(chl16_sep,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_oct = chl16[[seq_oct]] ; chl16_oct = calc(chl16_oct,mean,na.rm=T); chl16_oct = resample(chl16_oct,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_nov = chl16[[seq_nov]] ; chl16_nov = calc(chl16_nov,mean,na.rm=T); chl16_nov = resample(chl16_nov,bat)
chl16 = brick("env_vars.nc",varname = "chl",level=16) ; chl16 = crop(chl16,ext) ; chl16_dec = chl16[[seq_dec]] ; chl16_dec = calc(chl16_dec,mean,na.rm=T); chl16_dec = resample(chl16_dec,bat)
#depth17
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_jan = chl17[[seq_jan]] ; chl17_jan = calc(chl17_jan,mean,na.rm=T); chl17_jan = resample(chl17_jan,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_feb = chl17[[seq_feb]] ; chl17_feb = calc(chl17_feb,mean,na.rm=T); chl17_feb = resample(chl17_feb,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_mar = chl17[[seq_mar]] ; chl17_mar = calc(chl17_mar,mean,na.rm=T); chl17_mar = resample(chl17_mar,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_apr = chl17[[seq_apr]] ; chl17_apr = calc(chl17_apr,mean,na.rm=T); chl17_apr = resample(chl17_apr,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_may = chl17[[seq_may]] ; chl17_may = calc(chl17_may,mean,na.rm=T); chl17_may = resample(chl17_may,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_jun = chl17[[seq_jun]] ; chl17_jun = calc(chl17_jun,mean,na.rm=T); chl17_jun = resample(chl17_jun,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_jul = chl17[[seq_jul]] ; chl17_jul = calc(chl17_jul,mean,na.rm=T); chl17_jul = resample(chl17_jul,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_aug = chl17[[seq_aug]] ; chl17_aug = calc(chl17_aug,mean,na.rm=T); chl17_aug = resample(chl17_aug,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_sep = chl17[[seq_sep]] ; chl17_sep = calc(chl17_sep,mean,na.rm=T); chl17_sep = resample(chl17_sep,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_oct = chl17[[seq_oct]] ; chl17_oct = calc(chl17_oct,mean,na.rm=T); chl17_oct = resample(chl17_oct,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_nov = chl17[[seq_nov]] ; chl17_nov = calc(chl17_nov,mean,na.rm=T); chl17_nov = resample(chl17_nov,bat)
chl17 = brick("env_vars.nc",varname = "chl",level=17) ; chl17 = crop(chl17,ext) ; chl17_dec = chl17[[seq_dec]] ; chl17_dec = calc(chl17_dec,mean,na.rm=T); chl17_dec = resample(chl17_dec,bat)
#depth18
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_jan = chl18[[seq_jan]] ; chl18_jan = calc(chl18_jan,mean,na.rm=T); chl18_jan = resample(chl18_jan,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_feb = chl18[[seq_feb]] ; chl18_feb = calc(chl18_feb,mean,na.rm=T); chl18_feb = resample(chl18_feb,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_mar = chl18[[seq_mar]] ; chl18_mar = calc(chl18_mar,mean,na.rm=T); chl18_mar = resample(chl18_mar,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_apr = chl18[[seq_apr]] ; chl18_apr = calc(chl18_apr,mean,na.rm=T); chl18_apr = resample(chl18_apr,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_may = chl18[[seq_may]] ; chl18_may = calc(chl18_may,mean,na.rm=T); chl18_may = resample(chl18_may,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_jun = chl18[[seq_jun]] ; chl18_jun = calc(chl18_jun,mean,na.rm=T); chl18_jun = resample(chl18_jun,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_jul = chl18[[seq_jul]] ; chl18_jul = calc(chl18_jul,mean,na.rm=T); chl18_jul = resample(chl18_jul,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_aug = chl18[[seq_aug]] ; chl18_aug = calc(chl18_aug,mean,na.rm=T); chl18_aug = resample(chl18_aug,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_sep = chl18[[seq_sep]] ; chl18_sep = calc(chl18_sep,mean,na.rm=T); chl18_sep = resample(chl18_sep,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_oct = chl18[[seq_oct]] ; chl18_oct = calc(chl18_oct,mean,na.rm=T); chl18_oct = resample(chl18_oct,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_nov = chl18[[seq_nov]] ; chl18_nov = calc(chl18_nov,mean,na.rm=T); chl18_nov = resample(chl18_nov,bat)
chl18 = brick("env_vars.nc",varname = "chl",level=18) ; chl18 = crop(chl18,ext) ; chl18_dec = chl18[[seq_dec]] ; chl18_dec = calc(chl18_dec,mean,na.rm=T); chl18_dec = resample(chl18_dec,bat)
#depth19
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_jan = chl19[[seq_jan]] ; chl19_jan = calc(chl19_jan,mean,na.rm=T); chl19_jan = resample(chl19_jan,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_feb = chl19[[seq_feb]] ; chl19_feb = calc(chl19_feb,mean,na.rm=T); chl19_feb = resample(chl19_feb,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_mar = chl19[[seq_mar]] ; chl19_mar = calc(chl19_mar,mean,na.rm=T); chl19_mar = resample(chl19_mar,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_apr = chl19[[seq_apr]] ; chl19_apr = calc(chl19_apr,mean,na.rm=T); chl19_apr = resample(chl19_apr,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_may = chl19[[seq_may]] ; chl19_may = calc(chl19_may,mean,na.rm=T); chl19_may = resample(chl19_may,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_jun = chl19[[seq_jun]] ; chl19_jun = calc(chl19_jun,mean,na.rm=T); chl19_jun = resample(chl19_jun,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_jul = chl19[[seq_jul]] ; chl19_jul = calc(chl19_jul,mean,na.rm=T); chl19_jul = resample(chl19_jul,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_aug = chl19[[seq_aug]] ; chl19_aug = calc(chl19_aug,mean,na.rm=T); chl19_aug = resample(chl19_aug,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_sep = chl19[[seq_sep]] ; chl19_sep = calc(chl19_sep,mean,na.rm=T); chl19_sep = resample(chl19_sep,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_oct = chl19[[seq_oct]] ; chl19_oct = calc(chl19_oct,mean,na.rm=T); chl19_oct = resample(chl19_oct,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_nov = chl19[[seq_nov]] ; chl19_nov = calc(chl19_nov,mean,na.rm=T); chl19_nov = resample(chl19_nov,bat)
chl19 = brick("env_vars.nc",varname = "chl",level=19) ; chl19 = crop(chl19,ext) ; chl19_dec = chl19[[seq_dec]] ; chl19_dec = calc(chl19_dec,mean,na.rm=T); chl19_dec = resample(chl19_dec,bat)
#depth10
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_jan = chl20[[seq_jan]] ; chl20_jan = calc(chl20_jan,mean,na.rm=T); chl20_jan = resample(chl20_jan,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_feb = chl20[[seq_feb]] ; chl20_feb = calc(chl20_feb,mean,na.rm=T); chl20_feb = resample(chl20_feb,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_mar = chl20[[seq_mar]] ; chl20_mar = calc(chl20_mar,mean,na.rm=T); chl20_mar = resample(chl20_mar,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_apr = chl20[[seq_apr]] ; chl20_apr = calc(chl20_apr,mean,na.rm=T); chl20_apr = resample(chl20_apr,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_may = chl20[[seq_may]] ; chl20_may = calc(chl20_may,mean,na.rm=T); chl20_may = resample(chl20_may,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_jun = chl20[[seq_jun]] ; chl20_jun = calc(chl20_jun,mean,na.rm=T); chl20_jun = resample(chl20_jun,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_jul = chl20[[seq_jul]] ; chl20_jul = calc(chl20_jul,mean,na.rm=T); chl20_jul = resample(chl20_jul,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_aug = chl20[[seq_aug]] ; chl20_aug = calc(chl20_aug,mean,na.rm=T); chl20_aug = resample(chl20_aug,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_sep = chl20[[seq_sep]] ; chl20_sep = calc(chl20_sep,mean,na.rm=T); chl20_sep = resample(chl20_sep,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_oct = chl20[[seq_oct]] ; chl20_oct = calc(chl20_oct,mean,na.rm=T); chl20_oct = resample(chl20_oct,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_nov = chl20[[seq_nov]] ; chl20_nov = calc(chl20_nov,mean,na.rm=T); chl20_nov = resample(chl20_nov,bat)
chl20 = brick("env_vars.nc",varname = "chl",level=20) ; chl20 = crop(chl20,ext) ; chl20_dec = chl20[[seq_dec]] ; chl20_dec = calc(chl20_dec,mean,na.rm=T); chl20_dec = resample(chl20_dec,bat)
#depth21
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_jan = chl21[[seq_jan]] ; chl21_jan = calc(chl21_jan,mean,na.rm=T); chl21_jan = resample(chl21_jan,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_feb = chl21[[seq_feb]] ; chl21_feb = calc(chl21_feb,mean,na.rm=T); chl21_feb = resample(chl21_feb,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_mar = chl21[[seq_mar]] ; chl21_mar = calc(chl21_mar,mean,na.rm=T); chl21_mar = resample(chl21_mar,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_apr = chl21[[seq_apr]] ; chl21_apr = calc(chl21_apr,mean,na.rm=T); chl21_apr = resample(chl21_apr,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_may = chl21[[seq_may]] ; chl21_may = calc(chl21_may,mean,na.rm=T); chl21_may = resample(chl21_may,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_jun = chl21[[seq_jun]] ; chl21_jun = calc(chl21_jun,mean,na.rm=T); chl21_jun = resample(chl21_jun,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_jul = chl21[[seq_jul]] ; chl21_jul = calc(chl21_jul,mean,na.rm=T); chl21_jul = resample(chl21_jul,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_aug = chl21[[seq_aug]] ; chl21_aug = calc(chl21_aug,mean,na.rm=T); chl21_aug = resample(chl21_aug,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_sep = chl21[[seq_sep]] ; chl21_sep = calc(chl21_sep,mean,na.rm=T); chl21_sep = resample(chl21_sep,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_oct = chl21[[seq_oct]] ; chl21_oct = calc(chl21_oct,mean,na.rm=T); chl21_oct = resample(chl21_oct,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_nov = chl21[[seq_nov]] ; chl21_nov = calc(chl21_nov,mean,na.rm=T); chl21_nov = resample(chl21_nov,bat)
chl21 = brick("env_vars.nc",varname = "chl",level=21) ; chl21 = crop(chl21,ext) ; chl21_dec = chl21[[seq_dec]] ; chl21_dec = calc(chl21_dec,mean,na.rm=T); chl21_dec = resample(chl21_dec,bat)
#depth22
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_jan = chl22[[seq_jan]] ; chl22_jan = calc(chl22_jan,mean,na.rm=T); chl22_jan = resample(chl22_jan,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_feb = chl22[[seq_feb]] ; chl22_feb = calc(chl22_feb,mean,na.rm=T); chl22_feb = resample(chl22_feb,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_mar = chl22[[seq_mar]] ; chl22_mar = calc(chl22_mar,mean,na.rm=T); chl22_mar = resample(chl22_mar,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_apr = chl22[[seq_apr]] ; chl22_apr = calc(chl22_apr,mean,na.rm=T); chl22_apr = resample(chl22_apr,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_may = chl22[[seq_may]] ; chl22_may = calc(chl22_may,mean,na.rm=T); chl22_may = resample(chl22_may,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_jun = chl22[[seq_jun]] ; chl22_jun = calc(chl22_jun,mean,na.rm=T); chl22_jun = resample(chl22_jun,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_jul = chl22[[seq_jul]] ; chl22_jul = calc(chl22_jul,mean,na.rm=T); chl22_jul = resample(chl22_jul,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_aug = chl22[[seq_aug]] ; chl22_aug = calc(chl22_aug,mean,na.rm=T); chl22_aug = resample(chl22_aug,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_sep = chl22[[seq_sep]] ; chl22_sep = calc(chl22_sep,mean,na.rm=T); chl22_sep = resample(chl22_sep,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_oct = chl22[[seq_oct]] ; chl22_oct = calc(chl22_oct,mean,na.rm=T); chl22_oct = resample(chl22_oct,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_nov = chl22[[seq_nov]] ; chl22_nov = calc(chl22_nov,mean,na.rm=T); chl22_nov = resample(chl22_nov,bat)
chl22 = brick("env_vars.nc",varname = "chl",level=22) ; chl22 = crop(chl22,ext) ; chl22_dec = chl22[[seq_dec]] ; chl22_dec = calc(chl22_dec,mean,na.rm=T); chl22_dec = resample(chl22_dec,bat)
#depth23
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_jan = chl23[[seq_jan]] ; chl23_jan = calc(chl23_jan,mean,na.rm=T); chl23_jan = resample(chl23_jan,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_feb = chl23[[seq_feb]] ; chl23_feb = calc(chl23_feb,mean,na.rm=T); chl23_feb = resample(chl23_feb,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_mar = chl23[[seq_mar]] ; chl23_mar = calc(chl23_mar,mean,na.rm=T); chl23_mar = resample(chl23_mar,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_apr = chl23[[seq_apr]] ; chl23_apr = calc(chl23_apr,mean,na.rm=T); chl23_apr = resample(chl23_apr,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_may = chl23[[seq_may]] ; chl23_may = calc(chl23_may,mean,na.rm=T); chl23_may = resample(chl23_may,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_jun = chl23[[seq_jun]] ; chl23_jun = calc(chl23_jun,mean,na.rm=T); chl23_jun = resample(chl23_jun,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_jul = chl23[[seq_jul]] ; chl23_jul = calc(chl23_jul,mean,na.rm=T); chl23_jul = resample(chl23_jul,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_aug = chl23[[seq_aug]] ; chl23_aug = calc(chl23_aug,mean,na.rm=T); chl23_aug = resample(chl23_aug,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_sep = chl23[[seq_sep]] ; chl23_sep = calc(chl23_sep,mean,na.rm=T); chl23_sep = resample(chl23_sep,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_oct = chl23[[seq_oct]] ; chl23_oct = calc(chl23_oct,mean,na.rm=T); chl23_oct = resample(chl23_oct,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_nov = chl23[[seq_nov]] ; chl23_nov = calc(chl23_nov,mean,na.rm=T); chl23_nov = resample(chl23_nov,bat)
chl23 = brick("env_vars.nc",varname = "chl",level=23) ; chl23 = crop(chl23,ext) ; chl23_dec = chl23[[seq_dec]] ; chl23_dec = calc(chl23_dec,mean,na.rm=T); chl23_dec = resample(chl23_dec,bat)
#depth24
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_jan = chl24[[seq_jan]] ; chl24_jan = calc(chl24_jan,mean,na.rm=T); chl24_jan = resample(chl24_jan,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_feb = chl24[[seq_feb]] ; chl24_feb = calc(chl24_feb,mean,na.rm=T); chl24_feb = resample(chl24_feb,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_mar = chl24[[seq_mar]] ; chl24_mar = calc(chl24_mar,mean,na.rm=T); chl24_mar = resample(chl24_mar,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_apr = chl24[[seq_apr]] ; chl24_apr = calc(chl24_apr,mean,na.rm=T); chl24_apr = resample(chl24_apr,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_may = chl24[[seq_may]] ; chl24_may = calc(chl24_may,mean,na.rm=T); chl24_may = resample(chl24_may,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_jun = chl24[[seq_jun]] ; chl24_jun = calc(chl24_jun,mean,na.rm=T); chl24_jun = resample(chl24_jun,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_jul = chl24[[seq_jul]] ; chl24_jul = calc(chl24_jul,mean,na.rm=T); chl24_jul = resample(chl24_jul,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_aug = chl24[[seq_aug]] ; chl24_aug = calc(chl24_aug,mean,na.rm=T); chl24_aug = resample(chl24_aug,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_sep = chl24[[seq_sep]] ; chl24_sep = calc(chl24_sep,mean,na.rm=T); chl24_sep = resample(chl24_sep,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_oct = chl24[[seq_oct]] ; chl24_oct = calc(chl24_oct,mean,na.rm=T); chl24_oct = resample(chl24_oct,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_nov = chl24[[seq_nov]] ; chl24_nov = calc(chl24_nov,mean,na.rm=T); chl24_nov = resample(chl24_nov,bat)
chl24 = brick("env_vars.nc",varname = "chl",level=24) ; chl24 = crop(chl24,ext) ; chl24_dec = chl24[[seq_dec]] ; chl24_dec = calc(chl24_dec,mean,na.rm=T); chl24_dec = resample(chl24_dec,bat)
#depth25
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_jan = chl25[[seq_jan]] ; chl25_jan = calc(chl25_jan,mean,na.rm=T); chl25_jan = resample(chl25_jan,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_feb = chl25[[seq_feb]] ; chl25_feb = calc(chl25_feb,mean,na.rm=T); chl25_feb = resample(chl25_feb,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_mar = chl25[[seq_mar]] ; chl25_mar = calc(chl25_mar,mean,na.rm=T); chl25_mar = resample(chl25_mar,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_apr = chl25[[seq_apr]] ; chl25_apr = calc(chl25_apr,mean,na.rm=T); chl25_apr = resample(chl25_apr,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_may = chl25[[seq_may]] ; chl25_may = calc(chl25_may,mean,na.rm=T); chl25_may = resample(chl25_may,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_jun = chl25[[seq_jun]] ; chl25_jun = calc(chl25_jun,mean,na.rm=T); chl25_jun = resample(chl25_jun,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_jul = chl25[[seq_jul]] ; chl25_jul = calc(chl25_jul,mean,na.rm=T); chl25_jul = resample(chl25_jul,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_aug = chl25[[seq_aug]] ; chl25_aug = calc(chl25_aug,mean,na.rm=T); chl25_aug = resample(chl25_aug,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_sep = chl25[[seq_sep]] ; chl25_sep = calc(chl25_sep,mean,na.rm=T); chl25_sep = resample(chl25_sep,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_oct = chl25[[seq_oct]] ; chl25_oct = calc(chl25_oct,mean,na.rm=T); chl25_oct = resample(chl25_oct,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_nov = chl25[[seq_nov]] ; chl25_nov = calc(chl25_nov,mean,na.rm=T); chl25_nov = resample(chl25_nov,bat)
chl25 = brick("env_vars.nc",varname = "chl",level=25) ; chl25 = crop(chl25,ext) ; chl25_dec = chl25[[seq_dec]] ; chl25_dec = calc(chl25_dec,mean,na.rm=T); chl25_dec = resample(chl25_dec,bat)
#__________________________________________________________________________________________________________________



#:: Resulting rasters (chl1 to chl23) are the multiannual monthly mean layers of chl for each month from depth 1 to depth 23
# (0.5 to 108.03 m depth)



#__________________________________________________________________________________________________________________
# STEP 3 chl------------------------------------------------------------------
# Reclassify Bathymetric layer using depths in the restulting rasters from step 2 as new classes

# 3.1 Create a reclassification matrix for target depths (0.5 to 108.03 m depth)
reclass_m <- matrix(c(-Inf, -109.0, NA,
                   -108.029, -97.040, 25,
                   -97.039, -86.930, 24,
                   -86.929, -77.610, 23,
                   -77.609, -69.020, 22,
                   -69.019, -61.110, 21,
                   -61.109, -53.850, 20,
                   -53.849, -47.210, 19,
                   -47.209, -41.180, 18,
                   -41.179, -35.740, 17,
                   -35.739, -30.870, 16,
                   -30.869, -26.560, 15,
                   -26.559, -22.760, 14,
                   -22.759, -19.430, 13,
                   -19.429, -16.530, 12,
                   -16.529, -13.990, 11,
                   -13.989, -11.770, 10,
                   -11.769, -9.820, 9,
                   -9.819, -8.090, 8,
                   -8.089, -6.540, 7,
                   -6.539, -5.140, 6,
                   -5.139, -3.860, 5,
                   -3.859, -2.670, 4,
                   -2.669, -1.560, 3,
                   -1.559, -0.510, 2,
                   -0.509, 0, 1,
                   0.1, Inf, NA), ncol=3, byrow=TRUE)

##:: Note that values above 0m and below -13.99m are set to NA

# 3.2 Reclassify Bathymetric layer using "reclass_m"
bat_reclass <- reclassify(bat,reclass_m)
#check the plot
plot(bat_reclass)


# 3.3 #extract values from the reclassified raster for each new depth class
bat_depth1 = raster::clamp (bat_reclass,lower = 1, upper= 1,useValues=FALSE)
bat_depth2 = raster::clamp (bat_reclass,lower = 2, upper= 2,useValues=FALSE)
bat_depth3 = raster::clamp (bat_reclass,lower = 3, upper= 3,useValues=FALSE)
bat_depth4 = raster::clamp (bat_reclass,lower = 4, upper= 4,useValues=FALSE)
bat_depth5 = raster::clamp (bat_reclass,lower = 5, upper= 5,useValues=FALSE)
bat_depth6 = raster::clamp (bat_reclass,lower = 6, upper= 6,useValues=FALSE)
bat_depth7 = raster::clamp (bat_reclass,lower = 7, upper= 7,useValues=FALSE)
bat_depth8 = raster::clamp (bat_reclass,lower = 8, upper= 8,useValues=FALSE)
bat_depth9 = raster::clamp (bat_reclass,lower = 9, upper= 9,useValues=FALSE)
bat_depth10 = raster::clamp (bat_reclass,lower = 10, upper= 10,useValues=FALSE)
bat_depth11 = raster::clamp (bat_reclass,lower = 11, upper= 11,useValues=FALSE)
bat_depth12 = raster::clamp (bat_reclass,lower = 12, upper= 12,useValues=FALSE)
bat_depth13 = raster::clamp (bat_reclass,lower = 13, upper= 13,useValues=FALSE)
bat_depth14 = raster::clamp (bat_reclass,lower = 14, upper= 14,useValues=FALSE)
bat_depth15 = raster::clamp (bat_reclass,lower = 15, upper= 15,useValues=FALSE)
bat_depth16 = raster::clamp (bat_reclass,lower = 16, upper= 16,useValues=FALSE)
bat_depth17 = raster::clamp (bat_reclass,lower = 17, upper= 17,useValues=FALSE)
bat_depth18 = raster::clamp (bat_reclass,lower = 18, upper= 18,useValues=FALSE)
bat_depth19 = raster::clamp (bat_reclass,lower = 19, upper= 19,useValues=FALSE)
bat_depth20 = raster::clamp (bat_reclass,lower = 20, upper= 20,useValues=FALSE)
bat_depth21 = raster::clamp (bat_reclass,lower = 21, upper= 21,useValues=FALSE)
bat_depth22 = raster::clamp (bat_reclass,lower = 22, upper= 22,useValues=FALSE)
bat_depth23 = raster::clamp (bat_reclass,lower = 23, upper= 23,useValues=FALSE)
bat_depth24 = raster::clamp (bat_reclass,lower = 24, upper= 24,useValues=FALSE)
bat_depth25 = raster::clamp (bat_reclass,lower = 25, upper= 25,useValues=FALSE)

#__________________________________________________________________________________________________________________




#__________________________________________________________________________________________________________________
# STEP 4 chl------------------------------------------------------------------
# 4.1 Extract data from chl at each depth using reclassified depth classes as masks 
# for each month, by first aligning spatial extents that might have slightly 
# moved during during last steps

chl_depth_1_jan = raster::mask(chl23_jan,bat_depth1)
chl_depth_2_jan = raster::mask(chl2_jan,bat_depth2)
chl_depth_3_jan = raster::mask(chl3_jan,bat_depth3)
chl_depth_4_jan = raster::mask(chl4_jan,bat_depth4)
chl_depth_5_jan = raster::mask(chl5_jan,bat_depth5)
chl_depth_6_jan = raster::mask(chl6_jan,bat_depth6)
chl_depth_7_jan = raster::mask(chl7_jan,bat_depth7)
chl_depth_8_jan = raster::mask(chl8_jan,bat_depth8)
chl_depth_9_jan = raster::mask(chl9_jan,bat_depth9)
chl_depth_10_jan = raster::mask(chl10_jan,bat_depth10)
chl_depth_11_jan = raster::mask(chl11_jan,bat_depth11)
chl_depth_12_jan = raster::mask(chl12_jan,bat_depth12)
chl_depth_13_jan = raster::mask(chl13_jan,bat_depth13)
chl_depth_14_jan = raster::mask(chl14_jan,bat_depth14)
chl_depth_15_jan = raster::mask(chl15_jan,bat_depth15)
chl_depth_16_jan = raster::mask(chl16_jan,bat_depth16)
chl_depth_17_jan = raster::mask(chl17_jan,bat_depth17)
chl_depth_18_jan = raster::mask(chl18_jan,bat_depth18)
chl_depth_19_jan = raster::mask(chl19_jan,bat_depth19)
chl_depth_20_jan = raster::mask(chl20_jan,bat_depth20)
chl_depth_21_jan = raster::mask(chl21_jan,bat_depth21)
chl_depth_22_jan = raster::mask(chl22_jan,bat_depth22)
chl_depth_23_jan = raster::mask(chl23_jan,bat_depth23)
chl_depth_24_jan = raster::mask(chl24_jan,bat_depth24)
chl_depth_25_jan = raster::mask(chl25_jan,bat_depth25)
#__________________________________________________________________________________________________________________



#__________________________________________________________________________________________________________________
# STEP 5 chl------------------------------------------------------------------
# 5.1 Merge the resulting rasters after 4.1 in a final raster layer
chl_bottom_jan = raster::merge(chl_depth_1_jan,chl_depth_2_jan,chl_depth_3_jan,chl_depth_4_jan,
                               chl_depth_5_jan,chl_depth_6_jan,chl_depth_7_jan,chl_depth_8_jan,
                               chl_depth_9_jan,chl_depth_10_jan,chl_depth_11_jan,chl_depth_12_jan,
                               chl_depth_13_jan,chl_depth_14_jan,chl_depth_15_jan,chl_depth_16_jan,
                               chl_depth_17_jan,chl_depth_18_jan,chl_depth_19_jan,chl_depth_20_jan,
                               chl_depth_21_jan,chl_depth_22_jan,chl_depth_23_jan,chl_depth_24_jan,chl_depth_25_jan)

# 5.2 Check the plot
plot(chl_bottom_jan) # This is the ocean bottom layer for chl and in january
     

# 5.2 (Optional) Since some missing data can occur from the original NetCdf we
# can interpolate those using Inverse Distance Weighting or any interpolation/imputation
# method of your perference
coords_chl_bottom_jan = xyFromCell(chl_bottom_jan,c(seq(1,72625,1))) ; table_raster_chl_bottom_jan=as.data.frame(chl_bottom_jan)
# 72625 is the total ammount of cells in the raster
table_raster_chl_bottom_jan=data.frame(coords_chl_bottom_jan,table_raster_chl_bottom_jan$layer)
names(table_raster_chl_bottom_jan)=c("x","y","chl_bottom_jan")
table_raster_chl_bottom_jan = table_raster_chl_bottom_jan[complete.cases(table_raster_chl_bottom_jan), ]
model_chl_bottom_jan<- gstat(id = "chl_bottom_jan", formula = chl_bottom_jan~1, locations = ~x+y, data=table_raster_chl_bottom_jan, 
                       nmax=24)
chl_bottom_jan<- interpolate(chl_bottom_jan, model_chl_bottom_jan)
chl_bottom_jan <- mask(chl_bottom_jan, bat_reclass)
plot(chl_bottom_jan)

# 5.3 Save results from 5.2 in a new raster tif file
writeRaster(chl_bottom_jan,"chl_bottom_jan.tif") 

# NOTE: This is the final ocean bottom layer for chl in January that you can use
# as a predictor for benthic species distribution models. But you still need
# to produce bottom layers for the rest of months

# 5.4 Just replace "jan" by "feb", "mar" and so on until "dec", and run all the 
# code for each month to produce the bottom chl layers for each month

#__________________________________________________________________________________________________________________



# REPEAT PROCESS FOR OTHER VARIABLES --------------------------------------


#Repeat the process for pH, the second variable in the env_vars NetCdf


#__________________________________________________________________________________________________________________
# STEP 1 pH------------------------------------------------------------------
# Select environmental variables and depths. Crop stud area, resample, extract
# and set months apart

# Select ph as our target variable for depth 1 (0-0.45 m depth)
ph1 = brick("env_vars.nc",varname = "ph",level=1)
plot(ph1)

# 1.1 Crop the resulting raster brick "ph1" to the target study area. Here the study 
# Area is the Coast of the Colombian Pacific Ocean (0.5 to 108.03 m depth)
ext = c(-80, -76, 1, 8)
ph1 = crop(ph1,ext)
plot(ph1)

# We also need to crop the Bathymetric layer
bat = crop (bat,ph1)
plot(bat)

# 1.2 Extract target months. For that purpose we create sequences to extract the index 
# position of for each month within the ph1 raster brick. Pay attention to how
# months are included in your full time series and use this value as the length
# of the sequence each 12 months.

env_vars # 36 months - 3 years

seq_jan = seq(1,36,12) 
seq_feb = seq(2,36,12) 
seq_mar = seq(3,36,12)
seq_apr = seq(4,36,12) 
seq_may = seq(5,36,12) 
seq_jun = seq(6,36,12)
seq_jul = seq(7,36,12) 
seq_aug = seq(8,36,12) 
seq_sep = seq(9,36,12) 
seq_oct = seq(10,36,12)
seq_nov = seq(11,36,12)
seq_dec = seq(12,36,12)

# 1.3 Use the resulting seq_jan sequence to extract all Januaries from ph1
ph1_jan = ph1[[seq_jan]]
#__________________________________________________________________________________________________________________




#__________________________________________________________________________________________________________________
# STEP 2 pH------------------------------------------------------------------
# 2.1 Calculate multiannual monthly means 
ph1_jan = calc(ph1, fun = mean, na.rm=T)
plot(ph1_jan)
# :: The reulting raster is the multiannual monthly mean of variable ph1
# for depth 1 (0.5 - 108.03 m depth)

# 2.2 Resample ph_1jan to the same resolution of the bathymetric layer
ph1_jan = resample(ph1_jan,bat,method="bilinear")
plot(ph1_jan)


# 2.3 Repeat the process for all months
#feb
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_feb = ph1[[seq_feb]] ; ph1_feb = calc(ph1_feb,mean,na.rm=T); ph1_feb = resample(ph1_feb,bat)
#mar
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_mar = ph1[[seq_mar]] ; ph1_mar = calc(ph1_mar,mean,na.rm=T); ph1_mar = resample(ph1_mar,bat)
#apr
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_apr = ph1[[seq_apr]] ; ph1_apr = calc(ph1_apr,mean,na.rm=T); ph1_apr = resample(ph1_apr,bat)
#may
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_may = ph1[[seq_may]] ; ph1_may = calc(ph1_may,mean,na.rm=T); ph1_may = resample(ph1_may,bat)
#jun
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_jun = ph1[[seq_jun]] ; ph1_jun = calc(ph1_jun,mean,na.rm=T); ph1_jun = resample(ph1_jun,bat)
#jul
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_jul = ph1[[seq_jul]] ; ph1_jul = calc(ph1_jul,mean,na.rm=T); ph1_jul = resample(ph1_jul,bat)
#aug
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_aug = ph1[[seq_aug]] ; ph1_aug = calc(ph1_aug,mean,na.rm=T); ph1_aug = resample(ph1_aug,bat)
#sep
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_sep = ph1[[seq_sep]] ; ph1_sep = calc(ph1_sep,mean,na.rm=T); ph1_sep = resample(ph1_sep,bat)
#oct
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_oct = ph1[[seq_oct]] ; ph1_oct = calc(ph1_oct,mean,na.rm=T); ph1_oct = resample(ph1_oct,bat)
#nov
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_nov = ph1[[seq_nov]] ; ph1_nov = calc(ph1_nov,mean,na.rm=T); ph1_nov = resample(ph1_nov,bat)
#dec
ph1 = brick("env_vars.nc",varname = "ph",level=1) ; ph1 = crop(ph1,ext) ; ph1_dec = ph1[[seq_dec]] ; ph1_dec = calc(ph1_dec,mean,na.rm=T); ph1_dec = resample(ph1_dec,bat)


#:: Restulting rasters (ph1_feb to ph1_dec) are the multiannual monthly mean layers of ph for each month in depth 1


# 2.4 Repeat the process for all depths
#depth2
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_jan = ph2[[seq_jan]] ; ph2_jan = calc(ph2_jan,mean,na.rm=T); ph2_jan = resample(ph2_jan,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_feb = ph2[[seq_feb]] ; ph2_feb = calc(ph2_feb,mean,na.rm=T); ph2_feb = resample(ph2_feb,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_mar = ph2[[seq_mar]] ; ph2_mar = calc(ph2_mar,mean,na.rm=T); ph2_mar = resample(ph2_mar,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_apr = ph2[[seq_apr]] ; ph2_apr = calc(ph2_apr,mean,na.rm=T); ph2_apr = resample(ph2_apr,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_may = ph2[[seq_may]] ; ph2_may = calc(ph2_may,mean,na.rm=T); ph2_may = resample(ph2_may,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_jun = ph2[[seq_jun]] ; ph2_jun = calc(ph2_jun,mean,na.rm=T); ph2_jun = resample(ph2_jun,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_jul = ph2[[seq_jul]] ; ph2_jul = calc(ph2_jul,mean,na.rm=T); ph2_jul = resample(ph2_jul,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_aug = ph2[[seq_aug]] ; ph2_aug = calc(ph2_aug,mean,na.rm=T); ph2_aug = resample(ph2_aug,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_sep = ph2[[seq_sep]] ; ph2_sep = calc(ph2_sep,mean,na.rm=T); ph2_sep = resample(ph2_sep,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_oct = ph2[[seq_oct]] ; ph2_oct = calc(ph2_oct,mean,na.rm=T); ph2_oct = resample(ph2_oct,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_nov = ph2[[seq_nov]] ; ph2_nov = calc(ph2_nov,mean,na.rm=T); ph2_nov = resample(ph2_nov,bat)
ph2 = brick("env_vars.nc",varname = "ph",level=2) ; ph2 = crop(ph2,ext) ; ph2_dec = ph2[[seq_dec]] ; ph2_dec = calc(ph2_dec,mean,na.rm=T); ph2_dec = resample(ph2_dec,bat)
#depth3
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_jan = ph3[[seq_jan]] ; ph3_jan = calc(ph3_jan,mean,na.rm=T); ph3_jan = resample(ph3_jan,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_feb = ph3[[seq_feb]] ; ph3_feb = calc(ph3_feb,mean,na.rm=T); ph3_feb = resample(ph3_feb,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_mar = ph3[[seq_mar]] ; ph3_mar = calc(ph3_mar,mean,na.rm=T); ph3_mar = resample(ph3_mar,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_apr = ph3[[seq_apr]] ; ph3_apr = calc(ph3_apr,mean,na.rm=T); ph3_apr = resample(ph3_apr,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_may = ph3[[seq_may]] ; ph3_may = calc(ph3_may,mean,na.rm=T); ph3_may = resample(ph3_may,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_jun = ph3[[seq_jun]] ; ph3_jun = calc(ph3_jun,mean,na.rm=T); ph3_jun = resample(ph3_jun,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_jul = ph3[[seq_jul]] ; ph3_jul = calc(ph3_jul,mean,na.rm=T); ph3_jul = resample(ph3_jul,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_aug = ph3[[seq_aug]] ; ph3_aug = calc(ph3_aug,mean,na.rm=T); ph3_aug = resample(ph3_aug,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_sep = ph3[[seq_sep]] ; ph3_sep = calc(ph3_sep,mean,na.rm=T); ph3_sep = resample(ph3_sep,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_oct = ph3[[seq_oct]] ; ph3_oct = calc(ph3_oct,mean,na.rm=T); ph3_oct = resample(ph3_oct,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_nov = ph3[[seq_nov]] ; ph3_nov = calc(ph3_nov,mean,na.rm=T); ph3_nov = resample(ph3_nov,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_dec = ph3[[seq_dec]] ; ph3_dec = calc(ph3_dec,mean,na.rm=T); ph3_dec = resample(ph3_dec,bat)
ph3 = brick("env_vars.nc",varname = "ph",level=3) ; ph3 = crop(ph3,ext) ; ph3_dec = ph3[[seq_dec]] ; ph3_dec = calc(ph3_dec,mean,na.rm=T); ph3_dec = resample(ph3_dec,bat)
#depth4
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_jan = ph4[[seq_jan]] ; ph4_jan = calc(ph4_jan,mean,na.rm=T); ph4_jan = resample(ph4_jan,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_feb = ph4[[seq_feb]] ; ph4_feb = calc(ph4_feb,mean,na.rm=T); ph4_feb = resample(ph4_feb,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_mar = ph4[[seq_mar]] ; ph4_mar = calc(ph4_mar,mean,na.rm=T); ph4_mar = resample(ph4_mar,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_apr = ph4[[seq_apr]] ; ph4_apr = calc(ph4_apr,mean,na.rm=T); ph4_apr = resample(ph4_apr,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_may = ph4[[seq_may]] ; ph4_may = calc(ph4_may,mean,na.rm=T); ph4_may = resample(ph4_may,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_jun = ph4[[seq_jun]] ; ph4_jun = calc(ph4_jun,mean,na.rm=T); ph4_jun = resample(ph4_jun,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_jul = ph4[[seq_jul]] ; ph4_jul = calc(ph4_jul,mean,na.rm=T); ph4_jul = resample(ph4_jul,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_aug = ph4[[seq_aug]] ; ph4_aug = calc(ph4_aug,mean,na.rm=T); ph4_aug = resample(ph4_aug,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_sep = ph4[[seq_sep]] ; ph4_sep = calc(ph4_sep,mean,na.rm=T); ph4_sep = resample(ph4_sep,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_oct = ph4[[seq_oct]] ; ph4_oct = calc(ph4_oct,mean,na.rm=T); ph4_oct = resample(ph4_oct,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_nov = ph4[[seq_nov]] ; ph4_nov = calc(ph4_nov,mean,na.rm=T); ph4_nov = resample(ph4_nov,bat)
ph4 = brick("env_vars.nc",varname = "ph",level=4) ; ph4 = crop(ph4,ext) ; ph4_dec = ph4[[seq_dec]] ; ph4_dec = calc(ph4_dec,mean,na.rm=T); ph4_dec = resample(ph4_dec,bat)
#depth5
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_jan = ph5[[seq_jan]] ; ph5_jan = calc(ph5_jan,mean,na.rm=T); ph5_jan = resample(ph5_jan,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_feb = ph5[[seq_feb]] ; ph5_feb = calc(ph5_feb,mean,na.rm=T); ph5_feb = resample(ph5_feb,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_mar = ph5[[seq_mar]] ; ph5_mar = calc(ph5_mar,mean,na.rm=T); ph5_mar = resample(ph5_mar,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_apr = ph5[[seq_apr]] ; ph5_apr = calc(ph5_apr,mean,na.rm=T); ph5_apr = resample(ph5_apr,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_may = ph5[[seq_may]] ; ph5_may = calc(ph5_may,mean,na.rm=T); ph5_may = resample(ph5_may,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_jun = ph5[[seq_jun]] ; ph5_jun = calc(ph5_jun,mean,na.rm=T); ph5_jun = resample(ph5_jun,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_jul = ph5[[seq_jul]] ; ph5_jul = calc(ph5_jul,mean,na.rm=T); ph5_jul = resample(ph5_jul,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_aug = ph5[[seq_aug]] ; ph5_aug = calc(ph5_aug,mean,na.rm=T); ph5_aug = resample(ph5_aug,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_sep = ph5[[seq_sep]] ; ph5_sep = calc(ph5_sep,mean,na.rm=T); ph5_sep = resample(ph5_sep,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_oct = ph5[[seq_oct]] ; ph5_oct = calc(ph5_oct,mean,na.rm=T); ph5_oct = resample(ph5_oct,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_nov = ph5[[seq_nov]] ; ph5_nov = calc(ph5_nov,mean,na.rm=T); ph5_nov = resample(ph5_nov,bat)
ph5 = brick("env_vars.nc",varname = "ph",level=5) ; ph5 = crop(ph5,ext) ; ph5_dec = ph5[[seq_dec]] ; ph5_dec = calc(ph5_dec,mean,na.rm=T); ph5_dec = resample(ph5_dec,bat)
#depth6
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_jan = ph6[[seq_jan]] ; ph6_jan = calc(ph6_jan,mean,na.rm=T); ph6_jan = resample(ph6_jan,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_feb = ph6[[seq_feb]] ; ph6_feb = calc(ph6_feb,mean,na.rm=T); ph6_feb = resample(ph6_feb,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_mar = ph6[[seq_mar]] ; ph6_mar = calc(ph6_mar,mean,na.rm=T); ph6_mar = resample(ph6_mar,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_apr = ph6[[seq_apr]] ; ph6_apr = calc(ph6_apr,mean,na.rm=T); ph6_apr = resample(ph6_apr,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_may = ph6[[seq_may]] ; ph6_may = calc(ph6_may,mean,na.rm=T); ph6_may = resample(ph6_may,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_jun = ph6[[seq_jun]] ; ph6_jun = calc(ph6_jun,mean,na.rm=T); ph6_jun = resample(ph6_jun,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_jul = ph6[[seq_jul]] ; ph6_jul = calc(ph6_jul,mean,na.rm=T); ph6_jul = resample(ph6_jul,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_aug = ph6[[seq_aug]] ; ph6_aug = calc(ph6_aug,mean,na.rm=T); ph6_aug = resample(ph6_aug,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_sep = ph6[[seq_sep]] ; ph6_sep = calc(ph6_sep,mean,na.rm=T); ph6_sep = resample(ph6_sep,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_oct = ph6[[seq_oct]] ; ph6_oct = calc(ph6_oct,mean,na.rm=T); ph6_oct = resample(ph6_oct,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_nov = ph6[[seq_nov]] ; ph6_nov = calc(ph6_nov,mean,na.rm=T); ph6_nov = resample(ph6_nov,bat)
ph6 = brick("env_vars.nc",varname = "ph",level=6) ; ph6 = crop(ph6,ext) ; ph6_dec = ph6[[seq_dec]] ; ph6_dec = calc(ph6_dec,mean,na.rm=T); ph6_dec = resample(ph6_dec,bat)
#depth7
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_jan = ph7[[seq_jan]] ; ph7_jan = calc(ph7_jan,mean,na.rm=T); ph7_jan = resample(ph7_jan,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_feb = ph7[[seq_feb]] ; ph7_feb = calc(ph7_feb,mean,na.rm=T); ph7_feb = resample(ph7_feb,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_mar = ph7[[seq_mar]] ; ph7_mar = calc(ph7_mar,mean,na.rm=T); ph7_mar = resample(ph7_mar,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_apr = ph7[[seq_apr]] ; ph7_apr = calc(ph7_apr,mean,na.rm=T); ph7_apr = resample(ph7_apr,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_may = ph7[[seq_may]] ; ph7_may = calc(ph7_may,mean,na.rm=T); ph7_may = resample(ph7_may,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_jun = ph7[[seq_jun]] ; ph7_jun = calc(ph7_jun,mean,na.rm=T); ph7_jun = resample(ph7_jun,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_jul = ph7[[seq_jul]] ; ph7_jul = calc(ph7_jul,mean,na.rm=T); ph7_jul = resample(ph7_jul,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_aug = ph7[[seq_aug]] ; ph7_aug = calc(ph7_aug,mean,na.rm=T); ph7_aug = resample(ph7_aug,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_sep = ph7[[seq_sep]] ; ph7_sep = calc(ph7_sep,mean,na.rm=T); ph7_sep = resample(ph7_sep,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_oct = ph7[[seq_oct]] ; ph7_oct = calc(ph7_oct,mean,na.rm=T); ph7_oct = resample(ph7_oct,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_nov = ph7[[seq_nov]] ; ph7_nov = calc(ph7_nov,mean,na.rm=T); ph7_nov = resample(ph7_nov,bat)
ph7 = brick("env_vars.nc",varname = "ph",level=7) ; ph7 = crop(ph7,ext) ; ph7_dec = ph7[[seq_dec]] ; ph7_dec = calc(ph7_dec,mean,na.rm=T); ph7_dec = resample(ph7_dec,bat)
#depth8
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_jan = ph8[[seq_jan]] ; ph8_jan = calc(ph8_jan,mean,na.rm=T); ph8_jan = resample(ph8_jan,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_feb = ph8[[seq_feb]] ; ph8_feb = calc(ph8_feb,mean,na.rm=T); ph8_feb = resample(ph8_feb,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_mar = ph8[[seq_mar]] ; ph8_mar = calc(ph8_mar,mean,na.rm=T); ph8_mar = resample(ph8_mar,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_apr = ph8[[seq_apr]] ; ph8_apr = calc(ph8_apr,mean,na.rm=T); ph8_apr = resample(ph8_apr,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_may = ph8[[seq_may]] ; ph8_may = calc(ph8_may,mean,na.rm=T); ph8_may = resample(ph8_may,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_jun = ph8[[seq_jun]] ; ph8_jun = calc(ph8_jun,mean,na.rm=T); ph8_jun = resample(ph8_jun,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_jul = ph8[[seq_jul]] ; ph8_jul = calc(ph8_jul,mean,na.rm=T); ph8_jul = resample(ph8_jul,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_aug = ph8[[seq_aug]] ; ph8_aug = calc(ph8_aug,mean,na.rm=T); ph8_aug = resample(ph8_aug,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_sep = ph8[[seq_sep]] ; ph8_sep = calc(ph8_sep,mean,na.rm=T); ph8_sep = resample(ph8_sep,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_oct = ph8[[seq_oct]] ; ph8_oct = calc(ph8_oct,mean,na.rm=T); ph8_oct = resample(ph8_oct,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_nov = ph8[[seq_nov]] ; ph8_nov = calc(ph8_nov,mean,na.rm=T); ph8_nov = resample(ph8_nov,bat)
ph8 = brick("env_vars.nc",varname = "ph",level=8) ; ph8 = crop(ph8,ext) ; ph8_dec = ph8[[seq_dec]] ; ph8_dec = calc(ph8_dec,mean,na.rm=T); ph8_dec = resample(ph8_dec,bat)
#depth9
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_jan = ph9[[seq_jan]] ; ph9_jan = calc(ph9_jan,mean,na.rm=T); ph9_jan = resample(ph9_jan,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_feb = ph9[[seq_feb]] ; ph9_feb = calc(ph9_feb,mean,na.rm=T); ph9_feb = resample(ph9_feb,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_mar = ph9[[seq_mar]] ; ph9_mar = calc(ph9_mar,mean,na.rm=T); ph9_mar = resample(ph9_mar,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_apr = ph9[[seq_apr]] ; ph9_apr = calc(ph9_apr,mean,na.rm=T); ph9_apr = resample(ph9_apr,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_may = ph9[[seq_may]] ; ph9_may = calc(ph9_may,mean,na.rm=T); ph9_may = resample(ph9_may,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_jun = ph9[[seq_jun]] ; ph9_jun = calc(ph9_jun,mean,na.rm=T); ph9_jun = resample(ph9_jun,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_jul = ph9[[seq_jul]] ; ph9_jul = calc(ph9_jul,mean,na.rm=T); ph9_jul = resample(ph9_jul,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_aug = ph9[[seq_aug]] ; ph9_aug = calc(ph9_aug,mean,na.rm=T); ph9_aug = resample(ph9_aug,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_sep = ph9[[seq_sep]] ; ph9_sep = calc(ph9_sep,mean,na.rm=T); ph9_sep = resample(ph9_sep,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_oct = ph9[[seq_oct]] ; ph9_oct = calc(ph9_oct,mean,na.rm=T); ph9_oct = resample(ph9_oct,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_nov = ph9[[seq_nov]] ; ph9_nov = calc(ph9_nov,mean,na.rm=T); ph9_nov = resample(ph9_nov,bat)
ph9 = brick("env_vars.nc",varname = "ph",level=9) ; ph9 = crop(ph9,ext) ; ph9_dec = ph9[[seq_dec]] ; ph9_dec = calc(ph9_dec,mean,na.rm=T); ph9_dec = resample(ph9_dec,bat)
#depth10
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_jan = ph10[[seq_jan]] ; ph10_jan = calc(ph10_jan,mean,na.rm=T); ph10_jan = resample(ph10_jan,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_feb = ph10[[seq_feb]] ; ph10_feb = calc(ph10_feb,mean,na.rm=T); ph10_feb = resample(ph10_feb,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_mar = ph10[[seq_mar]] ; ph10_mar = calc(ph10_mar,mean,na.rm=T); ph10_mar = resample(ph10_mar,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_apr = ph10[[seq_apr]] ; ph10_apr = calc(ph10_apr,mean,na.rm=T); ph10_apr = resample(ph10_apr,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_may = ph10[[seq_may]] ; ph10_may = calc(ph10_may,mean,na.rm=T); ph10_may = resample(ph10_may,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_jun = ph10[[seq_jun]] ; ph10_jun = calc(ph10_jun,mean,na.rm=T); ph10_jun = resample(ph10_jun,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_jul = ph10[[seq_jul]] ; ph10_jul = calc(ph10_jul,mean,na.rm=T); ph10_jul = resample(ph10_jul,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_aug = ph10[[seq_aug]] ; ph10_aug = calc(ph10_aug,mean,na.rm=T); ph10_aug = resample(ph10_aug,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_sep = ph10[[seq_sep]] ; ph10_sep = calc(ph10_sep,mean,na.rm=T); ph10_sep = resample(ph10_sep,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_oct = ph10[[seq_oct]] ; ph10_oct = calc(ph10_oct,mean,na.rm=T); ph10_oct = resample(ph10_oct,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_nov = ph10[[seq_nov]] ; ph10_nov = calc(ph10_nov,mean,na.rm=T); ph10_nov = resample(ph10_nov,bat)
ph10 = brick("env_vars.nc",varname = "ph",level=10) ; ph10 = crop(ph10,ext) ; ph10_dec = ph10[[seq_dec]] ; ph10_dec = calc(ph10_dec,mean,na.rm=T); ph10_dec = resample(ph10_dec,bat)
#depth11
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_jan = ph11[[seq_jan]] ; ph11_jan = calc(ph11_jan,mean,na.rm=T); ph11_jan = resample(ph11_jan,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_feb = ph11[[seq_feb]] ; ph11_feb = calc(ph11_feb,mean,na.rm=T); ph11_feb = resample(ph11_feb,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_mar = ph11[[seq_mar]] ; ph11_mar = calc(ph11_mar,mean,na.rm=T); ph11_mar = resample(ph11_mar,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_apr = ph11[[seq_apr]] ; ph11_apr = calc(ph11_apr,mean,na.rm=T); ph11_apr = resample(ph11_apr,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_may = ph11[[seq_may]] ; ph11_may = calc(ph11_may,mean,na.rm=T); ph11_may = resample(ph11_may,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_jun = ph11[[seq_jun]] ; ph11_jun = calc(ph11_jun,mean,na.rm=T); ph11_jun = resample(ph11_jun,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_jul = ph11[[seq_jul]] ; ph11_jul = calc(ph11_jul,mean,na.rm=T); ph11_jul = resample(ph11_jul,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_aug = ph11[[seq_aug]] ; ph11_aug = calc(ph11_aug,mean,na.rm=T); ph11_aug = resample(ph11_aug,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_sep = ph11[[seq_sep]] ; ph11_sep = calc(ph11_sep,mean,na.rm=T); ph11_sep = resample(ph11_sep,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_oct = ph11[[seq_oct]] ; ph11_oct = calc(ph11_oct,mean,na.rm=T); ph11_oct = resample(ph11_oct,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_nov = ph11[[seq_nov]] ; ph11_nov = calc(ph11_nov,mean,na.rm=T); ph11_nov = resample(ph11_nov,bat)
ph11 = brick("env_vars.nc",varname = "ph",level=11) ; ph11 = crop(ph11,ext) ; ph11_dec = ph11[[seq_dec]] ; ph11_dec = calc(ph11_dec,mean,na.rm=T); ph11_dec = resample(ph11_dec,bat)
#depth111
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_jan = ph12[[seq_jan]] ; ph12_jan = calc(ph12_jan,mean,na.rm=T); ph12_jan = resample(ph12_jan,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_feb = ph12[[seq_feb]] ; ph12_feb = calc(ph12_feb,mean,na.rm=T); ph12_feb = resample(ph12_feb,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_mar = ph12[[seq_mar]] ; ph12_mar = calc(ph12_mar,mean,na.rm=T); ph12_mar = resample(ph12_mar,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_apr = ph12[[seq_apr]] ; ph12_apr = calc(ph12_apr,mean,na.rm=T); ph12_apr = resample(ph12_apr,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_may = ph12[[seq_may]] ; ph12_may = calc(ph12_may,mean,na.rm=T); ph12_may = resample(ph12_may,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_jun = ph12[[seq_jun]] ; ph12_jun = calc(ph12_jun,mean,na.rm=T); ph12_jun = resample(ph12_jun,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_jul = ph12[[seq_jul]] ; ph12_jul = calc(ph12_jul,mean,na.rm=T); ph12_jul = resample(ph12_jul,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_aug = ph12[[seq_aug]] ; ph12_aug = calc(ph12_aug,mean,na.rm=T); ph12_aug = resample(ph12_aug,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_sep = ph12[[seq_sep]] ; ph12_sep = calc(ph12_sep,mean,na.rm=T); ph12_sep = resample(ph12_sep,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_oct = ph12[[seq_oct]] ; ph12_oct = calc(ph12_oct,mean,na.rm=T); ph12_oct = resample(ph12_oct,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_nov = ph12[[seq_nov]] ; ph12_nov = calc(ph12_nov,mean,na.rm=T); ph12_nov = resample(ph12_nov,bat)
ph12 = brick("env_vars.nc",varname = "ph",level=12) ; ph12 = crop(ph12,ext) ; ph12_dec = ph12[[seq_dec]] ; ph12_dec = calc(ph12_dec,mean,na.rm=T); ph12_dec = resample(ph12_dec,bat)
#depth13
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_jan = ph13[[seq_jan]] ; ph13_jan = calc(ph13_jan,mean,na.rm=T); ph13_jan = resample(ph13_jan,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_feb = ph13[[seq_feb]] ; ph13_feb = calc(ph13_feb,mean,na.rm=T); ph13_feb = resample(ph13_feb,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_mar = ph13[[seq_mar]] ; ph13_mar = calc(ph13_mar,mean,na.rm=T); ph13_mar = resample(ph13_mar,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_apr = ph13[[seq_apr]] ; ph13_apr = calc(ph13_apr,mean,na.rm=T); ph13_apr = resample(ph13_apr,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_may = ph13[[seq_may]] ; ph13_may = calc(ph13_may,mean,na.rm=T); ph13_may = resample(ph13_may,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_jun = ph13[[seq_jun]] ; ph13_jun = calc(ph13_jun,mean,na.rm=T); ph13_jun = resample(ph13_jun,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_jul = ph13[[seq_jul]] ; ph13_jul = calc(ph13_jul,mean,na.rm=T); ph13_jul = resample(ph13_jul,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_aug = ph13[[seq_aug]] ; ph13_aug = calc(ph13_aug,mean,na.rm=T); ph13_aug = resample(ph13_aug,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_sep = ph13[[seq_sep]] ; ph13_sep = calc(ph13_sep,mean,na.rm=T); ph13_sep = resample(ph13_sep,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_oct = ph13[[seq_oct]] ; ph13_oct = calc(ph13_oct,mean,na.rm=T); ph13_oct = resample(ph13_oct,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_nov = ph13[[seq_nov]] ; ph13_nov = calc(ph13_nov,mean,na.rm=T); ph13_nov = resample(ph13_nov,bat)
ph13 = brick("env_vars.nc",varname = "ph",level=13) ; ph13 = crop(ph13,ext) ; ph13_dec = ph13[[seq_dec]] ; ph13_dec = calc(ph13_dec,mean,na.rm=T); ph13_dec = resample(ph13_dec,bat)
#depth14
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_jan = ph14[[seq_jan]] ; ph14_jan = calc(ph14_jan,mean,na.rm=T); ph14_jan = resample(ph14_jan,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_feb = ph14[[seq_feb]] ; ph14_feb = calc(ph14_feb,mean,na.rm=T); ph14_feb = resample(ph14_feb,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_mar = ph14[[seq_mar]] ; ph14_mar = calc(ph14_mar,mean,na.rm=T); ph14_mar = resample(ph14_mar,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_apr = ph14[[seq_apr]] ; ph14_apr = calc(ph14_apr,mean,na.rm=T); ph14_apr = resample(ph14_apr,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_may = ph14[[seq_may]] ; ph14_may = calc(ph14_may,mean,na.rm=T); ph14_may = resample(ph14_may,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_jun = ph14[[seq_jun]] ; ph14_jun = calc(ph14_jun,mean,na.rm=T); ph14_jun = resample(ph14_jun,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_jul = ph14[[seq_jul]] ; ph14_jul = calc(ph14_jul,mean,na.rm=T); ph14_jul = resample(ph14_jul,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_aug = ph14[[seq_aug]] ; ph14_aug = calc(ph14_aug,mean,na.rm=T); ph14_aug = resample(ph14_aug,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_sep = ph14[[seq_sep]] ; ph14_sep = calc(ph14_sep,mean,na.rm=T); ph14_sep = resample(ph14_sep,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_oct = ph14[[seq_oct]] ; ph14_oct = calc(ph14_oct,mean,na.rm=T); ph14_oct = resample(ph14_oct,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_nov = ph14[[seq_nov]] ; ph14_nov = calc(ph14_nov,mean,na.rm=T); ph14_nov = resample(ph14_nov,bat)
ph14 = brick("env_vars.nc",varname = "ph",level=14) ; ph14 = crop(ph14,ext) ; ph14_dec = ph14[[seq_dec]] ; ph14_dec = calc(ph14_dec,mean,na.rm=T); ph14_dec = resample(ph14_dec,bat)
#depth15
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_jan = ph15[[seq_jan]] ; ph15_jan = calc(ph15_jan,mean,na.rm=T); ph15_jan = resample(ph15_jan,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_feb = ph15[[seq_feb]] ; ph15_feb = calc(ph15_feb,mean,na.rm=T); ph15_feb = resample(ph15_feb,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_mar = ph15[[seq_mar]] ; ph15_mar = calc(ph15_mar,mean,na.rm=T); ph15_mar = resample(ph15_mar,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_apr = ph15[[seq_apr]] ; ph15_apr = calc(ph15_apr,mean,na.rm=T); ph15_apr = resample(ph15_apr,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_may = ph15[[seq_may]] ; ph15_may = calc(ph15_may,mean,na.rm=T); ph15_may = resample(ph15_may,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_jun = ph15[[seq_jun]] ; ph15_jun = calc(ph15_jun,mean,na.rm=T); ph15_jun = resample(ph15_jun,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_jul = ph15[[seq_jul]] ; ph15_jul = calc(ph15_jul,mean,na.rm=T); ph15_jul = resample(ph15_jul,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_aug = ph15[[seq_aug]] ; ph15_aug = calc(ph15_aug,mean,na.rm=T); ph15_aug = resample(ph15_aug,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_sep = ph15[[seq_sep]] ; ph15_sep = calc(ph15_sep,mean,na.rm=T); ph15_sep = resample(ph15_sep,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_oct = ph15[[seq_oct]] ; ph15_oct = calc(ph15_oct,mean,na.rm=T); ph15_oct = resample(ph15_oct,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_nov = ph15[[seq_nov]] ; ph15_nov = calc(ph15_nov,mean,na.rm=T); ph15_nov = resample(ph15_nov,bat)
ph15 = brick("env_vars.nc",varname = "ph",level=15) ; ph15 = crop(ph15,ext) ; ph15_dec = ph15[[seq_dec]] ; ph15_dec = calc(ph15_dec,mean,na.rm=T); ph15_dec = resample(ph15_dec,bat)
#depth16
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_jan = ph16[[seq_jan]] ; ph16_jan = calc(ph16_jan,mean,na.rm=T); ph16_jan = resample(ph16_jan,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_feb = ph16[[seq_feb]] ; ph16_feb = calc(ph16_feb,mean,na.rm=T); ph16_feb = resample(ph16_feb,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_mar = ph16[[seq_mar]] ; ph16_mar = calc(ph16_mar,mean,na.rm=T); ph16_mar = resample(ph16_mar,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_apr = ph16[[seq_apr]] ; ph16_apr = calc(ph16_apr,mean,na.rm=T); ph16_apr = resample(ph16_apr,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_may = ph16[[seq_may]] ; ph16_may = calc(ph16_may,mean,na.rm=T); ph16_may = resample(ph16_may,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_jun = ph16[[seq_jun]] ; ph16_jun = calc(ph16_jun,mean,na.rm=T); ph16_jun = resample(ph16_jun,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_jul = ph16[[seq_jul]] ; ph16_jul = calc(ph16_jul,mean,na.rm=T); ph16_jul = resample(ph16_jul,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_aug = ph16[[seq_aug]] ; ph16_aug = calc(ph16_aug,mean,na.rm=T); ph16_aug = resample(ph16_aug,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_sep = ph16[[seq_sep]] ; ph16_sep = calc(ph16_sep,mean,na.rm=T); ph16_sep = resample(ph16_sep,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_oct = ph16[[seq_oct]] ; ph16_oct = calc(ph16_oct,mean,na.rm=T); ph16_oct = resample(ph16_oct,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_nov = ph16[[seq_nov]] ; ph16_nov = calc(ph16_nov,mean,na.rm=T); ph16_nov = resample(ph16_nov,bat)
ph16 = brick("env_vars.nc",varname = "ph",level=16) ; ph16 = crop(ph16,ext) ; ph16_dec = ph16[[seq_dec]] ; ph16_dec = calc(ph16_dec,mean,na.rm=T); ph16_dec = resample(ph16_dec,bat)
#depth17
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_jan = ph17[[seq_jan]] ; ph17_jan = calc(ph17_jan,mean,na.rm=T); ph17_jan = resample(ph17_jan,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_feb = ph17[[seq_feb]] ; ph17_feb = calc(ph17_feb,mean,na.rm=T); ph17_feb = resample(ph17_feb,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_mar = ph17[[seq_mar]] ; ph17_mar = calc(ph17_mar,mean,na.rm=T); ph17_mar = resample(ph17_mar,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_apr = ph17[[seq_apr]] ; ph17_apr = calc(ph17_apr,mean,na.rm=T); ph17_apr = resample(ph17_apr,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_may = ph17[[seq_may]] ; ph17_may = calc(ph17_may,mean,na.rm=T); ph17_may = resample(ph17_may,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_jun = ph17[[seq_jun]] ; ph17_jun = calc(ph17_jun,mean,na.rm=T); ph17_jun = resample(ph17_jun,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_jul = ph17[[seq_jul]] ; ph17_jul = calc(ph17_jul,mean,na.rm=T); ph17_jul = resample(ph17_jul,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_aug = ph17[[seq_aug]] ; ph17_aug = calc(ph17_aug,mean,na.rm=T); ph17_aug = resample(ph17_aug,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_sep = ph17[[seq_sep]] ; ph17_sep = calc(ph17_sep,mean,na.rm=T); ph17_sep = resample(ph17_sep,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_oct = ph17[[seq_oct]] ; ph17_oct = calc(ph17_oct,mean,na.rm=T); ph17_oct = resample(ph17_oct,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_nov = ph17[[seq_nov]] ; ph17_nov = calc(ph17_nov,mean,na.rm=T); ph17_nov = resample(ph17_nov,bat)
ph17 = brick("env_vars.nc",varname = "ph",level=17) ; ph17 = crop(ph17,ext) ; ph17_dec = ph17[[seq_dec]] ; ph17_dec = calc(ph17_dec,mean,na.rm=T); ph17_dec = resample(ph17_dec,bat)
#depth18
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_jan = ph18[[seq_jan]] ; ph18_jan = calc(ph18_jan,mean,na.rm=T); ph18_jan = resample(ph18_jan,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_feb = ph18[[seq_feb]] ; ph18_feb = calc(ph18_feb,mean,na.rm=T); ph18_feb = resample(ph18_feb,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_mar = ph18[[seq_mar]] ; ph18_mar = calc(ph18_mar,mean,na.rm=T); ph18_mar = resample(ph18_mar,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_apr = ph18[[seq_apr]] ; ph18_apr = calc(ph18_apr,mean,na.rm=T); ph18_apr = resample(ph18_apr,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_may = ph18[[seq_may]] ; ph18_may = calc(ph18_may,mean,na.rm=T); ph18_may = resample(ph18_may,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_jun = ph18[[seq_jun]] ; ph18_jun = calc(ph18_jun,mean,na.rm=T); ph18_jun = resample(ph18_jun,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_jul = ph18[[seq_jul]] ; ph18_jul = calc(ph18_jul,mean,na.rm=T); ph18_jul = resample(ph18_jul,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_aug = ph18[[seq_aug]] ; ph18_aug = calc(ph18_aug,mean,na.rm=T); ph18_aug = resample(ph18_aug,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_sep = ph18[[seq_sep]] ; ph18_sep = calc(ph18_sep,mean,na.rm=T); ph18_sep = resample(ph18_sep,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_oct = ph18[[seq_oct]] ; ph18_oct = calc(ph18_oct,mean,na.rm=T); ph18_oct = resample(ph18_oct,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_nov = ph18[[seq_nov]] ; ph18_nov = calc(ph18_nov,mean,na.rm=T); ph18_nov = resample(ph18_nov,bat)
ph18 = brick("env_vars.nc",varname = "ph",level=18) ; ph18 = crop(ph18,ext) ; ph18_dec = ph18[[seq_dec]] ; ph18_dec = calc(ph18_dec,mean,na.rm=T); ph18_dec = resample(ph18_dec,bat)
#depth19
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_jan = ph19[[seq_jan]] ; ph19_jan = calc(ph19_jan,mean,na.rm=T); ph19_jan = resample(ph19_jan,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_feb = ph19[[seq_feb]] ; ph19_feb = calc(ph19_feb,mean,na.rm=T); ph19_feb = resample(ph19_feb,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_mar = ph19[[seq_mar]] ; ph19_mar = calc(ph19_mar,mean,na.rm=T); ph19_mar = resample(ph19_mar,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_apr = ph19[[seq_apr]] ; ph19_apr = calc(ph19_apr,mean,na.rm=T); ph19_apr = resample(ph19_apr,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_may = ph19[[seq_may]] ; ph19_may = calc(ph19_may,mean,na.rm=T); ph19_may = resample(ph19_may,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_jun = ph19[[seq_jun]] ; ph19_jun = calc(ph19_jun,mean,na.rm=T); ph19_jun = resample(ph19_jun,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_jul = ph19[[seq_jul]] ; ph19_jul = calc(ph19_jul,mean,na.rm=T); ph19_jul = resample(ph19_jul,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_aug = ph19[[seq_aug]] ; ph19_aug = calc(ph19_aug,mean,na.rm=T); ph19_aug = resample(ph19_aug,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_sep = ph19[[seq_sep]] ; ph19_sep = calc(ph19_sep,mean,na.rm=T); ph19_sep = resample(ph19_sep,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_oct = ph19[[seq_oct]] ; ph19_oct = calc(ph19_oct,mean,na.rm=T); ph19_oct = resample(ph19_oct,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_nov = ph19[[seq_nov]] ; ph19_nov = calc(ph19_nov,mean,na.rm=T); ph19_nov = resample(ph19_nov,bat)
ph19 = brick("env_vars.nc",varname = "ph",level=19) ; ph19 = crop(ph19,ext) ; ph19_dec = ph19[[seq_dec]] ; ph19_dec = calc(ph19_dec,mean,na.rm=T); ph19_dec = resample(ph19_dec,bat)
#depth10
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_jan = ph20[[seq_jan]] ; ph20_jan = calc(ph20_jan,mean,na.rm=T); ph20_jan = resample(ph20_jan,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_feb = ph20[[seq_feb]] ; ph20_feb = calc(ph20_feb,mean,na.rm=T); ph20_feb = resample(ph20_feb,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_mar = ph20[[seq_mar]] ; ph20_mar = calc(ph20_mar,mean,na.rm=T); ph20_mar = resample(ph20_mar,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_apr = ph20[[seq_apr]] ; ph20_apr = calc(ph20_apr,mean,na.rm=T); ph20_apr = resample(ph20_apr,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_may = ph20[[seq_may]] ; ph20_may = calc(ph20_may,mean,na.rm=T); ph20_may = resample(ph20_may,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_jun = ph20[[seq_jun]] ; ph20_jun = calc(ph20_jun,mean,na.rm=T); ph20_jun = resample(ph20_jun,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_jul = ph20[[seq_jul]] ; ph20_jul = calc(ph20_jul,mean,na.rm=T); ph20_jul = resample(ph20_jul,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_aug = ph20[[seq_aug]] ; ph20_aug = calc(ph20_aug,mean,na.rm=T); ph20_aug = resample(ph20_aug,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_sep = ph20[[seq_sep]] ; ph20_sep = calc(ph20_sep,mean,na.rm=T); ph20_sep = resample(ph20_sep,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_oct = ph20[[seq_oct]] ; ph20_oct = calc(ph20_oct,mean,na.rm=T); ph20_oct = resample(ph20_oct,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_nov = ph20[[seq_nov]] ; ph20_nov = calc(ph20_nov,mean,na.rm=T); ph20_nov = resample(ph20_nov,bat)
ph20 = brick("env_vars.nc",varname = "ph",level=20) ; ph20 = crop(ph20,ext) ; ph20_dec = ph20[[seq_dec]] ; ph20_dec = calc(ph20_dec,mean,na.rm=T); ph20_dec = resample(ph20_dec,bat)
#depth21
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_jan = ph21[[seq_jan]] ; ph21_jan = calc(ph21_jan,mean,na.rm=T); ph21_jan = resample(ph21_jan,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_feb = ph21[[seq_feb]] ; ph21_feb = calc(ph21_feb,mean,na.rm=T); ph21_feb = resample(ph21_feb,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_mar = ph21[[seq_mar]] ; ph21_mar = calc(ph21_mar,mean,na.rm=T); ph21_mar = resample(ph21_mar,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_apr = ph21[[seq_apr]] ; ph21_apr = calc(ph21_apr,mean,na.rm=T); ph21_apr = resample(ph21_apr,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_may = ph21[[seq_may]] ; ph21_may = calc(ph21_may,mean,na.rm=T); ph21_may = resample(ph21_may,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_jun = ph21[[seq_jun]] ; ph21_jun = calc(ph21_jun,mean,na.rm=T); ph21_jun = resample(ph21_jun,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_jul = ph21[[seq_jul]] ; ph21_jul = calc(ph21_jul,mean,na.rm=T); ph21_jul = resample(ph21_jul,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_aug = ph21[[seq_aug]] ; ph21_aug = calc(ph21_aug,mean,na.rm=T); ph21_aug = resample(ph21_aug,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_sep = ph21[[seq_sep]] ; ph21_sep = calc(ph21_sep,mean,na.rm=T); ph21_sep = resample(ph21_sep,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_oct = ph21[[seq_oct]] ; ph21_oct = calc(ph21_oct,mean,na.rm=T); ph21_oct = resample(ph21_oct,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_nov = ph21[[seq_nov]] ; ph21_nov = calc(ph21_nov,mean,na.rm=T); ph21_nov = resample(ph21_nov,bat)
ph21 = brick("env_vars.nc",varname = "ph",level=21) ; ph21 = crop(ph21,ext) ; ph21_dec = ph21[[seq_dec]] ; ph21_dec = calc(ph21_dec,mean,na.rm=T); ph21_dec = resample(ph21_dec,bat)
#depth22
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_jan = ph22[[seq_jan]] ; ph22_jan = calc(ph22_jan,mean,na.rm=T); ph22_jan = resample(ph22_jan,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_feb = ph22[[seq_feb]] ; ph22_feb = calc(ph22_feb,mean,na.rm=T); ph22_feb = resample(ph22_feb,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_mar = ph22[[seq_mar]] ; ph22_mar = calc(ph22_mar,mean,na.rm=T); ph22_mar = resample(ph22_mar,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_apr = ph22[[seq_apr]] ; ph22_apr = calc(ph22_apr,mean,na.rm=T); ph22_apr = resample(ph22_apr,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_may = ph22[[seq_may]] ; ph22_may = calc(ph22_may,mean,na.rm=T); ph22_may = resample(ph22_may,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_jun = ph22[[seq_jun]] ; ph22_jun = calc(ph22_jun,mean,na.rm=T); ph22_jun = resample(ph22_jun,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_jul = ph22[[seq_jul]] ; ph22_jul = calc(ph22_jul,mean,na.rm=T); ph22_jul = resample(ph22_jul,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_aug = ph22[[seq_aug]] ; ph22_aug = calc(ph22_aug,mean,na.rm=T); ph22_aug = resample(ph22_aug,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_sep = ph22[[seq_sep]] ; ph22_sep = calc(ph22_sep,mean,na.rm=T); ph22_sep = resample(ph22_sep,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_oct = ph22[[seq_oct]] ; ph22_oct = calc(ph22_oct,mean,na.rm=T); ph22_oct = resample(ph22_oct,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_nov = ph22[[seq_nov]] ; ph22_nov = calc(ph22_nov,mean,na.rm=T); ph22_nov = resample(ph22_nov,bat)
ph22 = brick("env_vars.nc",varname = "ph",level=22) ; ph22 = crop(ph22,ext) ; ph22_dec = ph22[[seq_dec]] ; ph22_dec = calc(ph22_dec,mean,na.rm=T); ph22_dec = resample(ph22_dec,bat)
#depth23
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_jan = ph23[[seq_jan]] ; ph23_jan = calc(ph23_jan,mean,na.rm=T); ph23_jan = resample(ph23_jan,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_feb = ph23[[seq_feb]] ; ph23_feb = calc(ph23_feb,mean,na.rm=T); ph23_feb = resample(ph23_feb,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_mar = ph23[[seq_mar]] ; ph23_mar = calc(ph23_mar,mean,na.rm=T); ph23_mar = resample(ph23_mar,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_apr = ph23[[seq_apr]] ; ph23_apr = calc(ph23_apr,mean,na.rm=T); ph23_apr = resample(ph23_apr,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_may = ph23[[seq_may]] ; ph23_may = calc(ph23_may,mean,na.rm=T); ph23_may = resample(ph23_may,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_jun = ph23[[seq_jun]] ; ph23_jun = calc(ph23_jun,mean,na.rm=T); ph23_jun = resample(ph23_jun,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_jul = ph23[[seq_jul]] ; ph23_jul = calc(ph23_jul,mean,na.rm=T); ph23_jul = resample(ph23_jul,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_aug = ph23[[seq_aug]] ; ph23_aug = calc(ph23_aug,mean,na.rm=T); ph23_aug = resample(ph23_aug,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_sep = ph23[[seq_sep]] ; ph23_sep = calc(ph23_sep,mean,na.rm=T); ph23_sep = resample(ph23_sep,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_oct = ph23[[seq_oct]] ; ph23_oct = calc(ph23_oct,mean,na.rm=T); ph23_oct = resample(ph23_oct,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_nov = ph23[[seq_nov]] ; ph23_nov = calc(ph23_nov,mean,na.rm=T); ph23_nov = resample(ph23_nov,bat)
ph23 = brick("env_vars.nc",varname = "ph",level=23) ; ph23 = crop(ph23,ext) ; ph23_dec = ph23[[seq_dec]] ; ph23_dec = calc(ph23_dec,mean,na.rm=T); ph23_dec = resample(ph23_dec,bat)
#depth24
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_jan = ph24[[seq_jan]] ; ph24_jan = calc(ph24_jan,mean,na.rm=T); ph24_jan = resample(ph24_jan,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_feb = ph24[[seq_feb]] ; ph24_feb = calc(ph24_feb,mean,na.rm=T); ph24_feb = resample(ph24_feb,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_mar = ph24[[seq_mar]] ; ph24_mar = calc(ph24_mar,mean,na.rm=T); ph24_mar = resample(ph24_mar,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_apr = ph24[[seq_apr]] ; ph24_apr = calc(ph24_apr,mean,na.rm=T); ph24_apr = resample(ph24_apr,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_may = ph24[[seq_may]] ; ph24_may = calc(ph24_may,mean,na.rm=T); ph24_may = resample(ph24_may,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_jun = ph24[[seq_jun]] ; ph24_jun = calc(ph24_jun,mean,na.rm=T); ph24_jun = resample(ph24_jun,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_jul = ph24[[seq_jul]] ; ph24_jul = calc(ph24_jul,mean,na.rm=T); ph24_jul = resample(ph24_jul,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_aug = ph24[[seq_aug]] ; ph24_aug = calc(ph24_aug,mean,na.rm=T); ph24_aug = resample(ph24_aug,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_sep = ph24[[seq_sep]] ; ph24_sep = calc(ph24_sep,mean,na.rm=T); ph24_sep = resample(ph24_sep,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_oct = ph24[[seq_oct]] ; ph24_oct = calc(ph24_oct,mean,na.rm=T); ph24_oct = resample(ph24_oct,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_nov = ph24[[seq_nov]] ; ph24_nov = calc(ph24_nov,mean,na.rm=T); ph24_nov = resample(ph24_nov,bat)
ph24 = brick("env_vars.nc",varname = "ph",level=24) ; ph24 = crop(ph24,ext) ; ph24_dec = ph24[[seq_dec]] ; ph24_dec = calc(ph24_dec,mean,na.rm=T); ph24_dec = resample(ph24_dec,bat)
#depth25
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_jan = ph25[[seq_jan]] ; ph25_jan = calc(ph25_jan,mean,na.rm=T); ph25_jan = resample(ph25_jan,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_feb = ph25[[seq_feb]] ; ph25_feb = calc(ph25_feb,mean,na.rm=T); ph25_feb = resample(ph25_feb,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_mar = ph25[[seq_mar]] ; ph25_mar = calc(ph25_mar,mean,na.rm=T); ph25_mar = resample(ph25_mar,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_apr = ph25[[seq_apr]] ; ph25_apr = calc(ph25_apr,mean,na.rm=T); ph25_apr = resample(ph25_apr,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_may = ph25[[seq_may]] ; ph25_may = calc(ph25_may,mean,na.rm=T); ph25_may = resample(ph25_may,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_jun = ph25[[seq_jun]] ; ph25_jun = calc(ph25_jun,mean,na.rm=T); ph25_jun = resample(ph25_jun,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_jul = ph25[[seq_jul]] ; ph25_jul = calc(ph25_jul,mean,na.rm=T); ph25_jul = resample(ph25_jul,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_aug = ph25[[seq_aug]] ; ph25_aug = calc(ph25_aug,mean,na.rm=T); ph25_aug = resample(ph25_aug,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_sep = ph25[[seq_sep]] ; ph25_sep = calc(ph25_sep,mean,na.rm=T); ph25_sep = resample(ph25_sep,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_oct = ph25[[seq_oct]] ; ph25_oct = calc(ph25_oct,mean,na.rm=T); ph25_oct = resample(ph25_oct,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_nov = ph25[[seq_nov]] ; ph25_nov = calc(ph25_nov,mean,na.rm=T); ph25_nov = resample(ph25_nov,bat)
ph25 = brick("env_vars.nc",varname = "ph",level=25) ; ph25 = crop(ph25,ext) ; ph25_dec = ph25[[seq_dec]] ; ph25_dec = calc(ph25_dec,mean,na.rm=T); ph25_dec = resample(ph25_dec,bat)
#__________________________________________________________________________________________________________________



#:: Resulting rasters (ph1 to ph23) are the multiannual monthly mean layers of ph for each month from depth 1 to depth 23
# (0.5 to 108.03 m depth)



#__________________________________________________________________________________________________________________
# STEP 3 pH------------------------------------------------------------------
# Reclassify Bathymetric layer using depths in the restulting rasters from step 2 as new classes

# 3.1 Create a reclassification matrix for target depths (0.5 to 108.03 m depth)
reclass_m <- matrix(c(-Inf, -109.0, NA,
                      -108.029, -97.040, 25,
                      -97.039, -86.930, 24,
                      -86.929, -77.610, 23,
                      -77.609, -69.020, 22,
                      -69.019, -61.110, 21,
                      -61.109, -53.850, 20,
                      -53.849, -47.210, 19,
                      -47.209, -41.180, 18,
                      -41.179, -35.740, 17,
                      -35.739, -30.870, 16,
                      -30.869, -26.560, 15,
                      -26.559, -22.760, 14,
                      -22.759, -19.430, 13,
                      -19.429, -16.530, 12,
                      -16.529, -13.990, 11,
                      -13.989, -11.770, 10,
                      -11.769, -9.820, 9,
                      -9.819, -8.090, 8,
                      -8.089, -6.540, 7,
                      -6.539, -5.140, 6,
                      -5.139, -3.860, 5,
                      -3.859, -2.670, 4,
                      -2.669, -1.560, 3,
                      -1.559, -0.510, 2,
                      -0.509, 0, 1,
                      0.1, Inf, NA), ncol=3, byrow=TRUE)

##:: Note that values above 0m and below -13.99m are set to NA

# 3.2 Reclassify Bathymetric layer using "reclass_m"
bat_reclass <- reclassify(bat,reclass_m)
#check the plot
plot(bat_reclass)


# 3.3 #extract values from the reclassified raster for each new depth class
bat_depth1 = raster::clamp (bat_reclass,lower = 1, upper= 1,useValues=FALSE)
bat_depth2 = raster::clamp (bat_reclass,lower = 2, upper= 2,useValues=FALSE)
bat_depth3 = raster::clamp (bat_reclass,lower = 3, upper= 3,useValues=FALSE)
bat_depth4 = raster::clamp (bat_reclass,lower = 4, upper= 4,useValues=FALSE)
bat_depth5 = raster::clamp (bat_reclass,lower = 5, upper= 5,useValues=FALSE)
bat_depth6 = raster::clamp (bat_reclass,lower = 6, upper= 6,useValues=FALSE)
bat_depth7 = raster::clamp (bat_reclass,lower = 7, upper= 7,useValues=FALSE)
bat_depth8 = raster::clamp (bat_reclass,lower = 8, upper= 8,useValues=FALSE)
bat_depth9 = raster::clamp (bat_reclass,lower = 9, upper= 9,useValues=FALSE)
bat_depth10 = raster::clamp (bat_reclass,lower = 10, upper= 10,useValues=FALSE)
bat_depth11 = raster::clamp (bat_reclass,lower = 11, upper= 11,useValues=FALSE)
bat_depth12 = raster::clamp (bat_reclass,lower = 12, upper= 12,useValues=FALSE)
bat_depth13 = raster::clamp (bat_reclass,lower = 13, upper= 13,useValues=FALSE)
bat_depth14 = raster::clamp (bat_reclass,lower = 14, upper= 14,useValues=FALSE)
bat_depth15 = raster::clamp (bat_reclass,lower = 15, upper= 15,useValues=FALSE)
bat_depth16 = raster::clamp (bat_reclass,lower = 16, upper= 16,useValues=FALSE)
bat_depth17 = raster::clamp (bat_reclass,lower = 17, upper= 17,useValues=FALSE)
bat_depth18 = raster::clamp (bat_reclass,lower = 18, upper= 18,useValues=FALSE)
bat_depth19 = raster::clamp (bat_reclass,lower = 19, upper= 19,useValues=FALSE)
bat_depth20 = raster::clamp (bat_reclass,lower = 20, upper= 20,useValues=FALSE)
bat_depth21 = raster::clamp (bat_reclass,lower = 21, upper= 21,useValues=FALSE)
bat_depth22 = raster::clamp (bat_reclass,lower = 22, upper= 22,useValues=FALSE)
bat_depth23 = raster::clamp (bat_reclass,lower = 23, upper= 23,useValues=FALSE)
bat_depth24 = raster::clamp (bat_reclass,lower = 24, upper= 24,useValues=FALSE)
bat_depth25 = raster::clamp (bat_reclass,lower = 25, upper= 25,useValues=FALSE)

#__________________________________________________________________________________________________________________




#__________________________________________________________________________________________________________________
# STEP 4 pH------------------------------------------------------------------
# 4.1 Extract data from ph at each depth using reclassified depth classes as masks 
# for each month, by first aligning spatial extents that might have slightly 
# moved during during last steps

ph_depth_1_jan = raster::mask(ph23_jan,bat_depth1)
ph_depth_2_jan = raster::mask(ph2_jan,bat_depth2)
ph_depth_3_jan = raster::mask(ph3_jan,bat_depth3)
ph_depth_4_jan = raster::mask(ph4_jan,bat_depth4)
ph_depth_5_jan = raster::mask(ph5_jan,bat_depth5)
ph_depth_6_jan = raster::mask(ph6_jan,bat_depth6)
ph_depth_7_jan = raster::mask(ph7_jan,bat_depth7)
ph_depth_8_jan = raster::mask(ph8_jan,bat_depth8)
ph_depth_9_jan = raster::mask(ph9_jan,bat_depth9)
ph_depth_10_jan = raster::mask(ph10_jan,bat_depth10)
ph_depth_11_jan = raster::mask(ph11_jan,bat_depth11)
ph_depth_12_jan = raster::mask(ph12_jan,bat_depth12)
ph_depth_13_jan = raster::mask(ph13_jan,bat_depth13)
ph_depth_14_jan = raster::mask(ph14_jan,bat_depth14)
ph_depth_15_jan = raster::mask(ph15_jan,bat_depth15)
ph_depth_16_jan = raster::mask(ph16_jan,bat_depth16)
ph_depth_17_jan = raster::mask(ph17_jan,bat_depth17)
ph_depth_18_jan = raster::mask(ph18_jan,bat_depth18)
ph_depth_19_jan = raster::mask(ph19_jan,bat_depth19)
ph_depth_20_jan = raster::mask(ph20_jan,bat_depth20)
ph_depth_21_jan = raster::mask(ph21_jan,bat_depth21)
ph_depth_22_jan = raster::mask(ph22_jan,bat_depth22)
ph_depth_23_jan = raster::mask(ph23_jan,bat_depth23)
ph_depth_24_jan = raster::mask(ph24_jan,bat_depth24)
ph_depth_25_jan = raster::mask(ph25_jan,bat_depth25)
#__________________________________________________________________________________________________________________



#__________________________________________________________________________________________________________________
# STEP 5 pH------------------------------------------------------------------
# 5.1 Merge the resulting rasters after 4.1 in a final raster layer
ph_bottom_jan = raster::merge(ph_depth_1_jan,ph_depth_2_jan,ph_depth_3_jan,ph_depth_4_jan,
                              ph_depth_5_jan,ph_depth_6_jan,ph_depth_7_jan,ph_depth_8_jan,
                              ph_depth_9_jan,ph_depth_10_jan,ph_depth_11_jan,ph_depth_12_jan,
                              ph_depth_13_jan,ph_depth_14_jan,ph_depth_15_jan,ph_depth_16_jan,
                              ph_depth_17_jan,ph_depth_18_jan,ph_depth_19_jan,ph_depth_20_jan,
                              ph_depth_21_jan,ph_depth_22_jan,ph_depth_23_jan,ph_depth_24_jan,ph_depth_25_jan)

# 5.2 Check the plot
plot(ph_bottom_jan) # This is the ocean bottom layer for ph and in january


# 5.2 (Optional) Since some missing data can occur from the original NetCdf we
# can interpolate those using Inverse Distance Weighting or any interpolation/imputation
# method of your perference
coords_ph_bottom_jan = xyFromCell(ph_bottom_jan,c(seq(1,72625,1))) ; table_raster_ph_bottom_jan=as.data.frame(ph_bottom_jan)
# 72625 is the total ammount of cells in the raster
table_raster_ph_bottom_jan=data.frame(coords_ph_bottom_jan,table_raster_ph_bottom_jan$layer)
names(table_raster_ph_bottom_jan)=c("x","y","ph_bottom_jan")
table_raster_ph_bottom_jan = table_raster_ph_bottom_jan[complete.cases(table_raster_ph_bottom_jan), ]
model_ph_bottom_jan<- gstat(id = "ph_bottom_jan", formula = ph_bottom_jan~1, locations = ~x+y, data=table_raster_ph_bottom_jan, 
                            nmax=24)
ph_bottom_jan<- interpolate(ph_bottom_jan, model_ph_bottom_jan)
ph_bottom_jan <- mask(ph_bottom_jan, bat_reclass)
plot(ph_bottom_jan)

# 5.3 Save results from 5.2 in a new raster tif file
writeRaster(ph_bottom_jan,"ph_bottom_jan.tif") 

# NOTE: This is the final ocean bottom layer for ph in January that you can use
# as a predictor for benthic species distribution models. But you still need
# to produce bottom layers for the rest of months

# 5.4 Just replace "jan" by "feb", "mar" and so on until "dec", and run all the 
# code for each month to produce the bottom ph layers for each month
#__________________________________________________________________________________________________________________






#__________________________________________________________________________________________________________________
# STEP 6 (OPTIONAL)------------------------------------------------------------------
# Stack and store your resulting ocean bottom layers in  a new raster tif or 
# NetCdf file
my_bottom_layers = stack(chl_bottom_jan,ph_bottom_jan)
writeRaster(my_bottom_layers,"my_bottom_layers.tif")
#__________________________________________________________________________________________________________________


# - - - THANKS FOR USING BATHYMETRIC PROJECTION FOR YOUR RESEARCH
# - - - Please write to pipeben@gmail.com if you have any question
