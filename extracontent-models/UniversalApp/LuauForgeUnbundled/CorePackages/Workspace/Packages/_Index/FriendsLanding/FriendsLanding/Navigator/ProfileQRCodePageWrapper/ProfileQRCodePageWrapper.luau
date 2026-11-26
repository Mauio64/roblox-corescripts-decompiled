local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local roact = dependencies.Roact
local react = dependencies.React
local llama = dependencies.llama
local profileQRCode = dependencies.ProfileQRCode
local contexts = dependencies.SocialLuaAnalytics.Analytics.Enums.Contexts
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")

local fFlagProfileQRCodeGamepadBackFix = profileQRCode.FFlagProfileQRCodeGamepadBackFix

return function(p2)
	local v5 = FriendsLandingContext.useContext()
	local v6

	if fFlagProfileQRCodeGamepadBackFix then
		v6 = react.useCallback(function()
			p2.navigation.goBack()
		end, { p2.navigation })
	end

	return roact.createElement(profileQRCode.ProfileQRCodeEntryPoint, llama.Dictionary.join(p2, {
		onClose = not fFlagProfileQRCodeGamepadBackFix and function()
			p2.navigation.goBack()
		end or v6,
		source = contexts.AddFriends,
		robloxEventReceiver = v5.robloxEventReceiver
	}))
end
