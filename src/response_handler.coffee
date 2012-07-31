root = exports ? this

# Callback function to parse the response and build an HTML table to display search results
root._cb_findItemsByKeywords = (ebayResults) ->
  items = ebayResults.findItemsByKeywordsResponse[0].searchResult[0].item || []
  html = []
  
  html.push('<table width="100%" border="0" cellspacing="0" cellpadding="3"><tbody>')
  for item in items
    if item.title? and item.viewItemURL?
      html.push('<tr><td>' + '<img src="' + item.galleryURL + '" border="0">' + '</td>' +
      '<td><a href="' + item.viewItemURL + '" target="_blank">' + item.title + '</a></td></tr>')
  
  html.push('</tbody></table>');
  document.getElementById("results").innerHTML = html.join("")
