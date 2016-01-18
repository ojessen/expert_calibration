
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  output$counter <-
    renderText({
      if (!file.exists("counter.Rdata")) counter <- 0
      if (file.exists("counter.Rdata")) load(file="counter.Rdata")
      counter <- counter <<- counter + 1

      save(counter, file="counter.Rdata")
      paste0("Hits: ", counter)
    })

  # This renderUI function holds the primary actions of the
  # survey area.
  output$MainAction <- renderUI( {
    dynamicUi()
  })

  get_vec_id <- reactive({
    load("vec_id.RData")
    num_questions <- input$num_questions
    if(!exists("vec_id_initialized") | num_questions != length(vec_id)){

      vec_id = sample(binary_questions$ID, num_questions, replace = FALSE)
      save(vec_id,file = "vec_id.RData")
      vec_id_initialized <<- TRUE
    }


    vec_id

  })



  # Dynamic UI is the interface which changes as the survey
  # progresses.
  dynamicUi <- reactive({
    # Initially it shows a welcome message.


    vec_id = get_vec_id()
    cat(paste(input$Click.Counter, vec_id,"\n", sep = ":" ))

    counter = 1:length(vec_id)

    if (input$Click.Counter == 0)
      return(
        list(
          h4("Wellcome to the Expert Calibration Tool!"),
          h5("The methodology is based on How to Measure Anything by ..."),
          textInput("user_name", "Enter your first name")
        )
      )

    # Once the next button has been clicked once we see each question
    # of the survey.
    if (input$Click.Counter == 1){


      return(list(h4("Part 1 - Binary questions!"),
                  h5("For each statement, give your judgment, if the statement is true or false,
                     and give a percentage how confident you are that the judgement is correct."),
                  lapply(counter, function(x){renderBinaryQuestions(vec_id[x],x)}))

      )
    }

    if (input$Click.Counter == 2){


      return(list(h4("Part 2 - Range questions!"),
                  h5("For each questions, give the upper and the lower bound for
                     an estimate which has a 90% confidence."),
                  lapply(counter, function(x){renderRangeQuestions(vec_id[x],x)}))

      )
    }

    if (input$Click.Counter == 3){
      results_binary = data.frame(Question = binary_questions$Questions[vec_id],
                                  user_answer = NA,
                                  user_confidence = NA,
                                  correct_answer = binary_questions$Answer[vec_id])
      for(iter in counter){
        id_answer = paste("binary_answer", iter, sep = "_")
        results_binary$user_answer[iter] = as.logical(input[[id_answer]])
        id_confidence = paste("binary_confidence",iter, sep = "_")
        results_binary$user_confidence[iter] = as.numeric(input[[id_confidence]])
      }

      results_binary$answered_correctly = results_binary$user_answer == results_binary$correct_answer

      expected_confidence = mean(results_binary$user_confidence)
      realized_confidence = mean(results_binary$answered_correctly)
      diff_confidence = expected_confidence - realized_confidence

      results_range = data.frame(id = range_questions$Questions[vec_id],
                                  user_lower = NA,
                                  user_upper = NA,
                                  correct_answer = range_questions$Answer[vec_id])
      for(iter in counter){
        id_lower = paste("range_answer_lower", iter, sep = "_")
        results_range$user_lower[iter] = as.numeric(input[[id_lower]])
        id_upper = paste("range_answer_upper",iter, sep = "_")
        results_range$user_upper[iter] = as.numeric(input[[id_upper]])
      }

      results_range$answered_in_range = results_range$user_lower <= results_range$correct_answer &
        results_range$correct_answer <= results_range$user_upper

      expected_confidence_range = 0.9
      realized_confidence_range = mean(results_range$answered_in_range)
      diff_confidence_range = expected_confidence_range - realized_confidence_range

      return(list(h4("Part 3 - Results"),
                  h5("The methodology is based on How to Measure Anything by ..."),
                  h4("Binary questions"),
                  renderTable(results_binary),
                  h5(paste("Based on your average confidence, you expected to answer",
                           expected_confidence*100,
                           "% correctly. Indeed, you answered",
                           realized_confidence*100,
                           "% correctly.")),
                  if(diff_confidence > 0){
                    h5(paste("You are",
                             diff_confidence*100,
                             "% overconfident."))
                  } else if(diff_confidence < 0 ){
                    h5(paste("You are",
                             - diff_confidence*100,
                             "% underconfident"))
                  } else{
                    h5("You were spot on.")
                  },
                  h4("Range questions"),
                  renderTable(results_range),
                  h5(paste("You were supposed to give answers with ",
                           expected_confidence_range*100,
                           "%. Indeed, your indicated ranges encompassed the correct answer in ",
                           realized_confidence_range*100,
                           "% of the cases.")),
                  if(diff_confidence_range > 0){
                    h5(paste("You are",
                             diff_confidence_range*100,
                             "% overconfident."))
                  } else if(diff_confidence < 0 ){
                    h5(paste("You are",
                             - diff_confidence_range*100,
                             "% underconfident"))
                  } else{
                    h5("You were spot on.")
                  }


      )
      )
    }
    if (input$Click.Counter == 3){
      rm(vec_id_initialized)
      h5("This concludes the test. To take the test again, load refresh.")
    }

  })


})
