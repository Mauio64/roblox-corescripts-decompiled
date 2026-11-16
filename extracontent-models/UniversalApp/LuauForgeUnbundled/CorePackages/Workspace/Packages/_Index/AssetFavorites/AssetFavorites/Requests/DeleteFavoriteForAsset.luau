local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/Http").Url

return function(callback, p2, p3)
	return callback(
		string.format("%s/v1/favorites/users/%s/assets/%s/favorite", url.CATALOG_URL, p2, p3),
		"DELETE",
		{ postBody = HttpService:JSONEncode({}) }
	)
end
