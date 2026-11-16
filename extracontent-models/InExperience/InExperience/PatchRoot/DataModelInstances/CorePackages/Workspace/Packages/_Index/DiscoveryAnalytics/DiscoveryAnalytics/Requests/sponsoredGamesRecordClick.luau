local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p: string)
	return callback(string.format("%sv1/sponsored-games/click", Url.ADS_URL), "POST", {
		postBody = "\"" .. p .. "\""
	})
end
