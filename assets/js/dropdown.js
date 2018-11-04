const verbose = str => debugLevel >= DEBUG_LEVEL.VERBOSE ? console.log(str) : null;
const log = str => debugLevel >= DEBUG_LEVEL.DEFAULT ? console.log(str) : null;

const DEBUG_LEVEL = {
  SILENT: 0,
  DEFAULT: 1,
  VERBOSE: 2
}

const debugLevel = 1;

window.onload = function() {
  initPlugin();
}

const initPlugin = () => {
  verbose("🌀 [Dropdown.js] Binding to DOM...");
  attachListeners();
  log("✅ Dropdown.js configured");
}

const attachListeners = () => {
  const triggerNodes = document.querySelectorAll("*[data-has-dropdown=true]");
  verbose("Found " + triggerNodes.length + " dropdown triggers to configure");
  triggerNodes.forEach(addDropdownOpenListeners);
  const dropdownBodies = document.querySelectorAll(".dropdown-wrapper");
  verbose("Found " + dropdownBodies.length + " dropdown bodies to configure");
  dropdownBodies.forEach(addDropdownCloseListeners);
}

const addDropdownOpenListeners = (elem) => {
  elem.addEventListener('mouseover', openDropdown);
  elem.addEventListener('mouseout', closeDropdown);
}

const addDropdownCloseListeners = (elem) => {
  elem.addEventListener('mouseout', closeDropdown);
}

const openDropdown = (event) => {
  log("⬆️ openDropdown");
  const target = event.currentTarget;
  const dropdown = target.parentElement.querySelector('.dropdown-wrapper');
  addVisibleClass(dropdown);
}

const closeDropdown = (event) => {
  log("⬇️ closeDropdown");
  const target = event.currentTarget;
  const dropdown = target.parentElement.querySelector('.dropdown-wrapper');
  removeVisibleClass(dropdown);
}

const addVisibleClass = (elem) => elem.classList.add("visible");
const removeVisibleClass = (elem) => elem.classList.remove("visible");


// Test code: toggles the dropdown on and off eveery 2 seconds

// let isOpen = false;

// const getNextEvent = () => isOpen ? "mouseout" : "mouseover";

// setInterval(() => {

//   const mouseEvent = new Event(getNextEvent());
//   document.querySelector("*[data-has-dropdown=true]").dispatchEvent(mouseEvent);
//   log(mouseEvent.type);
//   isOpen = !isOpen;
// }, 2000)