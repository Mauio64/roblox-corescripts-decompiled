local parent = script:FindFirstAncestor("VoiceChat").Parent
local HttpService = game:GetService("HttpService")
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, isUserOptIn, isOptedInThroughUpsell)
	assert(type(isUserOptIn) == "boolean", "UserOptIn request expects isUserOptIn to be a boolean")

	local v = string.format("%sv1/settings/user-opt-in/", Url.VOICE_URL)
	local postBody

	if isOptedInThroughUpsell == nil then
		postBody = HttpService:JSONEncode({ isUserOptIn = isUserOptIn })
	else
		assert(
			type(isOptedInThroughUpsell) == "boolean",
			"UserOptIn request expects isOptedInThroughUpsell to be a boolean"
		)

		postBody = HttpService:JSONEncode({
			isUserOptIn = isUserOptIn,
			isOptedInThroughUpsell = isOptedInThroughUpsell
		})
	end

	return callback(v, "POST", { postBody = postBody })
end
