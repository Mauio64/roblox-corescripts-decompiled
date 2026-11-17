local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local roact = dependencies.Roact
local react = dependencies.React
local llama = dependencies.llama
local profileQRCode = dependencies.ProfileQRCode
local contexts = dependencies.SocialLuaAnalytics.Analytics.Enums.Contexts
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)

local fFlagProfileQRCodeGamepadBackFix = profileQRCode.FFlagProfileQRCodeGamepadBackFix

return function(p)
	local v = FriendsLandingContext.useContext()
	local v2

	if fFlagProfileQRCodeGamepadBackFix then
		v2 = react.useCallback(function()
			p.navigation.goBack()
		end, { p.navigation })
	end

	return roact.createElement(profileQRCode.ProfileQRCodeEntryPoint, llama.Dictionary.join(p, {
		onClose = not fFlagProfileQRCodeGamepadBackFix and function()
			p.navigation.goBack()
		end or v2,
		source = contexts.AddFriends,
		robloxEventReceiver = v.robloxEventReceiver
	}))
end
