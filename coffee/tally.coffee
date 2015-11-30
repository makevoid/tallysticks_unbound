form = null
submit_btn = null
spinner = null

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

$ ->
  form.on "submit", (evt) ->
    evt.preventDefault()
    spinner.css
      opacity: 1

_.delay got_data, 1000
