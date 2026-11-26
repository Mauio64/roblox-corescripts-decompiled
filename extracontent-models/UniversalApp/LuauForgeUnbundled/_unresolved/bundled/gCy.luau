local url = require("@game/CorePackages/Workspace/Packages/Http").Url

return function(callback, p2, p3)
	local queryString = url:makeQueryString({
		playerId = p2,
		placeId = p3,
		status = "pending",
		locationType = "ExperienceDetailPage"
	})

	return callback(
		string.format("%s%s?%s", url.APIS_URL, "game-transactions/v1/receipts", queryString),
		"GET"
	)
end
