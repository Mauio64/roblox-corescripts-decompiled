local parent = script.Parent.Parent.Parent
local Http = require(parent.Http)
local Url = Http.Url
local HttpService = game:GetService("HttpService")

return function(callback, value, value2)
	assert(type(value) == "string", "FollowingsPostFollow request expects userId to be a string")
	assert(type(value2) == "string", "FollowingsPostFollow request expects universeId to be a string")

	return callback(string.format("%s/v1/users/%s/universes/%s", Url.FOLLOWINGS_URL, value, value2), "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
