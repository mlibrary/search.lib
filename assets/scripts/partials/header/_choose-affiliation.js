const chooseAffiliation = () => {
  // Check if the change affiliation form exists
  const chooseAffiliationForm = document.getElementById('affiliation__form');
  if (!chooseAffiliationForm) {
    return;
  }

  // Check if the choose affiliation button and dialog exist, or else the button cannot open the dialog
  const buttonChangeAffiliation = chooseAffiliationForm.querySelector('.affiliation__change');
  const dialog = chooseAffiliationForm.querySelector('.affiliation__dialog');
  if (!buttonChangeAffiliation || !dialog) {
    return;
  }

  // Check if the dialog has dismiss buttons, or else the dialog cannot be closed
  const buttonDismiss = dialog.querySelectorAll('.affiliation__dialog--dismiss');
  if (!buttonDismiss.length) {
    return;
  }

  // Check if the dialog has a submit button, or else the action cannot be posted
  const buttonSubmit = dialog.querySelector('button[type="submit"]');
  if (!buttonSubmit) {
    return;
  }

  // Event listener to open dialog on button click
  buttonChangeAffiliation.addEventListener('click', (event) => {
    event.preventDefault();
    dialog.showModal();
  });

  // Event listeners to close dialog on each dismiss button click
  buttonDismiss.forEach((dismissButton) => {
    dismissButton.addEventListener('click', (event) => {
      event.preventDefault();
      dialog.close();
    });
  });
};

export default chooseAffiliation;
