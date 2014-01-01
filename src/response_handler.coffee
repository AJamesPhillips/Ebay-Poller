root = exports ? this

#declare the global name space
root.EBayPoller = {}

# Callback function to parse the response and build an HTML table to display search results
root.EBayPoller.callback = (ebayResults) ->
  items = ebayResults.findItemsByKeywordsResponse[0].searchResult[0].item || []
  html = []
  itemPresent = false

  datetime = (new Date()).toUTCString()
  html.push("Results for \"#{window.query}\" retrieved on #{datetime}")
  html.push('<table width="100%" border="0" cellspacing="0" cellpadding="3"><tbody>')
  for item in items
    if item.title? and item.viewItemURL?
      itemPresent = true
      html.push('<tr><td>' + '<img src="' + item.galleryURL + '" border="0">' + '</td>' +
      '<td><a href="' + item.viewItemURL + '" target="_blank">' + item.title + '</a></td></tr>')

  html.push('</tbody></table><hr>');
  resultEl = document.getElementById('results')
  resultEl.innerHTML = html.join('') + resultEl.innerHTML

  EBayPoller.updateItemPresenceStatus(itemPresent)


root.EBayPoller.updateItemPresenceStatus = (itemPresent) ->
  if itemPresent
    EBayPoller.makeANoise()
    EBayPoller.changeBackGroundColour(true)
  else
    EBayPoller.changeBackGroundColour(false)


root.EBayPoller.makeANoise = ->
  audioElement = document.getElementById('noise');
  audioElement.play();


root.EBayPoller.changeBackGroundColour = (success) ->
  if success
    cssClass = "itemPresent"
  else
    cssClass = "itemAbsent"
  root.document.getElementsByTagName('body')[0].className = cssClass
