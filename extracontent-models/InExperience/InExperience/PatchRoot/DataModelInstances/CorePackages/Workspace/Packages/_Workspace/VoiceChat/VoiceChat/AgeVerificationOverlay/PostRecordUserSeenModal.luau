local Parent = script:FindFirstAncestor("VoiceChat").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 10
	-- upvalues: Url (copy)
	return p1(string.format("%s/v1/settings/record-user-seen-upsell-modal", Url.VOICE_URL), "POST", {
		postBody = "{}"
	})
end
