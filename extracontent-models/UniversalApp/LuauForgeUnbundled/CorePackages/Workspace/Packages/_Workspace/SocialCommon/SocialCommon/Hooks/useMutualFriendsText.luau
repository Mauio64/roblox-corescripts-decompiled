local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Localization").Hooks.useLocalization

local getMutualFriendsText = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/getMutualFriendsText")

return function(p2)
	return getMutualFriendsText({
		mutualFriendsCount = p2,
		localized = useLocalization({
			singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
			mutualConnections = {
				"Feature.Friends.Label.MutualFriendsTitle",
				numConnections = p2
			}
		})
	})
end
