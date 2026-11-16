local parent = script:FindFirstAncestor("AuthCommon").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback)
	return callback(urlBuilder.fromString("auth:v1/session/refresh")(), "POST", { postBody = "" })
end
