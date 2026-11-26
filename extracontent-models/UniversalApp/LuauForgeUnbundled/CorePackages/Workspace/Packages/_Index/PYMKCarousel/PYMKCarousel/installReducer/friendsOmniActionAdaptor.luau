local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local roduxFriends = dependencies.RoduxFriends
local players = dependencies.Players
local llama = dependencies.llama

local transformOmniRecommendationsToActions = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/transformOmniRecommendationsToActions")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/OmniTypes")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants")
local recommendationContextType = roduxFriends.Enums.RecommendationContextType
local socialCommon = dependencies.SocialCommon
local recommendationSourceEnum = socialCommon.Enums.RecommendationSourceEnum
local contextualInfoTypes = socialCommon.Enums.ContextualInfoTypes

local function fn(data, rank, data2)
	local contextType = data.contextType
	local v5 = recommendationContextType.fromRawValue(contextType)
	local v6

	if v5 and v5 ~= recommendationContextType.None then
		v6 = data.contextType
	else
		v6 = data2.contextType
	end

	local mutualFriendsCount = data2.mutualFriendsCount and tonumber(data2.mutualFriendsCount) or 0

	if v6 == recommendationContextType.MutualFriends.rawValue() and mutualFriendsCount == 0 then
		v6 = recommendationContextType.None.rawValue()
	end

	local v7 = v6 == contextualInfoTypes.Contacts
		and {
			avatarImageUrl = data.AvatarThumbnailUrl,
			headshotImageUrl = data.HeadshotThumbnailUrl
		}
		or nil

	local v9 = if v6 == contextualInfoTypes.Contacts then data.ContactId else tostring(data.userId)
	local v8 = {
		id = v9,
		contextType = v6,
		mutualFriendsList = data.mutualFriendDisplayName,
		rank = 0,
		mutualFriendsCount = 0,
		hasIncomingFriendRequest = 0,
		thumbnailEntities = 0,
		contactId = 0,
		displayName = 0
	}

	if data2.rank then
		rank = tonumber(data2.rank)
	end

	v8.rank = rank
	v8.mutualFriendsCount = mutualFriendsCount
	v8.hasIncomingFriendRequest = data2.hasPendingFriendRequest == Constants.BE_TRUE_VALUE
	v8.thumbnailEntities = v7
	v8.contactId = data.ContactId
	v8.displayName = data.ContactName
	return v8
end

local function fn2(p2, p3, p4)
	local localPlayer = players.LocalPlayer
	assert(localPlayer, "LocalPlayer must be non-nil")
	local userId = tostring(localPlayer.UserId)

	return roduxFriends.Actions.RecommendationCreated({
		baseUserId = userId,
		recommendedUser = fn(p2, p3, p4)
	})
end

local function fn3(p2, options)
	local keys = llama.Dictionary.keys(options or {})

	return roduxFriends.Actions.RecommendationSourceCreated({
		source = recommendationSourceEnum.HomepagePYMKCarousel,
		recommendationIds = keys
	})
end

return function(p2)
	return {
		AddContentMetadata = function(p3)
			return { p3 }
		end,
		AddOmniRecommendations = function(p3)
			return transformOmniRecommendationsToActions(p3.recommendations or {}, p2, fn2, fn3)
		end
	}
end
