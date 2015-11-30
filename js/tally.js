var access_token_client, before_send, cors_proxy, data_value, elem, form, get_invoice_data, got_data, host, host_tally, invoice_id, post_transaction_tally, process_data_change, spinner, store, submit_btn, tally_invoice_url, transactions_url, watch_for_data_change;

form = null;

submit_btn = null;

spinner = null;

store = {
  invoice: {}
};

invoice_id = 8;

access_token_client = 'ft302w0hmbjhc22fnyg44qhs6lbcv4syt7t16q3vcyg9gmp4kj0d11gb';

host = "http://52.31.192.26:8080";

cors_proxy = "localhost:1337/";

host_tally = "http://" + cors_proxy + "ec2-54-175-210-222.compute-1.amazonaws.com:3000";

tally_invoice_url = function(id) {
  return host_tally + "/invoice/" + id;
};

transactions_url = function(account) {
  return host + "/bapi/accounts/" + account + "/transactions";
};

before_send = function(xhr) {
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.setRequestHeader('Access-Token', access_token_client);
  return true;
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

get_invoice_data = function(invoice_id_new) {
  var inv_id, url;
  inv_id = invoice_id_new || invoice_id;
  url = tally_invoice_url(inv_id);
  return $.getJSON(url, function(data) {
    var invoice_data;
    store.invoice = data;
    invoice_data = {
      id: data.address,
      amount: data.amount,
      supplier: data.senderName + " (" + data.sender + ")"
    };
    return got_data(invoice_data);
  });
};

got_data = function(invoice_data) {
  var el, field, invoice, results, value;
  spinner.css({
    opacity: 0
  });
  invoice = invoice_data;
  results = [];
  for (field in invoice) {
    value = invoice[field];
    el = elem(field);
    results.push(el.val(value));
  }
  return results;
};

post_transaction_tally = function(barclays_tx_id, callback) {
  var body, success, url;
  url = tally_invoice_url(invoice_id);
  body = store.invoice;
  body.paymentReference = barclays_tx_id;
  body.paymentMethod = 2;
  body.paid = 4;
  success = function() {
    console.log("post transaction call");
    return callback();
  };
  return $.ajax({
    url: url,
    type: "POST",
    data: JSON.stringify(body),
    beforeSend: before_send,
    success: success
  });
};

data_value = null;

process_data_change = function() {
  var value;
  value = $(".data").html();
  if (data_value !== value) {
    $(window).trigger("data_change", [value]);
    return data_value = value;
  }
};

watch_for_data_change = function() {
  return _.delay(function() {
    process_data_change();
    return watch_for_data_change();
  }, 200);
};

get_invoice_data();

$(function() {
  data_value = $(".data").html();
  watch_for_data_change();
  form.on("submit", function(evt) {
    evt.preventDefault();
    spinner.css({
      opacity: 1
    });
    return post_transaction_tally(function() {
      return console.log("post transaction callback");
    });
  });
  $("form.load_invoice").on("submit", function(evt) {
    evt.preventDefault();
    spinner.css({
      opacity: 1
    });
    return get_invoice_data($("input[name='loaded_invoice[id]']").val());
  });
  return $(window).on("data_change", function(event, value) {
    var barclays_tx_id;
    console.log("Data changed:", value);
    barclays_tx_id = value.split("=")[1];
    console.log("barclays_tx_id:", barclays_tx_id);
    return post_transaction_tally(barclays_tx_id, function() {
      console.log("post transaction callback");
      return alert("Payment successfully saved on the blockchain!");
    });
  });
});
