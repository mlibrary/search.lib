import { existsSync, readdirSync } from 'fs';
import { extname, join } from 'path';
import { expect } from 'chai';

const getJsFilesRecursively = (directory = 'assets/scripts') => {
  let jsFiles = [];
  // Read the directory contents
  const entries = readdirSync(directory, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = join(directory, entry.name);
    if (entry.isDirectory()) {
      // If the entry is a directory, recursively search it
      jsFiles = jsFiles.concat(getJsFilesRecursively(fullPath));
    } else if (entry.isFile() && extname(entry.name) === '.js') {
      // If the entry is a .js file, add it to the list
      jsFiles.push(fullPath);
    }
  }

  return jsFiles;
};

describe('spec files exist', function () {
  it('should have a spec file for every JavaScript file', function () {
    getJsFilesRecursively().forEach((filePath) => {
      const testFile = filePath.replace('assets/', 'test/').replace('.js', '.spec.js');
      expect(existsSync(testFile), `\`${filePath}\` should have a spec file located at: \`${testFile}\``).to.be.true;
    });
  });
});
