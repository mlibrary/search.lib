const chooseAffiliation = () => {
  // Check if the website header navigation exists
  const websiteHeader = document.querySelector('m-website-header > nav > ul');
  if (!websiteHeader) {
    return;
  }

  // Check if the choose affiliation button and dialog exist
  const buttonChangeAffiliation = websiteHeader.querySelector('.affiliation__change');
  const dialog = websiteHeader.querySelector('.affiliation__dialog');
  if (!buttonChangeAffiliation || !dialog) {
    return;
  }

  // Check if the dialog has dismiss buttons, or else the dialog cannot be closed
  const buttonDismiss = dialog.querySelectorAll('.affiliation__dialog--dismiss');
  if (!buttonDismiss.length) {
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
