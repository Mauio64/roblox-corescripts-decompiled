local fFlagLuaAppHeaderButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppHeaderButtonText
local fFlagLuaAppRfySignalApportioningIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppRfySignalApportioningIxp
local fFlagLuaAppEnableReportExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppEnableReportExperience

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppUsePrevalidatedVideoGamePlayability
local fFlagLuaAppRfyRevealRows = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppRfyRevealRows
local fFlagLuaAppSortHeaderAnchorTag = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppSortHeaderAnchorTag
local fFlagLuaAppContinueSortInstantPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppSupportHomeBackToTop = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppSupportHomeBackToTop

require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/RoduxTypes")

return {
	EventContext = "HomeOmniFeed",
	OmniSortRetrievalStatus = { Exception = "Exception", Success = "Success" },
	GlobalLayoutDataKeys = {
		JYFRefresh = "JYFRefresh",
		ShowBackToTop = fFlagLuaAppSupportHomeBackToTop and "showBackToTop" or nil
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
		HeaderButtonText = fFlagLuaAppHeaderButtonText and "headerButtonText" or nil,
		HideTileMetadata = "hideTileMetadata",
		HideTileTitle = "hideTileTitle",
		ContainedTile = "containedTile",
		HasPrevalidatedVideoGamePlayability = fFlagLuaAppUsePrevalidatedVideoGamePlayability and "hasPrevalidatedVideoGamePlayability" or nil,
		EnableExplicitFeedback = "enableExplicitFeedback",
		EnableSignalApportioning = fFlagLuaAppRfySignalApportioningIxp and "enableSignalApportioning" or nil,
		SponsoredUserCohort = "sponsoredUserCohort",
		EnableSponsoredFeedback = "enableSponsoredFeedback",
		EnableCollectionGrid = "enableCollectionGrid",
		SortHeaderAnchorTag = fFlagLuaAppSortHeaderAnchorTag and "sortHeaderAnchorTag" or nil,
		InitialFeedVisibleRows = fFlagLuaAppRfyRevealRows and "initialFeedVisibleRows" or nil,
		VisibleRowsPerReveal = fFlagLuaAppRfyRevealRows and "visibleRowsPerReveal" or nil,
		EnableReportAd = "enableReportAd",
		EnableReportExperience = fFlagLuaAppEnableReportExperience and "enableReportExperience" or nil,
		IsSponsoredRatingFooterAllowed = "isSponsoredRatingFooterAllowed",
		AmpUpsellFeatureName = "ampUpsellFeatureName",
		AmpUpsellNamespace = "ampUpsellNamespace",
		EnableInstantPlay = fFlagLuaAppContinueSortInstantPlay and "enableInstantPlay" or nil,
		InstantPlayTreatment = fFlagLuaAppContinueSortInstantPlay and "instantPlayTreatment" or nil
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
