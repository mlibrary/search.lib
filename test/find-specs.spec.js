import { existsSync, readdirSync } from 'fs';
import { expect } from 'chai';

const getJavaScriptFiles = (directory = 'assets/scripts') => {
  let jsFiles = [];
  const entries = readdirSync(directory, { withFileTypes: true });

  for (const entry of entries) {
    const { name } = entry;
    const fullPath = [directory, name].join('/');
    if (entry.isDirectory()) {
      // If the entry is a directory, recursively search it
      jsFiles = jsFiles.concat(getJavaScriptFiles(fullPath));
    } else if (entry.isFile() && name !== 'scripts.js') {
      // If the entry is a .js file that's not named `scripts.js`, add it to the list
      jsFiles.push(fullPath);
    }
  }

  return jsFiles;
};

describe('spec files exist', function () {
  it('should have a spec file for every JavaScript file', function () {
    getJavaScriptFiles().forEach((filePath) => {
      const testFile = filePath.replace('assets/', 'test/').replace('.js', '.spec.js');
      expect(existsSync(testFile), `\`${filePath}\` should have a spec file located at: \`${testFile}\``).to.be.true;
    });
  });
});
