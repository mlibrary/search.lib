const websiteHeader = document.querySelector('m-website-header > nav > ul');
const linkChangeAffiliation = websiteHeader.querySelector('.affiliation__change');
const buttonChangeAffiliation = document.createElement('button');
buttonChangeAffiliation.innerHTML = linkChangeAffiliation.innerHTML;
buttonChangeAffiliation.className = linkChangeAffiliation.className;
const dialog = websiteHeader.querySelector('.affiliation__dialog');
const buttonDismiss = dialog.querySelectorAll('.affiliation__dialog--dismiss');

const chooseAffiliation = () => {
  linkChangeAffiliation.parentNode.replaceChild(buttonChangeAffiliation, linkChangeAffiliation);
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
