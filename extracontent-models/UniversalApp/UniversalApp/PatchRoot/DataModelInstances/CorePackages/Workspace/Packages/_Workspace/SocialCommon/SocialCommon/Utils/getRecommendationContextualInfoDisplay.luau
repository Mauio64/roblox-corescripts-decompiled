local SocialCommon = script:FindFirstAncestor("SocialCommon")
local SocialCommonParent = SocialCommon.Parent
local getMutualFriendsText = require(SocialCommon.Utils.getMutualFriendsText)
local RecommendationContextType = require(SocialCommon.Enums.RecommendationContextType)
local Images = require(SocialCommonParent.UIBlox).App.ImageSet.Images
local FFlagHomepagePYMKUseHorizontalUserList = require(SocialCommonParent.SharedFlags).FFlagHomepagePYMKUseHorizontalUserList

return function(t1: {[any]: any}) -- line: 45
	-- upvalues: FFlagHomepagePYMKUseHorizontalUserList (copy), RecommendationContextType (copy), getMutualFriendsText (copy), Images (copy)
	local connectionRequests = nil
	local v9 = nil
	local v10 = t1.recommendation.contextType and t1.recommendation.contextType.rawValue()
	local v11 = t1.recommendation.mutualFriendsCount or 0

	if FFlagHomepagePYMKUseHorizontalUserList and t1.recommendation.hasIncomingFriendRequest then
		connectionRequests = t1.localized.connectionRequests
		v9 = nil
	end

	if v10 == RecommendationContextType.Contacts.rawValue() then
		connectionRequests = t1.localized.contacts
	elseif v10 == RecommendationContextType.MutualFriends.rawValue() and v11 > 0 then
		connectionRequests = getMutualFriendsText({
			mutualFriendsCount = v11,
			localized = {
				mutualConnections = t1.localized.mutualConnections,
				singularMutualConnection = t1.localized.singularMutualConnection
			}
		})
		v9 = Images["icons/status/player/friend"]
	elseif v10 == RecommendationContextType.Frequents.rawValue() then
		connectionRequests = t1.localized.frequents
	end

	if not FFlagHomepagePYMKUseHorizontalUserList and t1.recommendation.hasIncomingFriendRequest then
		connectionRequests = t1.localized.connectionRequests
		v9 = nil
	end

	return {
		text = connectionRequests,
		icon = v9
	}
end
