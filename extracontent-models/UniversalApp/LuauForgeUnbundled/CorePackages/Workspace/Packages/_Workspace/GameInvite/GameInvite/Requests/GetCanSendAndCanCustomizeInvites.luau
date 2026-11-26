local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Http").Url

return function(callback, p2, p3)
	local queryString = url:makeQueryString({
		RecipientUserId = p3,
		Trigger = p2,
		PlaceId = game.PlaceId
	})

	return callback(
		string.format("%snotifications/v1/can-prompt-experience-invite?%s", url.APIS_URL, queryString),
		"GET"
	)
end
