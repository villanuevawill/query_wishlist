SELECT
  COUNT(*) as connections,
  fromAddr,
  toAddr,
  year,
  month
FROM msgs
WHERE (mainType = "call" OR mainType = "create") AND isValid = 1
GROUP BY
  fromAddr, toAddr, year, month
ORDER BY year, month ASC, connections DESC;
