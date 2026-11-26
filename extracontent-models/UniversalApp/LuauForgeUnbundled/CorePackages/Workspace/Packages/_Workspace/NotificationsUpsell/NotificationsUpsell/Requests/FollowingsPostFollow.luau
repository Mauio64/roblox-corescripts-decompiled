local url = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/Http").Url
local HttpService = game:GetService("HttpService")

return function(callback, value, value2)
	assert(type(value) == "string", "FollowingsPostFollow request expects userId to be a string")
	assert(type(value2) == "string", "FollowingsPostFollow request expects universeId to be a string")

	return callback(
		string.format("%s/v1/users/%s/universes/%s", url.FOLLOWINGS_URL, value, value2),
		"POST",
		{ postBody = HttpService:JSONEncode({}) }
	)
end
