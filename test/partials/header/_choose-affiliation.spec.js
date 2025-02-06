import chooseAffiliation from '../../../assets/scripts/partials/header/_choose-affiliation.js';
import { expect } from 'chai';
import { JSDOM } from 'jsdom';

describe('chooseAffiliation', () => {
  const html = `
    <m-website-header>
      <nav>
        <ul>
          <li>
            <a href="/about-library-search?affiliation=flint" class="affiliation__change">
              <span class="affiliation__active">
                <span class="visually-hidden">Current campus affiliation:</span>
                <span>Ann Arbor</span>
              </span>
              <span class="">
                <span class="visually-hidden">Choose campus affiliation:</span>
                <span>Flint</span>
              </span>
            </a>
            <dialog class="container__rounded--no-shadow affiliation__dialog">
              <section class="content">
                <h2>Choose campus affiliation</h2>
                <p>Selecting an affiliation helps us connect you to available online materials licensed for your campus.</p>
                <div class="affiliation__dialog--buttons">
                  <button class="button__primary affiliation__dialog--dismiss">
                    Continue as Ann Arbor
                  </button>
                  or
                  <a href="/about-library-search?affiliation=flint" class="button__ghost">
                    Change to Flint
                  </a>
                </div>
                <p><small>You can still use Library Search if you're not affiliated with either campus.</small></p>
              </section>
              <button class="button__link affiliation__dialog--dismiss">Dismiss</button>
            </dialog>
          </li>
        </ul>
      </nav>
    </m-website-header>
  `;

  let window;
  let document;

  beforeEach(() => {
    const { window: jsdomWindow } = new JSDOM(html, { url: 'http://localhost/' });
    window = jsdomWindow;
    document = window.document;
    global.window = window;
    global.document = document;

    // Mock HTMLDialogElement
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

    // Apply mock methods to dialog elements in the document
    document.querySelectorAll('dialog').forEach((dialog) => {
      dialog.showModal = function () {
        return dialog.setAttribute('open', 'true');
      };
      dialog.close = function () {
        return dialog.removeAttribute('open');
      };
    });
  });

  afterEach(() => {
    document.body.innerHTML = '';
    delete global.window;
    delete global.document;
    delete global.HTMLDialogElement;
  });

  describe('anchor', () => {
    it('replaces the anchor with a button', () => {
      // Check if the initial element is an anchor
      const initialElement = document.querySelector('.affiliation__change');
      expect(initialElement, 'anchor element should exist before modification').to.not.be.null;
      expect(initialElement.tagName, 'initial element should be an anchor tag').to.equal('A');
  
      chooseAffiliation();
  
      // Check if the anchor has been replaced by a button
      const modifiedElement = document.querySelector('.affiliation__change');
      expect(modifiedElement, 'button element should exist after modification').to.not.be.null;
      expect(modifiedElement.tagName, 'modified element should be a button tag').to.equal('BUTTON');
    });
  
    it('adds the same class and content to the button', () => {
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

  describe('dialog', () => {
    let buttonChangeAffiliation;
    let dialog;

    beforeEach(() => {
      // Run the function before each test
      chooseAffiliation();

      // Get the button and dialog elements
      buttonChangeAffiliation = document.querySelector('button.affiliation__change');
      dialog = document.querySelector('.affiliation__dialog');
    });

    it('opens the dialog when the new button is clicked', () => {
      buttonChangeAffiliation.click();
      expect(dialog.hasAttribute('open'), 'dialog element should have an `open` attribute').to.be.true;
    });
  
    it('closes the dialog when any dismiss button is clicked', () => {
      // Get all dismiss buttons
      const dismissButtons = document.querySelectorAll('.affiliation__dialog--dismiss');

      dismissButtons.forEach((dismissButton) => {
        // Show the dialog first
        buttonChangeAffiliation.click();
        expect(dialog.hasAttribute('open'), 'dialog element should have an `open` attribute').to.be.true;

        // Close the dialog
        dismissButton.click();
        expect(dialog.hasAttribute('open'), 'dialog element should not have an `open` attribute').to.be.false;
      });
    });
  });
});
