local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local roact = dependencies.Roact
local llama = dependencies.llama
local profileQRCode = dependencies.ProfileQRCode
local contexts = dependencies.SocialLuaAnalytics.Analytics.Enums.Contexts
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")

return function(p2)
	local v5 = FriendsLandingContext.useContext()

	return roact.createElement(profileQRCode.ProfileQRCodeEntryPoint, llama.Dictionary.join(p2, {
		onClose = function()
			p2.navigation.goBack()
		end,
		source = contexts.AddFriends,
		robloxEventReceiver = v5.robloxEventReceiver
	}))
end
