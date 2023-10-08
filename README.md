# GRLCM package - Global to Regional and Local Circulation Models

(Note: You might also be interested in the Bathymetric Projection code https://github.com/pipeben/Bathymetric-Projection)

This is an R-code that allows to easily manage GIS processes for bringing General Circulation Models (GCM) into Regional or Local Circulation Models (RCM or LCM).
It includes all necessary functions

Climate change studies requiere the outputs of GCM across different scenarios to be used as future data (RCPs 2.6, 4.5, 6.0, 8.5). However, these outputs are avaliable only at a global scale, with coarse spatial resolution (1° or higher). Therefore, Global GCMs are not useful for more regional or local scale studies.

Several GIS (Geographical Information Systems) processes are required to bring GCM to RCM or LCM, and depending on the characteristics of each GCM data, more or less steps can be needed. You can do this using the two options in the code: 1) Classical Statisticsal Dowscaling or 2) Deep Learning Downscaling.

GRLCM package makes it all easier by allowing you to interact with all these tools in one platform. You need to upload a GCM output and follow the steps to bring it to your study area. You can use GRLCM to perform statistical downscaling, delta downscaling or future scenario building with Deep Learning, which do not require downscaling. This last option usually gives more accurate results and preserve local characteristics.

The final proudct is a netCdf or raster file ready to be used for your research


