.import Qt.labs.calendar 1.0 as Calendar

function addDays(date, days) {
    date.setDate(date.getDate()+days);
    return date;
}

function getMonthName(month) {
   switch(month) {
   case Calendar.January: return "January";
   case Calendar.December: return "December";
   default: return "Unknown";
   }
}
