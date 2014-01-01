root = exports ? this


#attach event listener to search button
document.getElementById('search').onclick = ->
  search()


## define autoPoller
autoPoll = (timeDelayInSeconds = 600, timeTillNextSearch = 0) ->
  if timeTillNextSearch <= 0
    console.log 'autoPoll searching'
    search()
    timeTillNextSearch = timeDelayInSeconds
  else
    timeTillNextSearch -= 1
    seconds = timeTillNextSearch % 60
    seconds = "#{seconds} seconds"
    mins = Math.floor(timeTillNextSearch / 60)
    mins = if mins then "#{mins} minutes " else ""
    msg = "#{mins}#{seconds}"
    document.getElementById('poll-times').innerHTML = msg
  root.setTimeout(autoPoll, 1000, timeDelayInSeconds, timeTillNextSearch)


search = ->
  query = getSearchQuery()
  url = constructURL(query)
  # Build and append the indexed item filters to the url used for the request
  # url += buildFilterURL resultsFilter
  submitRequest(url)


getSearchQuery = ->
  searchQueryValue = document.getElementById('search-query').value
  console.log "Searching for #{searchQueryValue}"
  return searchQueryValue


# Construct the request URL
constructURL = (searchQuery = "harry%20potter") ->
  ## @TODO do we need to call escaoe or encodeURI on the searchQuery
  """
  http://svcs.ebay.com/services/search/FindingService/v1
  ?OPERATION-NAME=findItemsByKeywords
  &SERVICE-VERSION=1.0.0
  &SECURITY-APPNAME=Jf8f7d060-1456-4fa9-bfc6-ec5d2e1c822
  &GLOBAL-ID=EBAY-GB
  &RESPONSE-DATA-FORMAT=JSON
  &callback=EBayPoller.callback
  &REST-PAYLOAD
  &keywords=#{searchQuery}
  &paginationInput.entriesPerPage=3
  """


# Create a JavaScript array of the item filters you want to use in your request
resultsFilter = [
  {
    name: "MaxPrice"
    value: "25"
    paramName: "Currency"
    paramValue: "U"
  }
  {
    name: "FreeShippingOnly"
    value: "true"
    paramName: ""
    paramValue: ""
  }
  {
    name: "ListingType"
    value: ["AuctionWithBIN", "FixedPrice", "StoreInventory"]
    paramName: ""
    paramValue: ""
  }
]


# Generates an indexed URL snippet from the array of item filters
# @param resultsFilter {array}  item filters to apply to the search results
# @param urlFilter {string}  string, of indexed filters, to append to search request URL
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


# finally set up the autoPoller
autoPoll()
