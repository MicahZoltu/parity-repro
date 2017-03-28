FROM ethcore/parity:v1.6.5

RUN apt-get update \
	&& apt-get install --yes --no-install-recommends curl \
	&& rm -rf /var/lib/apt/lists/*

RUN /parity/parity daemon /parity/parity.pid --chain dev --no-ui --no-dapps --no-discovery --jsonrpc-apis web3,eth,net,personal,parity,parity_set,traces,rpc,parity_accounts \
	&& while ! curl --silent --show-error -X POST localhost:8545 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"net_version","id": 1}'; do sleep 0.1; done \
	&& set -x \
	&& curl --silent --show-error -X POST localhost:8545 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["",""],"id": 1}' \
	&& curl --silent --show-error -X POST localhost:8545 -H "Content-Type: application/json" --data '{"method":"personal_unlockAccount","params":["0x00a329c0648769a73afac7f9381e08fb43dbea72","",null],"id":1,"jsonrpc":"2.0"}' \
	&& curl --silent --show-error -X POST localhost:8545 -H "Content-Type: application/json" --data '{"id": "bdc713432a-2","jsonrpc": "2.0","method": "eth_sendTransaction","params": [{"data": "0x6100008061000e60003961000e565b6000f3","from": "0x00a329c0648769a73afac7f9381e08fb43dbea72","gas": "0x2fefd8"}]}' \
	&& curl --silent --show-error -X POST localhost:8545 -H "Content-Type: application/json" --data '{"id": "bdc713432a-3","jsonrpc": "2.0","method": "eth_getTransactionReceipt","params": ["0x0d5b766c1c688cf45d5e1515f851999f7b895666842bb5e542261bfdb862a433"]}' \
	&& curl --silent --show-error -X POST localhost:8545 -H "Content-Type: application/json" --data '{"id": "bdc713432a-4","jsonrpc": "2.0","method": "eth_getCode","params": ["0x731a10897d267e19b34503ad902d0a29173ba4b1","latest"]}'

ENTRYPOINT ["/bin/bash"]
