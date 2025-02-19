const searchForm = 'form.search-form .search-form__';

// Display search tip if `data-value` matches the selected value
const handleSearchOptionChange = (value) => {
  // Toggle visibility of every search tip based on the selected value
  const searchTipSection = document.querySelector(`${searchForm}tip`);
  const searchTips = searchTipSection.querySelectorAll('.search-form__tip--content');
  searchTips.forEach((tip) => {
    tip.style.display = tip.getAttribute('data-value') === value ? 'initial' : 'none';
  });

  // Toggle visibility of the search tip section if it has at least one visible tip
  const tipIsVisible = [...searchTips].some((tip) => {
    return tip.style.display !== 'none';
  });
  searchTipSection.style.display = tipIsVisible ? 'flex' : 'none';
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
