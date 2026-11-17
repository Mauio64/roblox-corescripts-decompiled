local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsTypes = require(parent.MomentsTypes)
local RecommendationConfigType = require(Moments.Enums.RecommendationConfigType)
local ReactionType = MomentsTypes.Enums.ReactionType

local recommendationConfig = {
	[RecommendationConfigType.Default] = { ConfigName = "RecentlyAdded", LocationId = "Trending" },
	[RecommendationConfigType.Trending] = { ConfigName = "MaximizeJoins", LocationId = "Trending" },
	[RecommendationConfigType.PlayerOwnedItems] = {
		ConfigName = "PlayerOwnedItems",
		LocationId = "My Moments"
	},
	[RecommendationConfigType.PlayerSpecific] = {
		ConfigName = "PlayerSpecific",
		LocationId = "User Profile"
	}
}
return {
	DisplayOrder = { Feed = 100, FeedTopBar = 101, Modals = 400 },
	ZIndex = { PostStatusCard = 9, Toasts = 10, Dialog = 20 },
	MaxSize = { BottomUI = Vector2.new(600, 1e999) },
	RecommendationConfig = recommendationConfig,
	ImmersiveFeedKind = { Trending = "trending", User = "user" },
	DefaultReaction = ReactionType.ThumbsUp,
	PlaceholderTracingId = {
		DeepLinked = "deep-linked-placeholder",
		RecentlyUploaded = "recently-uploaded-placeholder"
	},
	ToastVariant = { PostSuccessShare = "postSuccessShare" },
	LaunchToastPriority = { PostSuccessShare = 1, Engagement = 2 },
	ConfigKeys = {
		PostSuccessShareToastEnabled = "post_success_share_toast_enabled",
		PostSuccessShareToastImpressionEnabled = "post_success_share_toast_impression_enabled"
	},
	PointerPanVerticalDominatesRatio = 1.25,
	TrackpadHorizontalTabNavigationAccumThreshold = 0.38,
	EaseInOut = { 0.19, 1, 0.22, 1 },
	EaseInCubic = { 0.3, 0, 0.7, 0 },
	ShareLinkExpirationTime = 2419200,
	MOMENTS_UNIVERSE_ID = "8357232245",
	MOMENTS_PLACE_ID = "119524072047648",
	SOURCE_SURFACE = "moments_tab",
	RecommendationActionType = {
		AddReaction = 1,
		RemoveReaction = 2,
		Share = 3,
		Report = 4,
		Comment = 5,
		Play = 6,
		Purchase = 7,
		CommentDelete = 8,
		CommentSectionOpen = 9
	},
	CapturesAssetId = "rbxassetid://117011861606730",
	HowToCaptureModalSteps = {
		image1 = "rbxassetid://91055014485206",
		image2 = "rbxassetid://107813398556114",
		image3 = "rbxassetid://75489087089000"
	},
	NonRootPlaceErrorMessages = "The Source Place and the Destination Place are not in the same Universe.",
	UserCannotJoin = "A specified Member cannot join the Destination Place",
	PostStatusToastNotificationType = "MomentPostStatus"
}
