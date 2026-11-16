local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value, value2)
	assert(type(value) == "string", "FollowingsGetStatus request expects userId to be a string")
	assert(type(value2) == "string", "FollowingsGetStatus request expects universeId to be a string")

	return callback(
		string.format("%s/v1/users/%s/universes/%s/status", Url.FOLLOWINGS_URL, value, value2),
		"GET"
	)
end
