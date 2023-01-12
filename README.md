# Analyzing Student Test Data

Analysis of 9th grade student Algebra 1 Readiness test data.

Before doing any EDA, I built a table in PostgreSQL from .csv data I recieved from the school district.

I also built a second table in the database that represents the teacher's schedules.

```sql

CREATE TABLE teachers (
		teacher VARCHAR,
		period INTEGER,
		subject VARCHAR);
		
INSERT INTO teachers (teacher,period,subject)
VALUES  ('Daniel, Tony', 3, 'Algebra 1'),
		('Daniel, Tony', 5, 'Algebra 1 C'),
		('Thomas, Alice', 2, 'Algebra 1'),
		('Thomas, Alice', 3, 'Algebra 1'),
		('Thomas, Alice', 4, 'Algebra 1'),
		('Thomas, Alice', 5, 'Algebra 1 C'),
		('Thomas, Alice', 6, 'Algebra 1 C'),
		('Sans, Rosie', 1, 'Algebra 1'),
		('Sans, Rosie', 2, 'Algebra 1'),
		('Sans, Rosie', 3, 'Algebra 1'),
		('Sans, Rosie', 5, 'Algebra 1'),
		('Sans, Rosie', 6, 'Algebra 1'),
		('Jonas, Beau', 3, 'Algebra 1 C'),
		('Jonas, Beau', 4, 'Algebra 1 C'),
		('Jillian, Richie', 5, 'Algebra 1'),
		('Jillian, Richie', 6, 'Algebra 1'),
		('Gray, Stephanie', 1, 'Algebra 1'),
		('Gray, Stephanie', 2, 'Algebra 1');
		
```


Initially, I started off by removing unnecessary columns such as student name, class name (everyone is in Algebra 1), and code. I also stripped any identifiers of teachers and students by anonymizing student ids and teacher names (this step is not shown for privacy).

```sql

CREATE TABLE mdtp2 AS
SELECT teacher,period, start_date, sub_date, raw_score, percent, num_att, last_att, daps5, decm6, exps4, fnct5, frac6, geom8,intg4, linr7, id
FROM mdtp;

```

The new table created is the one you see in this repository.

Next, I performed some simple queries to explore the data a bit further.


1. Visualize the number of students per period, by teacher. Note: this was done for each teacher individually and all teachers as whole department, but only a one teacher snippet is shown.

```sql

SELECT teacher, period, COUNT(period) AS num_students
FROM mdtp2
WHERE teacher = 'Daniel, Tony'
GROUP BY teacher, period;

```

![image](https://user-images.githubusercontent.com/94575481/208777193-52a74f97-0c3a-4b72-bc71-242042234f8a.png)


2. Calculate the average score of all students in a period, sorted by teacher.

```sql

SELECT ROUND(AVG(percent),2) AS avg_percent,
		teacher,
		period
FROM mdtp
GROUP BY teacher, period
ORDER BY avg_percent;

```
![image](https://user-images.githubusercontent.com/94575481/208776188-496d6353-a1be-4c1d-ae2f-8038fea877d3.png)

3. Look at students who completed less than half of the questions on the exam, but still scored over a 50%.

```sql

SELECT id, teacher, percent
FROM mdtp2
WHERE id IN (
			SELECT id
			FROM mdtp2
			WHERE num_att < 23)
	AND percent > 50
ORDER BY percent DESC;

```

![image](https://user-images.githubusercontent.com/94575481/208775549-2e0cf9a9-af40-41f0-b88f-642e76785d10.png)

4. Have a look at only the classes that are listed in the master schedule as cotaught. In order to do so, I had to first merge the test results data table with the teacher table, as you can see below.

```sql

SELECT m.teacher, ROUND(AVG(percent),2) AS avg_score, t.period
FROM mdtp2 AS m
LEFT JOIN teachers AS t
ON m.teacher = t.teacher
	AND m.period = t.period
WHERE subject = 'Algebra 1 C'
GROUP BY m.teacher, t.period
ORDER BY avg_score;

```
![Screenshot 2023-01-11 205605](https://user-images.githubusercontent.com/94575481/211980360-b3e175f0-dc65-4551-8e9b-0d109881c7a5.png)


