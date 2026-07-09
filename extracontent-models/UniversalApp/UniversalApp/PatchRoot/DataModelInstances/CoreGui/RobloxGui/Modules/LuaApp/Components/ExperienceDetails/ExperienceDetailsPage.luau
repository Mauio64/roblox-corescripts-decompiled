local LocalizationService = game:GetService("LocalizationService")
local IXPService = game:GetService("IXPService")
local AppStorageService = game:GetService("AppStorageService")
local CorePackages = game:GetService("CorePackages")
local v5 = game:DefineFastFlag("LuaAppRemoveEDPLoadingState", false)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useTokens = Foundation.Hooks.useTokens
local ButtonSize = Foundation.Enums.ButtonSize
local UIBlox = require(CorePackages.Packages.UIBlox)
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local EmptyState = UIBlox.App.Indicator.EmptyState
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Core.Style.withStyle
local DetailsPageSelector = require(CorePackages.Workspace.Packages.AppBlox).DetailsPageSelector
local ContentPosition = require(CorePackages.Workspace.Packages.AppBlox).ContentPosition
local useCloseWithBackButton = require(CorePackages.Workspace.Packages.AppBlox).useCloseWithBackButton
local Images = UIBlox.App.ImageSet.Images
local PlayerCount = UIBlox.App.Indicator.PlayerCount
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local MenuDirection = UIBlox.App.Menu.MenuDirection
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local DeviceType = RobloxAppEnums.DeviceType
local UiMode = RobloxAppEnums.UiMode
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local abbreviateCount = require(CorePackages.Workspace.Packages.Localization).abbreviateCount
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local GameStats = require(CorePackages.Workspace.Packages.GameTile).GameStats
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local ExperienceDetailsExperimentation = require(script.Parent.ExperienceDetailsExperimentation)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Display = require(CorePackages.Workspace.Packages.Display)
local ExperienceCommunityLink = require(CorePackages.Workspace.Packages.CommunityLinks).Components.ExperienceCommunityLink
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local AgeRecommendationDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.AgeRecommendationDetails
local ExperienceDetailsNoticeType = require(CorePackages.Workspace.Packages.DiscoveryTypes).ExperienceDetailsNoticeType
local EnumGameDetailErrorTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes).EnumGameDetailErrorTypes
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local ExperienceRatings = Modules.LuaApp.Components.ExperienceDetails.ExperienceRatings
local getPlayButtonProps = Modules.LuaApp.Common.Experience.getPlayButtonProps
local GamePlayButton = require(CorePackages.Workspace.Packages.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local PlayWithRewardComponent = require(CorePackages.Workspace.Packages.PlayWithRewardComponent).PlayWithRewardComponent
local checkAndFormatPossibleLink = require(CorePackages.Workspace.Packages.CollectionViews).checkAndFormatPossibleLink
local RetrievalStatus2 = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules2.LuaApp.Constants)
local TransitionAnimation = require(Modules2.LuaApp.Enum.TransitionAnimation)
local openExternalBrowser = require(Modules2.LuaApp.openExternalBrowser)
local EventsListWrapper = require(Modules2.LuaApp.Components.VirtualEvents.EventsListWrapper)
local GameRefundPolicy = require(Modules2.LuaApp.Components.GameDetails.GameRefundPolicy)
local GameDetailNotificationsButtonHint = require(Modules2.LuaApp.Components.GameDetails.GameDetailNotificationsButtonHint)
local ExperienceDescription = require(script.Parent.ExperienceDescription)
local IgrsRatingLabel = require(script.Parent.IgrsRatingLabel)
local ExperienceLogoTray = require(script.Parent.ExperienceLogoTray)
local ExperienceInfoTable = require(script.Parent.ExperienceInfoTable)
local ExperienceDetailsLoadingStatePage = require(script.Parent.ExperienceDetailsLoadingStatePage)
local ExperienceMediaGallery = require(script.Parent.ExperienceMediaGallery)
local ExperienceTagsContainer = require(script.Parent.ExperienceTagsContainer)
local RecommendedExperienceCarousel = require(script.Parent.RecommendedExperienceCarousel)
local ExperienceSongsCarousel = require(script.Parent.ExperienceSongsCarousel)
local ApiFetchExperienceDetailsPageCounters = require(Modules2.LuaApp.Thunks.ApiFetchExperienceDetailsPageCounters)
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local EdpSduiUtils = require(script.Parent.EdpSduiUtils)
local useEdpServerIxpVariables = require(script.Parent.Hooks.useEdpServerIxpVariables)
local useEdpPerUniverseVisibilityVariablesForUniverse = require(script.Parent.Hooks.useEdpPerUniverseVisibilityVariablesForUniverse)
local EdpSocialLinksImpressionsDetector = require(Modules2.LuaApp.Components.ExperienceDetails.EdpSocialLinksImpressionsDetector)
local PlayButtonContextualMessageImpressionsDetector = GamePlayButton.PlayButtonContextualMessageImpressionsDetector
local GameDetailTelemetry = require(CorePackages.Workspace.Packages.GameDetailTelemetry)
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants
local FFlagEDPTTITrackingEnabled = GameDetailTelemetry.FFlagEDPTTITrackingEnabled
local useEDPTTITracking = require(script.Parent.useEDPTTITracking)
local useFirstMediaCarouselImageUri = require(script.Parent.useFirstMediaCarouselImageUri).useFirstMediaCarouselImageUri
local GetFFlagEnableTenftUiDetailsMoreDropupMenu = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableTenftUiDetailsMoreDropupMenu
local GetFFlagExpDetailsUseSelectionBumpers = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagExpDetailsUseSelectionBumpers
local FFlagExperienceDetailsTextUseTokens = require(script.Parent.Flags.FFlagExperienceDetailsTextUseTokens)
local GetFFlagLuaAppEnableNotificationsEDPTooltip = require(Modules2.LuaApp.Flags.GetFFlagLuaAppEnableNotificationsEDPTooltip)
local GetFIntNotificationsEDPTooltipTimeLimit = require(Modules2.LuaApp.Flags.GetFIntNotificationsEDPTooltipTimeLimit)
local GetFFlagConsoleApplyTokenizationEdp = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagConsoleApplyTokenizationEdp
local FFlagLuaAppEnablePlaySquadButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnablePlaySquadButton
local GetFFlagNotificationsForceEnableEDPDiscoverability = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagNotificationsForceEnableEDPDiscoverability
local FFlagLuaAppDesktopMediaGalleryTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDesktopMediaGalleryTelemetry
local FFlagLuaAppEdpFixDefaultBanner = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpFixDefaultBanner
local FFlagSongEdpCarouselIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSongEdpCarouselIxp
local FFlagLuaAppExperienceDetailsLayoutOrderConfig = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppExperienceDetailsLayoutOrderConfig
local FFlagLuaAppEdpMediaGalleryRedesignIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignIxp
local FFlagLuaAppEnableConsolidatedGameRefundPolicy = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableConsolidatedGameRefundPolicy
local FFlagLuaAppEdpMediaGalleryFullScreen = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FFlagLuaAppEdpMediaGalleryAutoAdvance = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryAutoAdvance
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local FFlagEnableCreatorSubtitleNavigation = require(Modules2.LuaApp.Flags.FFlagEnableCreatorSubtitleNavigation)
local FFlagCreatorSubtitleNavigationIXPEnabled = require(Modules2.LuaApp.Flags.FFlagCreatorSubtitleNavigationIXPEnabled)
local FStringCreatorSubtitleNavigationExperimentLayer = require(Modules2.LuaApp.Flags.FStringCreatorSubtitleNavigationExperimentLayer)
local FFlagLuaAppEdpMediaGalleryRedesignTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignTelemetry
local FFlagLuaAppUnifyPlayButtonNonMobileEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUnifyPlayButtonNonMobileEdp
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
local FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local FFlagLuaAppUnifiedPlayButtonSquadMenuDirection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUnifiedPlayButtonSquadMenuDirection
local FFlagLuaAppGameStatsFallbackRendering = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGameStatsFallbackRendering
local FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp
local FFlagLuaAppAddSocialLinkClickTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkClickTelemetryToEdp
local FFlagLuaAppExpandableTextImpressionsEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppExpandableTextImpressionsEnabled
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagEnablePlayWithRewardNonPeekviewEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePlayWithRewardNonPeekviewEdp
local GetFFlagUIBloxUseFoundationButton = require(CorePackages.Workspace.Packages.SharedFlags).UIBlox.GetFFlagUIBloxUseFoundationButton
local FFlagLuaAppPlayButtonOptOutFoundationButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayButtonOptOutFoundationButton
local v132 = game:DefineFastInt("PlayWithRewardNonPeekviewEdpLayoutOrder", 75)
local v133 = if not FFlagLuaAppGameStatsFallbackRendering then nil else "--"
local t1 = {
	MediaGalleryMediaFirst = 100,
	EventsListRedesign = 200,
	Description = 300,
	MediaGallery = 400,
	IgrsRatingLabel = 450,
	ExperienceRatings = 500,
	PlaysAndVisits = 600,
	CommunityLink = 700,
	ExperienceInfoTable = 800,
	RefundPolicy = 900,
	LogoTraySection = 1000,
	Notice = 1200,
	RecommendedExperiences = 1300,
	ExperienceSongsCarousel = 1400,
	SduiFeedItemsDefault = 1500,
	PlayWithReward = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else v132
}
local t2 = {
	MediaGallery = 100,
	EventsListRedesign = 200,
	Description = 300,
	IgrsRatingLabel = 350,
	RecommendedExperiences = 500,
	ExperienceSongsCarousel = 600,
	ExperienceRatings = 700,
	PlaysAndVisits = 800,
	CommunityLink = 900,
	ExperienceInfoTable = 1000,
	RefundPolicy = 1100,
	LogoTraySection = 1200,
	Notice = 1300,
	SduiFeedItemsDefault = 1500,
	PlayWithReward = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else v132
}
local v136 = Roact.PureComponent:extend("ExperienceDetailsPage")

v136.validateProps = t.strictInterface({
	universeId = t.string,
	referralSource = t.optional(t.string),
	experienceJoinData = if not FFlagLuaAppUnifyPlayButtonNonMobileEdp and not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else t.optional(t.table),
	placeIdOverride = t.optional(t.string),
	onClose = t.callback,
	thumbnail = t.optional(t.table),
	bannerImageId = t.optional(t.string),
	defaultBannerUrl = if not FFlagLuaAppEdpFixDefaultBanner then nil else t.optional(t.string),
	gameInfo = t.optional(t.table),
	gameDetail = t.optional(t.table),
	gameDetailError = t.optional(t.table),
	creatorVerified = t.optional(t.boolean),
	gameDetailsPageDataStatus = t.optional(t.string),
	gameProductInfo = t.optional(t.table),
	socialLinks = t.optional(t.table),
	ageRecommendations = t.optional(AgeRecommendationDetails.validateModel),
	communityLink = t.optional(t.table),
	gameFollowings = t.optional(t.table),
	sduiFeedItemConfigs = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else t.optional(t.table),
	playWithRewardData = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else t.optional(t.table),
	showPlayWithReward = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else t.optional(t.boolean),
	isPlayable = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else t.optional(t.boolean),
	communityLinksEnabled = t.optional(t.boolean),
	communityLinkVariant = t.optional(t.string),
	enableNotificationsDiscoverability = t.optional(t.boolean),
	mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else t.optional(t.boolean),
	mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else t.optional(t.boolean),
	showSongCarousel = if not FFlagSongEdpCarouselIxp then nil else t.optional(t.boolean),
	shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t.optional(t.boolean),
	shouldInterleaveSduiIxp = if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else t.optional(t.boolean),
	edpServerIxpVariables = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else t.optional(t.table),
	edpPerUniverseVisibilityVariables = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable) then nil else t.optional(t.table),
	hideCloseButton = t.optional(t.boolean),
	hasUnifiedPlayButtonIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else t.optional(t.boolean),
	unifyToUIBloxIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else t.optional(t.boolean),
	fetchGameDetailsPageData = t.callback,
	openLeaveRobloxAlertUIBlox = t.callback,
	openMoreContextualMenu = t.callback,
	openShareContextualMenu = t.callback,
	closeAlert = t.callback,
	openVerifiedBadgeModal = t.optional(t.callback),
	openCreatorPage = if not FFlagEnableCreatorSubtitleNavigation then t.callback else nil,
	openCommunityProfilePage = if not FFlagEnableCreatorSubtitleNavigation then nil else t.optional(t.callback),
	openUserProfilePage = if not FFlagEnableCreatorSubtitleNavigation then nil else t.optional(t.callback),
	openExperienceGuidelinesExplained = t.callback,
	toggleFollowExperience = t.optional(t.callback),
	openRefundPolicyLearnMorePage = t.callback,
	openWebview = t.callback,
	onMediaGalleryPreviewActivated = if not FFlagLuaAppDesktopMediaGalleryTelemetry or FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else t.optional(t.callback),
	onMediaGalleryThumbnailActivated = if not FFlagLuaAppDesktopMediaGalleryTelemetry or FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else t.optional(t.callback),
	onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else t.optional(t.callback),
	onMediaGalleryEnterFullscreen = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else t.optional(t.callback),
	onMediaGalleryExitFullscreen = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else t.optional(t.callback),
	linking = t.table,
	playabilityStatus = t.optional(t.table),
	playButtonState = t.string,
	onPlayButtonActivated = t.callback,
	onPlaySquadButtonActivated = if not FFlagLuaAppEnablePlaySquadButton then nil else t.callback,
	playButtonContextualMessage = t.optional(t.string),
	deviceType = t.optional(t.string),
	detailsPageConfiguration = t.optional(t.table),
	viewWidth = t.optional(t.number),
	viewHeight = t.optional(t.number),
	setControllerBarNavigation = t.optional(t.callback),
	uiModeInfo = t.optional(t.any),
	focusGuiObject = t.optional(t.callback),
	tokens = t.strictInterface({
		thumbnailSize = t.optional(t.number),
		thumbnailMargin = t.optional(t.number),
		thumbnailShadowHeight = t.optional(t.number),
		sideMargin = t.optional(t.number),
		headerItemPadding = t.optional(t.number),
		headerDescriptionMaxRows = t.optional(t.number),
		headerDescriptionLineHeight = t.optional(t.number),
		actionBarButtonBackgroundColor = t.optional(t.table),
		actionBarTextButtonPadding = t.optional(t.Vector2),
		headerGradientHeight = t.optional(t.number),
		headerBarBackgroundHeight = t.optional(t.number),
		headerBottomMargin = t.optional(t.number),
		animationConfig = t.optional(t.table),
		itemPadding = t.optional(t.number),
		safeAreaSize = t.optional(t.Vector2),
		trailingWhitespace = t.optional(t.number),
		iconSize = t.optional(t.number),
		expandableAreaHeightOffset = if not GetFFlagConsoleApplyTokenizationEdp() then nil else t.optional(t.number),
		actionBarHeight = t.optional(t.number)
	}),
	webViewSupport = t.boolean,
	notificationsCanEnableExperience = t.optional(t.boolean),
	experienceDetailsNoticeType = t.optional(t.string),
	iconButtonSize = t.optional(t.UDim2),
	textButtonSize = t.optional(t.UDim2),
	playButtonSize = t.optional(t.UDim2),
	actionBarHeight = t.optional(t.number),
	statsAndInfoRef = t.optional(t.table),
	playButtonRef = t.optional(t.union(t.table, t.callback)),
	containerRef = t.optional(t.union(t.table, t.callback)),
	foundationTokens = t.optional(t.table),
	disableStickyActionBar = t.optional(t.boolean)
})

local function createImageURL(p1) -- line: 377
	if p1 then
		return "rbxassetid://" .. p1
	end

	return ""
end

local t3 = {
	showEventsList = true,
	showLogoTraySection = true,
	showCornerGradientPropEnabled = false,
	showCommunityLink = false
}

function v136.init(p2) -- line: 392
	-- upvalues: Localization (copy), LocalizationService (copy), abbreviateCount (copy), UiMode (copy), GetFFlagEnableTenftUiDetailsMoreDropupMenu (copy), FFlagEnableLeftNavOnConsole (copy), Display (copy), memoize (copy), Text (copy), FFlagLuaAppGameStatsFallbackRendering (copy), Roact (copy), StyledTextLabel (copy), GetFFlagLuaAppEnableNotificationsEDPTooltip (copy), withStyle (copy), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagCreatorSubtitleNavigationIXPEnabled (copy), IXPServiceWrapper (copy), FStringCreatorSubtitleNavigationExperimentLayer (copy), AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy), FFlagEnableCreatorSubtitleNavigation (copy), VerifiedBadges (copy), React (copy), ExperienceTagsContainer (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameStats (copy), PlayerCount (copy), v133 (copy), Images (copy), ExperienceDescription (copy), RetrievalStatus (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), withLocalization (copy), PlayButtonContextualMessageImpressionsDetector (copy), IgrsRatingLabel (copy), Constants (copy), openExternalBrowser (copy), FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), AppCommonLib (copy), ExperienceLogoTray (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), EdpSocialLinksImpressionsDetector (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppDesktopMediaGalleryTelemetry (copy), ExperienceMediaGallery (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), ExperienceRatings (copy), ExperienceInfoTable (copy), EventsListWrapper (copy), RecommendedExperienceCarousel (copy), FFlagSongEdpCarouselIxp (copy), ExperienceSongsCarousel (copy), ExperienceCommunityLink (copy), checkAndFormatPossibleLink (copy), FFlagLuaAppEnableConsolidatedGameRefundPolicy (copy), GameRefundPolicy (copy), FFlagEnablePlayWithRewardNonPeekviewEdp (copy), PlayWithRewardComponent (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppExperienceDetailsLayoutOrderConfig (copy), t1 (copy), t2 (copy), ContentPosition (copy), GetFFlagExpDetailsUseSelectionBumpers (copy), ExperienceDetailsExperimentation (copy), ExperienceDetailsNoticeType (copy), FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), IXPService (copy), AppUserLayers (copy), AppStorageService (copy)
	local v142 = Localization.new(LocalizationService.RobloxLocaleId)

	function p2.applyTokenScaling(n1: number) -- line: 394
		-- upvalues: p2 (copy)
		return n1 * p2.props.foundationTokens.Stroke.Standard
	end
	function p2.getAbbreviateCount(p3) -- line: 399
		-- upvalues: abbreviateCount (copy), v142 (copy)
		return abbreviateCount(p3, v142:GetLocale())
	end
	function p2.upperString(p4) -- line: 402
		-- upvalues: v142 (copy)
		return string.upper(v142:Format(p4))
	end
	function p2.onPlayButtonActivated() -- line: 406
		-- upvalues: p2 (copy)
		return p2.props.onPlayButtonActivated()
	end
	function p2.openMoreContextualMenu(p5) -- line: 410
		-- upvalues: p2 (copy), UiMode (copy), GetFFlagEnableTenftUiDetailsMoreDropupMenu (copy), FFlagEnableLeftNavOnConsole (copy), Display (copy)
		local universeId = p2.props.universeId
		local vector2 = nil
		local v227 = p2.props.uiModeInfo and p2.props.uiModeInfo.uiMode == UiMode.TenFoot
		local uDim2

		if GetFFlagEnableTenftUiDetailsMoreDropupMenu() and v227 then
			local v228 = nil

			if FFlagEnableLeftNavOnConsole then
				v228 = Display.GetDisplayStore().getDeviceSafePadding()
			end

			vector2 = Vector2.new(0, 1)
			uDim2 = UDim2.fromOffset(p5.AbsolutePosition.X, p5.AbsolutePosition.Y - 12 + (not FFlagEnableLeftNavOnConsole and 0 or v228.top))
		else
			uDim2 = UDim2.fromOffset(p5.AbsolutePosition.X + p5.AbsoluteSize.X - 300, p5.AbsolutePosition.Y + p5.AbsoluteSize.Y + 12)
		end

		return p2.props.openMoreContextualMenu(universeId, uDim2, vector2, p2.props.hideCloseButton)
	end

	p2.getTextHeight = memoize(function(p6, p7, p8, p9) -- line: 440
		-- upvalues: Text (copy)
		return Text.GetTextHeight(p6, p7, p8, p9)
	end)

	function p2.openShareContextualMenu(p10) -- line: 444
		-- upvalues: p2 (copy)
		local universeId = p2.props.universeId
		local uDim2 = UDim2.fromOffset(p10.AbsolutePosition.X + p10.AbsoluteSize.X - 300, p10.AbsolutePosition.Y + p10.AbsoluteSize.Y + 12)

		return p2.props.openShareContextualMenu(universeId, uDim2, p2.props.hideCloseButton)
	end
	function p2.getPlaysAnsVisitsInfo(p11, p12) -- line: 454
		-- upvalues: FFlagLuaAppGameStatsFallbackRendering (copy)
		return {
			plays = p11 and p11.playing or (p12 and p12.playerCount or (not FFlagLuaAppGameStatsFallbackRendering and 0 or nil)),
			visits = p11 and p11.visits or (not FFlagLuaAppGameStatsFallbackRendering and 0 or nil),
			totalUpVotes = p12 and p12.totalUpVotes or 0,
			totalDownVotes = p12 and p12.totalDownVotes or 1
		}
	end
	function p2.getStyledTextLabel(p13, p14, p15) -- line: 465
		-- upvalues: Roact (copy), StyledTextLabel (copy)
		if p13 then
			return Roact.createElement(StyledTextLabel, {
				layoutOrder = 1,
				richText = false,
				lineHeight = 1,
				text = p13,
				fontStyle = p14,
				colorStyle = p15,
				automaticSize = Enum.AutomaticSize.XY
			})
		end

		return nil
	end
	function p2.toggleFollowExperience() -- line: 481
		-- upvalues: GetFFlagLuaAppEnableNotificationsEDPTooltip (copy), p2 (copy)
		if GetFFlagLuaAppEnableNotificationsEDPTooltip() then
			p2:setState({
				isNotificationsTooltipActive = false
			})
		end

		if not p2.props.gameFollowings then
			return
		end

		local universeId = p2.props.universeId
		local isFollowed = p2.props.gameFollowings.isFollowed

		if p2.props.toggleFollowExperience then
			p2.props.toggleFollowExperience(universeId, not isFollowed)
		end
	end
	function p2.renderSubtitleTextOverride(p16, p17, p18, _, p20, p21) -- line: 500
		-- upvalues: withStyle (copy), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagCreatorSubtitleNavigationIXPEnabled (copy), IXPServiceWrapper (copy), FStringCreatorSubtitleNavigationExperimentLayer (copy), AppPage (copy), UrlBuilder (copy), v142 (copy), TransitionAnimation (copy), Roact (copy), FFlagEnableCreatorSubtitleNavigation (copy), p2 (copy), VerifiedBadges (copy)
		return Roact.createElement(VerifiedBadges.EmojiWrapper, {
			layoutOrder = 2,
			emoji = not p20 and "" or VerifiedBadges.emoji.verified,
			onActivated = if not p20 or not p21 then nil else p2.props.openVerifiedBadgeModal
		}, {
			userText = withStyle(function(p22) -- line: 509
				-- upvalues: FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagCreatorSubtitleNavigationIXPEnabled (copy), IXPServiceWrapper (copy), FStringCreatorSubtitleNavigationExperimentLayer (copy), p16 (copy), p21 (copy), AppPage (copy), UrlBuilder (copy), p18 (copy), p17 (copy), v142 (copy), TransitionAnimation (copy), Roact (copy), FFlagEnableCreatorSubtitleNavigation (copy), p2 (copy)
				local v387 = if not FFlagExperienceDetailsTextUseTokens then p22.Font.Header2 else if not FFlagRenameDeprecatedUIBloxTokens then p22.Tokens.Semantic.Typography.Subheader else p22.Tokens.Typography.TitleLarge
				local v388 = if not FFlagExperienceDetailsTextUseTokens then v387.RelativeSize * p22.Font.BaseSize else v387.FontSize
				local TextMuted = p22.Theme.TextMuted

				if FFlagCreatorSubtitleNavigationIXPEnabled then
					IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringCreatorSubtitleNavigationExperimentLayer)
				end

				if p16 and p21 then
					local t4 = {
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.game.info.creator({
							creatorType = p18,
							creatorId = p17
						}),
						extraProps = {
							title = v142:Format("Feature.GameDetails.Label.Developer"),
							transitionAnimation = TransitionAnimation.SlideInFromRight
						}
					}

					return Roact.createElement("TextButton", {
						Text = p16,
						Font = v387.Font,
						TextColor3 = TextMuted.Color,
						LayoutOrder = 2,
						AutoButtonColor = false,
						LineHeight = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = v388,
						BackgroundTransparency = 1,
						[Roact.Event.Activated] = function() -- line: 549
							-- upvalues: FFlagEnableCreatorSubtitleNavigation (copy), p18 (copy), p2 (copy), p17 (copy), t4 (copy)
							if FFlagEnableCreatorSubtitleNavigation then
								if p18 == "User" then
									p2.props.openUserProfilePage(p17, "ExperienceDetailsPage:SubTitle")

									return
								end

								if p18 == "Group" then
									p2.props.openCommunityProfilePage(p17, "ExperienceDetailsPage:SubTitle")

									return
								end
							else
								p2.props.openCreatorPage(t4)
							end
						end
					})
				end

				return p2.getStyledTextLabel(p16, v387, TextMuted)
			end)
		})
	end
	function p2.renderTextOverride(p23, _, _, p26) -- line: 576
		-- upvalues: withStyle (copy), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p2 (copy), Roact (copy), VerifiedBadges (copy)
		return Roact.createElement(VerifiedBadges.EmojiWrapper, {
			layoutOrder = 0,
			emoji = not p26 and "" or VerifiedBadges.emoji.verified,
			size = UDim2.fromScale(0, 1)
		}, {
			userText = withStyle(function(p27) -- line: 578
				-- upvalues: FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p2 (copy), p23 (copy)
				local v393 = if not FFlagExperienceDetailsTextUseTokens then p27.Font.Header2 else if not FFlagRenameDeprecatedUIBloxTokens then p27.Tokens.Semantic.Typography.Subheader else p27.Tokens.Typography.TitleLarge
				local TextEmphasis = p27.Theme.TextEmphasis

				return p2.getStyledTextLabel(p23, v393, TextEmphasis)
			end)
		})
	end

	p2.renderExperienceGuidelines = memoize(function(p28) -- line: 598
		-- upvalues: React (copy), ExperienceTagsContainer (copy), p2 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
		return React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4)
			}),
			ExperienceTagsContainer = React.createElement(ExperienceTagsContainer, {
				areTagsInteractable = true,
				includeAgeRecommendations = true,
				LayoutOrder = 1,
				universeId = p28,
				hideCloseButton = p2.props.hideCloseButton,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp
			})
		})
	end)
	p2.renderInlinePlayerCountAndLikes = memoize(function(p29, p30, p31) -- line: 622
		-- upvalues: Roact (copy), GameStats (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(0, 120, 0, 20)
		}, {
			GameStats = Roact.createElement(GameStats, {
				stats = {
					playerCount = p29,
					totalUpVotes = p30,
					totalDownVotes = p31
				}
			})
		})
	end)

	function p2.renderBriefDescription(p32, p33) -- line: 638
		-- upvalues: withStyle (copy), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p2 (copy), Roact (copy), StyledTextLabel (copy)
		return withStyle(function(p34) -- line: 639
			-- upvalues: p32 (copy), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p2 (copy), p33 (copy), Roact (copy), StyledTextLabel (copy)
			local p34Font = p34.Font
			local headerDescriptionLineHeight = p32.headerDescriptionLineHeight
			local v398 = headerDescriptionLineHeight * math.floor(p34Font.BaseSize * p34Font.Body.RelativeSize) * p32.headerDescriptionMaxRows
			local v399 = if not FFlagExperienceDetailsTextUseTokens then p34Font.BaseSize * p34Font.Body.RelativeSize else if not FFlagRenameDeprecatedUIBloxTokens then p34.Tokens.Semantic.Typography.Body.FontSize else p34.Tokens.Typography.BodyLarge.FontSize
			local v400 = if not FFlagExperienceDetailsTextUseTokens then p34Font.Body.Font else if not FFlagRenameDeprecatedUIBloxTokens then p34.Tokens.Semantic.Typography.Body.Font else p34.Tokens.Typography.BodyLarge.Font
			local v401 = p2.getTextHeight(p33, v400, v399, UDim2.new(1, 0, 0, v398))

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 0, (math.min(v401, v398)))
			}, {
				GameDescriptionText = Roact.createElement(StyledTextLabel, {
					richText = false,
					fluidSizing = false,
					text = p33,
					fontStyle = if not FFlagExperienceDetailsTextUseTokens then p34Font.Body else if not FFlagRenameDeprecatedUIBloxTokens then p34.Tokens.Semantic.Typography.Body else p34.Tokens.Typography.BodyLarge,
					colorStyle = p34.Theme.TextEmphasis,
					size = UDim2.fromScale(1, 1),
					lineHeight = headerDescriptionLineHeight
				})
			})
		end)
	end
	function p2.renderInfoContent(p35, p36, p37, p38, p39, p40, p41, p42, p43, p44) -- line: 680
		-- upvalues: p2 (copy), UiMode (copy), FFlagEnableCreatorSubtitleNavigation (copy), Roact (copy)
		local v270 = p2.props.uiModeInfo and p2.props.uiModeInfo.uiMode == UiMode.TenFoot
		local v271 = p35 and p35.headerItemPadding or 0
		local v272 = v270 and (p41 ~= nil and #p41 > 0)
		local v273 = not v270

		return function() -- line: 699
			-- upvalues: FFlagEnableCreatorSubtitleNavigation (copy), p2 (copy), p37 (copy), p38 (copy), p39 (copy), p36 (copy), p40 (copy), UiMode (copy), Roact (copy), v271 (copy), v270 (copy), p42 (copy), p43 (copy), p44 (copy), v272 (copy), p35 (copy), p41 (copy), v273 (copy)
			local v402 = if not FFlagEnableCreatorSubtitleNavigation then p2.renderSubtitleTextOverride(p37, p38, p39, p36, p40) else p2.renderSubtitleTextOverride(p37, p38, p39, p36, p40, p2.props.uiModeInfo.uiMode ~= UiMode.TenFoot)

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, v271)
				}),
				SubtitleText = v402,
				Padding = if not v271 then nil else Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v271)
				}),
				PlayStats = if not v270 then nil else p2.renderInlinePlayerCountAndLikes(p42, p43, p44),
				Description = if not v272 then nil else p2.renderBriefDescription(p35, p41),
				ExperienceGuidelinesComponent = if not v273 then nil else p2.renderExperienceGuidelines(p36)
			})
		end
	end

	p2.renderPlaysAndVisits = memoize(function(p45, p46) -- line: 738
		-- upvalues: Roact (copy), PlayerCount (copy), FFlagLuaAppGameStatsFallbackRendering (copy), v133 (copy), p2 (copy), Images (copy)
		return function() -- line: 739
			-- upvalues: Roact (copy), PlayerCount (copy), FFlagLuaAppGameStatsFallbackRendering (copy), p45 (copy), v133 (copy), p2 (copy), Images (copy), p46 (copy)
			return Roact.createElement(PlayerCount, {
				layoutOrder = 1,
				countLeft = {
					countText = if not FFlagLuaAppGameStatsFallbackRendering or p45 ~= nil then p2.getAbbreviateCount(p45) else v133,
					labelText = p2.upperString("Feature.GameDetails.Label.Playing"),
					icon = Images["icons/status/games/people-playing_large"]
				},
				countRight = {
					countText = if not FFlagLuaAppGameStatsFallbackRendering or p46 ~= nil then p2.getAbbreviateCount(p46) else v133,
					labelText = p2.upperString("Feature.GameDetails.Label.Visits"),
					icon = Images["icons/status/games/sessions_large"]
				}
			})
		end
	end)

	function p2.onFocusChanged(p47) -- line: 760
		-- upvalues: p2 (copy)
		if p2.props.setControllerBarNavigation then
			p2.props.setControllerBarNavigation(not p47)
		end
	end

	p2.renderDescription = memoize(function(p48, p49) -- line: 767
		-- upvalues: Roact (copy), ExperienceDescription (copy), RetrievalStatus (copy), p2 (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), AppPage (copy)
		return function() -- line: 768
			-- upvalues: Roact (copy), ExperienceDescription (copy), RetrievalStatus (copy), p48 (copy), p49 (copy), p2 (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), AppPage (copy)
			return Roact.createElement(ExperienceDescription, {
				dataStatus = RetrievalStatus.fromRawValue(p48),
				descriptionText = p49,
				onFocusChanged = p2.onFocusChanged,
				universeId = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else p2.props.universeId,
				pageContext = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else AppPage.ExperienceDetail,
				componentType = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else "gameDescription"
			})
		end
	end)
	p2.renderNotice = memoize(function(p50) -- line: 779
		-- upvalues: withLocalization (copy), Roact (copy), ExperienceDescription (copy), RetrievalStatus (copy), p2 (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), AppPage (copy)
		return function() -- line: 780
			-- upvalues: withLocalization (copy), Roact (copy), ExperienceDescription (copy), RetrievalStatus (copy), p50 (copy), p2 (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), AppPage (copy)
			return withLocalization({
				noticeHeader = "Feature.ExperienceDetails.Body.NotesTitle",
				noticeText = "Feature.ExperienceDetails.Notes.InExperiencePurchase"
			})(function(p51) -- line: 784
				-- upvalues: Roact (copy), ExperienceDescription (copy), RetrievalStatus (copy), p50 (copy), p2 (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), AppPage (copy)
				return Roact.createElement(ExperienceDescription, {
					dataStatus = RetrievalStatus.fromRawValue(p50),
					headerText = p51.noticeHeader,
					descriptionText = p51.noticeText,
					onFocusChanged = p2.onFocusChanged,
					universeId = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else p2.props.universeId,
					pageContext = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else AppPage.ExperienceDetail,
					componentType = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else "gameNotice"
				})
			end)
		end
	end)

	function p2.renderActionBarLabelImpressionsDetector(p52, p53) -- line: 798
		-- upvalues: Roact (copy), PlayButtonContextualMessageImpressionsDetector (copy), p2 (copy), AppPage (copy)
		return Roact.createElement(PlayButtonContextualMessageImpressionsDetector, {
			containerRef = p52,
			universeId = p2.props.universeId,
			playabilityStatus = p2.props.playabilityStatus,
			contextualMessage = p2.props.playButtonContextualMessage,
			pageContext = AppPage.ExperienceDetail,
			scrollViewPositionChangedSignal = p53
		})
	end

	p2.renderIgrsRatingLabel = memoize(function(p54, p55, p56, p57, p58) -- line: 810
		-- upvalues: React (copy), IgrsRatingLabel (copy), Constants (copy), v142 (copy), openExternalBrowser (copy)
		return function() -- line: 811
			-- upvalues: React (copy), IgrsRatingLabel (copy), p54 (copy), p55 (copy), p56 (copy), p57 (copy), Constants (copy), v142 (copy), openExternalBrowser (copy), p58 (copy)
			return React.createElement(IgrsRatingLabel, {
				igrsRating = p54,
				igrsRatingDisplayMessage = p55,
				onActivated = not p56 and function() -- line: 822
					-- upvalues: openExternalBrowser (copy), p58 (copy), Constants (copy)
					openExternalBrowser(p58, Constants.INDONESIAN_CONTENT_MATURITY_URL)
				end or function() -- line: 816
					-- upvalues: p57 (copy), Constants (copy), v142 (copy)
					p57(Constants.INDONESIAN_CONTENT_MATURITY_URL, v142:Format("Feature.GameDetails.Label.ContentMaturity"))
				end
			})
		end
	end)
	p2.renderLogoTray = memoize(function(p59, p60) -- line: 830
		-- upvalues: FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), p2 (copy), React (copy), AppCommonLib (copy), Roact (copy), ExperienceLogoTray (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), EdpSocialLinksImpressionsDetector (copy), AppPage (copy)
		return function() -- line: 831
			-- upvalues: FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy), p2 (copy), React (copy), AppCommonLib (copy), Roact (copy), ExperienceLogoTray (copy), p59 (copy), p60 (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), EdpSocialLinksImpressionsDetector (copy), AppPage (copy)
			if FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then
				local v403 = `EXPERIENCE_SOCIAL_LINKS_{ p2.props.universeId }`
				local v404 = React.createRef()
				local v405 = AppCommonLib.Signal.new()

				return React.createElement(React.Fragment, nil, {
					ExperienceLogoTray = Roact.createElement(ExperienceLogoTray, {
						socialLinks = p59,
						linking = p60,
						openLeaveRobloxAlertUIBlox = p2.props.openLeaveRobloxAlertUIBlox,
						closeAlert = p2.props.closeAlert,
						impressionsTag = v403,
						forwardRef = v404,
						onAbsolutePositionChanged = function(_) -- line: 843
							-- upvalues: v405 (copy)
							v405:fire()
						end,
						universeId = if not FFlagLuaAppAddSocialLinkClickTelemetryToEdp then nil else p2.props.universeId
					}),
					EdpSocialLinksImpressionsDetector = Roact.createElement(EdpSocialLinksImpressionsDetector, {
						parentRef = v404,
						scrollViewPositionChangedSignal = v405,
						pageContext = AppPage.ExperienceDetail,
						impressionsTag = v403,
						socialLinks = p59,
						universeId = p2.props.universeId
					})
				})
			end

			return Roact.createElement(ExperienceLogoTray, {
				socialLinks = p59,
				linking = p60,
				openLeaveRobloxAlertUIBlox = p2.props.openLeaveRobloxAlertUIBlox,
				closeAlert = p2.props.closeAlert,
				universeId = if not FFlagLuaAppAddSocialLinkClickTelemetryToEdp then nil else p2.props.universeId
			})
		end
	end)

	local function handleControllerBarInMediaGalleryFullscreen(p62) -- line: 879
		-- upvalues: p2 (copy)
		if p2.props.setControllerBarNavigation then
			p2.props.setControllerBarNavigation(p62)
		end
	end

	function p2.onMediaGalleryPreviewActivated(p63, p64) -- line: 885
		-- upvalues: p2 (copy), UiMode (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppDesktopMediaGalleryTelemetry (copy)
		local v292 = p2.props.uiModeInfo and p2.props.uiModeInfo.uiMode == UiMode.TenFoot

		if not p2.state.isFullscreen and (v292 and p2.props.setControllerBarNavigation) then
			p2.props.setControllerBarNavigation(false)
		end

		p2:setState({
			isFullscreen = true,
			mediaGalleryShowIndex = p63,
			currentIndex = if not v292 then nil else p63
		})

		if FFlagLuaAppEdpMediaGalleryRedesignTelemetry and p2.props.onMediaGalleryEnterFullscreen then
			p2.props.onMediaGalleryEnterFullscreen(p63, p64)

			return
		end

		if FFlagLuaAppDesktopMediaGalleryTelemetry and p2.props.onMediaGalleryPreviewActivated then
			p2.props.onMediaGalleryPreviewActivated(p63)
		end
	end

	p2.renderMediaGallery = memoize(function(p65, p66) -- line: 904
		-- upvalues: p2 (copy), UiMode (copy), Roact (copy), ExperienceMediaGallery (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppDesktopMediaGalleryTelemetry (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy)
		if p2.props.uiModeInfo and p2.props.uiModeInfo.uiMode == UiMode.TenFoot then
			return function() -- line: 907
				-- upvalues: Roact (copy), ExperienceMediaGallery (copy), p2 (copy), p65 (copy), p66 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
				return Roact.createElement(ExperienceMediaGallery, {
					tokens = p2.props.tokens,
					deviceType = p2.props.deviceType,
					universeId = p65,
					onPreviewActivated = p2.onMediaGalleryPreviewActivated,
					isFullscreenState = p66,
					exitFullscreen = p2.onClose,
					onSelectionGained = p2.onSelectionGained,
					mediaGalleryGainFocused = p2.mediaGalleryGainFocused,
					uiMode = p2.props.uiModeInfo.uiMode,
					shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp
				})
			end
		end

		return function() -- line: 924
			-- upvalues: Roact (copy), ExperienceMediaGallery (copy), p2 (copy), p65 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppDesktopMediaGalleryTelemetry (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), p66 (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
			return Roact.createElement(ExperienceMediaGallery, {
				deviceType = p2.props.deviceType,
				universeId = p65,
				startIndex = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else p2.state.mediaGalleryShowIndex,
				onPreviewActivated = p2.onMediaGalleryPreviewActivated,
				onThumbnailActivated = if not FFlagLuaAppDesktopMediaGalleryTelemetry or FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else p2.props.onMediaGalleryThumbnailActivated,
				onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else p2.props.onMediaGalleryMediaChanged,
				isOccluded = if not FFlagLuaAppEdpMediaGalleryFullScreen or not FFlagLuaAppEdpMediaGalleryAutoAdvance and not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else p66,
				mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else p2.props.mediaGalleryRedesignEnabledIxp,
				mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else p2.props.mediaGalleryVideoPreviewEnabledIxp,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp
			})
		end
	end)
	p2.renderExperienceRating = memoize(function(p67) -- line: 955
		-- upvalues: Roact (copy), ExperienceRatings (copy), p2 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
		return function() -- line: 956
			-- upvalues: Roact (copy), ExperienceRatings (copy), p67 (copy), p2 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
			return Roact.createElement(ExperienceRatings, {
				universeId = p67,
				height = math.floor((p2.applyTokenScaling(72))),
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp,
				styleProps = {
					statWidgetIconSize = math.floor((p2.applyTokenScaling(48)))
				}
			})
		end
	end)
	p2.renderExperienceInfoTable = memoize(function(p68) -- line: 970
		-- upvalues: Roact (copy), p2 (copy), ExperienceInfoTable (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
		return function() -- line: 971
			-- upvalues: Roact (copy), p2 (copy), ExperienceInfoTable (copy), p68 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
			return Roact.createElement("Folder", {
				[Roact.Ref] = p2.props.statsAndInfoRef
			}, Roact.createElement(ExperienceInfoTable, {
				key = "ExperienceInfoTable",
				renderTextOverride = p2.renderTextOverride,
				universeId = p68,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp,
				hideCloseButton = p2.props.hideCloseButton
			}))
		end
	end)
	p2.renderEventsList = memoize(function(p69, p70) -- line: 990
		-- upvalues: Roact (copy), EventsListWrapper (copy)
		return function() -- line: 991
			-- upvalues: Roact (copy), EventsListWrapper (copy), p69 (copy), p70 (copy)
			return Roact.createElement(EventsListWrapper, {
				referralSource = "expDetailsPage",
				universeId = p69,
				defaultThumbnail = if not p70 then nil else "rbxassetid://" .. p70
			})
		end
	end)
	p2.renderRecommendedExperiencesCarousel = memoize(function(p71) -- line: 1000
		-- upvalues: Roact (copy), RecommendedExperienceCarousel (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p2 (copy), AppPage (copy)
		return function() -- line: 1001
			-- upvalues: Roact (copy), RecommendedExperienceCarousel (copy), p71 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p2 (copy), AppPage (copy)
			return Roact.createElement(RecommendedExperienceCarousel, {
				universeId = p71,
				shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp,
				pageContext = AppPage.ExperienceDetail
			})
		end
	end)

	if FFlagSongEdpCarouselIxp then
		p2.renderExperienceSongsCarousel = memoize(function(p72, p73) -- line: 1013
			-- upvalues: React (copy), ExperienceSongsCarousel (copy)
			return function() -- line: 1014
				-- upvalues: React (copy), ExperienceSongsCarousel (copy), p72 (copy), p73 (copy)
				return React.createElement(ExperienceSongsCarousel, {
					fractionalItemAmount = 0,
					collectionOrder = 2,
					clipsDescendants = true,
					universeId = p72,
					universeTitle = p73 or ""
				})
			end
		end)
	end

	p2.renderCommunityLink = memoize(function(p74, p75, p76) -- line: 1026
		-- upvalues: React (copy), ExperienceCommunityLink (copy)
		return function() -- line: 1027
			-- upvalues: React (copy), ExperienceCommunityLink (copy), p74 (copy), p75 (copy), p76 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 16)
				}),
				ExperienceCommunityLink = React.createElement(ExperienceCommunityLink, {
					communityInfo = p74,
					experienceName = p75 or "",
					universeId = p76
				})
			})
		end
	end)
	p2.linkStartStyle = memoize(function(p77) -- line: 1045
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		local Color3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p77.Tokens.Semantic.Color.Text.Link else p77.Tokens.Color.Content.Link)).Color3

		return `<font color="{ string.format("rgb(%d, %d, %d)", math.round(Color3.R * 255), math.round(Color3.G * 255), (math.round(Color3.B * 255))) }"><b>`
	end)
	p2.checkAndFormatPossibleLink = memoize(function(p78, p79) -- line: 1059
		-- upvalues: checkAndFormatPossibleLink (copy), p2 (copy)
		return checkAndFormatPossibleLink(p79, nil, nil, p2.linkStartStyle(p78), "</b></font>")
	end)
	p2.renderRefundPolicy = memoize(function(p80) -- line: 1065
		-- upvalues: FFlagLuaAppEnableConsolidatedGameRefundPolicy (copy), withStyle (copy), Roact (copy), GameRefundPolicy (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p2 (copy), React (copy)
		return function() -- line: 1066
			-- upvalues: FFlagLuaAppEnableConsolidatedGameRefundPolicy (copy), withStyle (copy), Roact (copy), GameRefundPolicy (copy), p80 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p2 (copy), React (copy)
			if FFlagLuaAppEnableConsolidatedGameRefundPolicy then
				return withStyle(function(p81) -- line: 1068
					-- upvalues: Roact (copy), GameRefundPolicy (copy), p80 (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
					return Roact.createElement(GameRefundPolicy, {
						refundPolicy = p80,
						paddingTop = if not FFlagRenameDeprecatedUIBloxTokens then p81.Tokens.Global.Space_300 else p81.Tokens.Size.Size_600
					})
				end)
			end

			return withStyle(function(p82) -- line: 1077
				-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), p2 (copy), p80 (copy), React (copy)
				local v421 = if not FFlagRenameDeprecatedUIBloxTokens then p82.Tokens.Semantic.Typography.Body else p82.Tokens.Typography.BodyLarge
				local v422 = if not FFlagRenameDeprecatedUIBloxTokens then p82.Tokens.Semantic.Color.Text.Muted else p82.Tokens.Color.Content.Muted
				local v423, v424 = p2.checkAndFormatPossibleLink(p82, p80.policyText)

				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p82.Tokens.Global.Space_300 else p82.Tokens.Size.Size_600)
					}),
					RefundPolicy = React.createElement("TextButton", {
						BackgroundTransparency = 1,
						Text = v424,
						AutomaticSize = Enum.AutomaticSize.XY,
						Font = v421.Font,
						TextSize = v421.FontSize,
						TextColor3 = v422.Color3,
						TextTransparency = v422.Transparency,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						RichText = v423,
						[React.Event.Activated] = function(_) -- line: 1119
							-- upvalues: p2 (copy), p80 (copy)
							p2.props.openRefundPolicyLearnMorePage(p80.learnMoreUrl)
						end
					})
				})
			end)
		end
	end)

	if FFlagEnablePlayWithRewardNonPeekviewEdp then
		p2.renderPlayWithReward = memoize(function(p84, p85, p86, p87, p88) -- line: 1130
			-- upvalues: Roact (copy), PlayWithRewardComponent (copy)
			return function() -- line: 1131
				-- upvalues: Roact (copy), PlayWithRewardComponent (copy), p84 (copy), p85 (copy), p87 (copy), p88 (copy), p86 (copy)
				return Roact.createElement(PlayWithRewardComponent, {
					useLargerStyles = true,
					universeId = p84,
					placeId = p85,
					placeIdOverride = p87,
					experienceJoinData = p88,
					flowId = p86.flowId,
					fetchedUniverseId = p86.universeId,
					isAdDataExpected = p86.isAdDataExpected,
					playWithRewardAdData = p86.adData
				})
			end
		end)
	end

	p2.getBodyComponentListProps = memoize(function(p89, p90, p91, p92, p93, p94, p95, p96, p97, p98, p99, p100, p101, p102, p103, p104, p105, p106, p107, p108, p109, p110, p111, p112, p113, p114, p115, p116) -- line: 1149
		-- upvalues: p2 (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagEnablePlayWithRewardNonPeekviewEdp (copy), FFlagLuaAppExperienceDetailsLayoutOrderConfig (copy), t1 (copy), t2 (copy), ContentPosition (copy), GetFFlagExpDetailsUseSelectionBumpers (copy), ExperienceDetailsExperimentation (copy), ExperienceDetailsNoticeType (copy), FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex (copy), FFlagSongEdpCarouselIxp (copy)
		local v343 = p99.showLogoTraySection and (p95 and next(p95))
		local v344 = p99.showCommunityLink and (p97 and (p98 == "banner" and p96))
		local showEventsList = p99.showEventsList
		local v346 = p2.props.webViewSupport and p103 ~= nil
		local v347 = FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable and ((FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p2.props.shouldInterleaveSduiIxp) and (p2.props.edpPerUniverseVisibilityVariables and p2.props.edpPerUniverseVisibilityVariables.hidePlayWithReward == true))
		local v348 = if not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then nil else FFlagEnablePlayWithRewardNonPeekviewEdp and (p113 and (p112 and (p111 and not v347)))
		local v349 = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 20 or t1.Description
		local v350 = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 40 or t1.MediaGallery
		local v351 = if p101 then v350 else v349
		local v352 = if not FFlagLuaAppExperienceDetailsLayoutOrderConfig then v351 - 10 else t1.EventsListRedesign
		local v353 = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 10 or t2.EventsListRedesign
		local Left = ContentPosition.Left
		local t5 = {
			MediaGallery = {
				portraitLayoutOrder = if p101 then v349 else not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 5 or t1.MediaGalleryMediaFirst,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 10 or t2.MediaGallery,
				landscapePosition = ContentPosition.Right,
				showCornerGradient = not p99.showCornerGradientPropEnabled and nil,
				useSelectionBumper = not not GetFFlagExpDetailsUseSelectionBumpers() or nil,
				renderComponent = p2.renderMediaGallery(p89, p100)
			},
			Description = {
				portraitLayoutOrder = v351,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 20 or t2.Description,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderDescription(p90, p91)
			},
			IgrsRatingLabel = if not p106 then nil else {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 45 or t1.IgrsRatingLabel,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 30 or t2.IgrsRatingLabel,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderIgrsRatingLabel(p106, p107, p108, p109, p110)
			},
			ExperienceRatings = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or (not p2.props.edpServerIxpVariables or p2.props.edpServerIxpVariables.hideGameRatings ~= true) then {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 50 or t1.ExperienceRatings,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 40 or t2.ExperienceRatings,
				landscapePosition = ContentPosition.Left,
				useSelectionBumper = not not GetFFlagExpDetailsUseSelectionBumpers() or nil,
				renderComponent = p2.renderExperienceRating(p89)
			} else nil,
			PlaysAndVisits = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or (not p2.props.edpServerIxpVariables or p2.props.edpServerIxpVariables.showVisitsInInfoList ~= true) then {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 60 or t1.PlaysAndVisits,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 50 or t2.PlaysAndVisits,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderPlaysAndVisits(p93, p94)
			} else nil,
			CommunityLink = if not v344 then nil else {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 70 or t1.CommunityLink,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 60 or t2.CommunityLink,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderCommunityLink(p96, p92, p89)
			},
			ExperienceInfoTable = {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 80 or t1.ExperienceInfoTable,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 70 or t2.ExperienceInfoTable,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderExperienceInfoTable(p89)
			},
			RefundPolicy = if not v346 then nil else {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 85 or t1.RefundPolicy,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 75 or t2.RefundPolicy,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderRefundPolicy(p103)
			},
			LogoTraySection = v343 and {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 90 or t1.LogoTraySection,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 80 or t2.LogoTraySection,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderLogoTray(p95, p110)
			} or nil,
			EventsList = if not showEventsList then nil else {
				portraitLayoutOrder = v352,
				landscapeLayoutOrder = v353,
				landscapePosition = Left,
				renderComponent = p2.renderEventsList(p89, p102)
			},
			Notice = if p104 ~= ExperienceDetailsNoticeType.InExperiencePurchase then nil else {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 100 or t1.Notice,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 100 or t2.Notice,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderNotice(p90)
			},
			RecommendedExperiences = {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 110 or t1.RecommendedExperiences,
				portraitZIndex = if not FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex then nil else 2,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 30 or t2.RecommendedExperiences,
				landscapePosition = ContentPosition.Right,
				useSelectionBumper = not not GetFFlagExpDetailsUseSelectionBumpers() or nil,
				renderComponent = p2.renderRecommendedExperiencesCarousel(p89)
			},
			ExperienceSongsCarousel = if not FFlagSongEdpCarouselIxp or not p2.props.showSongCarousel then nil else {
				portraitLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 120 or t1.ExperienceSongsCarousel,
				portraitZIndex = if not FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex then nil else 1,
				landscapeLayoutOrder = not FFlagLuaAppExperienceDetailsLayoutOrderConfig and 35 or t2.ExperienceSongsCarousel,
				landscapePosition = ContentPosition.Right,
				renderComponent = p2.renderExperienceSongsCarousel(p89, p92)
			},
			PlayWithReward = if not if not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then FFlagEnablePlayWithRewardNonPeekviewEdp and (p113 and (p112 and p111)) else v348 then nil else {
				portraitLayoutOrder = t1.PlayWithReward,
				landscapeLayoutOrder = t2.PlayWithReward,
				landscapePosition = ContentPosition.Left,
				renderComponent = p2.renderPlayWithReward(p89, p114, p111, p115, p116)
			}
		}

		if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p2.props.shouldInterleaveSduiIxp) and p105 then
			for v356, v357 in p105 do
				t5[`SduiFeedItem_{ v356 }`] = {
					portraitLayoutOrder = v357.portraitLayoutOrder,
					landscapeLayoutOrder = v357.landscapeLayoutOrder,
					landscapePosition = ContentPosition.Left,
					renderComponent = v357.renderComponent
				}
			end
		end

		return t5
	end)

	function p2.onClose() -- line: 1441
		-- upvalues: p2 (copy), UiMode (copy)
		if p2.state.isFullscreen then
			p2:setState({
				isFullscreen = false
			})

			if p2.props.uiModeInfo and p2.props.uiModeInfo.uiMode == UiMode.TenFoot and p2.props.setControllerBarNavigation then
				p2.props.setControllerBarNavigation(true)

				return
			end
		else
			p2.props.onClose()
		end
	end

	p2.exitFullscreen = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else function(p117, p118) -- line: 1458
		-- upvalues: p2 (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy)
		if not p2.state.isFullscreen then
			return
		end

		if FFlagLuaAppEdpMediaGalleryRedesignTelemetry and p2.props.onMediaGalleryExitFullscreen then
			p2.props.onMediaGalleryExitFullscreen(p117, p118)
		end

		p2:setState({
			isFullscreen = false,
			mediaGalleryShowIndex = p117
		})
	end
	p2.focusEventHandlers = {
		[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p119) -- line: 1476
				-- upvalues: p2 (copy)
				p2.onClose()
				p119:cancel()
			end)
		}
	}
	p2.renderFullscreenContent = memoize(function(p120, p121, p122, p123, p124, p125) -- line: 1484
		-- upvalues: p2 (copy), UiMode (copy), Roact (copy), ExperienceMediaGallery (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy)
		if p2.props.uiModeInfo and p2.props.uiModeInfo.uiMode == UiMode.TenFoot then
			return function() -- line: 1487
				-- upvalues: Roact (copy), ExperienceMediaGallery (copy), p2 (copy), p120 (copy), p121 (copy), p122 (copy), p123 (copy), p125 (copy), p124 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
				return Roact.createElement(ExperienceMediaGallery, {
					isFullscreen = true,
					tokens = p2.props.tokens,
					universeId = p120,
					fullscreenShowIndex = p121,
					deviceType = p2.props.deviceType,
					isFullscreenState = p122,
					isCrossFade = p123,
					setCrossFade = p2.setCrossFade,
					nextIndex = p125,
					currentIndex = p124,
					setCurrentIndex = p2.setCurrentIndex,
					uiMode = p2.props.uiModeInfo.uiMode,
					shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp
				})
			end
		end

		return function() -- line: 1507
			-- upvalues: Roact (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), p2 (copy), ExperienceMediaGallery (copy), p120 (copy), p121 (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
			return Roact.createElement(FocusNavigableSurfaceWrapper, {
				isIsolated = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				customEventHandlers = p2.focusEventHandlers
			}, {
				ExperienceMediaGallery = Roact.createElement(ExperienceMediaGallery, {
					isFullscreen = true,
					universeId = p120,
					fullscreenShowIndex = p121,
					onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else p2.props.onMediaGalleryMediaChanged,
					startIndex = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else p121,
					exitFullscreen = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else p2.exitFullscreen,
					mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else p2.props.mediaGalleryRedesignEnabledIxp,
					mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else p2.props.mediaGalleryVideoPreviewEnabledIxp,
					shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p2.props.shouldHydrateLegacyIxp
				})
			})
		end
	end)

	function p2.resolveTitleText(p126, p127) -- line: 1538
		return p126 and p126.name or (p127 and p127.name or nil)
	end
	function p2.checkCommunityLinkExposureLogging() -- line: 1543
		-- upvalues: p2 (copy), IXPService (copy), AppUserLayers (copy)
		if p2.props.communityLink then
			IXPService:LogUserLayerExposure(AppUserLayers.EDPCommunityLinksLayer)
		end
	end

	if p2.props.uiModeInfo and p2.props.uiModeInfo.uiMode == UiMode.TenFoot then
		p2.state = {
			isCrossFade = false,
			currentIndex = 1,
			nextIndex = 1,
			bannerImageId = p2.props.bannerImageId
		}

		function p2.setCurrentIndex(p128) -- line: 1558
			-- upvalues: p2 (copy)
			p2:setState({
				currentIndex = p128
			})
		end
		function p2.setCrossFade(p129) -- line: 1564
			-- upvalues: p2 (copy)
			p2:setState({
				isCrossFade = p129
			})
		end
		function p2.onSelectionGained(p130, p131) -- line: 1570
			-- upvalues: p2 (copy)
			if p130 ~= p2.state.nextIndex and p2.state.isCrossFade == false then
				p2.setCrossFade(true)
			end

			p2:setState({
				bannerImageId = p131,
				nextIndex = p130
			})
		end
		function p2.mediaGalleryGainFocused(p132) -- line: 1581
			-- upvalues: p2 (copy)
			if not p132 then
				p2:setState({
					bannerImageId = p2.props.bannerImageId
				})
			end
		end
	end

	if GetFFlagLuaAppEnableNotificationsEDPTooltip() then
		p2.isMounted = false

		local ok, result = pcall(function() -- line: 1593
			-- upvalues: AppStorageService (copy)
			return AppStorageService:GetItem("ShowNotificationsOptInTooltip")
		end)

		p2.showTooltip = not not ok and result == "true"
		p2:setState({
			isNotificationsTooltipActive = p2.showTooltip
		})
	end
end
function v136.didMount(p133) -- line: 1602
	-- upvalues: GetFFlagLuaAppEnableNotificationsEDPTooltip (copy), AppStorageService (copy), Promise (copy), GetFIntNotificationsEDPTooltipTimeLimit (copy)
	p133.checkCommunityLinkExposureLogging()

	if GetFFlagLuaAppEnableNotificationsEDPTooltip() then
		p133.isMounted = true

		if p133.showTooltip then
			pcall(function() -- line: 1608
				-- upvalues: AppStorageService (copy)
				AppStorageService:SetItem("ShowNotificationsOptInTooltip", "false")
				AppStorageService:Flush()
			end)
		end

		Promise.delay(GetFIntNotificationsEDPTooltipTimeLimit()):andThen(function() -- line: 1614
			-- upvalues: p133 (copy)
			if p133.isMounted then
				p133:setState({
					isNotificationsTooltipActive = false
				})
			end
		end)
	end
end
function v136.didUpdate(p134, p135) -- line: 1624
	if not p135.communityLink then
		p134.checkCommunityLinkExposureLogging()
	end
end
function v136.render(p136) -- line: 1630
	-- upvalues: v5 (copy), RetrievalStatus2 (copy), Roact (copy), LoadingStateContainer (copy), RetrievalStatus (copy)
	if v5 then
		if p136.props.gameDetailsPageDataStatus == RetrievalStatus2.Failed and not p136.props.gameInfo then
			return p136:renderOnFailed()
		end

		return p136:renderOnLoaded()
	end

	return Roact.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus.fromRawValue(p136.props.gameDetailsPageDataStatus),
		renderOnFailed = function() -- line: 1648
			-- upvalues: p136 (copy)
			if p136.props.gameInfo then
				return p136:renderOnLoaded()
			end

			return p136:renderOnFailed()
		end,
		renderOnLoaded = function() -- line: 1656
			-- upvalues: p136 (copy)
			return p136:renderOnLoaded()
		end,
		renderOnLoading = function() -- line: 1659
			-- upvalues: p136 (copy)
			return p136:renderOnLoading()
		end
	})
end
function v136.renderOnLoading(_) -- line: 1665
	-- upvalues: Roact (copy), ExperienceDetailsLoadingStatePage (copy)
	return Roact.createElement(ExperienceDetailsLoadingStatePage)
end
function v136.renderOnFailed(p138) -- line: 1669
	-- upvalues: withLocalization (copy), EnumGameDetailErrorTypes (copy), Roact (copy), EmptyState (copy)
	return withLocalization({
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
		experienceUnavailableMessage = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable"
	})(function(p139) -- line: 1673
		-- upvalues: p138 (copy), EnumGameDetailErrorTypes (copy), Roact (copy), EmptyState (copy)
		local v375 = p138.props.gameDetailError and p138.props.gameDetailError.errorType == EnumGameDetailErrorTypes.ExperienceUnavailable

		return Roact.createElement(EmptyState, {
			onActivated = if not v375 then p138.props.fetchGameDetailsPageData else nil,
			text = if not v375 then p139.failedMessage else p139.experienceUnavailableMessage
		})
	end)
end
function v136.willUnmount(p140) -- line: 1684
	-- upvalues: GetFFlagLuaAppEnableNotificationsEDPTooltip (copy)
	if GetFFlagLuaAppEnableNotificationsEDPTooltip() then
		p140.isMounted = false
	end
end
function v136.renderOnLoaded(p141) -- line: 1690
	-- upvalues: UiMode (copy), FFlagEnablePlayWithRewardNonPeekviewEdp (copy), getPlayButtonProps (copy), GetFFlagLuaAppEnableNotificationsEDPTooltip (copy), DeviceType (copy), GetFFlagNotificationsForceEnableEDPDiscoverability (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), Cryo (copy), Images (copy), Roact (copy), React (copy), GameDetailNotificationsButtonHint (copy), TooltipOrientation (copy), withLocalization (copy), FFlagLuaAppEdpFixDefaultBanner (copy), FFlagLuaAppUnifyPlayButtonNonMobileEdp (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), FFlagLuaAppEnablePlaySquadButton (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagLuaAppPlayButtonOptOutFoundationButton (copy), PlayButton (copy), ButtonSize (copy), FFlagLuaAppUnifiedPlayButtonSquadMenuDirection (copy), MenuDirection (copy), t3 (copy), DetailsPageSelector (copy)
	local deviceType = p141.props.deviceType
	local universeId = p141.props.universeId
	local gameInfo = p141.props.gameInfo
	local thumbnail = p141.props.thumbnail
	local tokens = p141.props.tokens
	local v159 = p141.props.uiModeInfo and p141.props.uiModeInfo.uiMode == UiMode.TenFoot
	local u160 = thumbnail and thumbnail.url
	local gameDetail = p141.props.gameDetail
	local v162 = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else gameDetail and gameDetail.rootPlaceId or gameInfo and gameInfo.placeId
	local v163 = gameDetail and gameDetail.description or nil
	local v164 = gameDetail and gameDetail.name or nil
	local v165 = p141.resolveTitleText(gameDetail, gameInfo)
	local v166 = gameDetail and gameDetail.creator.name or nil
	local v167 = gameDetail and gameDetail.creator.id or nil
	local v168 = gameDetail and gameDetail.creator.type or nil
	local v169 = nil
	local u170 = nil
	local u171 = nil

	if p141.props.ageRecommendations then
		local summary = p141.props.ageRecommendations.summary

		v169 = if not summary or not summary.ageRecommendation then nil else if not summary.ageRecommendation.displayNameWithHeaderShort then summary.ageRecommendation.displayName else summary.ageRecommendation.displayNameWithHeaderShort
		u170 = if not summary or (not summary.ageRecommendation or (not summary.ageRecommendation.igrsRating or summary.ageRecommendation.igrsRating == "")) then nil else summary.ageRecommendation.igrsRating
		u171 = if not summary or (not summary.ageRecommendation or not summary.ageRecommendation.igrsRatingDisplayMessage) then nil else summary.ageRecommendation.igrsRatingDisplayMessage
	end

	local v173 = p141.getPlaysAnsVisitsInfo(gameDetail, gameInfo)
	local socialLinks = p141.props.socialLinks
	local communityLink = p141.props.communityLink
	local v176 = getPlayButtonProps(p141.props.playButtonState, p141.props.gameProductInfo)
	local textKey = v176.textKey
	local price = v176.price
	local icon = v176.icon
	local v180 = not not GetFFlagLuaAppEnableNotificationsEDPTooltip() and p141.state.isNotificationsTooltipActive
	local isFullscreen = p141.state.isFullscreen
	local isCrossFade = p141.state.isCrossFade
	local currentIndex = p141.state.currentIndex
	local nextIndex = p141.state.nextIndex
	local mediaGalleryShowIndex = p141.state.mediaGalleryShowIndex
	local thumbnailSize = nil
	local sideMargin = nil
	local headerBarBackgroundHeight = nil

	if tokens then
		thumbnailSize = tokens.thumbnailSize
		sideMargin = tokens.sideMargin
		headerBarBackgroundHeight = tokens.headerBarBackgroundHeight
	end

	local u189 = nil

	if deviceType == DeviceType.Tablet then
		u189 = math.min(p141.props.viewHeight / 3, 500)
		thumbnailSize = 200
	elseif not v159 then
		u189 = 208
	end

	local v190 = v159 and v169
	local v191 = not not GetFFlagNotificationsForceEnableEDPDiscoverability() or p141.props.enableNotificationsDiscoverability
	local notificationsCanEnableExperience = p141.props.notificationsCanEnableExperience

	if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and ExperienceDetailsExperimentation.getShouldInterleaveSdui()) and (p141.props.edpServerIxpVariables and p141.props.edpServerIxpVariables.hideNotifyButton == true) then
		v191 = false
	end

	local v193 = Cryo.List.filter({
		not v159 and {
			props = {
				userInteractionEnabled = true,
				showBackground = true,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				icon = Images["icons/actions/friends/friendsplaying"],
				onActivated = p141.openShareContextualMenu,
				size = p141.props.iconButtonSize,
				backgroundColor = tokens and tokens.actionBarButtonBackgroundColor or nil
			}
		} or nil,
		{
			props = {
				userInteractionEnabled = true,
				showBackground = true,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				icon = Images["icons/common/more"],
				onActivated = p141.openMoreContextualMenu,
				size = p141.props.iconButtonSize,
				backgroundColor = tokens and tokens.actionBarButtonBackgroundColor or nil
			}
		},
		v191 and (not not notificationsCanEnableExperience and {
			props = {
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				icon = if not p141.props.gameFollowings or not p141.props.gameFollowings.isFollowed then Images["icons/common/notificationOff"] else Images["icons/common/notificationOn"],
				userInteractionEnabled = true,
				showBackground = true,
				onActivated = p141.toggleFollowExperience,
				size = p141.props.iconButtonSize,
				backgroundColor = tokens and tokens.actionBarButtonBackgroundColor or nil,
				[Roact.Children] = if not GetFFlagLuaAppEnableNotificationsEDPTooltip() then nil else {
					Tooltip = React.createElement(GameDetailNotificationsButtonHint, {
						isActive = v180,
						preferredOrientation = TooltipOrientation.Bottom
					})
				}
			}
		}) or nil
	}, function(p142) -- line: 1836
		return p142 ~= nil
	end)
	local t6 = nil

	if v159 then
		local v195 = p141.props.gameDetail and p141.props.gameDetail.licenseDescription or nil

		if v190 or v195 then
			t6 = {}
		end

		if v190 then
			table.insert(t6, {
				props = {
					userInteractionEnabled = true,
					showBackground = true,
					anchorPoint = Vector2.new(0, 0.5),
					position = UDim2.fromScale(0, 0.5),
					text = v169,
					horizontalPadding = tokens.actionBarTextButtonPadding.X,
					verticalPadding = tokens.actionBarTextButtonPadding.Y,
					size = p141.props.textButtonSize,
					onActivated = function() -- line: 1858
						-- upvalues: p141 (copy), universeId (copy)
						p141.props.openExperienceGuidelinesExplained(universeId, true)
					end,
					backgroundColor = tokens and tokens.actionBarButtonBackgroundColor or nil
				}
			})
		end

		if v195 then
			table.insert(t6, {
				props = {
					userInteractionEnabled = false,
					showBackground = true,
					anchorPoint = Vector2.new(0, 0.5),
					position = UDim2.fromScale(0, 0.5),
					text = v195,
					horizontalPadding = tokens.actionBarTextButtonPadding.X,
					verticalPadding = tokens.actionBarTextButtonPadding.Y,
					size = p141.props.textButtonSize,
					backgroundColor = tokens and tokens.actionBarButtonBackgroundColor or nil
				}
			})
		end
	else
		t6 = if not v190 then nil else {{
			props = {
				userInteractionEnabled = true,
				showBackground = true,
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.fromScale(0, 0.5),
				text = v169,
				horizontalPadding = tokens.actionBarTextButtonPadding.X,
				verticalPadding = tokens.actionBarTextButtonPadding.Y,
				size = p141.props.textButtonSize,
				onActivated = function() -- line: 1893
					-- upvalues: p141 (copy), universeId (copy)
					p141.props.openExperienceGuidelinesExplained(universeId, true)
				end,
				backgroundColor = tokens and tokens.actionBarButtonBackgroundColor or nil
			}
		}}
	end

	return withLocalization({
		buttonText = textKey
	})(function(p143) -- line: 1905
		-- upvalues: v176 (copy), price (copy), p141 (copy), deviceType (copy), u160 (ref), v165 (copy), tokens (copy), universeId (copy), v166 (copy), v167 (copy), v168 (copy), v163 (copy), v173 (copy), FFlagLuaAppEdpFixDefaultBanner (copy), FFlagLuaAppUnifyPlayButtonNonMobileEdp (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), FFlagLuaAppEnablePlaySquadButton (copy), icon (copy), Images (copy), GetFFlagUIBloxUseFoundationButton (copy), FFlagLuaAppPlayButtonOptOutFoundationButton (copy), Roact (copy), PlayButton (copy), v159 (copy), ButtonSize (copy), FFlagLuaAppUnifiedPlayButtonSquadMenuDirection (copy), MenuDirection (copy), v193 (copy), t6 (ref), v164 (copy), socialLinks (copy), communityLink (copy), t3 (copy), isFullscreen (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), u170 (ref), u171 (ref), FFlagEnablePlayWithRewardNonPeekviewEdp (copy), v162 (copy), mediaGalleryShowIndex (copy), isCrossFade (copy), currentIndex (copy), nextIndex (copy), sideMargin (ref), u189 (ref), thumbnailSize (ref), headerBarBackgroundHeight (ref), DetailsPageSelector (copy)
		local buttonText = p143.buttonText

		if v176.localizedFiatPrice then
			buttonText = v176.localizedFiatPrice
		elseif price then
			buttonText = p141.getAbbreviateCount(price)
		end

		local t7 = {
			dualPanelBreakpoint = 1e999,
			maxContentWidth = 850,
			deviceType = deviceType,
			thumbnailImageUrl = u160,
			titleText = v165,
			hideCloseButton = p141.props.hideCloseButton,
			actionBarLabelText = p141.props.playButtonContextualMessage,
			renderActionBarLabelImpressionsDetector = if not p141.props.playButtonContextualMessage then nil else p141.renderActionBarLabelImpressionsDetector,
			renderInfoContent = p141.renderInfoContent(tokens, universeId, v166, v167, v168, p141.props.creatorVerified or false, v163, v173.plays, v173.totalUpVotes, v173.totalDownVotes),
			onClose = p141.onClose
		}
		local defaultBannerUrl

		if FFlagLuaAppEdpFixDefaultBanner then
			defaultBannerUrl = p141.props.defaultBannerUrl

			if not defaultBannerUrl then
				local v381 = p141.state.bannerImageId or p141.props.bannerImageId

				defaultBannerUrl = not v381 and "" or "rbxassetid://" .. v381
			end
		else
			local v382 = p141.state.bannerImageId or p141.props.bannerImageId

			defaultBannerUrl = not v382 and "" or "rbxassetid://" .. v382
		end

		t7.bannerImageUrl = defaultBannerUrl
		t7.actionBarProps = {
			iconSize = p141.props.tokens.iconSize,
			buttonHeight = p141.props.actionBarHeight,
			buttonPadding = tokens.headerItemPadding,
			button = if not FFlagLuaAppUnifyPlayButtonNonMobileEdp or not not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp and not p141.props.hasUnifiedPlayButtonIxp then {
				props = if not FFlagLuaAppEnablePlaySquadButton or not v176.showSquadButton then {
					onActivated = p141.onPlayButtonActivated,
					icon = if not icon then nil else Images[icon],
					text = buttonText,
					isDisabled = v176.isDisabled,
					isLoading = v176.isLoading,
					buttonType = v176.buttonType,
					size = p141.props.playButtonSize,
					buttonRef = p141.props.playButtonRef,
					DO_NOT_USE_useUIBloxButton = GetFFlagUIBloxUseFoundationButton() and true or (not not FFlagLuaAppPlayButtonOptOutFoundationButton or nil)
				} else {
					button = {
						onActivated = p141.onPlayButtonActivated,
						icon = if not icon then nil else Images[icon],
						text = buttonText,
						isDisabled = v176.isDisabled
					},
					overflow = {
						isDisabled = v176.isSquadButtonDisabled,
						onActivated = p141.props.onPlaySquadButtonActivated
					},
					size = p141.props.playButtonSize
				}
			} else nil,
			buttonOverride = if not FFlagLuaAppUnifyPlayButtonNonMobileEdp or not not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp and not p141.props.hasUnifiedPlayButtonIxp then nil else Roact.createElement(PlayButton, {
				launchSource = "ExperienceDetailsPage",
				fillBehavior = "Fill",
				testId = "--experience-details--play-button",
				universeId = universeId,
				referralSource = p141.props.referralSource,
				experienceJoinData = p141.props.experienceJoinData,
				placeId = p141.props.placeIdOverride,
				buttonSize = if not v159 then ButtonSize.Large else ButtonSize.Medium,
				squadButtonHeight = UDim.new(0, p141.props.actionBarHeight),
				squadButtonMenuDirection = if not FFlagLuaAppUnifiedPlayButtonSquadMenuDirection then nil else MenuDirection.Down,
				useUIBloxButton = p141.props.unifyToUIBloxIxp
			}),
			icons = v193,
			textButtons = t6
		}
		t7.actionBarWidth = if not FFlagLuaAppEnablePlaySquadButton or not v176.showSquadButton then p141.applyTokenScaling(380) else p141.applyTokenScaling(420)
		t7.actionBarHeight = p141.props.actionBarHeight
		t7.componentList = p141.getBodyComponentListProps(universeId, p141.props.gameDetailsPageDataStatus, v163, v164, v173.plays, v173.visits, socialLinks, communityLink, p141.props.communityLinksEnabled, p141.props.communityLinkVariant, p141.props.detailsPageConfiguration or t3, isFullscreen, v159, p141.props.bannerImageId, if not p141.props.gameDetail then nil else p141.props.gameDetail.refundPolicy, p141.props.experienceDetailsNoticeType, if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) then nil else p141.props.sduiFeedItemConfigs, u170, u171, p141.props.webViewSupport, p141.props.openWebview, p141.props.linking, if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else p141.props.playWithRewardData, if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else p141.props.showPlayWithReward, if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else p141.props.isPlayable, if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else v162, if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else p141.props.placeIdOverride, if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else p141.props.experienceJoinData)
		t7.isFullscreen = isFullscreen
		t7.renderFullscreenContent = p141.renderFullscreenContent(universeId, mediaGalleryShowIndex, isFullscreen, isCrossFade, currentIndex, nextIndex)
		t7.sideMargin = sideMargin
		t7.startingOffsetPosition = u189
		t7.thumbnailHeight = thumbnailSize
		t7.headerBarBackgroundHeight = headerBarBackgroundHeight
		t7.tokens = if not tokens then nil else {
			thumbnailMargin = tokens.thumbnailMargin,
			thumbnailShadowHeight = tokens.thumbnailShadowHeight,
			headerGradientHeight = tokens.headerGradientHeight,
			headerBottomMargin = tokens.headerBottomMargin,
			animationConfig = tokens.animationConfig,
			itemPadding = tokens.itemPadding,
			safeAreaSize = tokens.safeAreaSize,
			trailingWhitespace = tokens.trailingWhitespace,
			actionBarHeight = p141.props.actionBarHeight
		}
		t7.disableStickyActionBar = p141.props.disableStickyActionBar
		t7.containerRef = p141.props.containerRef

		return Roact.createElement(DetailsPageSelector, {
			deviceType = deviceType,
			detailsPageProps = t7
		})
	end)
end

local function ExperienceDetailsPageFn(p144) -- line: 2084
	-- upvalues: FFlagEDPTTITrackingEnabled (copy), useFirstMediaCarouselImageUri (copy), useEDPTTITracking (copy), EDPTTIConstants (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ExperienceDetailsExperimentation (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), ServerDrivenUi (copy), EdpSduiUtils (copy), t1 (copy), t2 (copy), ApiFetchExperienceDetailsPageCounters (copy), useEdpServerIxpVariables (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), useEdpPerUniverseVisibilityVariablesForUniverse (copy), useUiModeInfo (copy), ReactFocusNavigation (copy), React (copy), UiMode (copy), useTokens (copy), Responsive (copy), useCloseWithBackButton (copy), Roact (copy), v136 (copy), Cryo (copy)
	if FFlagEDPTTITrackingEnabled then
		local v197 = useFirstMediaCarouselImageUri(p144.universeId)

		useEDPTTITracking(EDPTTIConstants.EDP_IMPLEMENTATION.LEGACY_FULL_PAGE, p144.universeId, v197)
	end

	local v198 = nil

	if FFlagLuaAppEdpBackendV2HydrateLegacyIxp then
		v198 = ExperienceDetailsExperimentation.getShouldHydrateLegacy()
	end

	local v199 = nil

	if FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v199 = ExperienceDetailsExperimentation.getShouldInterleaveSdui()
	end

	local v200 = nil
	local v201 = nil
	local v202 = nil

	if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		local v203 = ServerDrivenUi.useSduiContextFromSignalAndProcessConfigs(EdpSduiUtils.getUnprocessedEdpStoreKey((tostring(p144.universeId))), EdpSduiUtils.getEdpStoreKey((tostring(p144.universeId))), FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and v199)

		v200 = ServerDrivenUi.useSduiEdpFeedItemConfigs({
			sduiContext = v203,
			storeKey = EdpSduiUtils.getEdpStoreKey((tostring(p144.universeId))),
			portraitLayoutConfig = t1,
			landscapeLayoutConfig = t2,
			defaultLayoutOrder = t1.SduiFeedItemsDefault,
			logLayoutConflictFn = ApiFetchExperienceDetailsPageCounters.logSduiLayoutOrderConflict,
			shouldInterleaveSdui = FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and v199
		})
		v201 = useEdpServerIxpVariables()
		v202 = if not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then nil else useEdpPerUniverseVisibilityVariablesForUniverse(p144.universeId)
	end

	local v204 = useUiModeInfo()
	local v205 = ReactFocusNavigation.useFocusGuiObject()
	local v206, v207 = React.useState(nil)
	local v208 = not p144.tokens and 0 or p144.tokens.iconSize
	local v209 = if v204.uiMode ~= UiMode.TenFoot then nil else UDim2.fromOffset(v208, v208)
	local uDim2 = UDim2.fromOffset(0, v208)
	local v211 = p144.tokens and p144.tokens.actionBarHeight or v208
	local uDim2_2 = UDim2.new(1, 0, 0, v211)
	local v213 = useTokens()
	local v214 = React.useRef(nil)

	v214.current = Responsive.usePreferredInput() == Responsive.Input.Directional

	local current = v214.current
	local v216 = useCloseWithBackButton(v207, p144.onClose)
	local v217, v218 = React.useState(nil)
	local u219 = v217
	local v220 = React.useRef(nil)

	React.useEffect(function() -- line: 2157
		-- upvalues: u219 (ref), v220 (copy), v214 (copy), v205 (copy)
		if u219 == nil then
			v220.current = false

			return
		end

		if u219 and v214.current and not v220.current then
			v205(u219)
			v220.current = true
		end
	end, {
		u219,
		v205
	})
	React.useEffect(function() -- line: 2169
		-- upvalues: v206 (copy)
		local n2 = -1
		local connection = nil

		if v206 then
			connection = v206.SelectionChanged:Connect(function(_, p146, p147) -- line: 2173
				-- upvalues: v206 (copy), n2 (ref)
				if p147 == nil or (p146 == nil or not p147:IsDescendantOf(v206) or not p146:IsDescendantOf(v206)) then
					return
				end

				p147.SelectionOrder = n2
				n2 -= 1
			end)
		end

		return function() -- line: 2187
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v206 })

	return Roact.createElement(v136, Cryo.Dictionary.join({
		foundationTokens = v213,
		uiModeInfo = v204,
		focusGuiObject = v205,
		iconButtonSize = v209,
		textButtonSize = uDim2,
		playButtonSize = uDim2_2,
		actionBarHeight = v211,
		playButtonRef = v218,
		containerRef = v216,
		sduiFeedItemConfigs = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not v199) then nil else v200,
		disableStickyActionBar = current,
		hideCloseButton = current,
		shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else v198,
		shouldInterleaveSduiIxp = if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else v199,
		edpServerIxpVariables = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not v199) then nil else v201,
		edpPerUniverseVisibilityVariables = if not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable or not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not v199) then nil else v202
	}, p144))
end

return ExperienceDetailsPageFn
