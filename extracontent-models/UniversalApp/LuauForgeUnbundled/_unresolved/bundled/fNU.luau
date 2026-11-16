local url = require("@game/CorePackages/Workspace/Packages/Http").Url

return function(callback, p2)
	return callback(string.format("%s/v1/%s/metadata?appType=PlayerApplication", url.AUTH_URL, p2), "GET", {
		headers = { Referer = "https://roblox.cn/" }
	})
end
