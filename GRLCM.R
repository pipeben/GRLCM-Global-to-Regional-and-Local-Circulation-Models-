library(ncdf4)
# ibrary(tidyverse)  # because who can live without the tidyverse?
library(shiny)      # for the miniGadgets
library(shinyFiles) # for the buttons, e.g. 'shinyDirButton'
library(miniUI)     # package for Shiny UI Widgets for small screens
# library(shinyBS)    # 

###### ##########################################################################
rm(list = ls())
cat("\014")
graphics.off()
################################################################################


################################################################################
################################################################################
###  - create functions

# Function 1: define function to loadnetcdf 
if (exists("FUNC_load")) { rm(FUNC_load) }
FUNC_load = function()
{
  if (exists("temp.nc")) { rm(temp.nc) }
  
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Select and load netcdf data"),
    miniUI::miniTabstripPanel(
      miniUI::miniTabPanel("Load netcdf", 
                           icon = shiny::icon("folder-open"),
                           miniUI::miniContentPanel(
                             # Input: Select a file ----
                             shiny::fileInput("read_netcdf", "Choose one netcdf (*.nc) file",
                                              multiple = TRUE,
                                              placeholder = "No file selected",
                                              accept = c(".nc")),
                             shiny::uiOutput("wordOneButton")
                           )
      )
    )
  )
  
  server <- function(input, output, session) {
    ############################################################################
    # By default, Shiny limits file uploads to 5MB per file. You can modify this 
    # limit by using the shiny.maxRequestSize option. For example, adding 
    #
    # options(shiny.maxRequestSize=30*1024^2) 
    #
    # to the top of server.R would increase the limit to 30 MB.
    
    options(shiny.maxRequestSize=10000*1024^2,   # 10000 = 10000 MB = 10 GB
            shiny.trace=TRUE)
    ############################################################################
    ##  - observe file input widget
    output$chosen_file <- renderPrint({
      str(input$read_netcdf) 
    })
    # shiny::observeEvent(input$read_netcdf)
    
    reval <<- reactive(input$read_netcdf)
    
    output$wordOneButton <- renderUI({
      
      # Validate that reval() is distinct than ""
      shiny::validate(
        shiny::need(reval() != "", message = "")
      )
      
      shiny::actionButton("loadfile", 
                          # label = reval()[1]
                          label = "Load chosen netcdf file",
                          style="color: #fff; background-color: #337ab7; border-color: #2e6da4"
      )
    })
    
    ############################################################################
    ##  - observe action button 'Load chosen netcdf file'
    
    # load nc file after click event on button
    shiny::observeEvent(input$loadfile, {
      # here content to load nc file
      temp.nc <<- ncdf4::nc_open(paste0(input$read_netcdf, sep=""))
      return(temp.nc)
    })  # ** End of 'observeEvent(load_nc_file, {' ** #
    
    
    ##############################################################
    ### - Cancel / Stop button
    shiny::observeEvent(input$cancel, {
      stopApp(TRUE)
    })
    
    shiny::observeEvent(input$done, {
      stopApp()
    })
  }
  
  # shiny::runGadget(shiny::shinyApp(ui, server), 
  #                  # viewer = shiny::paneViewer()
  #                  shiny::dialogViewer(dialogName="Test", width = 600, height = 600)
  #                  )
  shiny::runGadget(ui, server,viewer = shiny::dialogViewer("Show selected dependant variable in map", 
                                                           width = 800, 
                                                           height = 800))
}


################################################################################
# Function 2: function to create tables from the metadata of variables and dimensions

if (exists("FUNC_variable_and_dims_data")) { rm(FUNC_variable_and_dims_data) }
FUNC_variable_and_dims_data = function(data)
{
  # get variable names
  var_names <<- as.character(unlist(attributes(temp.nc$var)))
  
  # get dimension names
  dim_names <<- as.character(unlist(attributes(temp.nc$dim)))
  
  ##############################################################################
  # Get the time variable. 
  time_name <- select.list(dim_names,
                           preselect = NULL,
                           multiple = FALSE,
                           title = "Select time",
                           graphics = TRUE)# # select time from the dimension variables in "matrix slices"
  time<-ncdf4::ncvar_get(temp.nc, time_name)
  
  tunits<-ncdf4::ncatt_get(temp.nc, time_name, attname="units")
  
  tustr<-strsplit(tunits$value, " ")
  dates<<-as.Date(time,origin=unlist(tustr)[3])
  ########################################################
  # create an empty data frame to store variable metadata results
  nc_depend_var_metadata <- data.frame(short_name=character(),
                                       long_name=character(), 
                                       unit=character(),
                                       nr_of_dimensions=as.numeric(),
                                       names_of_dimensions=character(),
                                       dim_lengths=character(),
                                       stringsAsFactors=FALSE)
  i <- 1
  for (i in 1:length(var_names)){
    print(var_names[i])
    nc_depend_var_metadata[c(nrow(nc_depend_var_metadata)+1), 1] <- var_names[i]
    nc_depend_var_metadata[c(nrow(nc_depend_var_metadata)),2] <- temp.nc$var[[i]]$longname
    nc_depend_var_metadata[c(nrow(nc_depend_var_metadata)),3] <- temp.nc$var[[i]]$units
    nc_depend_var_metadata[c(nrow(nc_depend_var_metadata)),4] <- temp.nc$var[[i]]$ndims
    
    if(exists("temp_001")) { rm(temp_001) }
    temp_001 <- temp.nc$var[[i]]$dim
    j <- 1
    dim_names <- c()
    dim_lengths <- c()
    for (j in 1:length(temp_001)) {
      dim_names <- c(dim_names, temp_001[[j]]$name)
      dim_lengths <- c(dim_lengths, as.character(temp_001[[j]]$len))
    }
    nc_depend_var_metadata[c(nrow(nc_depend_var_metadata)),5] <- paste0(as.character(dim_names), collapse=", ")
    nc_depend_var_metadata[c(nrow(nc_depend_var_metadata)),6] <- paste0(as.character(dim_lengths), collapse=", ")
    rm(dim_names, j, temp_001)
  }
  
  var_metadata <<- nc_depend_var_metadata
  
  ########################################################
  # create an empty data frame to store dimensions metadata results
  
  nc_dim_var_metadata <- data.frame(name=character(),
                                    dim_length=integer(), 
                                    dim_unit=character(),
                                    dim_range=character(),
                                    stringsAsFactors=FALSE)
  
  i <- 1
  for (i in 1:length(temp.nc$dim)){
    print(i)
    print(temp.nc$dim[[i]]$name)
    
    # if (exists("")) { rm() }
    nc_dim_var_metadata[c(nrow(nc_dim_var_metadata)+1), 1] <- temp.nc$dim[[i]]$name
    nc_dim_var_metadata[c(nrow(nc_dim_var_metadata)), 2] <- temp.nc$dim[[i]]$len
    nc_dim_var_metadata[c(nrow(nc_dim_var_metadata)), 3] <- temp.nc$dim[[i]]$units
    nc_dim_var_metadata[c(nrow(nc_dim_var_metadata)), 4] <- paste0(as.character(range(temp.nc$dim[[i]]$vals)), collapse=", ")
  }
  
  nc_dim_var_metadata$time_date_range <- NA
  
  nc_dim_var_metadata$time_date_range[nc_dim_var_metadata$name == 'time'] <- paste0(as.character(range(dates)), collapse = ", ")
  
  dim_metadata <<- nc_dim_var_metadata
  ##############################################################################
  ###  - ui
  ui <- miniPage(
    gadgetTitleBar("Netcdf (nc) metadata of variables and dimensions"), 
    miniContentPanel(
      h5(strong("Metadata of the netcdf variables")),
      div(tableOutput("var_table"), style = "font-size:80%"),
      h5(strong("Metadata of the netcdf dimensions")),
      div(tableOutput("dim_table"), style = "font-size:80%")
      # tableOutput("dim_table"),
    )
  )
  
  ##############################################################################
  ###  - server
  
  server <- function(input, output, session){
    
    output$var_table <- renderTable(nc_depend_var_metadata)
    output$dim_table <- renderTable(nc_dim_var_metadata)
    
    ##############################################################
    ### - Cancel / Stop button
    shiny::observeEvent(input$cancel, {
      stopApp(TRUE)
    })
    
    shiny::observeEvent(input$done, {
      stopApp(temp.nc())
    })
  } # ** End of 'server' ** #
  
  ##############################################################################
  ###   - run gadget
  shiny::runGadget(ui, server,viewer = shiny::dialogViewer("Show metadata of variables and dimensions", 
                                                           width = 900, 
                                                           height = 800))
}

# FUNC_variable_and_dims_data(temp.nc)  # delete later

################################################################################
# Function 3: function to select variable and dims 

if (exists("FUNC_define_var_to_plot")) { rm(FUNC_define_var_to_plot) }
FUNC_define_var_to_plot = function(var_metadata, dim_metadata)
{
  var_with_unit <- var_metadata[var_metadata$unit != "",]
  dims_with_unit <- dim_metadata[dim_metadata$dim_unit != "",]
  ##############################################################################
  ###  - define ui
  choices_list <- c()
  for (i in 1:nrow(var_with_unit)) {
    choices_list <- c(choices_list, 
                      paste0(var_with_unit$short_name[i], " = ", var_with_unit$long_name[i], sep="") )
  }
  
  
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Please choose a response variable"),
    miniUI::miniContentPanel(
      shiny::selectizeInput(
        inputId ="select_var", 
        label = "Select a response variable",
        choices = as.character(choices_list), 
        multiple = TRUE,
        width = '100%',
        options = list(maxItems = 1)
      ),
      shiny::conditionalPanel(
        condition = "input.select_var != ''",
        shiny::verbatimTextOutput("resp_var"),
        # shiny::verbatimTextOutput("nr_of_dims"),
        # shiny::verbatimTextOutput("names_of_dims"),
        # shiny::verbatimTextOutput("lengths_of_dims")
      ),
      shiny::conditionalPanel(
        condition = "input.select_var != ''",
        shiny::actionButton(inputId="actionButton_01", 
                            label = "Plot map",class = "btn-success")
      ),
      plotOutput("plot_nc", height = "100%")
    )
  ) # ** End of 'ui' ** #
  
  ##############################################################################
  ###  - define server
  server <- function(input, output){
    output$resp_var <- renderPrint({ 
      kotz <- input$select_var
      kotz <<- unlist(strsplit(kotz, " "))[1]
      return(kotz)
    })
    
    var_array <- reactive({
      a <- ncdf4::ncvar_get(temp.nc, kotz)
      fillvalue <- ncdf4::ncatt_get(temp.nc, kotz, "_FillValue")
      a[a==fillvalue$value] <- NA
      return(a)
    })
    
    observeEvent(input$actionButton_01,{
      lon <- temp.nc$dim$lon$vals
      lat <- temp.nc$dim$lat$vals
      
      # store the data in a 3-dimensional array
      ndvi.array <- ncdf4::ncvar_get(temp.nc, kotz)
      dim(ndvi.array) 
      
      # extract fillvalue and replace with NAS
      fillvalue <- ncdf4::ncatt_get(temp.nc, kotz, "_FillValue")
      ndvi.array[ndvi.array == fillvalue$value] <- NA
      
      # create a single slice of the nc matrix to allow to create an image
      if (length(dim(ndvi.array)) == 2) {
        ndvi.slice <- ndvi.array[,]
      }
      
      if (length(dim(ndvi.array)) >= 3) {
        ndvi.slice <- eval(parse(text = paste0("ndvi.array[ , ," , 
                                               # paste0(noquote(rep(",", (length(dim(ndvi.array))-2))), collapse = " "),
                                               
                                               # ", ", 
                                               paste0(noquote(rep("1", (length(dim(ndvi.array))-2))), collapse = ", "), 
                                               "]", 
                                               sep="") ) )
      }
      output$plot_nc <- renderPlot({ 
        plot1 <- image(sort(lon), sort(lat), ndvi.slice)
        return(plot1)
      })
      
    })
    
   
    
    # output$nr_of_dims <- renderPrint({
    #   kotz2 <<- paste0("Number of dimensions: ", var_with_unit[var_with_unit==kotz, "nr_of_dimensions"])
    #   return(kotz2)
    # })
    # 
    # output$names_of_dims <- renderPrint({
    #   kotz2 <<- paste0("Ordered names of dimensions: ", var_with_unit[var_with_unit==kotz, "names_of_dimensions"])
    #   return(kotz2)
    # })
    # 
    # output$lengths_of_dims <- renderPrint({
    #   kotz2 <<- paste0("Number of dimensions: ", var_with_unit[var_with_unit==kotz, "dim_lengths"])
    #   return(kotz2)
    # })
    
    # plot map 
    # observeEvent(actionButton_01)
    
    
    ####
    observeEvent(input$done, {
      # returnValue <- menuR
      stopApp()
    })
    
    observeEvent(input$cancel, {
      stopApp(kotz)
    })
  } # ** 'End of server' ** #
  ##############################################################################
  ###  - run MiniGadget
  shiny::runGadget(ui, server, viewer = shiny::dialogViewer("Choose variables to plot nc"))
}

# ################################################################################
# # Function 4: function to image the loaded netcdf 
# 
# if (exists("FUNC_plot_image")) { rm(FUNC_plot_image) }
# FUNC_plot_image = function()
# {
#   lon <- temp.nc$dim$lon$vals
#   lat <- temp.nc$dim$lat$vals
#   
#   # store the data in a 3-dimensional array
#   ndvi.array <- ncdf4::ncvar_get(temp.nc, kotz)
#   dim(ndvi.array) 
#   
#   # extract fillvalue and replace with NAS
#   fillvalue <- ncdf4::ncatt_get(temp.nc, kotz, "_FillValue")
#   ndvi.array[ndvi.array == fillvalue$value] <- NA
#   
#   # create a single slice of the nc matrix to allow to create an image
#   if (length(dim(ndvi.array)) == 2) {
#     ndvi.slice <- ndvi.array[,]
#   }
#   
#   if (length(dim(ndvi.array)) >= 3) {
#     ndvi.slice <- eval(parse(text = paste0("ndvi.array[ , ," , 
#                                          # paste0(noquote(rep(",", (length(dim(ndvi.array))-2))), collapse = " "),
#                                          
#                                          # ", ", 
#                                          paste0(noquote(rep("1", (length(dim(ndvi.array))-2))), collapse = ", "), 
#                                          "]", 
#                                          sep="") ) )
#     
#   plot1 <<- image(sort(lon), sort(lat), ndvi.slice)
#   
#   ##############################################################################
#   ### - ui
#   ui <- miniUI::miniPage(
#     miniUI::gadgetTitleBar(title = paste0("Image of the loaded netcdf of the variable ", kotz, sep=""),
#                            left = miniTitleBarCancelButton(),
#                            right = miniTitleBarButton("done", "Done", primary = TRUE)),
#     miniContentPanel(
#       plotOutput("plot_nc", height = "100%")
#     )
#     )
#   ##############################################################################
#   ###  - server
#   server <- function(input, output){
#     output$plot_nc <- renderPlot({ 
#       plot1 <- image(sort(lon), sort(lat), ndvi.slice)
#       return(plot1)
#       })
#     ##########
#     # observe cancel and stop button
#     ####
#     observeEvent(input$done, {
#       # returnValue <- menuR
#       stopApp()
#     })
#     
#     observeEvent(input$cancel, {
#       stopApp()
#     })
#     
#   }
#   ##############################################################################
#   ###  - run MiniGadget
#   shiny::runGadget(ui, server, viewer = shiny::dialogViewer("plot nc with chosen variable"))
#   
# } # ** End of 'FUNC_plot_image = function(' ** '

################################################################################
################################################################################
###   - 
rm(list= ls()[!(ls() %in% c('FUNC_load',
                            'FUNC_variable_and_dims_data', 
                            'FUNC_define_var_to_plot'))])

FUNC_load()
FUNC_variable_and_dims_data(temp.nc)
FUNC_define_var_to_plot(var_metadata, dim_metadata)

################################################################################
################################################################################
################################################################################


