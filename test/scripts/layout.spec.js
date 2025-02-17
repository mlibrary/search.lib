import { expect } from 'chai';
import removeBodyClasses from '../../assets/scripts/layout.js';

describe('removeBodyClasses', function () {
  beforeEach(function () {
    // Add a class to the body
    document.body.classList.add('test');
  });

  it('should remove all classes from the `body` element', function () {
    // Check if `body` has classes before load
    expect(document.body.classList, '`body` should have classes before load').to.not.be.empty;

    removeBodyClasses();

    // Check if `body` no longer has classes after load
    expect(document.body.hasAttribute('class'), '`body` should have no classes after load').to.be.false;
  });
});
