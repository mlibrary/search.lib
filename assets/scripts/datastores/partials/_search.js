const searchForm = document.querySelector('form.search-form');
const searchOption = searchForm.querySelector('.search-form__inputs--select');
const searchTip = searchForm.querySelector('.search-form__tip');
const searchTips = searchTip.querySelectorAll('p');

const handleSearchOptionChange = (value) => {
  searchTips.forEach((tip) => {
    tip.style.display = tip.getAttribute('data-value') === value ? 'initial' : 'none';
  });
};

const displaySearchTip = () => {
  searchTip.style.display = 'flex';
  handleSearchOptionChange(searchOption.value);
  searchOption.addEventListener('change', (event) => {
    handleSearchOptionChange(event.target.value);
  });
};

export default displaySearchTip;
