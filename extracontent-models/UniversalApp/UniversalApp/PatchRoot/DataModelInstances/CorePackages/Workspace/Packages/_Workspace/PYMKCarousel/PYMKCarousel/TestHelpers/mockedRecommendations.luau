local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local Dash = dependencies.Dash
local RoduxFriends = dependencies.RoduxFriends
local RoduxUsers = dependencies.RoduxUsers
local SocialCommon = dependencies.SocialCommon
local Recommendation = RoduxFriends.Models.Recommendation
local RecommendationContextType = RoduxFriends.Enums.RecommendationContextType
local User = RoduxUsers.Models.User
local RecommendationSourceEnum = SocialCommon.Enums.RecommendationSourceEnum
local RECOMMENDATION_SESSION_ID_KEY = require(PYMKCarousel.Common.Constants).RECOMMENDATION_SESSION_ID_KEY
local PresenceType = require(PYMKCarousel.installReducer.RoduxPresence).Enums.PresenceType
local HomepagePYMKCarousel = RecommendationSourceEnum.HomepagePYMKCarousel
local t1 = {
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
local v15 = Dash.map(Dash.values(t1), function(p1) -- line: 32
	return {
		id = p1
	}
end)
local t2 = {
	LocalUserId = "123456",
	ScreenSize = Vector2.new(1920, 1080),
	TopBar = {
		topBarHeight = 10
	},
	GlobalGuiInset = {
		bottom = 10
	},
	PYMKCarousel = {
		NetworkStatus = {},
		Users = {
			byUserId = {
				[t1.longName] = User.mock({
					displayName = "Very Long Display Name"
				}),
				[t1.noContext] = User.mock(),
				[t1.mutualContextPlural] = User.mock(),
				[t1.mutualContextSingle] = User.mock(),
				[t1.mutualContextNone] = User.mock(),
				[t1.frequentContext] = User.mock(),
				[t1.pendingFriendRequest] = User.mock(),
				[t1.incomingFriendRequest] = User.mock(),
				[t1.contact] = User.mock()
			}
		},
		Friends = {
			recommendations = {
				bySource = {
					[HomepagePYMKCarousel] = {
						[t1.longName] = true,
						[t1.noContext] = true,
						[t1.mutualContextPlural] = true,
						[t1.mutualContextSingle] = true,
						[t1.mutualContextNone] = true,
						[t1.frequentContext] = true,
						[t1.pendingFriendRequest] = true,
						[t1.incomingFriendRequest] = true,
						[t1.contact] = true
					}
				},
				byUserId = {
					["123456"] = {
						[t1.longName] = Recommendation.mock({
							rank = 5,
							id = t1.longName
						}),
						[t1.noContext] = Recommendation.mock({
							rank = 6,
							id = t1.noContext,
							contextType = RecommendationContextType.None
						}),
						[t1.mutualContextPlural] = Recommendation.mock({
							rank = 10,
							id = t1.mutualContextPlural,
							contextType = RecommendationContextType.MutualFriends,
							mutualFriendsList = {
								"111",
								"222",
								"333"
							}
						}),
						[t1.mutualContextSingle] = Recommendation.mock({
							rank = 12,
							id = t1.mutualContextSingle,
							contextType = RecommendationContextType.MutualFriends,
							mutualFriendsList = { "111" }
						}),
						[t1.mutualContextNone] = Recommendation.mock({
							rank = 1,
							id = t1.mutualContextNone,
							contextType = RecommendationContextType.MutualFriends,
							mutualFriendsList = {}
						}),
						[t1.frequentContext] = Recommendation.mock({
							rank = 0,
							id = t1.frequentContext,
							contextType = RecommendationContextType.Frequents,
							mutualFriendsList = {}
						}),
						[t1.pendingFriendRequest] = Recommendation.mock({
							rank = 70,
							id = t1.pendingFriendRequest
						}),
						[t1.incomingFriendRequest] = Recommendation.mock({
							rank = 71,
							id = t1.incomingFriendRequest
						}),
						[t1.contact] = Recommendation.new({
							rank = 80,
							entityId = "contact_entity_1",
							entityDisplayName = "Contact Display Name",
							id = t1.contact,
							contextType = RecommendationContextType.Contacts,
							thumbnailEntities = {
								avatarImageUrl = "https://example.com/contact-avatar.png",
								headshotImageUrl = ""
							}
						})
					}
				},
				hasIncomingFriendRequest = {
					[t1.incomingFriendRequest] = true
				}
			},
			friendshipStatus = {
				[t1.pendingFriendRequest] = Enum.FriendStatus.FriendRequestSent
			}
		},
		Analytics = {
			bySessionKey = {
				[RECOMMENDATION_SESSION_ID_KEY] = "mockedRecommendationSessionId"
			}
		},
		Presence = {
			byUserId = {
				[t1.noContext] = {
					userPresenceType = PresenceType.Online
				}
			}
		}
	}
}

return {
	recommendationIds = t1,
	state = t2,
	recommendationIdsList = v15
}
