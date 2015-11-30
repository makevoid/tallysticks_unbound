var access_token_client, elem, form, got_data, host, post_transaction, spinner, submit_btn, transactions_url;

form = null;

submit_btn = null;

spinner = null;

access_token_client = 'rq5tojxrve3amn5y1zximbh1payanuu32l6a89oc1g85azkqus81gdqn';

host = "http://52.31.192.26:8080";

transactions_url = function(account) {
  return "/bapi/accounts/" + account + "/transactions";
};

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

post_transaction = function(callback) {
  var account_id, before_send, body, url;
  account_id = 8253594415636011;
  url = transactions_url(account_id);
  body = {
    "amount": {
      "direction": "OUT",
      "value": "4.00"
    },
    "created": "20-11-2015 10:10:29",
    "description": "i7 Lenovo at Cyber Monday Discount",
    "paymentDescriptor": {
      "id": "7117552983543782"
    },
    "metadata": [],
    "tags": ["holiday", "savings"],
    "notes": null,
    "paymentMethod": "FASTER_PAYMENT"
  };
  console.log("asd");
  before_send = function(xhr) {
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Access-Token', access_token_client);
    return true;
  };
  return $.ajax({
    url: url,
    type: "POST",
    data: JSON.stringify(body),
    beforeSend: before_send
  }, function() {
    console.log("post transaction call");
    return callback();
  });
};

$(function() {
  return form.on("submit", function(evt) {
    evt.preventDefault();
    spinner.css({
      opacity: 1
    });
    return post_transaction(function() {
      return console.log("post transaction callback");
    });
  });
});

_.delay(got_data, 1000);
