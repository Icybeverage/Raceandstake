const { UniqueSDK } = require('@unique-nft/sdk');
const { Keyring } = require('@polkadot/api');
const config = require('./config');
const nftProperties = require('./generated-nfts/nfts.json');

const mintNFTs = async (collectionId) => {
  const sdk = new UniqueSDK({ baseUrl: config.endpoint });
  const keyring = new Keyring({ type: 'sr25519' });
  const owner = keyring.addFromUri(config.ownerSeed);

  for (const nft of nftProperties) {
    await sdk.token.create({
      collectionId,
      owner: owner.address,
      name: nft.name,
      description: nft.description,
      attributes: nft.attributes,
    });
  }

  console.log('NFTs minted successfully');
};

const collectionId = 'YOUR_COLLECTION_ID'; // Replace with your collection ID
mintNFTs(collectionId).catch(console.error);
