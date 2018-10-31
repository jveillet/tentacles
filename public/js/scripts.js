// Document is ready
$.ready().then(function() {

  /*
   * Check/Uncheck all the repositories
   */
  selectAll = function() {
    var selectAllInput = $('[name="select_all"]');
    $$(".repo-list__item").map(function(element) {
      if (selectAllInput.checked) {
        element.checked = true;
      } else {
        element.checked = false;
      }
      return element;
    });
    updateSelectAllLabel();
  }

  /*
   * Update the select all label with the status
   * of the checkbox (true/false).
   */
  updateSelectAllLabel = function() {
    // Change the label text with the checkbox value
    var labelNode = $(".filter__selectall");
    var selectAllInput = $('[name="select_all"]');
    if(selectAllInput.checked) {
      labelNode.innerText = "Deselect all repositories"
    } else {
      labelNode.innerText = "Select all repositories"
    }
  }

  /*
   * Count the total numbers of repositories.
   *
   * @return [Integer] The number of repositories.
   */
  repositoriesCount = function() {
    return $$(".repo-list__item").length;
  }

  /*
   * Count the numbers of selected repositories.
   *
   * @return [Integer] The number of checked repositories.
   */
  selectedRepositoriesCount = function() {
    var number = 0;
    $$(".repo-list__item").map(function(element) {
      if (element.checked) {
        number++;
      }
    });
    return number;
  }

  /*
   * Check if all the repositories displayed are checked.
   * When they are all checked, also check the "Select All"
   * checkbox and update its label.
   */
  lazyCheckAll = function() {
    var selectAllInput = $('[name="select_all"]');
    if (repositoriesCount() == selectedRepositoriesCount()) {
      selectAllInput.checked = true;
    } else {
      selectAllInput.checked = false;
    }
    updateSelectAllLabel();
  }

  /*
   * Filter repositories on the page based on names.
   * This function hides elements that do not match
   * a search term.
   */
  filter = function() {
    var searchedElement = $(".search");
    var searchedValue = searchedElement.value;
    removeFilter();
    if (isFilterEmpty(searchedValue)) {
      return;
    }
    $$(".js-repo-item").map(function(element) {
      element.classList.add("u-hide");
      var item = element.innerText;
      var result = item.match(searchedValue);
      if (result != null) {
        element.classList.remove("u-hide");
      }
    });
  }

  /*
   * Checks if the search term exists or is empty.
   * @param searchedValue [String] The value from the search field.
   * @return [Boolean] True if the search field is empty.
   */
  isFilterEmpty = function(searchedValue) {
    if (!searchedValue || searchedValue == "") {
      return true;
    }
    return false;
  }

  /*
   * Remove the display filter for repositories.
   */
  removeFilter = function() {
    $$(".js-repo-item").map(function(element) {
      element.classList.remove("u-hide");
    });
  }

  /*
   * Event registration on the search field.
   */
  $$('input[type="text"]')._.events({
    "input change": function(evt) {
      filter();
    }
  });

  /*
   * Event registration on the repositories checkboxes.
   */
  $$(".repo-list__item")._.events({
    "input change checked": function(evt) {
      lazyCheckAll();
    }
  });

  /*
   * Verify if some repository is selected
   * Submit the form to store selection
   * Redirect to destination
   */
  storeSelectionAndRedirect = function(destination) {
    if (checkRepoCheckboxes() == false) {
      displayNoRepoSelectedWarning();
    } else {
      document.forms["repoForm"].action="/repositories/selection?redirect=" + destination;
      document.forms["repoForm"].submit();
    }
  }

  /*
   * Check if at least one checkbox is checked.
   * @return [Boolean] checked.
   */
  checkRepoCheckboxes = function() {
    var checkboxes = document.getElementsByClassName("isRepoCheckBox");
    var checked = false;
    numberOfRepo = repositoriesCount();
    for (cursor = 0; cursor < numberOfRepo; cursor++) {
      if (checkboxes[cursor].checked == true) {
        checked = true;
        break;
      }
    }
    return checked;
  }

  /*
   * Post up an error message if no checkbox is checked.
   */
  displayNoRepoSelectedWarning = function() {
    var uncheckedText = document.getElementById("uncheckedMessage");
    uncheckedText.style.display = "block";
  }


  // Loop over the dates to print a more friendly date like "1 day ago"
  var dates = $$(".pr-details__date").map(function(element) {
    var momentDate = moment(element.innerText).fromNow();
    element.innerHTML = momentDate;
    return element.innerHTML;
  });

  // Check asynchronously the commits statuses and update the UI.
  var statuses = $$(".pr-check").map(function(element) {
    var repo = element.getAttribute('data-repo');
    var sha = element.id;
    statusesUrl = 'http://localhost:4011/statuses?repo='+repo+'&sha='+sha;
    fetch(statusesUrl)
    .then((resp) => resp.json())
    .then(function(response) {
      if(response.state == 'success') {
        element.childNodes[1].classList.toggle("icon-status-success");
        element.childNodes[1].title = "All checks have passed";
        element.childNodes[1].classList.toggle("icon-status-default");
      }
      else if(response.state == 'failure' || response.state == 'error') {
        element.childNodes[1].classList.toggle("icon-status-failure");
        element.childNodes[1].title = "All checks have failed";
        element.childNodes[1].classList.toggle("icon-status-default");
      }
      else if(response.state == 'pending') {
        element.childNodes[1].classList.toggle("icon-status-pending");
        element.childNodes[1].title = "All checks pending..";
        element.childNodes[1].classList.toggle("icon-status-default");
      }
    })
    .catch(function(error) {
      console.log(error);
    });
  });

});
