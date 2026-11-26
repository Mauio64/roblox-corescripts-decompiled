local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

return function(callback)
	return callback(urlBuilder.fromString("apis:auth-token-service/v1/login/create")(), "POST", {
		postBody = ""
	})
end
