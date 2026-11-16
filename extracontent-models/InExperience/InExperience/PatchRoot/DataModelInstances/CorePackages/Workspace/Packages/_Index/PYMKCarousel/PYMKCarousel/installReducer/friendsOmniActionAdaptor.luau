local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

local roduxFriends = dependencies.RoduxFriends
local players = dependencies.Players
local llama = dependencies.llama

local transformOmniRecommendationsToActions = require(script.Parent.transformOmniRecommendationsToActions)
require(PYMKCarousel.Common.OmniTypes)
local Constants = require(PYMKCarousel.Common.Constants)
local recommendationContextType = roduxFriends.Enums.RecommendationContextType
local socialCommon = dependencies.SocialCommon
local recommendationSourceEnum = socialCommon.Enums.RecommendationSourceEnum
local contextualInfoTypes = socialCommon.Enums.ContextualInfoTypes

local function fn(contextType: string?) -- 1 equivalent call inferred from this helper
	local v = recommendationContextType.fromRawValue(contextType)
	return v and v ~= recommendationContextType.None
end

local function fn2(data, rank: number, data2)
	local contextType

	if fn(data.contextType) then -- inferred equivalent call
		contextType = data.contextType
	else
		contextType = data2.contextType
	end

	local mutualFriendsCount = data2.mutualFriendsCount and tonumber(data2.mutualFriendsCount) or 0

	if contextType == recommendationContextType.MutualFriends.rawValue() and mutualFriendsCount == 0 then
		contextType = recommendationContextType.None.rawValue()
	end

	local thumbnailEntities = contextType == contextualInfoTypes.Contacts
		and {
			avatarImageUrl = data.AvatarThumbnailUrl,
			headshotImageUrl = data.HeadshotThumbnailUrl
		}
		or nil
	local id

	if contextType == contextualInfoTypes.Contacts then
		id = data.ContactId
	else
		id = tostring(data.userId)
	end

	local v = {
		id = id,
		contextType = contextType,
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

	v.rank = rank
	v.mutualFriendsCount = mutualFriendsCount
	v.hasIncomingFriendRequest = data2.hasPendingFriendRequest == Constants.BE_TRUE_VALUE
	v.thumbnailEntities = thumbnailEntities
	v.contactId = data.ContactId
	v.displayName = data.ContactName
	return v
end

local function fn3(p, p2: number, p3)
	local localPlayer = players.LocalPlayer
	assert(localPlayer, "LocalPlayer must be non-nil")
	local userId = tostring(localPlayer.UserId)

	return roduxFriends.Actions.RecommendationCreated({
		baseUserId = userId,
		recommendedUser = fn2(p, p2, p3)
	})
end

local function fn4(_, options)
	local keys = llama.Dictionary.keys(options or {})

	return roduxFriends.Actions.RecommendationSourceCreated({
		source = recommendationSourceEnum.HomepagePYMKCarousel,
		recommendationIds = keys
	})
end

return function(p)
	return {
		AddContentMetadata = function(p2)
			return { p2 }
		end,
		AddOmniRecommendations = function(p2)
			return transformOmniRecommendationsToActions(p2.recommendations or {}, p, fn3, fn4)
		end
	}
end
