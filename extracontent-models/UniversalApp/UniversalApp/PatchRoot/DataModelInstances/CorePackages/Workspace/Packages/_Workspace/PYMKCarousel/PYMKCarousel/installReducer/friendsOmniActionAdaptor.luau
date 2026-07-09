local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local RoduxFriends = dependencies.RoduxFriends
local Players = dependencies.Players
local llama = dependencies.llama
local transformOmniRecommendationsToActions = require(script.Parent.transformOmniRecommendationsToActions)

require(PYMKCarousel.Common.OmniTypes)

local Constants = require(PYMKCarousel.Common.Constants)
local RecommendationContextType = RoduxFriends.Enums.RecommendationContextType
local SocialCommon = dependencies.SocialCommon
local RecommendationSourceEnum = SocialCommon.Enums.RecommendationSourceEnum
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes

local function v12(p1, n1: number, p2) -- line: 21
	-- upvalues: RecommendationContextType (copy), ContextualInfoTypes (copy), Constants (copy)
	local contextType = p1.contextType
	local v21 = RecommendationContextType.fromRawValue(contextType)
	local v22 = if not (v21 and v21 ~= RecommendationContextType.None) then p2.contextType else p1.contextType
	local v23 = p2.mutualFriendsCount and tonumber(p2.mutualFriendsCount) or 0

	if v22 == RecommendationContextType.MutualFriends.rawValue() and v23 == 0 then
		v22 = RecommendationContextType.None.rawValue()
	end

	local v24 = if v22 ~= ContextualInfoTypes.Contacts then nil else {
		avatarImageUrl = p1.AvatarThumbnailUrl,
		headshotImageUrl = p1.HeadshotThumbnailUrl
	}

	return {
		id = if v22 ~= ContextualInfoTypes.Contacts then tostring(p1.userId) else p1.ContactId,
		contextType = v22,
		mutualFriendsList = p1.mutualFriendDisplayName,
		rank = if not p2.rank then n1 else tonumber(p2.rank),
		mutualFriendsCount = v23,
		hasIncomingFriendRequest = p2.hasPendingFriendRequest == Constants.BE_TRUE_VALUE,
		thumbnailEntities = v24,
		contactId = p1.ContactId,
		displayName = p1.ContactName
	}
end
local function v13(p3, n2: number, p4) -- line: 57
	-- upvalues: Players (copy), RoduxFriends (copy), v12 (copy)
	local LocalPlayer = Players.LocalPlayer

	assert(LocalPlayer, "LocalPlayer must be non-nil")

	local str = tostring(LocalPlayer.UserId)

	return RoduxFriends.Actions.RecommendationCreated({
		baseUserId = str,
		recommendedUser = v12(p3, n2, p4)
	})
end
local function v14(_, p6) -- line: 72
	-- upvalues: llama (copy), RoduxFriends (copy), RecommendationSourceEnum (copy)
	local v32 = llama.Dictionary.keys(p6 or {})

	return RoduxFriends.Actions.RecommendationSourceCreated({
		source = RecommendationSourceEnum.HomepagePYMKCarousel,
		recommendationIds = v32
	})
end

return function(p7) -- line: 84
	-- upvalues: transformOmniRecommendationsToActions (copy), v13 (copy), v14 (copy)
	return {
		AddContentMetadata = function(p8) -- line: 86
			return { p8 }
		end,
		AddOmniRecommendations = function(p9) -- line: 91
			-- upvalues: transformOmniRecommendationsToActions (copy), p7 (copy), v13 (copy), v14 (copy)
			return transformOmniRecommendationsToActions(p9.recommendations or {}, p7, v13, v14)
		end
	}
end
