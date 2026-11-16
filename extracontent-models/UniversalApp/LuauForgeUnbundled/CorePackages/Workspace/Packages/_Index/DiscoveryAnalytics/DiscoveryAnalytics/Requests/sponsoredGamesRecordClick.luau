local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/Http").Url

return function(callback, p2)
	return callback(string.format("%sv1/sponsored-games/click", url.ADS_URL), "POST", {
		postBody = "\"" .. p2 .. "\""
	})
end
