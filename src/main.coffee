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


#attach event listener to search button
document.getElementById("search").onclick = () ->
  search()


## define autoPoller
autoPoll = (timeDelayInSeconds = 600) ->
  console.log "autoPoll1"
  root.setTimeout(autoPoll, timeDelayInSeconds*1000)
  search getSearchQuery()
  console.log "autoPoll2"


getSearchQuery = () ->
  "harry%20potter"

search = () ->
  url = constructURL()
  # Build and append the indexed item filters to the url used for the request
  url += buildFilterURL resultsFilter
  submitRequest(url)

# Construct the request URL
constructURL = (searchQuery = "harry%20potter") ->
  """
  http://svcs.ebay.com/services/search/FindingService/v1
  ?OPERATION-NAME=findItemsByKeywords
  &SERVICE-VERSION=1.0.0
  &SECURITY-APPNAME=Jf8f7d060-1456-4fa9-bfc6-ec5d2e1c822
  &GLOBAL-ID=EBAY-US
  &RESPONSE-DATA-FORMAT=JSON
  &callback=_cb_findItemsByKeywords
  &REST-PAYLOAD
  &keywords=#{searchQuery}
  &paginationInput.entriesPerPage=3
  """
  

# Create a JavaScript array of the item filters you : "nt to use in your request
resultsFilter = [
  name: "MaxPrice"
  value: "25"
  paramName: "Currency"
  paramValue: "U"
  {
  name: "FreeShippingOnly"
  value: "true"
  paramName: ""
  paramValue: ""}
  {
  name: "ListingType"
  value: ["AuctionWithBIN", "FixedPrice", "StoreInventory"]
  paramName: ""
  paramValue: ""}
]


### 
 * Generates an indexed URL snippet from the array of item filters
 * 
 * @param resultsFilter {array}  item filters to apply to the search results
 * 
 * @param urlFilter {string}  string, of indexed filters, to append to search request URL
###
buildFilterURL = (resultsFilter) ->
  urlFilter = ""
  # Iterate through each filter in the array
  for filterItem in resultsFilter
    # Iterate through each parameter in each item filter
    for index in filterItem
      # Check to see if the parameter has a value (some don't)
      if filterItem[index] != ""
        if filterItem[index] instanceof Array
          for value, r in itemFilter[index]
            urlFilter += "&itemfilter\(#{i}\).#{index}\(#{r}\)=#{value}"
        else
          urlFilter += "&itemfilter\(#{i}\).#{index}=#{itemFilter[index]}"
          
  return urlFilter


# Submit the request
submitRequest = (url) ->
  scriptElement = document.createElement 'script' # create script element
  scriptElement.src = url
  document.body.appendChild scriptElement


#finally set up the autoPoller
autoPoll 600
