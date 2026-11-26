local url = require("@luauforge/deferred/gzA").Url
local urlBuilder = require("@luauforge/deferred/gzB").UrlBuilder

return function(callback, p2)
	return callback(urlBuilder.new({
		base = url.APIS_URL,
		path = "parental-controls-api/v1/parental-controls/consents",
		query = {
			childUserId = p2,
			consentStatus = "Pending",
			consentType = "LiftRestriction"
		}
	})(), "GET")
end
