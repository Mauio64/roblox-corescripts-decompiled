local module = require("@luauforge/bundled/dVn")
local HttpService = game:GetService("HttpService")

return function(callback, value, value2)
	assert(type(value) == "string", "FollowingsDeleteFollow request expects userId to be a string")
	assert(type(value2) == "string", "FollowingsDeleteFollow request expects universeId to be a string")

	return callback(
		string.format("%s/v1/users/%s/universes/%s", module.FOLLOWINGS_URL, value, value2),
		"DELETE",
		{ postBody = HttpService:JSONEncode({}) }
	)
end
