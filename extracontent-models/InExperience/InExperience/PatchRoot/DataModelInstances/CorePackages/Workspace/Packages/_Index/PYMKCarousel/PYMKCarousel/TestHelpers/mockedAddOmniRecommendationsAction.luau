local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
require(PYMKCarousel.Common.OmniTypes)
local Constants = require(PYMKCarousel.Common.Constants)

local recommendedFriendSort = {
	topicId = "topicId3",
	treatmentType = "FriendRecommendationCarousel",
	topic = "",
	recommendations = {
		{
			contentId = "RecommendedFriend1",
			contentType = "RecommendedFriend",
			contentMetadata = {
				rank = "10",
				recommendationRequestId = "recommendationSessionId",
				hasPendingFriendRequest = Constants.BE_FALSE_VALUE
			}
		},
		{
			contentId = "RecommendedFriend2",
			contentType = "RecommendedFriend",
			contentMetadata = {
				rank = "5",
				mutualFriendsCount = "5",
				contextType = recommendationContextType.MutualFriends.rawValue(),
				recommendationRequestId = "recommendationSessionId",
				hasPendingFriendRequest = Constants.BE_TRUE_VALUE
			}
		},
		{
			contentId = "RecommendedFriend3",
			contentType = "RecommendedFriend",
			contentMetadata = {
				rank = "8",
				contextType = recommendationContextType.Frequents.rawValue(),
				recommendationRequestId = "recommendationSessionId",
				hasPendingFriendRequest = Constants.BE_FALSE_VALUE
			}
		},
		{
			contentStringId = "RecommendedFriend4",
			contentId = "",
			contentType = "RecommendedFriend",
			contentMetadata = {
				rank = "1",
				contextType = recommendationContextType.Contacts.rawValue(),
				recommendationRequestId = "recommendationSessionId",
				hasPendingFriendRequest = Constants.BE_FALSE_VALUE
			}
		}
	}
}

local v = {
	RecommendedFriend1 = {
		userName = "userName1",
		mutualFriendDisplayName = {},
		displayName = "displayName1",
		userId = "RecommendedFriend1",
		contextType = recommendationContextType.Frequents.rawValue()
	},
	RecommendedFriend2 = {
		userName = "userName2",
		mutualFriendDisplayName = {},
		displayName = "displayName2",
		userId = "RecommendedFriend2",
		contextType = recommendationContextType.None.rawValue()
	},
	RecommendedFriend3 = {
		userName = "userName3",
		mutualFriendDisplayName = {},
		displayName = "displayName3",
		userId = "RecommendedFriend3",
		contextType = "NotCorrect"
	},
	RecommendedFriend4 = {
		AvatarThumbnailUrl = "AvatarImageUrl",
		ContactId = "ContactId",
		ContactName = "ContactName",
		HeadshotThumbnailUrl = "HeadshotImageUrl",
		contextType = recommendationContextType.Contacts.rawValue(),
		mutualFriendDisplayName = {},
		userId = "0"
	}
}

local v2 = {
	{
		topicId = "topicId1",
		treatmentType = "Carousel",
		topic = "TopicGames1",
		recommendations = {
			{ contentId = "Game1", contentType = "Game", contentMetadata = {} },
			{ contentId = "Game2", contentType = "Game", contentMetadata = {} }
		}
	},
	{
		topicId = "topicId2",
		treatmentType = "Carousel",
		topic = "TopicGames2",
		recommendations = {
			{ contentId = "Game3", contentType = "Game", contentMetadata = {} }
		}
	}
}

local Game = {
	Game1 = {
		universeId = "universeId1",
		name = "name1",
		totalUpVotes = 123,
		totalDownVotes = 123,
		placeId = "placeId1",
		playerCount = 123
	},
	Game2 = {
		universeId = "universeId2",
		name = "name2",
		totalUpVotes = 123,
		totalDownVotes = 123,
		placeId = "placeId2",
		playerCount = 123
	},
	Game3 = {
		universeId = "universeId3",
		name = "name3",
		totalUpVotes = 123,
		totalDownVotes = 123,
		placeId = "placeId3",
		playerCount = 123
	}
}

return {
	withoutContent = {
		type = "AddOmniRecommendations",
		recommendationsId = "recommendationsId",
		pageType = "Home",
		sortsExpirationTime = 2434324,
		recommendations = {}
	},
	withRecommendedFriends = {
		type = "AddOmniRecommendations",
		recommendationsId = "recommendationsId",
		pageType = "Home",
		sortsExpirationTime = 2434324,
		recommendations = {
			Home = {
				omniSessionId = "omniSessionId1",
				sorts = { v2[1], v2[2], recommendedFriendSort },
				metadata = {
					CatalogAsset = {},
					CatalogBundle = {},
					RecommendedFriend = v,
					Game = Game
				}
			}
		}
	},
	withoutRecommendedFriends = {
		type = "AddOmniRecommendations",
		recommendationsId = "recommendationsId",
		pageType = "Home",
		sortsExpirationTime = 2434324,
		recommendations = {
			Home = {
				omniSessionId = "omniSessionId1",
				sorts = { v2[1], v2[2] },
				metadata = {
					CatalogAsset = {},
					CatalogBundle = {},
					RecommendedFriend = {},
					Game = Game
				}
			}
		}
	},
	invalidRecommendedFriendsSort = {
		type = "AddOmniRecommendations",
		recommendationsId = "recommendationsId",
		pageType = "Home",
		sortsExpirationTime = 2434324,
		recommendations = {
			Home = {
				omniSessionId = "omniSessionId1",
				sorts = {
					v2[1],
					v2[2],
					{
						topicId = "topicId3",
						treatmentType = "FriendRecommendationCarousel",
						topic = "",
						recommendations = nil
					}
				},
				metadata = {
					CatalogAsset = {},
					CatalogBundle = {},
					RecommendedFriend = {},
					Game = Game
				}
			}
		}
	},
	recommendedFriendMetadata = v,
	recommendedFriendSort = recommendedFriendSort
}
