var elem, form, got_data, spinner, submit_btn;

form = null;

submit_btn = null;

spinner = null;

$(function() {
  form = $("form.invoice");
  submit_btn = $("input[type=submit]");
  return spinner = $("img.spinner");
});

elem = function(field) {
  return $("input[name='invoice[" + field + "]']");
};

console.log("js loaded");

got_data = function(invoice_data) {
  var el, field, invoice, results, value;
  invoice = invoice_data;
  invoice = {
    id: "1234",
    amount: 1000,
    supplier: "Currys ltd"
  };
  results = [];
  for (field in invoice) {
    value = invoice[field];
    el = elem(field);
    results.push(el.val(value));
  }
  return results;
};

$(function() {
  return form.on("submit", function(evt) {
    evt.preventDefault();
    return spinner.css({
      opacity: 1
    });
  });
});

_.delay(got_data, 1000);
