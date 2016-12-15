
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Dichotomization and cut-off values"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("cor",
                  "Correlation between underlying traits",
                  min = .01,
                  max = .99,
                  value = .50),
      checkboxInput("cut_A", "Dichotomize A?", T),
      sliderInput("cutoff_A",
                  "The cut-off centile for variable A",
                  min = .01,
                  max = .99,
                  value = .90),
      checkboxInput("cut_B", "Dichotomize B?"),
      sliderInput("cutoff_B",
                  "The cut-off centile for variable B",
                  min = .01,
                  max = .99,
                  value = .90),
      actionButton("update", "Update!")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      HTML("<p>Dichotomization is when we measure or classify something using only two values. Usually this is because we have to make a decision (yes or no) regarding something; for instance, whether to treat someone for a medical or mental problem or not. Other times it is because people are using a theory which claims that entities can be divided into two (or more) clear-cut groups. Theories like that are said to be <em>typological</em> (e.g. <a href='https://en.wikipedia.org/wiki/Myers%E2%80%93Briggs_Type_Indicator'>Myers Briggs</a>). The alternative to this is where traits have values along a continuum and these are called <em>trait</em> theories. Generally, typological theories about human psychology are inconsistent with what we know from behavior genetics and should be discarded.</p>",
           "<p>If we measure a continuous trait using only two values, then we are losing precision. If we then correlate the obtained data with some other variable, the resulting correlation will be lower than it would have been had we used a continuous measurement. The issue is further complicated by the fact that we can vary at which centile we set the cut-off point between the two values. Lack of understanding of this phenomenon leads to confusion and underestimization of the strength of relationships between traits that are routinely measured as dichotomous values, such as mental illnesses.</p>",
           "<p>Below we see a scatter plot of two variables. You can use the settings to the left to make one or both of the variables dichotomous. You can also decide at which cut-off centile the data are to be dichotomized. When you have made some changes and want to see the effect, click the 'Update!' button below.</p>"),
      plotOutput("plot", width = "600px"),
      hr(),
      HTML("Made by <a href='http://emilkirkegaard.dk'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'/>Shiny</a> for <a href='http://en.wikipedia.org/wiki/R_%28programming_language%29'>R</a>. Source code available on <a href='https://github.com/Deleetdk/dichotomization_cutoff'>Github</a>.")
    )
  )
))
