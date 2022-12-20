# Analyzing Student Test Data

Analysis of 9th grade student algebra 1 readiness test data

Before doing any work, I built a table in PostgreSQL from .csv data I recieved from the school district.


Fist I started off by removing unnecessary columns such as student name, class name (everyone is in Algebra 1), and code. I also stripped any identifiers of teacher and students by anonymizing student ids and teacher names (not shown for privacy).

'''sql

CREATE TABLE mdtp2 AS
SELECT teacher,period, start_date, sub_date, raw_score, percent, num_att, last_att, daps5, decm6, exps4, fnct5, frac6, geom8,intg4, linr7, id
FROM mdtp;

'''

The new table created is the one you see in this repository.

Next, I performed some simple queries to explore the data a bit further.


1. Visualize the number of students per period, by teacher.

'''sql

SELECT period, COUNT(period) AS num_students
FROM mdtp
WHERE teacher = 'Daniel, Tony'
GROUP BY period;

'''


