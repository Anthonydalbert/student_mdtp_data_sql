SELECT id, teacher, percent
FROM mdtp2
WHERE id IN (
			SELECT id
			FROM mdtp2
			WHERE num_att < 23)
	AND percent > 50
ORDER BY percent DESC;
