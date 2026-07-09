local Parent = script:FindFirstAncestor("AddFriends").Parent
local t = require(Parent.t)
local Images = require(Parent.UIBlox).App.ImageSet.Images
local PresenceType = require(Parent.AddFriendsState).RoduxPresence.Enums.PresenceType
local Constants = require(Parent.ContactImporter).Constants
local FriendshipOriginSourceType = require(Parent.FriendsNetworking).Enums.FriendshipOriginSourceType
local SocialCommon = require(Parent.SocialCommon)
local getRecommendationContextualInfoDisplay = SocialCommon.Utils.getRecommendationContextualInfoDisplay
local getRecommendationContextualInfoType = SocialCommon.Utils.getRecommendationContextualInfoType
local getMutualFriendsText = SocialCommon.Utils.getMutualFriendsText
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local FFlagAddFriendsRenderTileRefactor = require(Parent.SharedFlags).FFlagAddFriendsRenderTileRefactor
local v13 = t.strictInterface({
	mutualFriends = t.optional(t.table),
	amIFollowingUser = t.optional(t.boolean),
	isUserFollowingMe = t.optional(t.boolean),
	sentFromExperienceName = t.optional(t.string),
	isFriendRequest = t.boolean,
	isRecommendation = t.optional(t.boolean),
	userPresenceType = t.optional(t.userdata),
	lastLocation = t.optional(t.string),
	originSourceType = t.optional(t.string),
	contextType = t.optional(t.userdata),
	mutualFriendsCount = t.optional(t.number),
	hasIncomingFriendRequest = t.optional(t.boolean)
})

return function(p1, p2, p3) -- line: 46
	-- upvalues: v13 (copy), Constants (copy), FriendshipOriginSourceType (copy), getMutualFriendsText (copy), Images (copy), ContextualInfoTypes (copy), FFlagAddFriendsRenderTileRefactor (copy), PresenceType (copy), getRecommendationContextualInfoDisplay (copy), getRecommendationContextualInfoType (copy)
	assert(v13(p1))

	if p1.isFriendRequest then
		if p3.contactNameText then
			return {
				text = p3.contactNameText,
				fontStyle = p2.Font.CaptionBody
			}, "HaveContact"
		end

		if p1.originSourceType == Constants.PHONE_CONTACT_IMPORTER then
			return {
				text = p3.fromContactsText,
				fontStyle = p2.Font.CaptionBody
			}, "FromCI"
		end

		if p1.originSourceType == FriendshipOriginSourceType.QrCode.rawValue() then
			return {
				text = p3.foundThroughQRCode,
				fontStyle = p2.Font.CaptionBody
			}, "FRomQR"
		end

		local mutualFriends = p1.mutualFriends

		if mutualFriends ~= nil and #mutualFriends > 0 then
			return {
				text = getMutualFriendsText({
					mutualFriendsCount = #p1.mutualFriends,
					localized = {
						mutualConnections = p3.mutualConnections,
						singularMutualConnection = p3.singularMutualConnection
					}
				}),
				fontStyle = p2.Font.CaptionBody,
				icon = Images["icons/status/player/friend"]
			}, ContextualInfoTypes.MutualFriends
		end

		if p1.sentFromExperienceName ~= nil then
			return {
				text = p3.sentFromWithContextText,
				fontStyle = p2.Font.CaptionBody
			}, "FromExperience"
		end

		if p1.amIFollowingUser then
			return {
				text = p3.youAreFollowingText,
				fontStyle = p2.Font.CaptionBody,
				icon = Images["icons/status/player/following"]
			}, "FollowingUser"
		end

		if p1.isUserFollowingMe then
			return {
				text = p3.followsYouText,
				fontStyle = p2.Font.CaptionBody,
				icon = Images["icons/status/player/following"]
			}, "FollowingMe"
		end

		return nil
	end

	if not FFlagAddFriendsRenderTileRefactor and p1.userPresenceType == PresenceType.InGame then
		return p1.lastLocation and {
			text = p1.lastLocation,
			fontStyle = p2.Font.CaptionBody,
			icon = Images["icons/actions/friends/friendsplaying"],
			iconTransparency = p2.Theme.BackgroundUIDefault.Transparency,
			iconSize = UDim2.new(0, 24, 0, 24)
		}, "LastLocation"
	end

	if p1.isRecommendation then
		local t1 = {
			contextType = p1.contextType,
			mutualFriendsCount = p1.mutualFriendsCount,
			hasIncomingFriendRequest = p1.hasIncomingFriendRequest
		}
		local t2 = {
			mutualConnections = p3.mutualConnections,
			singularMutualConnection = p3.singularMutualConnection,
			frequents = p3.frequents,
			connectionRequests = p3.connectionRequests,
			contacts = p3.fromContacts
		}
		local v21 = getRecommendationContextualInfoDisplay({
			recommendation = t1,
			localized = t2
		})

		return {
			text = v21.text,
			fontStyle = p2.Font.CaptionBody,
			icon = v21.icon
		}, getRecommendationContextualInfoType(t1)
	end

	return nil
end
