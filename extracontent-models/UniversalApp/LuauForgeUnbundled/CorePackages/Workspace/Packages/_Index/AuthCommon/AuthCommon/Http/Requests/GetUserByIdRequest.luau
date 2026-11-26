local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

return function(callback, p2)
	return callback(urlBuilder.new({ base = url.USERS_URL, path = `users/{p2}` })(), "GET")
end
