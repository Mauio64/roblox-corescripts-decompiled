local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local RecommendationContextType = require(PYMKCarousel.dependencies).RoduxFriends.Enums.RecommendationContextType

require(PYMKCarousel.Common.OmniTypes)

local Constants = require(PYMKCarousel.Common.Constants)
local t1 = {
	topicId = "topicId3",
	treatmentType = "FriendRecommendationCarousel",
	topic = "",
	recommendations = {
		[1] = {
			contentId = "RecommendedFriend1",
			contentType = "RecommendedFriend",
			contentMetadata = {
				rank = "10",
				recommendationRequestId = "recommendationSessionId",
				hasPendingFriendRequest = Constants.BE_FALSE_VALUE
			}
		},
		[2] = {
			contentId = "RecommendedFriend2",
			contentType = "RecommendedFriend",
			contentMetadata = {
				rank = "5",
				mutualFriendsCount = "5",
				recommendationRequestId = "recommendationSessionId",
				contextType = RecommendationContextType.MutualFriends.rawValue(),
				hasPendingFriendRequest = Constants.BE_TRUE_VALUE
			}
		},
		[3] = {
			contentId = "RecommendedFriend3",
			contentType = "RecommendedFriend",
			contentMetadata = {
				rank = "8",
				recommendationRequestId = "recommendationSessionId",
				contextType = RecommendationContextType.Frequents.rawValue(),
				hasPendingFriendRequest = Constants.BE_FALSE_VALUE
			}
		},
		[4] = {
			contentStringId = "RecommendedFriend4",
			contentId = "",
			contentType = "RecommendedFriend",
			contentMetadata = {
				rank = "1",
				recommendationRequestId = "recommendationSessionId",
				contextType = RecommendationContextType.Contacts.rawValue(),
				hasPendingFriendRequest = Constants.BE_FALSE_VALUE
			}
		}
	}
}
local t2 = {
	RecommendedFriend1 = {
		userName = "userName1",
		displayName = "displayName1",
		userId = "RecommendedFriend1",
		mutualFriendDisplayName = {},
		contextType = RecommendationContextType.Frequents.rawValue()
	},
	RecommendedFriend2 = {
		userName = "userName2",
		displayName = "displayName2",
		userId = "RecommendedFriend2",
		mutualFriendDisplayName = {},
		contextType = RecommendationContextType.None.rawValue()
	},
	RecommendedFriend3 = {
		userName = "userName3",
		displayName = "displayName3",
		userId = "RecommendedFriend3",
		contextType = "NotCorrect",
		mutualFriendDisplayName = {}
	},
	RecommendedFriend4 = {
		AvatarThumbnailUrl = "AvatarImageUrl",
		ContactId = "ContactId",
		ContactName = "ContactName",
		HeadshotThumbnailUrl = "HeadshotImageUrl",
		userId = "0",
		contextType = RecommendationContextType.Contacts.rawValue(),
		mutualFriendDisplayName = {}
	}
}
local t3 = {
	[1] = {
		topicId = "topicId1",
		treatmentType = "Carousel",
		topic = "TopicGames1",
		recommendations = {
			[1] = {
				contentId = "Game1",
				contentType = "Game",
				contentMetadata = {}
			},
			[2] = {
				contentId = "Game2",
				contentType = "Game",
				contentMetadata = {}
			}
		}
	},
	[2] = {
		topicId = "topicId2",
		treatmentType = "Carousel",
		topic = "TopicGames2",
		recommendations = {
			[1] = {
				contentId = "Game3",
				contentType = "Game",
				contentMetadata = {}
			}
		}
	}
}
local t4 = {
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
				sorts = {
					[1] = t3[1],
					[2] = t3[2],
					[3] = t1
				},
				metadata = {
					CatalogAsset = {},
					CatalogBundle = {},
					RecommendedFriend = t2,
					Game = t4
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
				sorts = {
					[1] = t3[1],
					[2] = t3[2]
				},
				metadata = {
					CatalogAsset = {},
					CatalogBundle = {},
					RecommendedFriend = {},
					Game = t4
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
					[1] = t3[1],
					[2] = t3[2],
					[3] = {
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
					Game = t4
				}
			}
		}
	},
	recommendedFriendMetadata = t2,
	recommendedFriendSort = t1
}
