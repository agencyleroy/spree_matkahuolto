$(document).ready ->
  alert('a')
  list = $('.matkahuolto-destination-list')
  return unless list.length > 0

  radio = $('input[name="order[shipments_attributes][0][selected_shipping_rate_id]"]')
  shippingMethodId = parseInt(list.data('shipping_method_id'))

  onToggleChecked = ->
    checked = radio.filter(':checked')
    selectShippingMethodId = parseInt(checked.val())

    if shippingMethodId == selectShippingMethodId
      list.removeClass('hidden')
      $('#matkahuolto_selected_destination_id').prop("disabled", false)
      unless $('.matkahuolto-destination.active').length > 0
        $('input[name="commit"]').prop("disabled", true)
    else
      list.addClass('hidden')
      $('input[name="commit"]').prop("disabled", false)
      $('#matkahuolto_selected_destination_id').prop("disabled", true)

  onDestinationClick = ->
    $(@).siblings('li').removeClass('active')
    $(@).addClass("active")
    $('input[name="commit"]').prop("disabled", false)
    destinationId = $(@).data('id')
    $('#matkahuolto_selected_destination_id').val(destinationId)

  # Destination is selected
  $('.matkahuolto-destination').click onDestinationClick
  onToggleChecked()
  radio.change(onToggleChecked)

  activePreset = $('.matkahuolto-destination[data-id="'+$('#matkahuolto_selected_destination_id').val()+'"]')
  activePreset.click() if activePreset.length > 0
