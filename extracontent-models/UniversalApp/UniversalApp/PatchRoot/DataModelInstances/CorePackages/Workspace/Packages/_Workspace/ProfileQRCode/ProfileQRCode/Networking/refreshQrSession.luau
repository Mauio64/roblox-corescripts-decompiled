local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local Http = require(Parent.Http)

local function v3(p1) -- line: 6
	-- upvalues: Http (copy)
	return p1(Http.Url.FRIEND_URL):path("my"):path("friends"):path("refresh-qr-session"):body({})
end

return (function(p2) -- line: 10
	-- upvalues: v3 (copy)
	return p2.POST(script.Name, v3)
end)((require(script.Parent.configuredRoduxNetworking)))
