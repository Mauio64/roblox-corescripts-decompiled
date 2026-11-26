local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

return function(callback)
	return callback(urlBuilder.fromString("auth:v1/session/refresh")(), "POST", {
		postBody = ""
	})
end
