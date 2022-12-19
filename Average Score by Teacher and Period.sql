SELECT ROUND(AVG(percent),2) AS avg_percent,
		teacher,
		period
FROM mdtp
GROUP BY teacher, period
ORDER BY avg_percent;
