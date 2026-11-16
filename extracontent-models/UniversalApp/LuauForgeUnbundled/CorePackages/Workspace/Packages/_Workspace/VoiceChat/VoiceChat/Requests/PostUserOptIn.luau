local HttpService = game:GetService("HttpService")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").Url

return function(callback, p2, p3)
	assert(type(p2) == "boolean", "UserOptIn request expects isUserOptIn to be a boolean")

	local v5 = string.format("%sv1/settings/user-opt-in/", url.VOICE_URL)
	local v6

	if p3 == nil then
		v6 = HttpService:JSONEncode({ isUserOptIn = p2 })
	else
		assert(type(p3) == "boolean", "UserOptIn request expects isOptedInThroughUpsell to be a boolean")

		v6 = HttpService:JSONEncode({ isUserOptIn = p2, isOptedInThroughUpsell = p3 })
	end

	return callback(v5, "POST", { postBody = v6 })
end
