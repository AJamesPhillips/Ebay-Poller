root = exports ? this

#declare the global name space 
root.EBP = {}

# Callback function to parse the response and build an HTML table to display search results
root.EBP._cb_findItemsByKeywords = (ebayResults) ->
  items = ebayResults.findItemsByKeywordsResponse[0].searchResult[0].item || []
  html = []
  itemPresent = false
  
  html.push('<table width="100%" border="0" cellspacing="0" cellpadding="3"><tbody>')
  for item in items
    if item.title? and item.viewItemURL?
      itemPresent = true
      html.push('<tr><td>' + '<img src="' + item.galleryURL + '" border="0">' + '</td>' +
      '<td><a href="' + item.viewItemURL + '" target="_blank">' + item.title + '</a></td></tr>')
  
  html.push('</tbody></table>');
  document.getElementById("results").innerHTML = html.join("")
  
  EBP.updateItemPresenceStatus(itemPresent)
  

root.EBP.updateItemPresenceStatus = (itemPresent) ->
  if itemPresent
    EBP.makeANoise()
    EBP.changeBackGroundColour(true)
  else
    EBP.changeBackGroundColour(false)
  

root.EBP.makeANoise = ->
  audioElement = document.getElementById('beep1'); 
  audioElement.play();


root.EBP.changeBackGroundColour = (success) ->
  
  if success
    cssClass = "itemPresent"
  else
    cssClass = "itemAbsent"
  
  root.document.getElementsByTagName('body')[0].className = cssClass
