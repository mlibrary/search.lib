import { expect } from 'chai';
import fs from 'fs';

const deepSearch = (path) => {
  fs.readdirSync(path).forEach((listing) => {
    const listingPath = `${path}/${listing}`;
    // Keep searching until the current listing is not a directory
    if (!listing.includes('.')) {
      deepSearch(listingPath);
    }
    // Check if current listing is a JavaScript file
    if (listing.endsWith('.js')) {
      // Convert current listing path into matching spec path
      let specPath = path.split('/');
      specPath[0] = 'test';
      specPath = `${specPath.join('/')}/${listing.slice(0, -3)}.spec.js`;
      // Return test to see if the spec exists
      it(`'${listingPath}' has a spec file ('${specPath}')`, function () {
        expect(fs.existsSync(`${specPath}`)).to.be.true;
      });
    }
  });
};

describe('checks if component files have associated specs', function () {
  deepSearch('assets/scripts');
});
