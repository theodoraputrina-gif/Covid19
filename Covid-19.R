#
# Covid19 Shiny Dashboard. 
# Written by : Bakti Siregar, M.Si
# Department of Business statistics, Matana University (Tangerang)
# Notes: Please don't share this code anywhere (just for my students)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# A. PACKAGES----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(ggplot2)
library(plotly)
library(shiny)                                          # This packages use to create shiny web apps
library(markdown)

# B. PREPARE YOUR DATABASE  ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# covid19 = read.csv('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv')   

Covid19<-read.csv("covid_19.csv")

# C. BUILD YOUR SHINY APP ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# C.1 User Interface (ui) ----
ui<-navbarPage("Dashboard",
               tabPanel("Covid19",titlePanel("Cases"), DT::dataTableOutput("table1"),headerPanel('Download Data'),
               sidebarPanel(
                 selectInput("dataset", "Choose a dataset:", 
                             choices = c("Covid19")),
                 downloadButton('downloadData', 'Download')
               )),
               
               tabPanel("Visualization",plotlyOutput("plot")),
              
               mainPanel(
                 tableOutput('table2')),

               tabPanel("Help", titlePanel("Please contact:"), helpText("TheodoraPutrina Gea ~ Students of 
                Business Statistics, Matana University (Tangerang) at theodoraputrina@gmail.com"),

sidebarLayout(
  sidebarPanel(
    downloadButton("downloadCode", "Download Code", href = "")),
  mainPanel(tableOutput("table"))))
)


# C.2 Server ----
server<-function(input, output, session) {
  output$table1 <- DT::renderDataTable({DT::datatable(Covid19)})
  output$table2 <-renderTable({
    datasetInput()
  })
  
  datasetInput<-reactive({
    switch(input$dataset)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$dataset, '.csv', sep='') },
    content = function(file) {
      write.csv(dataset(), file)})
  
  output$plot <- renderPlotly(
    {ggplotly(ggplot(Covid19, aes(Recovery, Dead, color = Region)) +
                geom_point(aes(size = Positive, frame = Week, ids = Country)) +
                scale_x_log10())%>% 
        animation_opts(1000,easing="elastic",redraw=FALSE)})
  
}

shinyApp(ui, server)      # This is execute your apps






