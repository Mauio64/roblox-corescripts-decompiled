local parent = script:FindFirstAncestor("DiscoveryTypes").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppHeaderButtonText = SharedFlags.FFlagLuaAppHeaderButtonText
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppRfySignalApportioningIxp = SharedFlags2.FFlagLuaAppRfySignalApportioningIxp
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppEnableReportExperience = SharedFlags3.FFlagLuaAppEnableReportExperience

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = SharedFlags4.FFlagLuaAppUsePrevalidatedVideoGamePlayability
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppRfyRevealRows = SharedFlags5.FFlagLuaAppRfyRevealRows
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags6.FFlagLuaAppSortHeaderAnchorTag
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppContinueSortInstantPlay = SharedFlags7.FFlagLuaAppContinueSortInstantPlay
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppSupportHomeBackToTop = SharedFlags8.FFlagLuaAppSupportHomeBackToTop

require(script.Parent.RoduxTypes)

return {
	EventContext = "HomeOmniFeed",
	OmniSortRetrievalStatus = { Exception = "Exception", Success = "Success" },
	GlobalLayoutDataKeys = {
		JYFRefresh = "JYFRefresh",
		ShowBackToTop = FFlagLuaAppSupportHomeBackToTop and "showBackToTop" or nil
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
		HeaderButtonText = FFlagLuaAppHeaderButtonText and "headerButtonText" or nil,
		HideTileMetadata = "hideTileMetadata",
		HideTileTitle = "hideTileTitle",
		ContainedTile = "containedTile",
		HasPrevalidatedVideoGamePlayability = FFlagLuaAppUsePrevalidatedVideoGamePlayability and "hasPrevalidatedVideoGamePlayability" or nil,
		EnableExplicitFeedback = "enableExplicitFeedback",
		EnableSignalApportioning = FFlagLuaAppRfySignalApportioningIxp and "enableSignalApportioning" or nil,
		SponsoredUserCohort = "sponsoredUserCohort",
		EnableSponsoredFeedback = "enableSponsoredFeedback",
		EnableCollectionGrid = "enableCollectionGrid",
		SortHeaderAnchorTag = FFlagLuaAppSortHeaderAnchorTag and "sortHeaderAnchorTag" or nil,
		InitialFeedVisibleRows = FFlagLuaAppRfyRevealRows and "initialFeedVisibleRows" or nil,
		VisibleRowsPerReveal = FFlagLuaAppRfyRevealRows and "visibleRowsPerReveal" or nil,
		EnableReportAd = "enableReportAd",
		EnableReportExperience = FFlagLuaAppEnableReportExperience and "enableReportExperience" or nil,
		IsSponsoredRatingFooterAllowed = "isSponsoredRatingFooterAllowed",
		AmpUpsellFeatureName = "ampUpsellFeatureName",
		AmpUpsellNamespace = "ampUpsellNamespace",
		EnableInstantPlay = FFlagLuaAppContinueSortInstantPlay and "enableInstantPlay" or nil,
		InstantPlayTreatment = FFlagLuaAppContinueSortInstantPlay and "instantPlayTreatment" or nil
	},
	ComponentTypeDataKeys = {
		EventTile = "EventTile",
		GridTile = "GridTile",
		AppGameTileNoMetadata = "AppGameTileNoMetadata"
	},
	ItemLayoutDataKeys = { Footer = "Footer" },
	OmniRecommendationsRequestIntent = {
		ManualRefresh = "manualRefresh",
		AutoRefresh = "autoRefresh",
		FriendPresenceChange = "friendPresenceChange",
		LogIn = "logIn",
		LoadMore = "loadMore",
		GameExit = "gameExit",
		AmpUpsellFeatureGranted = "ampUpsellFeatureGranted",
		OptionSelector = "optionSelector"
	},
	ContentGroupType = { Game = "Game", Text = "Text", User = "User" },
	OmniFeedPageSection = { Header = "Header" }
}
