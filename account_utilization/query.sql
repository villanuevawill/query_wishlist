CREATE DATABASE IF NOT EXISTS will_v2;
DROP TABLE IF EXISTS will_v2.contract_accounts;
CREATE TABLE IF NOT EXISTS will_v2.contract_accounts ( address string, year int, month int, ts timestamp, code string, creator string, creation_tx_hash string);
INSERT INTO will_v2.contract_accounts
SELECT toAddr, year, month, ts, code, creator, tx_hash FROM (
  SELECT
    toAddr,
    year,
    month,
    ts,
    output as code,
    fromAddr as creator,
    txHash as tx_hash,
    ROW_NUMBER() OVER(PARTITION BY toAddr ORDER BY ts ASC) as rank
  FROM mainnet_v2.msgs
  WHERE mainType = "create" and isValid = 1
) WHERE rank = 1;

DROP TABLE IF EXISTS will_v2.account_counts;
CREATE TABLE IF NOT EXISTS will_v2.account_counts (cumulative int, alltime int, year int, month int);
INSERT INTO will_v2.account_counts
SELECT MAX(cumulative) as cumulative, MAX(alltime) as alltime, year, month FROM (
  SELECT address, year, month, ROW_NUMBER() OVER(ORDER BY ts ASC) AS cumulative, count(*) OVER() as alltime FROM will_v2.contract_accounts
) GROUP BY year, month ORDER BY year, month DESC;

USE mainnet_v2;
SELECT COUNT(address)/MAX(cumulative)*100 as percent_used, COUNT(address) as accounts_used, MAX(cumulative) as total_accounts, year, month  FROM (
  SELECT a.address, account_counts.cumulative, a.year, a.month FROM (
  (
    SELECT DISTINCT fromAddr as address, year, month FROM msgs
    UNION
    SELECT DISTINCT fromAddr as address, year, month FROM tx
    UNION
    SELECT DISTINCT toAddr as address, year, month FROM tx
    UNION
    SELECT DISTINCT toAddr as address, year, month FROM msgs
   ) as a
  RIGHT JOIN
  (SELECT address FROM will_v2.contract_accounts) as contract_accounts
  ON a.address = contract_accounts.address
  )
  JOIN
  will_v2.account_counts as account_counts
  ON a.year = account_counts.year AND a.month = account_counts.month
) WHERE address is not null GROUP BY year, month ORDER BY year, month asc;
