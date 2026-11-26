local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Http")

local function fn(callback, p2)
	return callback(Http.Url.FRIEND_URL):path("my"):path("friends"):path("refresh-qr-session"):body({})
end

return (function(p2)
	return p2.POST("refreshQrSession", fn)
end)((require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/configuredRoduxNetworking")))
