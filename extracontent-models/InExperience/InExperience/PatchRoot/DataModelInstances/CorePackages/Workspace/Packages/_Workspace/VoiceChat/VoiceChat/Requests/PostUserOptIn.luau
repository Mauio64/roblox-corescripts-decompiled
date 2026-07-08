local Parent = script:FindFirstAncestor("VoiceChat").Parent
local HttpService = game:GetService("HttpService")
local Url = require(Parent.Http).Url

return function(p1, p2, p3) -- line: 15
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p2) == "boolean", "UserOptIn request expects isUserOptIn to be a boolean")

	local v7 = string.format("%sv1/settings/user-opt-in/", Url.VOICE_URL)
	local json

	if p3 ~= nil then
		assert(type(p3) == "boolean", "UserOptIn request expects isOptedInThroughUpsell to be a boolean")
		json = HttpService:JSONEncode({
			isUserOptIn = p2,
			isOptedInThroughUpsell = p3
		})
	else
		json = HttpService:JSONEncode({
			isUserOptIn = p2
		})
	end

	return p1(v7, "POST", {
		postBody = json
	})
end
