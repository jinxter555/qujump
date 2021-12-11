WITH RECURSIVE subordinates AS (
	SELECT
		employee_id,
		manager_id,
		full_name
	FROM
		employees
	WHERE
		employee_id = 7
	UNION
		SELECT
			e.employee_id,
			e.manager_id,
			e.full_name
		FROM
			employees e
		INNER JOIN subordinates s ON s.employee_id = e.manager_id
) SELECT
	*
FROM
	subordinates;

WITH RECURSIVE subordinates AS (
	SELECT
		id,
	  parent_id,
		type
	FROM
		entities
	WHERE
		id = 4
	UNION
		SELECT
			e.id,
			e.parent_id,
			e.type
		FROM
			entities e
		INNER JOIN subordinates s ON s.id = e.parent_id
) SELECT
	*
FROM
	subordinates;
