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
