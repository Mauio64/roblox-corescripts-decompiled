local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local getMutualFriendsText = require(SocialCommon.Utils.getMutualFriendsText)

return function(p: number)
	return getMutualFriendsText({
		mutualFriendsCount = p,
		localized = useLocalization({
			singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
			mutualConnections = {
				"Feature.Friends.Label.MutualFriendsTitle",
				numConnections = p
			}
		})
	})
end
