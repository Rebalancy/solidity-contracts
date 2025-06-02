# AAVE Rebalancer Contracts


### Cases to consider

- Should we store the information of the investment strategy? i.e we are deploying X to Y Chain, no because we are not always taking funds from here.

- Think if we should enable the address of the agent and the max investment to be editables

## TODO

- hacer test basico
- add config values (usdc address en testnet etc, lending pools, etc)
- hacer un e2e test con forking
- Creo que voy a tener que crear .env.sample
- Tambien tendre que hacer scripts con e2e flows para probar la integracion con cctp
- Pensar si agrego access control o ownable para mas limpieza
