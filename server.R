
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)   #for server
library(MASS)    #for mvrnorm
library(ggplot2) #for the plot
library(stringr) #for text manipulation

shinyServer(function(input, output) {
  
  #The reactive data
  reac_data = reactive({
    #update on button click
    input$update
    
    isolate({
      set.seed(1)
      d = as.data.frame(mvrnorm(n, mu = c(0, 0), Sigma = matrix(c(1, input$cor, input$cor, 1), ncol = 2), empirical = T))
      colnames(d) = c("A", "B")
      
      #dichotomize A
      if (input$cut_A) {
        above = d$A > qnorm(input$cutoff_A)
        d[above, "A"] = 1
        d[!above, "A"] = 0
      }
      
      
      #dichotomize B
      if (input$cut_B) {
        above = d$B > qnorm(input$cutoff_B)
        d[above, "B"] = 1
        d[!above, "B"] = 0
      }
      
      return(d)
    })
    
  })

  output$plot <- renderPlot({
    #get data
    d = reac_data()
    
    #get correlation
    r = cor(d)[1, 2]
    
    #update on button click
    input$update
    
    isolate({
      #plot
      if (input$cut_A & input$cut_B) {
        #frequency table
        t = prop.table(table(d$A, d$B))
        #text as percent
        t_0_0 = percent(t[1, 1], 3)
        t_1_0 = percent(t[2, 1], 3)
        t_0_1 = percent(t[1, 2], 3)
        t_1_1 = percent(t[2, 2], 3)
        
        #correlation
        r = round(cor(reac_data())[1, 2], 3)
        t_r = str_c("Correlation in sample is: ", r)
        
        #plot
        ggplot(d, aes(A, B)) +
          geom_jitter(alpha = .3) +
          geom_smooth(method = lm, se = F, color = "green") +
          annotate("text", x = 0, y = 0, label = t_0_0, color = "red", size = 15) +
          annotate("text", x = 1, y = 0, label = t_1_0, color = "red", size = 15) +
          annotate("text", x = 0, y = 1, label = t_0_1, color = "red", size = 15) +
          annotate("text", x = 1, y = 1, label = t_1_1, color = "red", size = 15) +
          annotate("text", x = .5, y = .5, label = t_r, color = "orange", size = 10) +
          xlab("Variable A") + ylab("Variable B") +
          theme_bw()
      } 
      else {
        #correlation
        r = round(cor(reac_data())[1, 2], 3)
        t_r = str_c("Correlation in sample is: ", r)
        x_pos = (min(d$A) + max(d$A))/2
        y_pos = (min(d$B) + max(d$B))/2
        
        #plot
        ggplot(d, aes(A, B)) +
          geom_point(alpha = .5) +
          geom_smooth(method = lm, se = F, color = "green") +
          xlab("Variable A") + ylab("Variable B") +
          annotate("text",
                   x = -Inf,
                   y = Inf,
                   hjust = 0,
                   vjust = 1,
                   label = t_r,
                   color = "darkorange",
                   size = 10) +
          theme_bw()
      }
    })
    
    
  })

})
