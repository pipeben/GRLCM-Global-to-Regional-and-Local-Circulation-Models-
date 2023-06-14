install.packages(c("tensorflow", "keras", "raster"))
library(tensorflow)
library(keras)
library(raster)

# Simulated data generation
set.seed(123)
raster_dim <- c(100, 100)  # Dimensions of the raster
num_variables <- 5  # Number of variables (excluding temperature)

# Generate 2021 raster at 1-degree resolution
raster_2021 <- stack()
for (i in 1:(num_variables + 1)) {
  raster_2021 <- addLayer(raster_2021, setValues(raster(matrix(runif(prod(raster_dim)), nrow = raster_dim[1]), nrow = raster_dim[1]), i))
}

# Generate 2100 raster at 1-degree resolution (using same values as 2021 raster for simplicity)
raster_2100 <- raster_2021

# Data preparation
# Extracting variables from rasters
variables_2021 <- getValues(raster_2021)
variables_2100 <- getValues(raster_2100)

# Computing rate of change
rate_of_change <- variables_2100 - variables_2021[, , -1]

# Scaling the data (if necessary)
scaled_variables_2021 <- scale(variables_2021[, , -1])
scaled_rate_of_change <- scale(rate_of_change)

# Splitting the data into training and testing sets
train_percentage <- 0.8
train_samples <- floor(train_percentage * raster_dim[1] * raster_dim[2])
indices <- sample.int(raster_dim[1] * raster_dim[2])
train_indices <- indices[1:train_samples]
test_indices <- indices[(train_samples + 1):(raster_dim[1] * raster_dim[2])]

# Training data
train_data <- scaled_variables_2021[train_indices, , , drop = FALSE]
train_labels <- scaled_rate_of_change[train_indices, , , drop = FALSE]

# Testing data
test_data <- scaled_variables_2021[test_indices, , , drop = FALSE]
test_labels <- scaled_rate_of_change[test_indices, , , drop = FALSE]

# CNN Model Definition
cnn_model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu", input_shape = dim(train_data)[-1]) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = dim(train_labels)[-1])

# Model Compilation
cnn_model %>% compile(
  loss = "mean_squared_error",
  optimizer = optimizer_adam(),
  metrics = c("mean_absolute_error")
)

# Model Training
cnn_model %>% fit(
  train_data, train_labels,
  epochs = 10,
  
  
  # Install and load required packages
  install.packages(c("tensorflow", "keras", "raster"))
  library(tensorflow)
  library(keras)
  library(raster)
  
  # Function to generate simulated raster data
  generate_simulated_raster <- function(raster_dim, num_variables) {
    set.seed(123)
    
    raster_data <- stack()
    for (i in 1:(num_variables + 1)) {
      raster_data <- addLayer(raster_data, setValues(raster(matrix(runif(prod(raster_dim)), nrow = raster_dim[1]), nrow = raster_dim[1]), i))
    }
    
    return(raster_data)
  }
  
  # Function to prepare data
  prepare_data <- function(raster_2021, raster_2100) {
    variables_2021 <- getValues(raster_2021)
    variables_2100 <- getValues(raster_2100)
    
    rate_of_change <- variables_2100 - variables_2021[, , -1]
    
    scaled_variables_2021 <- scale(variables_2021[, , -1])
    scaled_rate_of_change <- scale(rate_of_change)
    
    train_percentage <- 0.8
    train_samples <- floor(train_percentage * prod(dim(raster_2021)[1:2]))
    indices <- sample.int(prod(dim(raster_2021)[1:2]))
    train_indices <- indices[1:train_samples]
    test_indices <- indices[(train_samples + 1):prod(dim(raster_2021)[1:2])]
    
    train_data <- scaled_variables_2021[train_indices, , , drop = FALSE]
    train_labels <- scaled_rate_of_change[train_indices, , , drop = FALSE]
    
    test_data <- scaled_variables_2021[test_indices, , , drop = FALSE]
    test_labels <- scaled_rate_of_change[test_indices, , , drop = FALSE]
    
    return(list(train_data = train_data, train_labels = train_labels, test_data = test_data, test_labels = test_labels))
  }
  
  # Generate simulated raster data
  raster_dim <- c(100, 100)
  num_variables <- 5
  raster_2021 <- generate_simulated_raster(raster_dim, num_variables)
  raster_2100 <- generate_simulated_raster(raster_dim, num_variables)
  
  # Prepare data
  data <- prepare_data(raster_2021, raster_2100)
  train_data <- data$train_data
  train_labels <- data$train_labels
  test_data <- data$test_data
  test_labels <- data$test_labels
  
  # Define and train a convolutional neural network (CNN)
  cnn_model <- keras_model_sequential() %>%
    layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu", input_shape = dim(train_data)[-1]) %>%
    layer_max_pooling_2d(pool_size = c(2, 2)) %>%
    layer_flatten() %>%
    layer_dense(units = 64, activation = "relu") %>%
    layer_dense(units = dim(train_labels)[-1])
  
  cnn_model %>% compile(
    loss = "mean_squared_error",
    optimizer = optimizer_adam(),
    metrics = c("mean_absolute_error")
  )
  
  cnn_model %>% fit(
    train_data, train_labels,
    epochs = 10,
    batch_size = 32
  )
  
  # Define and train a transformer neural network
  transformer_model <- keras_model_sequential() %>%
    layer_encoder_block(
      num_heads = 8,
      hidden_dim = 512,
      num_layers = 4,
      dropout = 0.1,
      input_shape = dim(train_data)[-1]
    ) %>%
    layer_flatten() %>%
    layer_dense(units = dim(train_labels)[-1])
  
  transformer_model %>% compile(
    loss = "mean_squared_error",
    optimizer = optimizer_adam(),
    metrics = c("mean_absolute_error")
  )
  
  transformer_model %>% fit(
    train_data, train_labels,
    epochs = 10,
    batch_size = 32
  )
  
  # Model evaluation
  cnn_results <- cnn_model %>% evaluate(test_data, test_labels)
  transformer_results <- transformer_model %>% evaluate(test_data, test_labels)
  
  print("CNN Model Evaluation:")
  print(cnn_results)
  print("Transformer Model Evaluation:")
  print(transformer_results)
  
  # Model deployment
  # Assuming you have a 2021 raster at 0.05-degree resolution
  raster_2021_high_res <- generate_simulated_raster(c(200, 200), num_variables)
  
  # Preprocess the high-resolution raster data
  high_res_data <- scale(getValues(raster_2021_high_res)[, , -1])
  
  # Predict future temperature using the CNN model
  cnn_predictions <- cnn_model %>% predict(high_res_data)
  
  # Predict future temperature using the transformer model
  transformer_predictions <- transformer_model %>% predict(high_res_data)
  
  # Print the predictions
  print("CNN Predictions:")
  print(cnn_predictions)
  print("Transformer Predictions:")
  print(transformer_predictions)
  
  # Install and load required packages
  install.packages(c("tensorflow", "keras", "raster"))
  library(tensorflow)
  library(keras)
  library(raster)
  
  # Function to generate simulated raster data
  generate_simulated_raster <- function(raster_dim, num_variables) {
    set.seed(123)
    
    raster_data <- stack()
    for (i in 1:(num_variables + 1)) {
      raster_data <- addLayer(raster_data, setValues(raster(matrix(runif(prod(raster_dim)), nrow = raster_dim[1]), nrow = raster_dim[1]), i))
    }
    
    return(raster_data)
  }
  
  # Function to prepare data
  prepare_data <- function(raster_2021, raster_2100) {
    variables_2021 <- getValues(raster_2021)
    variables_2100 <- getValues(raster_2100)
    
    rate_of_change <- variables_2100 - variables_2021[, , -1]
    
    scaled_variables_2021 <- scale(variables_2021[, , -1])
    scaled_rate_of_change <- scale(rate_of_change)
    
    train_percentage <- 0.8
    train_samples <- floor(train_percentage * prod(dim(raster_2021)[1:2]))
    indices <- sample.int(prod(dim(raster_2021)[1:2]))
    train_indices <- indices[1:train_samples]
    test_indices <- indices[(train_samples + 1):prod(dim(raster_2021)[1:2])]
    
    train_data <- scaled_variables_2021[train_indices, , , drop = FALSE]
    train_labels <- scaled_rate_of_change[train_indices, , , drop = FALSE]
    
    test_data <- scaled_variables_2021[test_indices, , , drop = FALSE]
    test_labels <- scaled_rate_of_change[test_indices, , , drop = FALSE]
    
    return(list(train_data = train_data, train_labels = train_labels, test_data = test_data, test_labels = test_labels))
  }
  
  # Function to train CNN model
  train_cnn_model <- function(train_data, train_labels, epochs = 10, batch_size = 32) {
    cnn_model <- keras_model_sequential() %>%
      layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu", input_shape = dim(train_data)[-1]) %>%
      layer_max_pooling_2d(pool_size = c(2, 2)) %>%
      layer_flatten() %>%
      layer_dense(units = 64, activation = "relu") %>%
      layer_dense(units = dim(train_labels)[-1])
    
    cnn_model %>% compile(
      loss = "mean_squared_error",
      optimizer = optimizer_adam(),
      metrics = c("mean_absolute_error")
    )
    
    cnn_model %>% fit(
      train_data, train_labels,
      epochs = epochs,
      batch_size = batch_size
    )
    
    return(cnn_model)
  }
  
  # Function to train Transformer model
  train_transformer_model <- function(train_data, train_labels, epochs = 10, batch_size = 32) {
    transformer_model <- keras_model_sequential() %>%
      layer_encoder_block(
        num_heads = 8,
        hidden_dim = 512,
        num_layers = 4,
        dropout = 0.1,
        input_shape = dim(train_data)[-1]
      ) %>%
      layer_flatten() %>
      