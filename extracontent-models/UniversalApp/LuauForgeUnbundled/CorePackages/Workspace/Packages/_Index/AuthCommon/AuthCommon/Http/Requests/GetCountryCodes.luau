local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder.new({
	base = url.APIS_URL,
	path = "phone-number-api/v1/phone-prefix-list"
})

return function(callback)
	return callback(urlBuilder(), "GET")
end
