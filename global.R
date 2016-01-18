wb = XLConnect::loadWorkbook("questions.xlsx")
binary_questions = XLConnect::readTable(wb,"Binary_Questions", "binary_questions")
range_questions = XLConnect::readTable(wb,"Range_Questions", "range_questions")

renderBinaryQuestions <- function(ID, counter){
  list(div(binary_questions$Questions[ID]),
    selectInput(paste("binary_answer", counter, sep = "_"),
              "Statement is: ",
              choices = c("",TRUE, FALSE),
              selected = "",
              width = "100%",
              selectize = FALSE),
       selectInput(paste("binary_confidence",counter, sep = "_"),
                   label = "Confidence",
                   choices = seq(0.5,1,by = 0.1))
       )
}

renderRangeQuestions <- function(ID, counter){
  list(div(range_questions$Questions[ID]),
       numericInput(paste("range_answer_lower", counter, sep = "_"),
                   "Lower bound is: ",
                   value = 0),
       numericInput(paste("range_answer_upper", counter, sep = "_"),
                    "Upper bound is: ",
                    value = 0)

  )
}


