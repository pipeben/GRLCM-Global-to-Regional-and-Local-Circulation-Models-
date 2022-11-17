library(raster)
library(ncdf4)
library(spatialEco)
library(tmap)
library(psych)

rm(list=ls())
cat("\014")
graphics.off()

#CMIP 6, Escenario 8.5, Modelo GFDL-ESM4, Thetao, 2050 (load file)

# setwd("C:/Users/Eq_PEP_IEP_SPN_Tco/Mi unidad/PostDoc/Future_GCM/8.5/thetao")

{
  winDialog(type = "ok", message = "Select directory with the netcdf file")
  setwd(choose.dir())               # let user define working directory
  root_dir <- "C:/Users/USUARIO/Desktop/Felipe_downscaling/data"
  print(getwd())
}

{
  winDialog(type = "ok", message = "Select the directory to save your results")
  result_path <- choose.dir(default = root_dir)              # let user define working directory
}


## load netcdf and convert it to a raster brick
# raster_brick_1 = raster::brick("thetao_Omon_GFDL-ESM4_ssp585_r1i1p1f1_gn_205501-207412.nc",
#                                level=1,
#                                stopIfNotEqualSpaced = FALSE)

#load a reference raster to make a mask
setwd("C:/Users/USUARIO/Desktop/Felipe_downscaling/data")
st_ref = raster("bat_reclass_phys.tif")

#create extension objetct to make crops (CPO)
ex=extent(c(-80.04167, -76.95833, -0.04166667, 8.041667)) #extent for all new rasters

# Loop 1: Get sequences to extract all jans, febs, marchs, etc.
{
  winDialog(type = "ok", "Choose the month(s):")
  months_nr_list <- as.character(seq(1,12,1))
  months_nr_list <- as.numeric(select.list(c(months_nr_list), preselect = c(months_nr_list), multiple = TRUE,
                                           title = "Select the months", graphics = TRUE))
  month_abrev_list <- tolower(month.abb)
  ##
  # create a list of depth the user can select from
  winDialog(type = "ok", "Select now the depth layers")
  selected_depth_layer <- as.numeric(select.list(as.character(c(1,6,12,15)),
                                                 preselect = as.character(c(1,6,12,15,18)), multiple = TRUE,
                                                 title = "Select the depths layer", graphics = TRUE))
}

# i <- 1     # 'i' is the loop variable for the month
if (exists("list_of_dfs")) { rm(list_of_dfs) }
for (i in c(months_nr_list)){
  print(i)              # just to test i
  print(month_abrev_list[i])   # just to test month abbrev
  # create the seq for the selected month
  nam <- paste0("seq_", month_abrev_list[i], sep="")
  # print(nam)           # just to test creation of name 'nam'
  
  assign(nam, seq(i,240,12) ) # here apply a function to 'nam', the result of your function appears under the created name 'nam' in the global environment
  rm(nam)
  
  # second loop over the create sequences (e.g. 'seq_jan') loops over the selected depths
  
}  

list_of_dfs <- ls(pattern = "seq_")  # create a list of all files with pattern 'seq' available in global environmenmt

if (length(list_of_dfs) != 0) {  # if this list is longer than 0
  print("Yeah!!!")
  
  # j is the loop variable over the seq_list listed in 'list of dfs'
  # h is the loop variable over the selected depths layer in 'selected depth_layer'
  j <- 1
  for (j in 1:length(list_of_dfs)) {
    print(paste("Loop nr: ", j, ", name of sequence file: ", list_of_dfs[j], sep=""))
    name_seq <- paste0(list_of_dfs[j])
    h <- selected_depth_layer[1]
    for (h in selected_depth_layer) {
      cat("\014")
      #  setwd(root_dir)
      if(exists("raster_brick_1")) { rm(raster_brick_1)}
      setwd("C:/Users/USUARIO/Desktop/Felipe_downscaling/data")
      raster_brick_1 = raster::brick("thetao_Omon_GFDL-ESM4_ssp585_r1i1p1f1_gn_205501-207412.nc",
                                     level=h,
                                     stopIfNotEqualSpaced = FALSE)
      
      print(paste("The depth layer in this run is layer: ", h, sep=""))
      name_depth_layer <- paste0(h)
      # here change: the user should define the path to the present data obove
      # before the loops
      root_dir <- "C:/Users/USUARIO/Desktop/Felipe_downscaling/data"
      setwd(paste0(root_dir, "/present", sep=""))
      
      # remove nam_2 if exists
      if (exists("nam_2")) { rm(nam_2) }
      nam_2 <- paste0("st_depth_layer_", h, "_2050_seq_", 
                      match(gsub("seq_", "", list_of_dfs[j]), 
                            tolower(month.abb)), 
                      "_month_name", 
                      gsub("seq", "", list_of_dfs[j]), sep="")
      
      # So soll es aussehen: raster_brick_1[[seq_jan]]
      if (exists("r_temp")) { rm(r_temp) }
      if (exists("c_text")) { rm(c_text) }
      
      c_text <- paste0("raster_brick_1[[", list_of_dfs[j], "]]", sep="")
      print(paste0("Command to run: ", c_text, sep=""))
      ##
      r_temp <- eval(parse(text = c_text))
      ##########################################################################
      #1.1define projection
      crs(r_temp) = "+proj=longlat +datum=WGS84 +no_defs"
      
      #2 crop raster
      r_temp = crop(r_temp, st_ref)
      
      #3 calculate mean
      r_temp = calc(r_temp, mean)
      plot(r_temp)
      
      #4
      r_temp = raster.downscale(raster("st_ref1_jan.tif"), r_temp)
      plot(r_temp$downscale)
      
      #4.1
      r_temp = r_temp$downscale
      plot(r_temp)
      
      tmap_mode("view")
      tm_shape(r_temp) +
        tm_raster()
      
      
      ##########################################################################
      
      assign(nam_2, r_temp)
      #################
      
      
      rm(r_temp)
      setwd(root_dir)
    }  #  end of 'for (h in selected_depth_layer)'
  }  #  end of 'for (j in 1:length(list_of_dfs))'
}  #  end of 'if (length(list_of_dfs) != 0)'

## Now save all created raster files

list_of_raster <- ls(pattern = "st_depth")  # create a list of all created raster files with pattern 'st_depth' in global environmenmt

if(exists("summary_table")) { rm(summary_table)}

for (tt in 1:length(list_of_raster)){
  if (exists("summary_table")) {
    summary_table <- rbind(summary_table, as.data.frame(psych::describe(as.data.frame(get(list_of_raster[tt])))))
  }
  if (!exists("summary_table")) {
    summary_table <- as.data.frame(psych::describe(as.data.frame(get(list_of_raster[tt]))))
  }
}
rownames(summary_table) <- c(list_of_raster)


list_of_raster <- ls(pattern = "st_depth")  # create a list of all created raster files with pattern 'st_depth' in global environmenmt

answer_01 <- "NO"
answer_01 <- winDialog("yesno", "Do you want to save the calculated results?")

if (answer_01 == "YES"){
  print("Data will be saved ....")
  main_dir <- result_path
  
  # setting up the sub directory
  sub_dir <- paste0("results_of_", Sys.Date(), sep="")
  
  # check if sub directory exists 
  if (file.exists(sub_dir)){
    
    # specifying the working directory
    setwd(file.path(main_dir, sub_dir))
  } else {
    
    # create a new sub directory inside
    # the main path
    dir.create(file.path(main_dir, sub_dir))
    
    # specifying the working directory
    setwd(file.path(main_dir, sub_dir))
  }
  w1 <- 1
  for (w1 in 1:length(list_of_raster)){
    n_temp <- list_of_raster[w1]
    writeRaster(get(n_temp),
                paste0(n_temp, ".tif", sep=""),
                overwrite=TRUE)
    rm(n_temp)
  }
}


winDialog(type = "ok", "End of program")


p_r <- select.list(choices= list_of_raster, preselect = NULL,
                   multiple = TRUE,
                   title = "Mapping: Select max. 5 raster", graphics = TRUE)

if(exists("cc")) { rm(cc) }
tmap_mode("view")
for(tr in 1:length(p_r)) {
  # for(tr in 1:3) {
  if(exists("cc")){
    cc <- paste(cc, " + tm_shape(", list_of_raster[tr], ") + tm_raster()", sep="")
  } else {cc <- paste("tm_shape(", list_of_raster[tr], ") + tm_raster()", sep="")
  }
}

eval(parse(text = cc))



# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------



