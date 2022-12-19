SELECT period, COUNT(period) AS num_students
FROM mdtp
WHERE teacher = 'Albert, Anthony'
GROUP BY period;