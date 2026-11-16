local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)
local parent = ProfilePlatform.Parent
local Http = require(parent.Http)

local function buildUrl(callback, p)
	return callback(Http.Url.FRIEND_URL):path("my"):path("friends"):path((tostring(p))):path("check-qr-session")
end

return myRoduxNetworking.GET("CheckQRSession", buildUrl)
