local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)
local ProfilePlatformParent = ProfilePlatform.Parent
local Http = require(ProfilePlatformParent.Http)

local function buildUrl(p1, n1: number) -- line: 6
	-- upvalues: Http (copy)
	return p1(Http.Url.FRIEND_URL):path("my"):path("friends"):path((tostring(n1))):path("check-qr-session")
end

return myRoduxNetworking.GET({
	Name = "CheckQRSession"
}, buildUrl)
