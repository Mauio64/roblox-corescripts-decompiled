local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local roact = dependencies.Roact
local llama = dependencies.llama
local profileQRCode = dependencies.ProfileQRCode
local contexts = dependencies.SocialLuaAnalytics.Analytics.Enums.Contexts
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)

return function(p)
	local v = FriendsLandingContext.useContext()

	return roact.createElement(profileQRCode.ProfileQRCodeEntryPoint, llama.Dictionary.join(p, {
		onClose = function()
			p.navigation.goBack()
		end,
		source = contexts.AddFriends,
		robloxEventReceiver = v.robloxEventReceiver
	}))
end
