local url = require("@game/CorePackages/Workspace/Packages/Http").Url

return function(callback, list, p2)
	local queryString = url:makeQueryString({
		gamePassIds = table.concat(list, ","),
		format = "png",
		size = p2,
		isCircular = true
	})

	return callback(string.format("%sv1/game-passes?%s", url.THUMBNAILS_URL, queryString), "GET")
end
