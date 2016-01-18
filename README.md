# Expert Calibration
A simple shiny app to support expert calibration
This app is a simple implementation of the method to calibrate your experts as descirbed in "How to measure anything" 
by Douglas W. Hubbard. This book is highly recommended for any risk manager.

In the first step, the user is asked to judge, whether a given statement is true or false, and his confidence into his judgment. 
In the final calculation, the average of his confidence is calculated and compared with the number of correct judgements. 
We would judge an expert overconfident if his expected confidence is significantly above the number of correct judgements.

In the second steps, the user is asked to give a 90% confidence interval for a numeric value, denoted by a lower and an upper bound.
We would judge an expert overconfident, if this range would not encompass the correct value less than 90% of the cases.

This is an initial commit, so it lacks some useful features, especially:
- User management - results will not be saved, restarting leads to a new draw of questions, but this might include questions 
already answered by this user
- Upload of new questions over the web interface
- Advanced analysis of results
