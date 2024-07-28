const fs = require('fs');
const path = require('path');
const config = require('./config');

const generateNFTProperties = () => {
  const nftProperties = [];
  for (let i = 0; i < config.requiredCount; i++) {
    nftProperties.push({
      name: `Upgrade #${i + 1}`,
      description: `This is upgrade #${i + 1}`,
      attributes: {
        speed: Math.floor(Math.random() * 10) + 1,
        handling: Math.floor(Math.random() * 10) + 1,
        boost: Math.floor(Math.random() * 10) + 1,
      },
    });
  }
  fs.writeFileSync(path.join(__dirname, 'generated-nfts', 'nfts.json'), JSON.stringify(nftProperties, null, 2));
};

generateNFTProperties();
