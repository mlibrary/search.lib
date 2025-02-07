import chooseAffiliation from '../../../assets/scripts/partials/header/_choose-affiliation.js';
import { expect } from 'chai';

describe('chooseAffiliation', function () {
  let getWebsiteHeader = null;
  let getChangeAffiliation = null;
  let getDialog = null;
  let getDismissButtons = null;

  beforeEach(function () {
    // Apply HTML to the body
    document.body.innerHTML = `
      <m-website-header>
        <nav>
          <ul>
            <li>
              <a href="#" class="affiliation__change">
                Change affiliation
              </a>
              <dialog class="affiliation__dialog">
                <button class="affiliation__dialog--dismiss">Dismiss</button>
                <button class="affiliation__dialog--dismiss">Dismiss</button>
              </dialog>
            </li>
          </ul>
        </nav>
      </m-website-header>
    `;

    getWebsiteHeader = () => {
      return document.querySelector('m-website-header > nav > ul');
    };
    getChangeAffiliation = () => {
      return document.querySelector('.affiliation__change');
    };
    getDialog = () => {
      return document.querySelector('.affiliation__dialog');
    };
    getDismissButtons = () => {
      return document.querySelectorAll('.affiliation__dialog--dismiss');
    };
  });

  afterEach(function () {
    getWebsiteHeader = null;
    getChangeAffiliation = null;
    getDialog = null;
    getDismissButtons = null;

    // Remove the HTML of the body
    document.body.innerHTML = '';
  });

  describe('anchor', function () {
    it('should remain unchanged if `websiteHeader` is `null`', function () {
      // Get the unordered list element
      const unorderedList = getWebsiteHeader();
      const unorderedListHTML = unorderedList.innerHTML;

      // Change to an ordered list element
      unorderedList.replaceWith(document.createElement('ol'));
      const orderedList = document.querySelector('m-website-header > nav > ol');
      orderedList.innerHTML = unorderedListHTML;

      // Check if `.affiliation__change` is an anchor
      const initialElement = getChangeAffiliation();
      expect(initialElement, 'anchor element should exist before modification').to.not.be.null;
      expect(initialElement.tagName, 'initial element should be an anchor tag').to.equal('A');

      chooseAffiliation();

      // Check if `.affiliation__change` is still an anchor
      const modifiedElement = getChangeAffiliation();
      expect(modifiedElement, 'anchor element should still exist after modification').to.not.be.null;
      expect(modifiedElement.tagName, 'modified element should still be an anchor tag').to.equal('A');
    });

    it('should remain unchanged if `dialog` element does not exist', function () {
      expect(getDialog(), 'dialog should exist before modification').to.not.be.null;

      // Remove the dialog class, and retrieve again
      getDialog().classList.remove('affiliation__dialog');
      expect(getDialog(), 'dialog should no longer be found').to.be.null;

      // Check if `.affiliation__change` is an anchor
      const initialElement = getChangeAffiliation();
      expect(initialElement, 'anchor element should exist before modification').to.not.be.null;
      expect(initialElement.tagName, 'initial element should be an anchor tag').to.equal('A');

      chooseAffiliation();

      // Check if `.affiliation__change` is still an anchor
      const modifiedElement = getChangeAffiliation();
      expect(modifiedElement, 'anchor element should still exist after modification').to.not.be.null;
      expect(modifiedElement.tagName, 'modified element should still be an anchor tag').to.equal('A');
    });

    it('should remain unchanged if a dismiss button does not exist', function () {
      expect(getDismissButtons(), 'at least one dismiss button should exist in order to close the dialog element').to.not.be.empty;

      // Remove the dismiss class, and retrieve again
      getDismissButtons().forEach((dismissButton) => {
        dismissButton.classList.remove('affiliation__dialog--dismiss');
      });
      expect(getDismissButtons(), 'no dismiss buttons should be found').to.be.empty;

      // Check if `.affiliation__change` is an anchor
      const initialElement = getChangeAffiliation();
      expect(initialElement, 'anchor element should exist before modification').to.not.be.null;
      expect(initialElement.tagName, 'initial element should be an anchor tag').to.equal('A');

      chooseAffiliation();

      // Check if `.affiliation__change` is still an anchor
      const modifiedElement = getChangeAffiliation();
      expect(modifiedElement, 'anchor element should still exist after modification').to.not.be.null;
      expect(modifiedElement.tagName, 'modified element should still be an anchor tag').to.equal('A');
    });

    it('should replace the anchor with a button', function () {
      // Check if the initial element is an anchor
      const initialElement = getChangeAffiliation();
      expect(initialElement, 'anchor element should exist before modification').to.not.be.null;
      expect(initialElement.tagName, 'initial element should be an anchor tag').to.equal('A');

      chooseAffiliation();

      // Check if the anchor has been replaced by a button
      const modifiedElement = getChangeAffiliation();
      expect(modifiedElement, 'button element should exist after modification').to.not.be.null;
      expect(modifiedElement.tagName, 'modified element should be a button tag').to.equal('BUTTON');
    });

    it('should add the same class and content to the button', function () {
      // Get the classList and innerHTML of the initial anchor element
      const initialElement = document.querySelector('a.affiliation__change');
      const initialClassList = [...initialElement.classList];
      const initialInnerHTML = initialElement.innerHTML;

      chooseAffiliation();

      // Get the classList and innerHTML of the modified button element
      const modifiedElement = document.querySelector('button.affiliation__change');
      const modifiedClassList = [...modifiedElement.classList];
      const modifiedInnerHTML = initialElement.innerHTML;

      expect(modifiedClassList, 'button element classList should match the anchor element classList').to.deep.equal(initialClassList);
      expect(modifiedInnerHTML, 'button element innerHTML should match the anchor element innerHTML').to.equal(initialInnerHTML);
    });
  });

  describe('dialog', function () {
    beforeEach(function () {
      // Mock HTMLDialogElement as it does not exist in JSDOM
      global.HTMLDialogElement = class {
        constructor () {
          this.open = false;
        }

        showModal () {
          this.open = true;
        }

        close () {
          this.open = false;
        }
      };

      // Apply mock methods to the dialog element in the DOM
      document.querySelectorAll('dialog').forEach((dialogElement) => {
        dialogElement.showModal = function () {
          return dialogElement.setAttribute('open', 'true');
        };
        dialogElement.close = function () {
          return dialogElement.removeAttribute('open');
        };
      });

      // Run the function before each test
      chooseAffiliation();
    });

    afterEach(function () {
      // Delete global variables
      delete global.HTMLDialogElement;
    });

    it('should open the dialog when the new button is clicked', function () {
      getChangeAffiliation().click();
      expect(getDialog().hasAttribute('open'), 'dialog element should have an `open` attribute').to.be.true;
    });

    it('should close the dialog when any dismiss button is clicked', function () {
      expect(getDismissButtons(), 'at least one dismiss button should exist in order to close the dialog element').to.not.be.empty;

      getDismissButtons().forEach((dismissButton) => {
        // Show the dialog first
        getChangeAffiliation().click();
        expect(getDialog().hasAttribute('open'), 'dialog element should have an `open` attribute').to.be.true;

        // Close the dialog
        dismissButton.click();
        expect(getDialog().hasAttribute('open'), 'dialog element should not have an `open` attribute').to.be.false;
      });
    });
  });
});
