library(shiny)
library(datasets)
library(UsingR)
library(manipulate)


#
# Define server logic required to summarize and view the selected dataset
#
shinyServer(function(input, output, session) {
  
  #
  # Which supplement did the user choose
  #
  chooseTreatment <- reactive({
    switch(input$chooseSupp,
           "Vitamin C" = 1,
           "Orange Juice" = 2,
           "Both" = 3
    )
  })
  

  #
  # Determine if the user wants a subet of the dataset
  #
  useData <- reactive({
    
    x <- ToothGrowth[order(ToothGrowth$supp),]
    #
    # Filter chosen dosage (these are OR conditions since it's a group of checkboxes)
    #
    x <- data.frame()
    for (i in as.numeric(input$chooseDose)){
      t <- subset(ToothGrowth, dose == i)
      x <- rbind(x, t)
    }
    #
    # Filter chosen supplement
    #
    if (chooseTreatment() == 1){
      x <- subset(x, supp == "VC")
      
    } else if (chooseTreatment() == 2){
      x <- subset(x, supp == "OJ")
    }
    
    x$supp <- factor(x$supp)    # refactor sonce only 1 treatment may have been chosen
    
    useData <- x
  })
  #
  # Which x axis did the user choose?
  #
  Variables <- reactive({
    
    if (length(input$check1) == 1){
      if (input$check1 == "1"){
        len~dose
      } else if (input$check1 == "2"){
        len~supp
      }
    } else {
      len~supp*dose
    }
  })
  
  #
  # Set x-axis according to the selected variables 
  #
  x_axis_label <- function(){
    if (length(input$check1) == 1){
      if (input$check1 == "1"){
        "Dose"
      } else if (input$check1 == "2"){
        "Supplement"
      }
    } else {
      "Supplement Dosage"
    }
  }
  
  #
  # Set colors according to selected variables 
  #
  colores <- function(){
    if (length(input$check1) == 1){
      if (input$check1 == "1" || input$chooseSupp == 1){
        c("cyan","blue", "black")
      } else if (input$check1 == "2" || input$chooseSupp == 2){
        c("blue", "red")
      }
    } else {
      c("blue","red")
    }
  }
  #
  # Set if the Nocth effect is draw or not
  #
  BAR_WIDTH   <- function(){
      if (input$Boxplotfeat1 == "TRUE"){
      TRUE
      }
      else{ 
      FALSE
      }
  }
  #
  # Show the customized graph
  #
  output$main_plot <- renderPlot({
    
    if (input$chartType == "Vertical"){
      boxplot(Variables(), data=useData(),  col = colores(), notch =  BAR_WIDTH(), xlab=x_axis_label(), ylab="Tooth Length", main= "Tooth Length related to doses and/or supplement type")
      
    } else if (input$chartType == "Horizontal") {
      boxplot(Variables(), data=useData(),  col = colores(), notch =  BAR_WIDTH(), horizontal = TRUE, xlab="Tooth Length" , ylab=x_axis_label(), main= "Tooth Length related to doses and/or supplement type")
    } 
  })
  #
  # Show a summary table of the selected data
  #
  output$view <- renderTable({
    Data <- useData()
    names(Data)<- c("Tooth.Length","Supplement","Dose.Supplied")
    res <- aggregate(Tooth.Length ~ Supplement+Dose.Supplied , data = Data, FUN = "mean")
  })
})
