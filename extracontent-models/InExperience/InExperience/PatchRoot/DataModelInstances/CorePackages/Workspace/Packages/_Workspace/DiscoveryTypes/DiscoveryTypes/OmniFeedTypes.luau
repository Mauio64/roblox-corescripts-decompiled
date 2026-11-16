local parent = script:FindFirstAncestor("DiscoveryTypes").Parent

local SharedFlags = require(parent.SharedFlags)
return {
	GenreExplorer = "GenreExplorerLabel",
	Carousel = "Carousel",
	AvatarCarousel = "AvatarCarousel",
	UserInfo = "UserInfo",
	FriendCarousel = "FriendCarousel",
	FriendRecommendationCarousel = "FriendRecommendationCarousel",
	HomeGameGrid = "SortlessGrid",
	JoinYourFriendsCarousel = "JoinYourFriendsCarousel",
	ServerDrivenUi = "sdui",
	ServerDrivenUiV2 = "SduiV2",
	SearchGameGrid = "SearchGameGrid",
	SearchText = "SearchText",
	UpsellCard = "UpsellCard",
	Prompts = "Prompts",
	UserSearchGrid = "UserSearchGrid",
	Pills = "Pills",
	SearchPillCarousel = "SearchPillCarousel",
	SongCarousel = SharedFlags.FFlagEnableTopSongsSort and "SongCarousel" or nil
}
