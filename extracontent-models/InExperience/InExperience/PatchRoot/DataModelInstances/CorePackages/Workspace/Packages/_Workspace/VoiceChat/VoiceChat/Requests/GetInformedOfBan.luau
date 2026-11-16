local parent = script:FindFirstAncestor("VoiceChat").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback)
	return callback(string.format("%sv1/moderation/informed-of-ban", Url.VOICE_URL), "GET")
end
