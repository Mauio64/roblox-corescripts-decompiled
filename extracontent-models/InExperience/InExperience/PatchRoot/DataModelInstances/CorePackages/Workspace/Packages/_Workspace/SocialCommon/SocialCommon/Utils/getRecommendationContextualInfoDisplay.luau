local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent

local getMutualFriendsText = require(SocialCommon.Utils.getMutualFriendsText)
local RecommendationContextType = require(SocialCommon.Enums.RecommendationContextType)
local FFlagShowClassmatesOnPYMK = require(parent.SharedFlags.FFlagShowClassmatesOnPYMK)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images

return function(p)
	local v = p.recommendation.contextType and p.recommendation.contextType.rawValue()
	local mutualFriendsCount = p.recommendation.mutualFriendsCount or 0
	local text

	if p.recommendation.hasIncomingFriendRequest then
		text = p.localized.connectionRequests
	end

	local iconsstatusplayerfriend = nil

	if v == RecommendationContextType.Contacts.rawValue() then
		text = p.localized.contacts
	elseif v == RecommendationContextType.MutualFriends.rawValue() and mutualFriendsCount > 0 then
		text = getMutualFriendsText({
			mutualFriendsCount = mutualFriendsCount,
			localized = {
				mutualConnections = p.localized.mutualConnections,
				singularMutualConnection = p.localized.singularMutualConnection
			}
		})

		iconsstatusplayerfriend = Images["icons/status/player/friend"]
	elseif v == RecommendationContextType.Frequents.rawValue() then
		text = p.localized.frequents
	elseif FFlagShowClassmatesOnPYMK and v == RecommendationContextType.Classmates.rawValue() then
		text = p.localized.classmates
	end

	return { text = text, icon = iconsstatusplayerfriend }
end
