const { UniqueSDK } = require('@unique-nft/sdk');
const { Keyring } = require('@polkadot/api');
const config = require('./config');

const createCollection = async () => {
  const sdk = new UniqueSDK({ baseUrl: config.endpoint });
  const keyring = new Keyring({ type: 'sr25519' });
  const owner = keyring.addFromUri(config.ownerSeed);

  const { collectionId } = await sdk.collection.create({
    name: 'Race and Stake Upgrades',
    description: 'Collection of racing game upgrades as NFTs',
    tokenPrefix: 'RACE',
    owner: owner.address,
  });

  console.log(`Collection created with ID: ${collectionId}`);
};

createCollection().catch(console.error);
