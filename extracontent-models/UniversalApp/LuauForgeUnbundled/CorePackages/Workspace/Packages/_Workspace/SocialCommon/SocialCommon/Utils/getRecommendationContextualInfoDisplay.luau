local getMutualFriendsText = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/getMutualFriendsText")
local RecommendationContextType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Enums/RecommendationContextType")
local FFlagShowClassmatesOnPYMK = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags/FFlagShowClassmatesOnPYMK")

local images = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox").App.ImageSet.Images

return function(p2)
	local v5 = p2.recommendation.contextType and p2.recommendation.contextType.rawValue()
	local mutualFriendsCount = p2.recommendation.mutualFriendsCount or 0
	local v6

	if p2.recommendation.hasIncomingFriendRequest then
		v6 = p2.localized.connectionRequests
	end

	local iconsstatusplayerfriend = nil

	if v5 == RecommendationContextType.Contacts.rawValue() then
		v6 = p2.localized.contacts
	elseif v5 == RecommendationContextType.MutualFriends.rawValue() and mutualFriendsCount > 0 then
		v6 = getMutualFriendsText({
			mutualFriendsCount = mutualFriendsCount,
			localized = {
				mutualConnections = p2.localized.mutualConnections,
				singularMutualConnection = p2.localized.singularMutualConnection
			}
		})

		iconsstatusplayerfriend = images["icons/status/player/friend"]
	elseif v5 == RecommendationContextType.Frequents.rawValue() then
		v6 = p2.localized.frequents
	elseif FFlagShowClassmatesOnPYMK and v5 == RecommendationContextType.Classmates.rawValue() then
		v6 = p2.localized.classmates
	end

	return { text = v6, icon = iconsstatusplayerfriend }
end
