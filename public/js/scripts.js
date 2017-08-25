// Document is ready
$.ready().then(function() {
  // Check/Uncheck all the repositories
  selectAll = function() {
    $$(".repo-list__item").map(function(element) {
      if (!element.classList.contains("hide")) {
        element.checked = !element.checked;
      }
      return element;
    });
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
  * Filter repositories on the page based on names.
  *
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
       item = element.innerText;
       result = item.match(searchedValue);
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
   // Event registration on the search field
   $$('input[type="text"]')._.events({
     "input change": function(evt) {
       filter();
     }
   });
});
