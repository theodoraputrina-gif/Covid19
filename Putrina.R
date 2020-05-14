#
# Covid19 Shiny Dashboard. 
# Written by : Theodora Putrina Gea
# Department of Business statistics, Matana University (Tangerang)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# A. PACKAGES----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(ggplot2)
library(plotly)
library(shiny)                                          # This packages use to create shiny web apps
library(markdown)

# B. PREPARE YOUR DATABASE  ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Covid19 <- read.csv("covid_19.csv")
# Actual Data Source
# covid19 = read.csv('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv')
# Write.csv2(covid19,'covid_data1.csv')

# # This must be run first
# Covid19 <- read.csv("covid_19.csv")
# 
# Covid19 <- select(Covid19, 
#                 Country=location, 
#                 Region=region, 
#                 Week=week, 
#                 Confirmed=total_cases, 
#                 Death=total_deaths)

# C. BUILD YOUR SHINY APP ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# C.1 User Interface (ui) ----
ui<-navbarPage("Dashboard",
               tabPanel("Covid19",titlePanel("Cases"), 
                        sidebarLayout(
                          sidebarPanel(DT::dataTableOutput("table1"),
                                       downloadButton("downloadData", "Download Data", href = "")),
                          mainPanel(tableOutput("table1`")))),
               
               tabPanel("Visualization",plotlyOutput("plot")),
               
               tabPanel("Help",
                        titlePanel("Please contact:"), 
                        helpText("Jerrel Audric Theos, Matana University to contact 
                                                       jerrel.audric@matanauniversity.ac.id"),
                        sidebarLayout(
                          sidebarPanel(
                            downloadButton("downloadCode", "Download Code", href = "")),
                          mainPanel(tableOutput("table"))))
)

# C.2 Server ----
server<-function(input, output, session) {
  output$table1 <- DT::renderDataTable({DT::datatable(covid)})
  
  output$plot <- renderPlotly(
    {ggplotly(ggplot(covid, aes(Confirmed, Death, color = Region)) +
                geom_point(aes(size = Death, frame = Week, ids = Country)) +
                scale_x_log10())%>% 
        animation_opts(1000,easing="elastic",redraw=FALSE)})
}

shinyApp(ui, server)      # This is execute your apps






