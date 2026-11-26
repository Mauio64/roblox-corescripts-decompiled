local url = require("@game/CorePackages/Workspace/Packages/Http").Url

return function(callback, list, p2)
	local queryString = url:makeQueryString({
		assetIds = table.concat(list, ","),
		format = "png",
		size = p2
	})

	return callback(string.format("%sv1/assets?%s", url.THUMBNAILS_URL, queryString), "GET")
end
