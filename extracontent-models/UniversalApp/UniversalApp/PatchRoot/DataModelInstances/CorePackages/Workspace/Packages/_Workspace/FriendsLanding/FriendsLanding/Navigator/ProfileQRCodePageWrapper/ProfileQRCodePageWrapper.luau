local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Roact = dependencies.Roact
local llama = dependencies.llama
local ProfileQRCode = dependencies.ProfileQRCode
local Contexts = dependencies.SocialLuaAnalytics.Analytics.Enums.Contexts
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)

return function(p1) -- line: 10
	-- upvalues: FriendsLandingContext (copy), Roact (copy), ProfileQRCode (copy), llama (copy), Contexts (copy)
	local v9 = FriendsLandingContext.useContext()

	return Roact.createElement(ProfileQRCode.ProfileQRCodeEntryPoint, llama.Dictionary.join(p1, {
		onClose = function() -- line: 16
			-- upvalues: p1 (copy)
			p1.navigation.goBack()
		end,
		source = Contexts.AddFriends,
		robloxEventReceiver = v9.robloxEventReceiver
	}))
end
