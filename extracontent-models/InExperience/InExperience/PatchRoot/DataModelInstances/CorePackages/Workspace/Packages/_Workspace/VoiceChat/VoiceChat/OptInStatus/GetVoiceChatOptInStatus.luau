local parent = script:FindFirstAncestor("VoiceChat").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback)
	return callback(string.format("%s/v1/settings/user-opt-in", Url.VOICE_URL), "GET")
end
