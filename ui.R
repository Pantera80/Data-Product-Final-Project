
#
# Developing Data Products Final Project
#
# This is a Shiny UI illustrating its reactivity to user's handling
# The UI consists of a bidebarPanel and a mainPanel
#
#
library(shiny)
#

x_axis_label = "x=axis"

# Define UI 

shinyUI(pageWithSidebar(
  
  
  headerPanel("Relationship between tooth growth and the type of supplement provided"),  # Title
   
  # Sidebar contains some input controls to provide supplement type, doses and combinations of both. 
  # Changes made to the Input controls are updated in the output
  # area immediately as you handle
  sidebarPanel(
    #
    # to choose the supplement
    #
    selectInput("chooseSupp", "Supplement:", choices = c("Both", "Vitamin C", "Orange Juice")),
    #
    # Check boxes to choose the dose level,
    #
    checkboxGroupInput("chooseDose", "Dosage:", c("0.5" = "0.5", "1.0" = "1.0", "2.0" = "2.0"),
                       selected=c("0.5","1.0","2.0"), inline=TRUE),
    #
    # Check boxes to show results as function of doses, supplement or both.
    #
    checkboxGroupInput("check1", "Results By:", c("Dose" = "1", "Supplement" = "2"), selected=c("1","2")),
    #
    # Radio buttons to set boxplot notch
    #
    radioButtons("Boxplotfeat1", "Notch:", list("TRUE" , "FALSE" = "2"), inline = TRUE),
    #
    # Radio buttons to choose boxplot orientation
    #
    radioButtons("chartType", "Orientation:", list("Vertical", "Horizontal"), inline=TRUE),
    #
    #
    p("User manual:"),
    p("Supplement: To choose supplement provided"),
    p("Dose: To chose the dose supplied regardless supplement. WARNING!! At least one of the three options must be selected."),
    p("Results by: Allows to graph the outcome by individual or combined variables"),
    p("Nocth: Indicate is nocth is drawn in each side of the boxes. If the notches of two plots do not overlap, this is a strong evidence that the two medians differ"),
    p("Orientation: Indicate the orientation of the boxes.")
  ),
  
  
   mainPanel(
    
    plotOutput('main_plot'),
    
    tableOutput("view")
  )
))

