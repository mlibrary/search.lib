const chooseAffiliation = () => {
  // Change the anchor to a button
  const websiteHeader = document.querySelector('m-website-header > nav > ul');
  const linkChangeAffiliation = websiteHeader.querySelector('.affiliation__change');
  const buttonChangeAffiliation = document.createElement('button');
  buttonChangeAffiliation.innerHTML = linkChangeAffiliation.innerHTML;
  buttonChangeAffiliation.className = linkChangeAffiliation.className;
  linkChangeAffiliation.parentNode.replaceChild(buttonChangeAffiliation, linkChangeAffiliation);

  // Add functionality to open and close the dialog
  const dialog = websiteHeader.querySelector('.affiliation__dialog');
  const buttonDismiss = dialog.querySelectorAll('.affiliation__dialog--dismiss');

  buttonChangeAffiliation.addEventListener('click', () => {
    dialog.showModal();
  });

  buttonDismiss.forEach((dismiss) => {
    dismiss.addEventListener('click', () => {
      dialog.close();
    });
  });
};

export default chooseAffiliation;
