local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

local dash = dependencies.Dash
local roduxFriends = dependencies.RoduxFriends
local roduxUsers = dependencies.RoduxUsers
local socialCommon = dependencies.SocialCommon

local recommendation = roduxFriends.Models.Recommendation
local recommendationContextType = roduxFriends.Enums.RecommendationContextType
local user = roduxUsers.Models.User
local recommendationSourceEnum = socialCommon.Enums.RecommendationSourceEnum
local Constants = require(PYMKCarousel.Common.Constants)
local RECOMMENDATION_SESSION_ID_KEY = Constants.RECOMMENDATION_SESSION_ID_KEY

local RoduxPresence = require(PYMKCarousel.installReducer.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType

local homepagePYMKCarousel = recommendationSourceEnum.HomepagePYMKCarousel

local recommendationIds = {
	longName = "1_longName",
	noContext = "2_noContext",
	mutualContextPlural = "3_mutualContextPlural",
	mutualContextSingle = "4_mutualContextSingle",
	mutualContextNone = "5_mutualContextNone",
	frequentContext = "6_frequentContext",
	pendingFriendRequest = "7_pendingFriendRequest",
	incomingFriendRequest = "8_incomingFriendRequest",
	contact = "9_contact"
}

local mapped = dash.map(dash.values(recommendationIds), function(id)
	return { id = id }
end)

local state = {
	ScreenSize = Vector2.new(1920, 1080),
	TopBar = { topBarHeight = 10 },
	GlobalGuiInset = { bottom = 10 },
	LocalUserId = "123456",
	PYMKCarousel = 0
}

local users = {
	byUserId = {
		[recommendationIds.longName] = user.mock({ displayName = "Very Long Display Name" }),
		[recommendationIds.noContext] = user.mock(),
		[recommendationIds.mutualContextPlural] = user.mock(),
		[recommendationIds.mutualContextSingle] = user.mock(),
		[recommendationIds.mutualContextNone] = user.mock(),
		[recommendationIds.frequentContext] = user.mock(),
		[recommendationIds.pendingFriendRequest] = user.mock(),
		[recommendationIds.incomingFriendRequest] = user.mock(),
		[recommendationIds.contact] = user.mock()
	}
}

local recommendations = {
	bySource = {
		[homepagePYMKCarousel] = {
			[recommendationIds.longName] = true,
			[recommendationIds.noContext] = true,
			[recommendationIds.mutualContextPlural] = true,
			[recommendationIds.mutualContextSingle] = true,
			[recommendationIds.mutualContextNone] = true,
			[recommendationIds.frequentContext] = true,
			[recommendationIds.pendingFriendRequest] = true,
			[recommendationIds.incomingFriendRequest] = true,
			[recommendationIds.contact] = true
		}
	},
	byUserId = {
		["123456"] = {
			[recommendationIds.longName] = recommendation.mock({
				id = recommendationIds.longName,
				rank = 5
			}),
			[recommendationIds.noContext] = recommendation.mock({
				id = recommendationIds.noContext,
				contextType = recommendationContextType.None,
				rank = 6
			}),
			[recommendationIds.mutualContextPlural] = recommendation.mock({
				id = recommendationIds.mutualContextPlural,
				contextType = recommendationContextType.MutualFriends,
				mutualFriendsList = { "111", "222", "333" },
				rank = 10
			}),
			[recommendationIds.mutualContextSingle] = recommendation.mock({
				id = recommendationIds.mutualContextSingle,
				contextType = recommendationContextType.MutualFriends,
				mutualFriendsList = { "111" },
				rank = 12
			}),
			[recommendationIds.mutualContextNone] = recommendation.mock({
				id = recommendationIds.mutualContextNone,
				contextType = recommendationContextType.MutualFriends,
				mutualFriendsList = {},
				rank = 1
			}),
			[recommendationIds.frequentContext] = recommendation.mock({
				id = recommendationIds.frequentContext,
				contextType = recommendationContextType.Frequents,
				mutualFriendsList = {},
				rank = 0
			}),
			[recommendationIds.pendingFriendRequest] = recommendation.mock({
				id = recommendationIds.pendingFriendRequest,
				rank = 70
			}),
			[recommendationIds.incomingFriendRequest] = recommendation.mock({
				id = recommendationIds.incomingFriendRequest,
				rank = 71
			}),
			[recommendationIds.contact] = recommendation.new({
				id = recommendationIds.contact,
				rank = 80,
				contextType = recommendationContextType.Contacts,
				entityId = "contact_entity_1",
				entityDisplayName = "Contact Display Name",
				thumbnailEntities = {
					avatarImageUrl = "https://example.com/contact-avatar.png",
					headshotImageUrl = ""
				}
			})
		}
	},
	hasIncomingFriendRequest = 0
}

local incomingFriendRequestSet = { [recommendationIds.incomingFriendRequest] = true }
recommendations.hasIncomingFriendRequest = incomingFriendRequestSet
state.PYMKCarousel = {
	NetworkStatus = {},
	Users = users,
	Friends = {
		recommendations = recommendations,
		friendshipStatus = {
			[recommendationIds.pendingFriendRequest] = Enum.FriendStatus.FriendRequestSent
		}
	},
	Analytics = {
		bySessionKey = { [RECOMMENDATION_SESSION_ID_KEY] = "mockedRecommendationSessionId" }
	},
	Presence = {
		byUserId = {
			[recommendationIds.noContext] = { userPresenceType = PresenceType.Online }
		}
	}
}

return { recommendationIds = recommendationIds, state = state, recommendationIdsList = mapped }
