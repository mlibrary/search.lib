const chooseAffiliation = () => {
  // Check if the website header navigation exists
  const websiteHeader = document.querySelector('m-website-header > nav > ul');
  if (!websiteHeader) {
    return;
  }

  // Check if the anchor and dialog exist
  const anchorChangeAffiliation = websiteHeader.querySelector('.affiliation__change');
  const dialog = websiteHeader.querySelector('.affiliation__dialog');
  if (!anchorChangeAffiliation || !dialog) {
    return;
  }

  // Check if the dialog has dismiss buttons, or else the dialog cannot be closed
  const buttonDismiss = dialog.querySelectorAll('.affiliation__dialog--dismiss');
  if (!buttonDismiss.length) {
    return;
  }

  // Convert the anchor tag into a button
  const buttonChangeAffiliation = document.createElement('button');
  buttonChangeAffiliation.innerHTML = anchorChangeAffiliation.innerHTML;
  buttonChangeAffiliation.classList = [...anchorChangeAffiliation.classList];
  anchorChangeAffiliation.replaceWith(buttonChangeAffiliation);

  // Event listener to open dialog on button click
  buttonChangeAffiliation.addEventListener('click', () => {
    dialog.showModal();
  });

  // Event listeners to close dialog on each dismiss button click
  buttonDismiss.forEach((dismissButton) => {
    dismissButton.addEventListener('click', () => {
      dialog.close();
    });
  });
};

export default chooseAffiliation;
