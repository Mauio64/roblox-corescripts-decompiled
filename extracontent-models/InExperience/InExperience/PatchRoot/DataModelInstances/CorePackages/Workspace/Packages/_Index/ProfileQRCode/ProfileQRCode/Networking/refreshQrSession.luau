local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local Http = require(parent.Http)
local configuredRoduxNetworking = require(script.Parent.configuredRoduxNetworking)

local function fn(callback, _)
	return callback(Http.Url.FRIEND_URL):path("my"):path("friends"):path("refresh-qr-session"):body({})
end

return (function(p)
	return p.POST(script.Name, fn)
end)(configuredRoduxNetworking)
