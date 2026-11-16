local parent = script:FindFirstAncestor("AuthCommon").Parent
local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = Url.APIS_URL,
	path = "phone-number-api/v1/phone-prefix-list"
})

return function(callback)
	return callback(urlBuilder(), "GET")
end
