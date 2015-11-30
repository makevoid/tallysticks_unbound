form = null
submit_btn = null
spinner = null
store =
  invoice: {}

# invoice_id = 1
invoice_id = 8

# demo note: if pc.crashed == true ; relaunch corsproxy

access_token_client = 'ft302w0hmbjhc22fnyg44qhs6lbcv4syt7t16q3vcyg9gmp4kj0d11gb'
host = "http://52.31.192.26:8080"
# host_tally = "http://localhost:3000"
cors_proxy = "localhost:1337/" # dev (or when we will add cors to the platorm)
# cors_proxy = "" # production
host_tally = "http://#{cors_proxy}ec2-54-175-210-222.compute-1.amazonaws.com:3000"

tally_invoice_url = (id) ->
  "#{host_tally}/invoice/#{id}"

transactions_url = (account) ->
  "#{host}/bapi/accounts/#{account}/transactions"


before_send = (xhr) -> # set token TODO rename
  xhr.setRequestHeader 'Content-Type', 'application/json'
  xhr.setRequestHeader 'Access-Token', access_token_client
  true


$ ->
  form = $ "form.invoice"
  submit_btn = $ "input[type=submit]"
  spinner = $ "img.spinner"
elem = (field) ->
  $ "input[name='invoice[#{field}]']"

console.log "js loaded"

get_invoice_data = (invoice_id_new) ->
  inv_id = invoice_id_new || invoice_id
  url = tally_invoice_url inv_id
  $.getJSON url, (data) ->
    # address: "0xb61ae6f73ca3329bc610802dc9b6838480eba158"
    # amount: "1000"
    # recipient: "0x442e11e618d6410acffd9bf6d7f8f2a5ed5dfc75"
    # sender: "0xc89df66e5b0ee70bea9cbe26fc9f960d805b41bb"
    store.invoice = data
    invoice_data =
      id: data.address
      amount: data.amount
      supplier: "#{data.senderName} (#{data.sender})"
    got_data invoice_data

got_data = (invoice_data) ->
  spinner.css
    opacity: 0
  invoice = invoice_data
  # invoice = { id: "1234", amount: 1000, supplier: "Currys ltd" } # tmp
  for field, value of invoice
    el = elem field
    el.val value


post_transaction_tally = (barclays_tx_id, callback) ->
  url = tally_invoice_url invoice_id
  body = store.invoice
  body.paymentReference = barclays_tx_id
  body.paymentMethod = 2
  body.paid = 4 #### PROD!!!
  # body.paid = 1   #### Dev

  success = ->
    console.log "post transaction call"
    callback()

  $.ajax { url: url, type: "POST", data: JSON.stringify(body), beforeSend: before_send, success: success}

data_value = null

process_data_change = ->
  # $(".data").html("test")
  value = $(".data").html()
  if data_value != value
    $(window).trigger "data_change", [value]
    data_value = value

watch_for_data_change = ->
  _.delay ->
    process_data_change()
    watch_for_data_change()
  , 200

#################################
# main

get_invoice_data()

$ ->
  data_value = $(".data").html()
  watch_for_data_change()
  form.on "submit", (evt) ->
    evt.preventDefault()
    spinner.css
      opacity: 1
    # post_transaction_barc ->
    #   console.log "post transaction callback"
    post_transaction_tally ->
      console.log "post transaction callback"

  $("form.load_invoice").on "submit", (evt) ->
    evt.preventDefault()
    spinner.css
      opacity: 1
    get_invoice_data($("input[name='loaded_invoice[id]']").val())

  $(window).on "data_change", (event, value) ->
    console.log "Data changed:", value
    barclays_tx_id = value.split("=")[1]
    console.log "barclays_tx_id:", barclays_tx_id
    post_transaction_tally barclays_tx_id, ->
      console.log "post transaction callback"
      alert "Payment successfully saved on the blockchain!"


# _.delay got_data, 1000
# _.delay got_data, 1000
