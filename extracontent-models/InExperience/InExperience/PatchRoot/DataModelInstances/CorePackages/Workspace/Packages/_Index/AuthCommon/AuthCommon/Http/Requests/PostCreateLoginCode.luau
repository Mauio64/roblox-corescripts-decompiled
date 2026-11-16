local parent = script:FindFirstAncestor("AuthCommon").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback)
	return callback(urlBuilder.fromString("apis:auth-token-service/v1/login/create")(), "POST", {
		postBody = ""
	})
end
