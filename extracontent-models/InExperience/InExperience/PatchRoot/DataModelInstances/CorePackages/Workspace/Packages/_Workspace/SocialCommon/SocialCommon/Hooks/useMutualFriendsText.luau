local SocialCommon = script:FindFirstAncestor("SocialCommon")
local SocialCommonParent = SocialCommon.Parent
local useLocalization = require(SocialCommonParent.Localization).Hooks.useLocalization
local getMutualFriendsText = require(SocialCommon.Utils.getMutualFriendsText)
local FFlagConnectionsToFriendsRename = require(SocialCommonParent.SharedFlags).FFlagConnectionsToFriendsRename

return function(n1: number) -- line: 14
	-- upvalues: useLocalization (copy), FFlagConnectionsToFriendsRename (copy), getMutualFriendsText (copy)
	local v7 = useLocalization({
		singularMutualConnection = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.MutualConnection" or "Feature.Friends.Label.MutualFriendTitle",
		mutualConnections = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.MutualConnections" or "Feature.Friends.Label.MutualFriendsTitle",
			numConnections = n1
		}
	})

	return getMutualFriendsText({
		mutualFriendsCount = n1,
		localized = v7
	})
end
