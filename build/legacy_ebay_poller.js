var url = "",
    _cb_findItemsByKeywords,
    scriptElement,
    resultsFilter,
    buildFilterURL;

// Callback function to parse the response and build an HTML table to display search results
_cb_findItemsByKeywords = function (root) {
	var items, item, html;
	items = root.findItemsByKeywordsResponse[0].searchResult[0].item || [];
  html = [];
  
  html.push('<table width="100%" border="0" cellspacing="0" cellpadding="3"><tbody>');
  for (var i = 0; i < items.length; ++i) {
    item = items[i];
    if (item.title !== null && item.title !== undefined && item.viewItemURL !== null && item.viewItemURL !== undefined) {
      html.push('<tr><td>' + '<img src="' + item.galleryURL + '" border="0">' + '</td>' +
      '<td><a href="' + item.viewItemURL + '" target="_blank">' + item.title + '</a></td></tr>');
    }
  }
  html.push('</tbody></table>');
	document.getElementById("results").innerHTML = html.join("");
};


// Construct the request URL
url += "http://svcs.ebay.com/services/search/FindingService/v1";
url += "?OPERATION-NAME=findItemsByKeywords";
url += "&SERVICE-VERSION=1.0.0";
url += "&SECURITY-APPNAME=Jf8f7d060-1456-4fa9-bfc6-ec5d2e1c822";
url += "&GLOBAL-ID=EBAY-US";
url += "&RESPONSE-DATA-FORMAT=JSON";
url += "&callback=_cb_findItemsByKeywords";
url += "&REST-PAYLOAD";
url += "&keywords=harry%20potter";
url += "&paginationInput.entriesPerPage=3";


// Create a JavaScript array of the item filters you want to use in your request
resultsFilter = [
  {"name":"MaxPrice",
   "value":"25",
   "paramName":"Currency",
   "paramValue":"USD"},
  {"name":"FreeShippingOnly",
   "value":"true",
   "paramName":"",
   "paramValue":""},
  {"name":"ListingType",
   "value":["AuctionWithBIN", "FixedPrice", "StoreInventory"],
   "paramName":"",
   "paramValue":""},
];


/* 
 * Generates an indexed URL snippet from the array of item filters
 * 
 * @param resultsFilter {array}  item filters to apply to the search results
 * 
 * @param urlFilter {string}  string, of indexed filters, to append to search request URL
 */
buildFilterURL = function (resultsFilter) {
	var urlFilter = "";
  // Iterate through each filter in the array
  for(var i=0; i<resultsFilter.length; i++) {
    //Index each item filter in resultsFilter
    var itemFilter = resultsFilter[i];
    // Iterate through each parameter in each item filter
    for(var index in itemFilter) {
      // Check to see if the parameter has a value (some don't)
      if (itemFilter[index] !== "") {
        if (itemFilter[index] instanceof Array) {
          for(var r=0; r < itemFilter[index].length; r++) {
	          var value = itemFilter[index][r];
	          urlFilter += "&itemfilter\(" + i + "\)." + index + "\(" + r + "\)=" + value;
          }
        }
        else {
          urlFilter += "&itemfilter\(" + i + "\)." + index + "=" + itemFilter[index];
        }
      }
    }
  }
  
  return urlFilter;
}

// Build and append the indexed item filters to the url used for the request
url += buildFilterURL(resultsFilter);


// Submit the request
scriptElement = document.createElement('script'); // create script element
scriptElement.src = url;
document.body.appendChild(scriptElement);