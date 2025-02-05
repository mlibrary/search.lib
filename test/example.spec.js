import { JSDOM } from 'jsdom';
import { expect } from 'chai';

function updateTextContent (elementId, text) {
  const element = document.getElementById(elementId);
  if (element) {
    element.textContent = text;
  }
}

describe('updateTextContent', () => {
  let document, dom;

  // Setup JSDOM before each test
  beforeEach(() => {
    dom = new JSDOM(`<!DOCTYPE html><p id="myParagraph">Initial Text</p>`);
    document = dom.window.document;
    global.document = document; // Attach to global scope
  });

  // Cleanup after each test
  afterEach(() => {
    dom.window.close();
    delete global.document; // Cleanup global document
  });

  it('should update the text content of the paragraph', () => {
    updateTextContent('myParagraph', 'Updated Text');
    const paragraph = document.getElementById('myParagraph');
    expect(paragraph.textContent).to.equal('Updated Text');
  });

  it('should not throw an error if the element does not exist', () => {
    expect(() => {
      return updateTextContent('nonExistentId', 'Some Text');
    }).to.not.throw();
  });
});
