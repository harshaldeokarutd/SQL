SELECT
    CONCAT(a.topping_name, ',', b.topping_name, ',', c.topping_name) AS pizza,
    ROUND(a.cost + b.cost + c.cost, 2) AS total_cost
FROM Toppings a
JOIN Toppings b
    ON a.topping_name < b.topping_name
JOIN Toppings c
    ON b.topping_name < c.topping_name
ORDER BY
    total_cost DESC,
    pizza ASC;