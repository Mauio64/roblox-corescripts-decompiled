local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http")

local function buildUrl(callback, p2)
	return callback(Http.Url.FRIEND_URL):path("my"):path("friends"):path((tostring(p2))):path("check-qr-session")
end

return myRoduxNetworking.GET("CheckQRSession", buildUrl)
