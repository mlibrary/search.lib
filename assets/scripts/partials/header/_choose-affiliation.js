const chooseAffiliation = () => {
  const chooseAffiliationForm = document.getElementById('affiliation__form');
  const buttonChangeAffiliation = chooseAffiliationForm.querySelector('.affiliation__change');
  const dialog = chooseAffiliationForm.querySelector('.affiliation__dialog');

  // Check if the dialog has a submit button, or else the action cannot be posted
  const buttonSubmit = dialog.querySelector('button[type="submit"]');
  if (!buttonSubmit) {
    return;
  }

  // Check if the dialog has dismiss buttons, or else the dialog cannot be closed
  const dismissButtons = dialog.querySelectorAll('.affiliation__dialog--dismiss');
  if (!dismissButtons.length) {
    return;
  }

  // Event listener to open dialog on button click
  buttonChangeAffiliation.addEventListener('click', (event) => {
    event.preventDefault();
    dialog.showModal();
  });

  // Event listeners to close dialog on each dismiss button click
  dismissButtons.forEach((dismissButton) => {
    dismissButton.addEventListener('click', (event) => {
      event.preventDefault();
      dialog.close();
    });
  });
};

export default chooseAffiliation;
