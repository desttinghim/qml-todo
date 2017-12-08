function addDays(date, days) {
    var ddays = date.getDays();
    ddays += days;
    date.setDays(ddays);
    return date;
}
