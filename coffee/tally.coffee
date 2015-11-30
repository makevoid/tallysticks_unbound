form = null
submit_btn = null
spinner = null

access_token_client = 'rq5tojxrve3amn5y1zximbh1payanuu32l6a89oc1g85azkqus81gdqn'
host = "http://52.31.192.26:8080"

transactions_url = (account) ->
  "#{host}/bapi/accounts/#{account}/transactions"

$ ->
  form = $ "form.invoice"
  submit_btn = $ "input[type=submit]"
  spinner = $ "img.spinner"
elem = (field) ->
  $ "input[name='invoice[#{field}]']"

console.log "js loaded"

# $.get "/tally_api/invoice", (data) ->
  # got_data data

got_data = (invoice_data) ->
  invoice = invoice_data
  invoice = { id: "1234", amount: 1000, supplier: "Currys ltd" } # tmp
  for field, value of invoice
    el = elem field
    el.val value

post_transaction = (callback) ->
  account_id = 8253594415636011
  url = transactions_url account_id
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
    "tags": [ "holiday", "savings" ],
    "notes": null,
    "paymentMethod": "FASTER_PAYMENT"
  }

  before_send = (xhr) ->
    xhr.setRequestHeader 'Content-Type', 'application/json'
    xhr.setRequestHeader 'Access-Token', access_token_client
    true

  $.ajax { url: url, type: "POST", data: JSON.stringify(body), beforeSend: before_send }, ->
    console.log "post transaction call"
    callback()

$ ->
  form.on "submit", (evt) ->
    evt.preventDefault()
    spinner.css
      opacity: 1
    post_transaction ->
      console.log "post transaction callback"

_.delay got_data, 1000
