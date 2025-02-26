const searchForm = 'form.search-form .search-form__';

// Toggle visibility of every search tip if `data-value` matches the selected value
const handleSearchOptionChange = (value) => {
  const searchTips = document.querySelectorAll(`${searchForm}tip`);
  searchTips.forEach((tip) => {
    tip.style.display = tip.getAttribute('data-value') === value ? 'flex' : 'none';
  });
};

// Display the selected search tip
const displaySearchTip = () => {
  const searchOption = document.querySelector(`${searchForm}inputs--select`);
  // Display the selected tip on load
  handleSearchOptionChange(searchOption.value);
  // Display the selected tip on change
  searchOption.addEventListener('change', (event) => {
    handleSearchOptionChange(event.target.value);
  });
};

export default displaySearchTip;
