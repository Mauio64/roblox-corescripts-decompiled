local Parent = script:FindFirstAncestor("DiscoveryTypes").Parent
local FFlagLuaAppHeaderButtonText = require(Parent.SharedFlags).FFlagLuaAppHeaderButtonText
local FFlagLuaAppGameCarouselAmpUpsellAction = require(Parent.SharedFlags).FFlagLuaAppGameCarouselAmpUpsellAction
local FFlagLuaAppRfySignalApportioningIxp = require(Parent.SharedFlags).FFlagLuaAppRfySignalApportioningIxp
local FFlagLuaAppEnableWhyThisAdModal = require(Parent.SharedFlags).FFlagLuaAppEnableWhyThisAdModal
local FFlagLuaAppEnableSponsoredReportAd = require(Parent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppChartsStickyHeader = require(Parent.SharedFlags).FFlagLuaAppChartsStickyHeader
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(Parent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
local FFlagLuaAppRfyRevealRows = require(Parent.SharedFlags).FFlagLuaAppRfyRevealRows
local FFlagLuaAppSortHeaderAnchorTag = require(Parent.SharedFlags).FFlagLuaAppSortHeaderAnchorTag
local FFlagSduiGenreSelector = require(Parent.SharedFlags).FFlagSduiGenreSelector

require(script.Parent.RoduxTypes)

return {
	EventContext = "HomeOmniFeed",
	OmniSortRetrievalStatus = {
		Exception = "Exception",
		Success = "Success"
	},
	GlobalLayoutDataKeys = {
		JYFRefresh = "JYFRefresh"
	},
	TopicLayoutDataKeys = {
		PYMKFindFriendsEnabled = "PYMKFindFriendsEnabled",
		PYMKSeeAllEnabled = "PYMKSeeAllEnabled",
		JYFFindFriendsEnabled = "JYFFindFriendsEnabled",
		ComponentType = "componentType",
		PlayerCountStyle = "playerCountStyle",
		IsSponsoredFooterAllowed = "isSponsoredFooterAllowed",
		LinkPath = "linkPath",
		SubtitleLinkPath = "subtitleLinkPath",
		HideSeeAll = "hideSeeAll",
		InfoText = "infoText",
		EndTimestamp = "endTimestamp",
		CountdownString = "countdownString",
		PlayButtonStyle = "playButtonStyle",
		BackgroundImageAssetId = "backgroundImageAssetId",
		HideTileMetadata = "hideTileMetadata",
		HideTileTitle = "hideTileTitle",
		ContainedTile = "containedTile",
		EnableExplicitFeedback = "enableExplicitFeedback",
		EnableSponsoredFeedback = "enableSponsoredFeedback",
		EnableCollectionGrid = "enableCollectionGrid",
		IsSponsoredRatingFooterAllowed = "isSponsoredRatingFooterAllowed",
		HeaderButtonText = if not FFlagLuaAppHeaderButtonText then nil else "headerButtonText",
		HasPrevalidatedVideoGamePlayability = if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else "hasPrevalidatedVideoGamePlayability",
		EnableSignalApportioning = if not FFlagLuaAppRfySignalApportioningIxp then nil else "enableSignalApportioning",
		SponsoredUserCohort = if not FFlagLuaAppEnableWhyThisAdModal then nil else "sponsoredUserCohort",
		SortHeaderAnchorTag = if not FFlagLuaAppSortHeaderAnchorTag then nil else "sortHeaderAnchorTag",
		InitialVisibleRows = if not FFlagLuaAppRfyRevealRows then nil else "initialVisibleRows",
		VisibleRowsPerReveal = if not FFlagLuaAppRfyRevealRows then nil else "visibleRowsPerReveal",
		EnableReportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else "enableReportAd",
		AmpUpsellFeatureName = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else "ampUpsellFeatureName",
		AmpUpsellNamespace = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else "ampUpsellNamespace"
	},
	ComponentTypeDataKeys = {
		EventTile = "EventTile",
		GridTile = "GridTile",
		AppGameTileNoMetadata = "AppGameTileNoMetadata"
	},
	ItemLayoutDataKeys = {
		Footer = "Footer"
	},
	OmniRecommendationsRequestIntent = {
		ManualRefresh = "manualRefresh",
		AutoRefresh = "autoRefresh",
		FriendPresenceChange = "friendPresenceChange",
		LogIn = "logIn",
		LoadMore = "loadMore",
		GameExit = "gameExit",
		AmpUpsellFeatureGranted = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else "ampUpsellFeatureGranted",
		OptionSelector = if not FFlagSduiGenreSelector then nil else "optionSelector"
	},
	ContentGroupType = {
		Game = "Game",
		Text = "Text",
		User = "User"
	},
	OmniFeedPageSection = if not FFlagLuaAppChartsStickyHeader then nil else {
		Header = "Header"
	}
}
