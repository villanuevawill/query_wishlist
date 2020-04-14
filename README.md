# query_wishlist
All queries take ~30 seconds to 2 minutes to run and are fully available to join/adjust with other data. As a longterm wishlist, we may begin expanding this capability for opcode/storage specific data as well.


- Accounts directed graph to measure partitioning effectiveness.
  - Contains amount of connections/edges between accounts, grouped by month
  - Query - https://github.com/villanuevawill/query_wishlist/blob/master/directed_graph/query.sql
  - CSV - https://github.com/villanuevawill/query_wishlist/tree/master/directed_graph
- Breakdown of SSTORE into create slot, modify slot, clear slot to see the effectiveness of the refund mechanism
  - Need to expand data to have opcode level detail. Adding this capability is possible and once completed will let us write historical queries easily around this level of detail. Will need to sync a geth node and add additional logs that upload to s3 and ingest into the hive framework
- Total number of leaves in account trie + total number of storage slots of every contract. This would tell us how big a single uniform trie would be. If we have historical, we can also extrapolate future trie depth & witness size.
  - TODO: historical total # of leaves in account trie is currently possible, storage slots will require logging/uploading from a syncing node
- Estimate state utilization. E.g. what percentage of accounts don't have incoming/outgoing txes. Same for storage of big contracts. I.e. how much of state can we evict and get away with it?
  - Contains state utilization for contract accounts. TODO: get utilization for contract + EOA accounts
  - Query - https://github.com/villanuevawill/query_wishlist/blob/master/account_utilization/query.sql
  - CSV - https://github.com/villanuevawill/query_wishlist/blob/master/account_utilization/utilization_stats.csv.tar.gz
  - To get storage of contracts and their utilization, we will need to upload this data from a syncing node and add additional logging
- Block and transaction statistics. Answer the question: what do average blocks and average transactions look like? Historgrams of numbers of inserted/read/written/deleted accounts per block, inserted/read/written/deleted storage locations per block, number of accounts/slots read/written by each contract call. Anything else relevant to witness statistics. Exclude DoS attack pathologies.
  - TODO: currently possible to get inserted, read/write, deleted. Need to upload further data via a syncing node to get granularity between read vs. write
  - Need to upload data, add logging etc. and sync a node to get storage level granularity/data
- Storage items used closely in transactions to DeXes, DAI, Gnosis-Safe. (This is to figure out if variable length storage is useful.)
  - Unsure what this means
- Selfdestructed code: record creation time, destruction time, code size, tx hash and creator address.
  - Contains all the data requested
  - Query - https://github.com/villanuevawill/query_wishlist/blob/master/suicide_stats/query.sql
  - CSV - https://github.com/villanuevawill/query_wishlist/blob/master/suicide_stats/destruct_stats.csv.tar.gz
- Download all contract code (currently) and all which ever existed.
  - All in bytecode format
  - Query - https://github.com/villanuevawill/query_wishlist/blob/master/contract_accounts/query.sql
  - CSV - https://github.com/villanuevawill/query_wishlist/tree/master/contract_accounts
