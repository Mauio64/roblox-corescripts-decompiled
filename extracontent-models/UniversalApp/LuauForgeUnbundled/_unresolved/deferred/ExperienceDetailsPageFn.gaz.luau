local LocalizationService = game:GetService("LocalizationService")
local IXPService = game:GetService("IXPService")
local AppStorageService = game:GetService("AppStorageService")
local CorePackages = game:GetService("CorePackages")
local defineFastFlag = game:DefineFastFlag("LuaAppRemoveEDPLoadingState", false)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useTokens = Foundation.Hooks.useTokens
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local UIBlox = require(CorePackages.Packages.UIBlox)
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local emptyState = UIBlox.App.Indicator.EmptyState
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Core.Style.withStyle
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local detailsPageSelector = require("@game/CorePackages/Workspace/Packages/AppBlox").DetailsPageSelector
local contentPosition = require("@game/CorePackages/Workspace/Packages/AppBlox").ContentPosition
local useCloseWithBackButton = require("@game/CorePackages/Workspace/Packages/AppBlox").useCloseWithBackButton
local images = UIBlox.App.ImageSet.Images
local playerCount = UIBlox.App.Indicator.PlayerCount
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local menuDirection = UIBlox.App.Menu.MenuDirection
local text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local deviceType = RobloxAppEnums.DeviceType
local uiMode = RobloxAppEnums.UiMode
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/Localization").abbreviateCount
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local gameStats = require("@luauforge/bundled/fYU").GameStats
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module6 = require("@luauforge/deferred/fXb")
local module7 = require("@luauforge/deferred/fZh")
local videoPlaybackCoordinator = require("@luauforge/bundled/fZd").VideoPlaybackCoordinator
local ixpServiceWrapper = require("@luauforge/bundled/fvx").IXPServiceWrapper
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local module9 = require("@luauforge/bundled/dUd")

local experienceCommunityLink = require("@luauforge/bundled/dBe").Components.ExperienceCommunityLink
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local module10 = require("@luauforge/bundled/eeo")
local focusNavigableSurfaceWrapper = module10.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module10.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module10.FocusNavigationEventNameEnum

local ageRecommendationDetails = require("@luauforge/bundled/dyi").AgeRecommendations.AgeRecommendationDetails
local experienceDetailsNoticeType = require("@luauforge/bundled/cyO").ExperienceDetailsNoticeType
local enumGameDetailErrorTypes = require("@luauforge/bundled/cyO").EnumGameDetailErrorTypes

local modules = require("@luauforge/bundled/dpZ").Modules
local experienceRatings = modules.LuaApp.Components.ExperienceDetails.ExperienceRatings
local getPlayButtonProps = modules.LuaApp.Common.Experience.getPlayButtonProps
local module11 = require("@luauforge/bundled/fWH")
local playButton = module11.PlayButton
local playWithRewardComponent = require("@luauforge/deferred/fXc").PlayWithRewardComponent

local checkAndFormatPossibleLink = require("@luauforge/bundled/edJ").checkAndFormatPossibleLink

local retrievalStatus2 = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus

local module12 = require("@luauforge/bundled/dwA")
local module13 = require("@luauforge/bundled/fue")
local module14 = require("@luauforge/deferred/fyr")
local module15 = require("@luauforge/deferred/fYP")
local module16 = require("@luauforge/deferred/fZr")

local FtuxTooltipAnchor = require("@game/CoreGui/RobloxGui/Modules/Chrome/Integrations/FtuxTooltipAnchor")
local module18 = require("@luauforge/deferred/fYX")
local module19 = require("@luauforge/deferred/fYb")
local module20 = require("@luauforge/deferred/fYl")
local module21 = require("@luauforge/deferred/fZq")
local module22 = require("@luauforge/deferred/fXY")
local module23 = require("@luauforge/deferred/gaA")
local module24 = require("@luauforge/deferred/fYc")
local module25 = require("@luauforge/deferred/gaF")
local module26 = require("@luauforge/deferred/fZc")
local module27 = require("@luauforge/deferred/fYV")
local module28 = require("@luauforge/deferred/gan")
local module29 = require("@luauforge/deferred/fZs")
local module30 = require("@luauforge/deferred/fWP")
local module31 = require("@luauforge/bundled/dAU")
local module32 = require("@luauforge/deferred/fWQ")
local module33 = require("@luauforge/deferred/fXe")

local module34 = require("@luauforge/deferred/fXf")

local module35 = require("@luauforge/deferred/fXR")
local playButtonContextualMessageImpressionsDetector = module11.PlayButtonContextualMessageImpressionsDetector

local module36 = require("@luauforge/bundled/dHp")
local edpttiConstants = module36.EDPTTIConstants
local fFlagEDPTTITrackingEnabled = module36.FFlagEDPTTITrackingEnabled
local module37 = require("@luauforge/deferred/gaq")
local useFirstMediaCarouselImageUri = require("@luauforge/deferred/gar").useFirstMediaCarouselImageUri
local module38 = require("@luauforge/deferred/fZn")

local useMediaGalleryVideoAnalytics = require("@luauforge/deferred/fZo").useMediaGalleryVideoAnalytics

local getFFlagEnableTenftUiDetailsMoreDropupMenu = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableTenftUiDetailsMoreDropupMenu

local getFFlagExpDetailsUseSelectionBumpers = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagExpDetailsUseSelectionBumpers
local module39 = require("@luauforge/deferred/fZa")

local module40 = require("@luauforge/deferred/fYj")
local module41 = require("@luauforge/deferred/fYk")

local getFFlagConsoleApplyTokenizationEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagConsoleApplyTokenizationEdp
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local getFFlagNotificationsForceEnableEDPDiscoverability = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagNotificationsForceEnableEDPDiscoverability

local fFlagLuaAppDesktopMediaGalleryTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDesktopMediaGalleryTelemetry

local fFlagLuaAppEdpFixDefaultBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpFixDefaultBanner
local fFlagSongEdpCarouselIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSongEdpCarouselIxp

local fFlagLuaAppExperienceDetailsLayoutOrderConfig = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExperienceDetailsLayoutOrderConfig

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEnableConsolidatedGameRefundPolicy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableConsolidatedGameRefundPolicy

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local module42 = require("@luauforge/deferred/fYq")
local module43 = require("@luauforge/deferred/fYr")

local module44 = require("@luauforge/deferred/fYs")

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppUnifyPlayButtonNonMobileEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifyPlayButtonNonMobileEdp

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagLuaAppEdpNonSduiBuildAttribution = SharedFlags.FFlagLuaAppEdpNonSduiBuildAttribution

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable

local fFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifyPlayButtonAllSurfacesIxp

local fFlagLuaAppUnifiedPlayButtonSquadMenuDirection = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifiedPlayButtonSquadMenuDirection

local fFlagLuaAppGameStatsFallbackRendering = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGameStatsFallbackRendering
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local fFlagLuaAppAddSocialLinkClickTelemetryToEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddSocialLinkClickTelemetryToEdp

local fFlagLuaAppExpandableTextImpressionsEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExpandableTextImpressionsEnabled

local fFlagEnablePlayWithRewardNonPeekviewEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlayWithRewardNonPeekviewEdp

local getFFlagUIBloxUseFoundationButton = require("@game/CorePackages/Workspace/Packages/SharedFlags").UIBlox.GetFFlagUIBloxUseFoundationButton

local fFlagLuaAppPlayButtonOptOutFoundationButton = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppPlayButtonOptOutFoundationButton
local fFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideo
local fFlagLuaAppEdpConsoleMediaGalleryVideoMute = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideoMute
local fFlagLuaAppUpdateFailedStateEdpIcon = SharedFlags.FFlagLuaAppUpdateFailedStateEdpIcon
local defineFastInt = game:DefineFastInt("PlayWithRewardNonPeekviewEdpLayoutOrder", 75)
local defineFastInt2 = game:DefineFastInt("LuaAppEDPSecondaryButtonExpansion", 200)
local v5 = fFlagLuaAppGameStatsFallbackRendering and "--" or nil
local v6 = {
	PlayWithReward = if fFlagEnablePlayWithRewardNonPeekviewEdp then defineFastInt else nil,
	MediaGalleryMediaFirst = 100,
	EventsListRedesign = 200,
	Description = 300,
	MediaGallery = 400,
	IgrsRatingLabel = 450,
	ExperienceRatings = 500,
	PlaysAndVisits = 600,
	CommunityLink = 700,
	ExperienceInfoTable = 800,
	BuildAttributionDisclaimer = fFlagLuaAppEdpNonSduiBuildAttribution and 850 or nil,
	RefundPolicy = 900,
	LogoTraySection = 1000,
	Notice = 1200,
	RecommendedExperiences = 1300,
	ExperienceSongsCarousel = 1400,
	SduiFeedItemsDefault = 1500
}

local v8 = {
	PlayWithReward = 0,
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
	BuildAttributionDisclaimer = 0,
	RefundPolicy = 1100,
	LogoTraySection = 1200,
	Notice = 1300,
	SduiFeedItemsDefault = 1500
}

if not fFlagEnablePlayWithRewardNonPeekviewEdp then
	defineFastInt = nil
end

v8.PlayWithReward = defineFastInt

v8.BuildAttributionDisclaimer = fFlagLuaAppEdpNonSduiBuildAttribution and 1050 or nil

local extended = Roact.PureComponent:extend("ExperienceDetailsPage")

local strictInterface = t.strictInterface
local v9 = {}
v9.universeId = t.string
v9.referralSource = t.optional(t.string)

local v10 = if fFlagLuaAppUnifyPlayButtonNonMobileEdp or fFlagEnablePlayWithRewardNonPeekviewEdp then t.optional(t.table) else nil
v9.experienceJoinData = v10

v9.placeIdOverride = t.optional(t.string)
v9.onClose = t.callback

v9.thumbnail = t.optional(t.table)
v9.bannerImageId = t.optional(t.string)
local v11 = if fFlagLuaAppEdpFixDefaultBanner then t.optional(t.string) else nil
v9.defaultBannerUrl = v11
v9.gameInfo = t.optional(t.table)
local v12 = if fFlagMigrateGameInfoToStore then t.optional(t.table) else nil
v9.storeVotes = v12
v9.gameDetail = t.optional(t.table)
v9.gameDetailError = t.optional(t.table)
v9.creatorVerified = t.optional(t.boolean)
v9.gameDetailsPageDataStatus = t.optional(t.string)
v9.gameProductInfo = t.optional(t.table)
v9.socialLinks = t.optional(t.table)
v9.ageRecommendations = t.optional(ageRecommendationDetails.validateModel)
v9.communityLink = t.optional(t.table)
v9.gameFollowings = t.optional(t.table)

local v13 = if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then t.optional(t.table) else nil
v9.sduiFeedItemConfigs = v13

local v14 = if fFlagEnablePlayWithRewardNonPeekviewEdp then t.optional(t.table) else nil
v9.playWithRewardData = v14
local v15 = if fFlagEnablePlayWithRewardNonPeekviewEdp then t.optional(t.boolean) else nil
v9.showPlayWithReward = v15
local v16 = if fFlagEnablePlayWithRewardNonPeekviewEdp then t.optional(t.boolean) else nil
v9.isPlayable = v16

v9.communityLinksEnabled = t.optional(t.boolean)
v9.communityLinkVariant = t.optional(t.string)
v9.enableNotificationsDiscoverability = t.optional(t.boolean)
local v17 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then t.optional(t.boolean) else nil
v9.mediaGalleryRedesignEnabledIxp = v17

local v18 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then t.optional(t.boolean) else nil
v9.mediaGalleryVideoPreviewEnabledIxp = v18

local v19 = if fFlagSongEdpCarouselIxp then t.optional(t.boolean) else nil
v9.showSongCarousel = v19
local v20 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v9.shouldHydrateLegacyIxp = v20
local v21 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then t.optional(t.boolean) else nil
v9.shouldInterleaveSduiIxp = v21

local v22 = if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then t.optional(t.table) else nil
v9.edpServerIxpVariables = v22

local v23 = if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then t.optional(t.table) else nil
v9.edpPerUniverseVisibilityVariables = v23

v9.hideCloseButton = t.optional(t.boolean)
local v24 = if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then t.optional(t.boolean) else nil
v9.hasUnifiedPlayButtonIxp = v24
local v25 = if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then t.optional(t.boolean) else nil
v9.unifyToUIBloxIxp = v25

v9.fetchGameDetailsPageData = t.callback
v9.openLeaveRobloxAlertUIBlox = t.callback
v9.openMoreContextualMenu = t.callback
v9.openShareContextualMenu = t.callback
v9.closeAlert = t.callback
v9.openVerifiedBadgeModal = t.optional(t.callback)
local v26 = if not module42 then t.callback else nil
v9.openCreatorPage = v26
local v27 = if module42 then t.optional(t.callback) else nil
v9.openCommunityProfilePage = v27
local v28 = if module42 then t.optional(t.callback) else nil
v9.openUserProfilePage = v28
v9.openExperienceGuidelinesExplained = t.callback
v9.toggleFollowExperience = t.optional(t.callback)
v9.openRefundPolicyLearnMorePage = t.callback
v9.openWebview = t.callback

local v29 = if fFlagLuaAppDesktopMediaGalleryTelemetry and not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v9.onMediaGalleryPreviewActivated = v29

local v30 = if fFlagLuaAppDesktopMediaGalleryTelemetry and not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v9.onMediaGalleryThumbnailActivated = v30

local v31 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v9.onMediaGalleryMediaChanged = v31
local v32 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v9.onMediaGalleryEnterFullscreen = v32
local v33 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v9.onMediaGalleryExitFullscreen = v33
local v34 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then t.optional(t.table) else nil
v9.videoAnalytics = v34

v9.linking = t.table

v9.playabilityStatus = t.optional(t.table)
v9.playButtonState = t.string
v9.secondaryPlayButtonState = t.optional(t.string)
v9.onPlayButtonActivated = t.callback
local v35 = if getFFlagIsSquadEnabled() then t.callback else nil
v9.onPlaySquadButtonActivated = v35
v9.playButtonContextualMessage = t.optional(t.string)
v9.canExpandActionBarForSecondaryButton = t.optional(t.boolean)

v9.deviceType = t.optional(t.string)
v9.detailsPageConfiguration = t.optional(t.table)

v9.viewWidth = t.optional(t.number)
v9.viewHeight = t.optional(t.number)

v9.setControllerBarNavigation = t.optional(t.callback)
v9.uiModeInfo = t.optional(t.any)
v9.focusGuiObject = t.optional(t.callback)

local strictInterface2 = t.strictInterface
local v36 = {
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
	expandableAreaHeightOffset = 0,
	actionBarHeight = 0
}
local v37 = if getFFlagConsoleApplyTokenizationEdp() then t.optional(t.number) else nil
v36.expandableAreaHeightOffset = v37
v36.actionBarHeight = t.optional(t.number)
v9.tokens = strictInterface2(v36)

v9.webViewSupport = t.boolean
v9.notificationsCanEnableExperience = t.optional(t.boolean)
v9.experienceDetailsNoticeType = t.optional(t.string)

v9.iconButtonSize = t.optional(t.UDim2)
v9.textButtonSize = t.optional(t.UDim2)
v9.playButtonSize = t.optional(t.UDim2)
v9.actionBarHeight = t.optional(t.number)

v9.statsAndInfoRef = t.optional(t.table)
v9.playButtonRef = t.optional(t.union(t.table, t.callback))
v9.containerRef = t.optional(t.union(t.table, t.callback))

v9.foundationTokens = t.optional(t.table)
v9.disableStickyActionBar = t.optional(t.boolean)
extended.validateProps = strictInterface(v9)

local function createImageURL(p2)
	if p2 then
		return "rbxassetid://" .. p2
	end

	return ""
end

local v38 = {
	showEventsList = true,
	showLogoTraySection = true,
	showCornerGradientPropEnabled = false,
	showCommunityLink = false
}

function extended:init()
	local v39 = localization.new(LocalizationService.RobloxLocaleId)
	function self.applyTokenScaling(p2)
		return p2 * self.props.foundationTokens.Stroke.Standard
	end

	function self.getAbbreviateCount(p2)
		return abbreviateCount(p2, v39:GetLocale())
	end

	function self.upperString(p2)
		return string.upper(v39:Format(p2))
	end

	function self.onPlayButtonActivated()
		return self.props.onPlayButtonActivated()
	end

	function self.openMoreContextualMenu(p2)
		local universeId = self.props.universeId
		local vector2 = nil

		local v40 = self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot
		local udim

		if getFFlagEnableTenftUiDetailsMoreDropupMenu() and v40 then
			local deviceSafePadding = module9.GetDisplayStore().getDeviceSafePadding()
			vector2 = Vector2.new(0, 1)
			udim = UDim2.fromOffset(
				p2.AbsolutePosition.X,
				p2.AbsolutePosition.Y - 12 + deviceSafePadding.top
			)
		else
			udim = UDim2.fromOffset(
				p2.AbsolutePosition.X + p2.AbsoluteSize.X - 300,
				p2.AbsolutePosition.Y + p2.AbsoluteSize.Y + 12
			)
		end

		return self.props.openMoreContextualMenu(universeId, udim, vector2, self.props.hideCloseButton)
	end

	self.getTextHeight = memoize(function(p2, p3, p4, p5)
		return text.GetTextHeight(p2, p3, p4, p5)
	end)

	function self.openShareContextualMenu(p2)
		local universeId = self.props.universeId
		local udim = UDim2.fromOffset(
			p2.AbsolutePosition.X + p2.AbsoluteSize.X - 300,
			p2.AbsolutePosition.Y + p2.AbsoluteSize.Y + 12
		)

		return self.props.openShareContextualMenu(universeId, udim, self.props.hideCloseButton)
	end

	function self.getPlaysAnsVisitsInfo(p2, data)
		if not fFlagMigrateGameInfoToStore then
			return {
				plays = p2 and p2.playing or data and data.playerCount or not fFlagLuaAppGameStatsFallbackRendering and 0 or nil,
				visits = p2 and p2.visits or not fFlagLuaAppGameStatsFallbackRendering and 0 or nil,
				totalUpVotes = data and data.totalUpVotes or 0,
				totalDownVotes = data and data.totalDownVotes or 1
			}
		end

		local storeVotes = self.props.storeVotes
		return {
			plays = p2 and p2.playing or data and data.playerCount or not fFlagLuaAppGameStatsFallbackRendering and 0 or nil,
			visits = p2 and p2.visits or not fFlagLuaAppGameStatsFallbackRendering and 0 or nil,
			totalUpVotes = storeVotes and storeVotes.upVotes or 0,
			totalDownVotes = storeVotes and storeVotes.downVotes or 1
		}
	end

	function self.getStyledTextLabel(p2, p3, p4)
		if p2 then
			return Roact.createElement(styledTextLabel, {
				text = p2,
				fontStyle = p3,
				colorStyle = p4,
				automaticSize = Enum.AutomaticSize.XY,
				layoutOrder = 1,
				richText = false,
				lineHeight = 1
			})
		end

		return nil
	end

	function self.toggleFollowExperience()
		if module40() then
			self:setState({ isNotificationsTooltipActive = false })
		end

		if not self.props.gameFollowings then
			return
		end

		local universeId = self.props.universeId
		local isFollowed = self.props.gameFollowings.isFollowed

		if self.props.toggleFollowExperience then
			self.props.toggleFollowExperience(universeId, not isFollowed)
		end
	end

	function self.renderSubtitleTextOverride(p2, p3, p4, p5, p6, p7, p8)
		local function fn(p9)
			return withStyle(function(props)
				local v40 = if module39 then props.Tokens.Typography.TitleLarge else props.Font.Header2

				local v41 = if module39 then v40.FontSize else v40.RelativeSize * props.Font.BaseSize
				local textMuted = props.Theme.TextMuted

				if module43 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(module44)
				end

				if not (p9 and p7) then
					return self.getStyledTextLabel(p9, v40, textMuted)
				end

				local v42 = {
					name = appPage.GenericWebPage,
					detail = urlBuilder.game.info.creator({
						creatorType = p4,
						creatorId = p3
					}),
					extraProps = {
						title = v39:Format("Feature.GameDetails.Label.Developer"),
						transitionAnimation = module13.SlideInFromRight
					}
				}

				local createElement = Roact.createElement
				local v44 = {}
				v44.Text = p9
				local v45 = if not foundationFontFaceMigration then v40.Font else nil
				v44.Font = v45

				local v46 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
				v44.FontFace = v46

				v44.TextColor3 = textMuted.Color
				v44.LayoutOrder = 2
				v44.AutoButtonColor = false
				v44.LineHeight = 1
				v44.AutomaticSize = Enum.AutomaticSize.XY
				v44.TextSize = v41
				v44.BackgroundTransparency = 1
				local tag = React.Tag
				local v47 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-experience-creator") else nil
				v44[tag] = v47

				v44[Roact.Event.Activated] = function()
					if module42 then
						if p4 == "User" then
							self.props.openUserProfilePage(p3, "ExperienceDetailsPage:SubTitle")
						elseif p4 == "Group" then
							self.props.openCommunityProfilePage(p3, "ExperienceDetailsPage:SubTitle")
						end
					else
						self.props.openCreatorPage(v42)
					end
				end

				return createElement("TextButton", v44)
			end)
		end

		local createElement = Roact.createElement
		local emojiWrapper = VerifiedBadges.EmojiWrapper
		local v40 = {
			emoji = not p6 and "" or VerifiedBadges.emoji.verified,
			layoutOrder = 2,
			onActivated = 0
		}

		local v41 = if p6 and p7 then self.props.openVerifiedBadgeModal else nil
		v40.onActivated = v41
		local element = createElement(emojiWrapper, v40, {
			userText = withStyle(function(props)
				local v42 = if module39 then props.Tokens.Typography.TitleLarge else props.Font.Header2

				local v43 = if module39 then v42.FontSize else v42.RelativeSize * props.Font.BaseSize
				local textMuted = props.Theme.TextMuted

				if module43 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(module44)
				end

				if not (p2 and p7) then
					return self.getStyledTextLabel(p2, v42, textMuted)
				end

				local v44 = {
					name = appPage.GenericWebPage,
					detail = urlBuilder.game.info.creator({
						creatorType = p4,
						creatorId = p3
					}),
					extraProps = {
						title = v39:Format("Feature.GameDetails.Label.Developer"),
						transitionAnimation = module13.SlideInFromRight
					}
				}

				local createElement2 = Roact.createElement
				local v46 = {}
				v46.Text = p2
				local v47 = if not foundationFontFaceMigration then v42.Font else nil
				v46.Font = v47

				local v48 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
				v46.FontFace = v48

				v46.TextColor3 = textMuted.Color
				v46.LayoutOrder = 2
				v46.AutoButtonColor = false
				v46.LineHeight = 1
				v46.AutomaticSize = Enum.AutomaticSize.XY
				v46.TextSize = v43
				v46.BackgroundTransparency = 1
				local tag = React.Tag
				local v49 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-experience-creator") else nil
				v46[tag] = v49

				v46[Roact.Event.Activated] = function()
					if module42 then
						if p4 == "User" then
							self.props.openUserProfilePage(p3, "ExperienceDetailsPage:SubTitle")
						elseif p4 == "Group" then
							self.props.openCommunityProfilePage(p3, "ExperienceDetailsPage:SubTitle")
						end
					else
						self.props.openCreatorPage(v44)
					end
				end

				return createElement2("TextButton", v46)
			end)
		})

		if not fFlagLuaAppEdpNonSduiBuildAttribution or p2 == nil or not p8 then
			return element
		end

		local v42 = if p6 then `{p2}{module3.emoji.verified}` else p2
		local v43 = module20(v39, true, v42)

		if v43 == nil then
			return element
		end

		return fn(v43)
	end

	function self.renderTextOverride(p2, p3, p4, p5)
		return Roact.createElement(VerifiedBadges.EmojiWrapper, {
			emoji = not p5 and "" or VerifiedBadges.emoji.verified,
			layoutOrder = 0,
			size = UDim2.fromScale(0, 1)
		}, {
			userText = withStyle(function(data)
				local v40 = if module39 then data.Tokens.Typography.TitleLarge else data.Font.Header2
				local textEmphasis = data.Theme.TextEmphasis
				return self.getStyledTextLabel(p2, v40, textEmphasis)
			end)
		})
	end

	self.renderExperienceGuidelines = memoize(function(p2)
		local createElement = React.createElement
		local v41 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			BackgroundTransparency = 1
		}

		local v42 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4)
			}),
			ExperienceTagsContainer = 0
		}

		local createElement2 = React.createElement
		local v44 = {
			areTagsInteractable = true,
			includeAgeRecommendations = true,
			universeId = p2,
			LayoutOrder = 1,
			hideCloseButton = self.props.hideCloseButton,
			shouldHydrateLegacyIxp = 0
		}

		local v45 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
		v44.shouldHydrateLegacyIxp = v45
		v42.ExperienceTagsContainer = createElement2(module27, v44)
		return createElement("Frame", v41, v42)
	end)

	self.renderInlinePlayerCountAndLikes = memoize(function(p2, p3, p4)
		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(0, 120, 0, 20),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			},
			{
				GameStats = Roact.createElement(gameStats, {
					stats = { playerCount = p2, totalUpVotes = p3, totalDownVotes = p4 }
				})
			}
		)
	end)

	function self.renderBriefDescription(p2, p3)
		return withStyle(function(props)
			local font = props.Font
			local headerDescriptionLineHeight = p2.headerDescriptionLineHeight

			local v40 = headerDescriptionLineHeight * math.floor(font.BaseSize * font.Body.RelativeSize) * p2.headerDescriptionMaxRows
			local v41

			if module39 then
				v41 = props.Tokens.Typography.BodyLarge.FontSize
			else
				v41 = font.BaseSize * font.Body.RelativeSize
			end

			local font2 = if module39 then props.Tokens.Typography.BodyLarge.Font else font.Body.Font
			local v42

			if foundationFontFaceMigration then
				v42 = getTextSize(p3, v41, font2, Vector2.new(1e999, 1e999)).Y
			else
				v42 = self.getTextHeight(p3, font2, v41, UDim2.new(1, 0, 0, v40))
			end

			local createElement = Roact.createElement
			local v44 = {
				Size = UDim2.new(1, 0, 0, (math.min(v42, v40))),
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				ClipsDescendants = true
			}

			local createElement2 = Roact.createElement
			local v47 = {
				text = p3,
				fontStyle = 0,
				colorStyle = 0,
				size = 0,
				richText = false,
				fluidSizing = false,
				lineHeight = 0
			}

			local v48 = if module39 then props.Tokens.Typography.BodyLarge else font.Body
			v47.fontStyle = v48

			v47.colorStyle = props.Theme.TextEmphasis
			v47.size = UDim2.fromScale(1, 1)

			v47.lineHeight = headerDescriptionLineHeight
			return createElement("Frame", v44, {
				GameDescriptionText = createElement2(styledTextLabel, v47)
			})
		end)
	end

	function self.renderInfoContent(p2, p3, p4, p5, p6, p7, list, p8, p9, p10, p11)
		local v40 = self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot
		local headerItemPadding = p2 and p2.headerItemPadding or 0

		local v41 = if v40 then not (list == nil) and #list > 0 else v40
		local v42 = not v40

		return function()
			local v43

			if module42 then
				local renderSubtitleTextOverride = self.renderSubtitleTextOverride

				local v49 = self.props.uiModeInfo.uiMode ~= uiMode.TenFoot
				local v50 = if fFlagLuaAppEdpNonSduiBuildAttribution then p11 else nil
				v43 = renderSubtitleTextOverride(p4, p5, p6, p3, p7, v49, v50)
			else
				local renderSubtitleTextOverride = self.renderSubtitleTextOverride
				local v50 = if fFlagLuaAppEdpNonSduiBuildAttribution then p11 else nil
				v43 = renderSubtitleTextOverride(p4, p5, p6, p3, p7, nil, v50)
			end

			local createElement = Roact.createElement
			local v45 = {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			}

			local v46 = {
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, headerItemPadding)
				}),
				SubtitleText = v43,
				Padding = 0,
				PlayStats = 0,
				Description = 0,
				ExperienceGuidelinesComponent = 0
			}

			local v47 = if headerItemPadding then Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, headerItemPadding)
			}) else nil
			v46.Padding = v47

			local v48 = if v40 then self.renderInlinePlayerCountAndLikes(p8, p9, p10) else nil
			v46.PlayStats = v48

			local v49 = if v41 then self.renderBriefDescription(p2, list) else nil
			v46.Description = v49

			local v50 = if v42 then self.renderExperienceGuidelines(p3) else nil
			v46.ExperienceGuidelinesComponent = v50
			return createElement("Frame", v45, v46)
		end
	end

	self.renderPlaysAndVisits = memoize(function(p2, p3)
		return function()
			local createElement = Roact.createElement

			local v43 = if fFlagLuaAppGameStatsFallbackRendering and p2 == nil then v5 else self.getAbbreviateCount(p2)
			local v41 = {
				layoutOrder = 1,
				countLeft = {
					countText = v43,
					labelText = self.upperString("Feature.GameDetails.Label.Playing"),
					icon = images["icons/status/games/people-playing_large"]
				},
				countRight = 0
			}

			local v45 = if fFlagLuaAppGameStatsFallbackRendering and p3 == nil then v5 else self.getAbbreviateCount(p3)
			v41.countRight = {
				countText = v45,
				labelText = self.upperString("Feature.GameDetails.Label.Visits"),
				icon = images["icons/status/games/sessions_large"]
			}
			return createElement(playerCount, v41)
		end
	end)

	function self.onFocusChanged(p2)
		if self.props.setControllerBarNavigation then
			self.props.setControllerBarNavigation(not p2)
		end
	end

	self.renderDescription = memoize(function(p2, p3)
		return function()
			local createElement = Roact.createElement
			local v41 = {
				dataStatus = retrievalStatus.fromRawValue(p2),
				descriptionText = p3,
				onFocusChanged = self.onFocusChanged,
				universeId = 0,
				pageContext = 0,
				componentType = 0
			}
			local v42 = if fFlagLuaAppExpandableTextImpressionsEnabled then self.props.universeId else nil
			v41.universeId = v42
			local v43 = if fFlagLuaAppExpandableTextImpressionsEnabled then appPage.ExperienceDetail else nil
			v41.pageContext = v43
			v41.componentType = fFlagLuaAppExpandableTextImpressionsEnabled and "gameDescription" or nil
			return createElement(module18, v41)
		end
	end)

	self.renderNotice = memoize(function(p2)
		return function()
			return withLocalization({
				noticeHeader = "Feature.ExperienceDetails.Body.NotesTitle",
				noticeText = "Feature.ExperienceDetails.Notes.InExperiencePurchase"
			})(function(p3)
				local createElement = Roact.createElement
				local v41 = {
					dataStatus = retrievalStatus.fromRawValue(p2),
					headerText = p3.noticeHeader,
					descriptionText = p3.noticeText,
					onFocusChanged = self.onFocusChanged,
					universeId = 0,
					pageContext = 0,
					componentType = 0
				}
				local v42 = if fFlagLuaAppExpandableTextImpressionsEnabled then self.props.universeId else nil
				v41.universeId = v42
				local v43 = if fFlagLuaAppExpandableTextImpressionsEnabled then appPage.ExperienceDetail else nil
				v41.pageContext = v43
				v41.componentType = fFlagLuaAppExpandableTextImpressionsEnabled and "gameNotice" or nil
				return createElement(module18, v41)
			end)
		end
	end)

	function self.renderActionBarLabelImpressionsDetector(p2, p3)
		return Roact.createElement(playButtonContextualMessageImpressionsDetector, {
			containerRef = p2,
			universeId = self.props.universeId,
			playabilityStatus = self.props.playabilityStatus,
			contextualMessage = self.props.playButtonContextualMessage,
			pageContext = appPage.ExperienceDetail,
			scrollViewPositionChangedSignal = p3
		})
	end

	self.renderIgrsRatingLabel = memoize(function(p2, p3, p4, callback, p5)
		return function()
			local createElement = React.createElement
			local v41 = {
				igrsRating = p2,
				igrsRatingDisplayMessage = p3,
				onActivated = 0
			}
			local v42

			if p4 then
				v42 = function()
					callback(
						module12.INDONESIAN_CONTENT_MATURITY_URL,
						v39:Format("Feature.GameDetails.Label.ContentMaturity")
					)
				end
			else
				v42 = function()
					module14(p5, module12.INDONESIAN_CONTENT_MATURITY_URL)
				end
			end

			v41.onActivated = v42
			return createElement(module21, v41)
		end
	end)

	self.renderLogoTray = memoize(function(p2, p3)
		return function()
			local formatted = `EXPERIENCE_SOCIAL_LINKS_{self.props.universeId}`

			local ref = React.createRef()

			local signal = AppCommonLib.Signal.new()

			local createElement = React.createElement
			local fragment = React.Fragment
			local createElement2 = Roact.createElement
			local v42 = {
				socialLinks = p2,
				linking = p3,
				openLeaveRobloxAlertUIBlox = self.props.openLeaveRobloxAlertUIBlox,
				closeAlert = self.props.closeAlert,
				impressionsTag = formatted,
				forwardRef = ref,
				onAbsolutePositionChanged = function(p4)
					signal:fire()
				end,
				universeId = 0
			}

			local v43 = if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then self.props.universeId else nil
			v42.universeId = v43
			return createElement(fragment, nil, {
				ExperienceLogoTray = createElement2(module22, v42),
				EdpSocialLinksImpressionsDetector = Roact.createElement(module35, {
					parentRef = ref,
					scrollViewPositionChangedSignal = signal,
					pageContext = appPage.ExperienceDetail,
					impressionsTag = formatted,
					socialLinks = p2,
					universeId = self.props.universeId
				})
			})
		end
	end)

	local function handleControllerBarInMediaGalleryFullscreen(p2)
		if self.props.setControllerBarNavigation then
			self.props.setControllerBarNavigation(p2)
		end
	end

	function self.onMediaGalleryPreviewActivated(p2, p3)
		local v40 = self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot

		if not self.state.isFullscreen and v40 and self.props.setControllerBarNavigation then
			self.props.setControllerBarNavigation(false)
		end

		self:setState({
			isFullscreen = true,
			mediaGalleryShowIndex = p2,
			currentIndex = if v40 then p2 else nil
		})

		if fFlagLuaAppEdpMediaGalleryRedesignTelemetry and self.props.onMediaGalleryEnterFullscreen then
			self.props.onMediaGalleryEnterFullscreen(p2, p3)
		elseif fFlagLuaAppDesktopMediaGalleryTelemetry and self.props.onMediaGalleryPreviewActivated then
			self.props.onMediaGalleryPreviewActivated(p2)
		end
	end

	self.renderMediaGallery = memoize(function(p2, p3)
		if self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot then
			return function()
				local createElement = Roact.createElement
				local v41 = {
					tokens = self.props.tokens,
					deviceType = self.props.deviceType,
					universeId = p2,
					onPreviewActivated = self.onMediaGalleryPreviewActivated,
					isFullscreenState = p3,
					exitFullscreen = self.onClose,
					onSelectionGained = self.onSelectionGained,
					mediaGalleryGainFocused = self.mediaGalleryGainFocused,
					uiMode = self.props.uiModeInfo.uiMode,
					toggleMuteSignal = 0,
					videoAnalytics = 0,
					videoPlaybackCoordinator = 0,
					shouldHydrateLegacyIxp = 0
				}

				local v42 = if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then self.consoleVideoMuteSignal else nil
				v41.toggleMuteSignal = v42

				local v43 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then self.props.videoAnalytics else nil
				v41.videoAnalytics = v43

				local v44 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then self.videoPlaybackCoordinator else nil
				v41.videoPlaybackCoordinator = v44

				local v45 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
				v41.shouldHydrateLegacyIxp = v45
				return createElement(module26, v41)
			end
		end

		return function()
			local createElement = Roact.createElement
			local v41 = {
				deviceType = self.props.deviceType,
				universeId = p2,
				startIndex = 0,
				onPreviewActivated = 0,
				onThumbnailActivated = 0,
				onMediaGalleryMediaChanged = 0,
				isOccluded = 0,
				mediaGalleryRedesignEnabledIxp = 0,
				mediaGalleryVideoPreviewEnabledIxp = 0,
				shouldHydrateLegacyIxp = 0
			}

			local v42 = if fFlagLuaAppEdpMediaGalleryFullScreen then self.state.mediaGalleryShowIndex else nil
			v41.startIndex = v42
			v41.onPreviewActivated = self.onMediaGalleryPreviewActivated

			local v43 = if fFlagLuaAppDesktopMediaGalleryTelemetry and not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then self.props.onMediaGalleryThumbnailActivated else nil
			v41.onThumbnailActivated = v43

			local v44 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then self.props.onMediaGalleryMediaChanged else nil
			v41.onMediaGalleryMediaChanged = v44
			local v45 = if fFlagLuaAppEdpMediaGalleryFullScreen and (fFlagLuaAppEdpMediaGalleryAutoAdvance or fFlagLuaAppEdpMediaGalleryVideoPreview) then p3 else nil
			v41.isOccluded = v45

			local v46 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then self.props.mediaGalleryRedesignEnabledIxp else nil
			v41.mediaGalleryRedesignEnabledIxp = v46

			local v47 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then self.props.mediaGalleryVideoPreviewEnabledIxp else nil
			v41.mediaGalleryVideoPreviewEnabledIxp = v47

			local v48 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v41.shouldHydrateLegacyIxp = v48
			return createElement(module26, v41)
		end
	end)

	self.renderExperienceRating = memoize(function(p2)
		return function()
			local createElement = Roact.createElement
			local v41 = {
				universeId = p2,
				height = math.floor((self.applyTokenScaling(72))),
				shouldHydrateLegacyIxp = 0,
				styleProps = 0
			}

			local v42 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v41.shouldHydrateLegacyIxp = v42

			v41.styleProps = {
				statWidgetIconSize = math.floor((self.applyTokenScaling(48)))
			}
			return createElement(experienceRatings, v41)
		end
	end)

	self.renderExperienceInfoTable = memoize(function(p2)
		return function()
			local createElement = Roact.createElement

			local statsAndInfoRefsByRef = { [Roact.Ref] = self.props.statsAndInfoRef }

			local createElement2 = Roact.createElement
			local v42 = {
				renderTextOverride = self.renderTextOverride,
				universeId = p2,
				key = "ExperienceInfoTable",
				shouldHydrateLegacyIxp = 0,
				hideCloseButton = 0
			}

			local v43 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v42.shouldHydrateLegacyIxp = v43

			v42.hideCloseButton = self.props.hideCloseButton
			return createElement("Folder", statsAndInfoRefsByRef, createElement2(module23, v42))
		end
	end)

	self.renderBuildAttributionDisclaimer = fFlagLuaAppEdpNonSduiBuildAttribution and function()
		return function()
			return Roact.createElement(module24, {
				horizontalPadding = 0,
				rightPadding = 0
			})
		end
	end or nil

	self.renderEventsList = memoize(function(p2, p3)
		return function()
			local createElement = Roact.createElement
			local v41 = {
				universeId = p2,
				referralSource = "expDetailsPage",
				defaultThumbnail = 0
			}

			local v42 = if p3 then "rbxassetid://" .. p3 else nil
			v41.defaultThumbnail = v42
			return createElement(module15, v41)
		end
	end)

	self.renderRecommendedExperiencesCarousel = memoize(function(p2)
		return function()
			local createElement = Roact.createElement
			local v41 = { universeId = p2, shouldHydrateLegacyIxp = 0, pageContext = 0 }

			local v42 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v41.shouldHydrateLegacyIxp = v42

			v41.pageContext = appPage.ExperienceDetail
			return createElement(module28, v41)
		end
	end)

	if fFlagSongEdpCarouselIxp then
		self.renderExperienceSongsCarousel = memoize(function(p2, value)
			return function()
				return React.createElement(module29, {
					universeId = p2,
					fractionalItemAmount = 0,
					universeTitle = value or "",
					collectionOrder = 2,
					clipsDescendants = true
				})
			end
		end)
	end

	self.renderCommunityLink = memoize(function(p2, value, p3)
		return function()
			return React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 16)
					}),
					ExperienceCommunityLink = React.createElement(experienceCommunityLink, {
						communityInfo = p2,
						experienceName = value or "",
						universeId = p3
					})
				}
			)
		end
	end)

	self.linkStartStyle = memoize(function(p2)
		local color3 = p2.Tokens.Color.Content.Link.Color3
		return `<font color="{string.format(
			"rgb(%d, %d, %d)",
			math.round(color3.R * 255),
			math.round(color3.G * 255),
			(math.round(color3.B * 255))
		)}"><b>`
	end)

	self.checkAndFormatPossibleLink = memoize(function(p2, p3)
		return checkAndFormatPossibleLink(p3, nil, nil, self.linkStartStyle(p2), "</b></font>")
	end)

	self.renderRefundPolicy = memoize(function(p2)
		return function()
			if fFlagLuaAppEnableConsolidatedGameRefundPolicy then
				return withStyle(function(p3)
					return Roact.createElement(module16, {
						refundPolicy = p2,
						paddingTop = p3.Tokens.Size.Size_600
					})
				end)
			end

			return withStyle(function(p3)
				local bodyLarge = p3.Tokens.Typography.BodyLarge
				local muted = p3.Tokens.Color.Content.Muted

				local v40, v41 = self.checkAndFormatPossibleLink(p3, p2.policyText)

				local createElement = React.createElement
				local v43 = {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}
				local v44 = {
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, p3.Tokens.Size.Size_600)
					}),
					RefundPolicy = 0
				}

				local createElement2 = React.createElement
				local v46 = {}
				v46.BackgroundTransparency = 1
				v46.Text = v41
				v46.AutomaticSize = Enum.AutomaticSize.XY
				local v47 = if not foundationFontFaceMigration then bodyLarge.Font else nil
				v46.Font = v47
				local v48 = if foundationFontFaceMigration then normalizeFontFace(bodyLarge.Font) else nil
				v46.FontFace = v48
				v46.TextSize = bodyLarge.FontSize
				v46.TextColor3 = muted.Color3
				v46.TextTransparency = muted.Transparency
				v46.TextWrapped = true
				v46.TextXAlignment = Enum.TextXAlignment.Left
				v46.RichText = v40
				local tag = React.Tag
				local v49 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-game-refund-policy") else nil
				v46[tag] = v49

				v46[React.Event.Activated] = function(p4)
					self.props.openRefundPolicyLearnMorePage(p2.learnMoreUrl)
				end

				v44.RefundPolicy = createElement2("TextButton", v46)
				return createElement("Frame", v43, v44)
			end)
		end
	end)

	if fFlagEnablePlayWithRewardNonPeekviewEdp then
		self.renderPlayWithReward = memoize(function(p2, p3, data, p4, p5)
			return function()
				return Roact.createElement(playWithRewardComponent, {
					universeId = p2,
					placeId = p3,
					placeIdOverride = p4,
					experienceJoinData = p5,
					flowId = data.flowId,
					fetchedUniverseId = data.universeId,
					isAdDataExpected = data.isAdDataExpected,
					playWithRewardAdData = data.adData,
					useLargerStyles = true
				})
			end
		end)
	end

	self.getBodyComponentListProps = memoize(function(p2, p3, p4, p5, p6, p7, items, p8, p9, p10, data, p11, p12, p13, p14, p15, items2, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27)
		local v40 = data.showLogoTraySection and items and next(items)

		local v41 = data.showCommunityLink

		if v41 then
			v41 = if p9 then p10 == "banner" and p8 else p9
		end

		local showEventsList = data.showEventsList

		local v42 = self.props.webViewSupport and p14 ~= nil

		local v43 = fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
			and (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and self.props.shouldInterleaveSduiIxp)
			and (not self.props.edpPerUniverseVisibilityVariables or self.props.edpPerUniverseVisibilityVariables.hidePlayWithReward == true)
		local v44

		if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
			v44 = fFlagEnablePlayWithRewardNonPeekviewEdp and p23 and p22 and p21 and not v43
		end

		local v45 = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 20 or v6.Description

		local v46 = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 40 or v6.MediaGallery

		if not p12 then
			v46 = v45
		end

		local v47 = if fFlagLuaAppExperienceDetailsLayoutOrderConfig then v6.EventsListRedesign else v46 - 10

		local v48 = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 10 or v8.EventsListRedesign

		local left = contentPosition.Left

		if not p12 then
			v45 = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 5 or v6.MediaGalleryMediaFirst
		end

		local v49 = {
			portraitLayoutOrder = v45,
			landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 10 or v8.MediaGallery,
			landscapePosition = contentPosition.Right,
			showCornerGradient = 0,
			useSelectionBumper = 0,
			renderComponent = 0
		}
		local v50 = if data.showCornerGradientPropEnabled then false else nil
		v49.showCornerGradient = v50
		v49.useSelectionBumper = getFFlagExpDetailsUseSelectionBumpers() and true or nil
		v49.renderComponent = self.renderMediaGallery(p2, p11)
		local result = {
			MediaGallery = v49,
			Description = {
				portraitLayoutOrder = v46,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 20 or v8.Description,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderDescription(p3, p4)
			},
			IgrsRatingLabel = p16 and {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 45 or v6.IgrsRatingLabel,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 30 or v8.IgrsRatingLabel,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderIgrsRatingLabel(p16, p17, p18, p19, p20)
			} or nil,
			ExperienceRatings = (not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module6.getShouldInterleaveSdui()) or not self.props.edpServerIxpVariables or self.props.edpServerIxpVariables.hideGameRatings ~= true) and {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 50 or v6.ExperienceRatings,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 40 or v8.ExperienceRatings,
				landscapePosition = contentPosition.Left,
				useSelectionBumper = getFFlagExpDetailsUseSelectionBumpers() and true or nil,
				renderComponent = self.renderExperienceRating(p2)
			} or nil,
			PlaysAndVisits = (not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module6.getShouldInterleaveSdui()) or not self.props.edpServerIxpVariables or self.props.edpServerIxpVariables.showVisitsInInfoList ~= true) and {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 60 or v6.PlaysAndVisits,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 50 or v8.PlaysAndVisits,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderPlaysAndVisits(p6, p7)
			} or nil,
			CommunityLink = v41 and {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 70 or v6.CommunityLink,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 60 or v8.CommunityLink,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderCommunityLink(p8, p5, p2)
			} or nil,
			ExperienceInfoTable = {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 80 or v6.ExperienceInfoTable,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 70 or v8.ExperienceInfoTable,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderExperienceInfoTable(p2)
			},
			BuildAttributionDisclaimer = fFlagLuaAppEdpNonSduiBuildAttribution and p27 and p12 and {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 82 or v6.BuildAttributionDisclaimer,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 72 or v8.BuildAttributionDisclaimer,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderBuildAttributionDisclaimer()
			} or nil,
			RefundPolicy = v42 and {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 85 or v6.RefundPolicy,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 75 or v8.RefundPolicy,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderRefundPolicy(p14)
			} or nil,
			LogoTraySection = v40 and ({
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 90 or v6.LogoTraySection,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 80 or v8.LogoTraySection,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderLogoTray(items, p20)
			} or nil) or nil,
			EventsList = showEventsList and {
				portraitLayoutOrder = v47,
				landscapeLayoutOrder = v48,
				landscapePosition = left,
				renderComponent = self.renderEventsList(p2, p13)
			} or nil,
			Notice = p15 == experienceDetailsNoticeType.InExperiencePurchase and {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 100 or v6.Notice,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 100 or v8.Notice,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderNotice(p3)
			} or nil,
			RecommendedExperiences = {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 110 or v6.RecommendedExperiences,
				portraitZIndex = 2,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 30 or v8.RecommendedExperiences,
				landscapePosition = contentPosition.Right,
				useSelectionBumper = getFFlagExpDetailsUseSelectionBumpers() and true or nil,
				renderComponent = self.renderRecommendedExperiencesCarousel(p2)
			},
			ExperienceSongsCarousel = fFlagSongEdpCarouselIxp and self.props.showSongCarousel and {
				portraitLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 120 or v6.ExperienceSongsCarousel,
				portraitZIndex = 1,
				landscapeLayoutOrder = not fFlagLuaAppExperienceDetailsLayoutOrderConfig and 35 or v8.ExperienceSongsCarousel,
				landscapePosition = contentPosition.Right,
				renderComponent = self.renderExperienceSongsCarousel(p2, p5)
			} or nil,
			PlayWithReward = 0
		}

		if not fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
			v44 = fFlagEnablePlayWithRewardNonPeekviewEdp and p23 and p22 and p21
		end

		result.PlayWithReward = v44
			and {
				portraitLayoutOrder = v6.PlayWithReward,
				landscapeLayoutOrder = v8.PlayWithReward,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderPlayWithReward(p2, p24, p21, p25, p26)
			}
			or nil

		if
			(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and self.props.shouldInterleaveSduiIxp)
			and items2
		then
			for k, item in items2 do
				result[`SduiFeedItem_{k}`] = {
					portraitLayoutOrder = item.portraitLayoutOrder,
					landscapeLayoutOrder = item.landscapeLayoutOrder,
					landscapePosition = contentPosition.Left,
					renderComponent = item.renderComponent
				}
			end
		end

		return result
	end)

	function self.onClose()
		if self.state.isFullscreen then
			self:setState({ isFullscreen = false })

			if
				self.props.uiModeInfo
				and self.props.uiModeInfo.uiMode == uiMode.TenFoot
				and self.props.setControllerBarNavigation
			then
				self.props.setControllerBarNavigation(true)
			end
		else
			self.props.onClose()
		end
	end

	self.exitFullscreen = fFlagLuaAppEdpMediaGalleryFullScreen and function(p2, p3)
		if not self.state.isFullscreen then
			return
		end

		if fFlagLuaAppEdpMediaGalleryRedesignTelemetry and self.props.onMediaGalleryExitFullscreen then
			self.props.onMediaGalleryExitFullscreen(p2, p3)
		end

		self:setState({ isFullscreen = false, mediaGalleryShowIndex = p2 })
	end or nil

	self.focusEventHandlers = {
		[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object2)
				self.onClose()
				object2:cancel()
			end)
		}
	}

	self.renderFullscreenContent = memoize(function(p2, p3, p4, p5, p6, p7)
		if self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot then
			return function()
				local createElement = Roact.createElement
				local v42 = {
					tokens = self.props.tokens,
					universeId = p2,
					isFullscreen = true,
					fullscreenShowIndex = p3,
					deviceType = self.props.deviceType,
					isFullscreenState = p4,
					isCrossFade = p5,
					setCrossFade = self.setCrossFade,
					nextIndex = p7,
					currentIndex = p6,
					setCurrentIndex = self.setCurrentIndex,
					uiMode = self.props.uiModeInfo.uiMode,
					toggleMuteSignal = 0,
					videoAnalytics = 0,
					videoPlaybackCoordinator = 0,
					shouldHydrateLegacyIxp = 0
				}

				local v43 = if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then self.consoleVideoMuteSignal else nil
				v42.toggleMuteSignal = v43

				local v44 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then self.props.videoAnalytics else nil
				v42.videoAnalytics = v44

				local v45 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then self.videoPlaybackCoordinator else nil
				v42.videoPlaybackCoordinator = v45

				local v46 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
				v42.shouldHydrateLegacyIxp = v46
				return createElement(module26, v42)
			end
		end

		return function()
			local createElement = Roact.createElement
			local v42 = {
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
				isIsolated = true,
				customEventHandlers = self.focusEventHandlers
			}

			local createElement2 = Roact.createElement
			local v45 = {
				universeId = p2,
				isFullscreen = true,
				fullscreenShowIndex = p3,
				onMediaGalleryMediaChanged = 0,
				startIndex = 0,
				exitFullscreen = 0,
				mediaGalleryRedesignEnabledIxp = 0,
				mediaGalleryVideoPreviewEnabledIxp = 0,
				shouldHydrateLegacyIxp = 0
			}

			local v46 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then self.props.onMediaGalleryMediaChanged else nil
			v45.onMediaGalleryMediaChanged = v46

			v45.startIndex = if fFlagLuaAppEdpMediaGalleryFullScreen then p3 else nil
			local v48 = if fFlagLuaAppEdpMediaGalleryFullScreen then self.exitFullscreen else nil
			v45.exitFullscreen = v48

			local v49 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then self.props.mediaGalleryRedesignEnabledIxp else nil
			v45.mediaGalleryRedesignEnabledIxp = v49

			local v50 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then self.props.mediaGalleryVideoPreviewEnabledIxp else nil
			v45.mediaGalleryVideoPreviewEnabledIxp = v50

			local v51 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v45.shouldHydrateLegacyIxp = v51
			return createElement(focusNavigableSurfaceWrapper, v42, {
				ExperienceMediaGallery = createElement2(module26, v45)
			})
		end
	end)

	self.renderBackgroundContent = fFlagLuaAppEdpConsoleMediaGalleryVideo and function(p2, p3, p4)
		if not p3 or self.state.selectedVideoId == nil or p2 then
			return nil
		end

		local createElement = Roact.createElement
		local v42 = {
			video = self.state.selectedVideoId,
			thumbnail = self.state.selectedVideoThumbnail or "",
			Size = UDim2.fromScale(1, 1),
			cornerRadius = 0,
			ZIndex = 1,
			itemIndex = self.state.nextIndex,
			isFullscreen = false,
			universeId = p4,
			videoAnalytics = self.props.videoAnalytics,
			hideMuteButton = not fFlagLuaAppEdpConsoleMediaGalleryVideoMute or nil,
			toggleMuteSignal = 0,
			videoPlaybackCoordinator = 0
		}

		local v43 = if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then self.consoleVideoMuteSignal else nil
		v42.toggleMuteSignal = v43

		v42.videoPlaybackCoordinator = self.videoPlaybackCoordinator
		return createElement(module7, v42)
	end or nil

	function self.resolveTitleText(p2, p3)
		return p2 and p2.name or p3 and p3.name or nil
	end

	function self.checkCommunityLinkExposureLogging()
		if self.props.communityLink then
			IXPService:LogUserLayerExposure(appUserLayers.EDPCommunityLinksLayer)
		end
	end

	if self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot then
		self.state = {
			bannerImageId = self.props.bannerImageId,
			isCrossFade = false,
			currentIndex = 1,
			nextIndex = 1
		}

		if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then
			self.consoleVideoMuteSignal = AppCommonLib.Signal.new()
		end

		if fFlagLuaAppEdpConsoleMediaGalleryVideo then
			self.videoPlaybackCoordinator = videoPlaybackCoordinator.new()
		end

		function self.setCurrentIndex(p2)
			self:setState({ currentIndex = p2 })
		end

		function self.setCrossFade(p2)
			self:setState({ isCrossFade = p2 })
		end

		function self.onSelectionGained(p2, p3, p4, p5)
			if self.state.nextIndex ~= p2 and self.state.isCrossFade == false then
				self.setCrossFade(true)
			end

			local v43 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then p4 or Roact.None else nil

			local v44 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then p5 or Roact.None else nil
			self:setState({
				bannerImageId = p3,
				nextIndex = p2,
				selectedVideoId = v43,
				selectedVideoThumbnail = v44
			})
		end

		function self.mediaGalleryGainFocused(p2)
			if not p2 then
				local v42 = {
					bannerImageId = self.props.bannerImageId,
					selectedVideoId = 0,
					selectedVideoThumbnail = 0
				}
				local v43 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then Roact.None else nil
				v42.selectedVideoId = v43
				local v44 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then Roact.None else nil
				v42.selectedVideoThumbnail = v44
				self:setState(v42)
			end
		end
	end

	if module40() then
		self.isMounted = false

		local success, result = pcall(function()
			return AppStorageService:GetItem("ShowNotificationsOptInTooltip")
		end)
		local v41 = if success then result == "true" else false
		self.showTooltip = v41
		self:setState({ isNotificationsTooltipActive = self.showTooltip })
	end
end

function extended:didMount()
	self.checkCommunityLinkExposureLogging()

	if module40() then
		self.isMounted = true

		if self.showTooltip then
			pcall(function()
				AppStorageService:SetItem("ShowNotificationsOptInTooltip", "false")
				AppStorageService:Flush()
			end)
		end

		Promise.delay(module41()):andThen(function()
			if self.isMounted then
				self:setState({ isNotificationsTooltipActive = false })
			end
		end)
	end
end

function extended.didUpdate(p2, p3)
	if not p3.communityLink then
		p2.checkCommunityLinkExposureLogging()
	end
end

function extended:render()
	if not defineFastFlag then
		return Roact.createElement(loadingStateContainer, {
			dataStatus = retrievalStatus.fromRawValue(self.props.gameDetailsPageDataStatus),
			renderOnFailed = function()
				if self.props.gameInfo then
					return self:renderOnLoaded()
				end

				return self:renderOnFailed()
			end,
			renderOnLoaded = function()
				return self:renderOnLoaded()
			end,
			renderOnLoading = function()
				return self:renderOnLoading()
			end
		})
	end

	if self.props.gameDetailsPageDataStatus == retrievalStatus2.Failed and not self.props.gameInfo then
		return self:renderOnFailed()
	end

	return self:renderOnLoaded()
end

function extended:renderOnLoading()
	return Roact.createElement(module25)
end

function extended.renderOnFailed(p2)
	return withLocalization({
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
		experienceUnavailableMessage = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable"
	})(function(p3)
		local v39 = p2.props.gameDetailError
			and p2.props.gameDetailError.errorType == enumGameDetailErrorTypes.ExperienceUnavailable

		if fFlagLuaAppUpdateFailedStateEdpIcon then
			return withStyle(function(p4)
				local createElement = Roact.createElement
				local v41 = {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = p4.Theme.BackgroundDefault.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0
				}

				local createElement2 = Roact.createElement
				local v44 = {
					icon = images["icons/status/error_large"],
					onActivated = 0,
					text = 0
				}
				local v45 = if not v39 then p2.props.fetchGameDetailsPageData else nil
				v44.onActivated = v45

				local v46 = if v39 then p3.experienceUnavailableMessage else p3.failedMessage
				v44.text = v46
				local v42 = {
					EmptyState = createElement2(emptyState, v44),
					CloseButton = 0
				}

				local v47 = if not p2.props.hideCloseButton then Roact.createElement(iconButton, {
					Position = UDim2.fromOffset(12, 12),
					ZIndex = 2,
					icon = iconName.X,
					isCircular = true,
					onActivated = p2.onClose,
					size = buttonSize.Medium,
					variant = buttonVariant.Utility,
					testId = "--discovery-edp-iconbutton-close"
				}) else nil
				v42.CloseButton = v47
				return createElement("Frame", v41, v42)
			end)
		end

		local createElement = Roact.createElement
		local v42 = if not v39 then p2.props.fetchGameDetailsPageData else nil

		local v43 = if v39 then p3.experienceUnavailableMessage else p3.failedMessage
		return createElement(emptyState, { onActivated = v42, text = v43 })
	end)
end

function extended:willUnmount()
	if module40() then
		self.isMounted = false
	end
end

function extended.renderOnLoaded(props)
	local deviceType2 = props.props.deviceType
	local universeId = props.props.universeId
	local gameInfo = props.props.gameInfo
	local thumbnail = props.props.thumbnail
	local tokens = props.props.tokens
	local v39 = props.props.uiModeInfo and props.props.uiModeInfo.uiMode == uiMode.TenFoot

	local url = thumbnail and thumbnail.url
	local gameDetail = props.props.gameDetail
	local rootPlaceId

	if fFlagEnablePlayWithRewardNonPeekviewEdp then
		rootPlaceId = gameDetail and gameDetail.rootPlaceId or gameInfo and gameInfo.placeId
	else
		rootPlaceId = nil
	end

	local description = if gameDetail then gameDetail.description or nil else nil
	local name = if gameDetail then gameDetail.name or nil else nil
	local titleText = props.resolveTitleText(gameDetail, gameInfo)
	local v40 = if fFlagLuaAppEdpNonSduiBuildAttribution then module19(gameDetail) else nil
	local name2 = if gameDetail then gameDetail.creator.name or nil else nil
	local id = if gameDetail then gameDetail.creator.id or nil else nil
	local kind = if gameDetail then gameDetail.creator.type or nil else nil
	local v41, igrsRating, igrsRatingDisplayMessage

	if props.props.ageRecommendations then
		local summary = props.props.ageRecommendations.summary

		if summary and summary.ageRecommendation then
			if summary.ageRecommendation.displayNameWithHeaderShort then
				v41 = summary.ageRecommendation.displayNameWithHeaderShort
			else
				v41 = summary.ageRecommendation.displayName
			end
		end

		if
			summary
			and summary.ageRecommendation
			and summary.ageRecommendation.igrsRating
			and summary.ageRecommendation.igrsRating ~= ""
		then
			igrsRating = summary.ageRecommendation.igrsRating
		else
			igrsRating = nil
		end

		if summary and summary.ageRecommendation and summary.ageRecommendation.igrsRatingDisplayMessage then
			igrsRatingDisplayMessage = summary.ageRecommendation.igrsRatingDisplayMessage
		else
			igrsRatingDisplayMessage = nil
		end
	else
		igrsRating = nil
		igrsRatingDisplayMessage = nil
	end

	local playsAnsVisitsInfo = props.getPlaysAnsVisitsInfo(gameDetail, gameInfo)
	local socialLinks = props.props.socialLinks
	local communityLink = props.props.communityLink
	local playButtonProps = getPlayButtonProps(props.props.playButtonState, props.props.gameProductInfo)
	local textKey = playButtonProps.textKey
	local price = playButtonProps.price
	local icon = playButtonProps.icon
	local v42 = if module40() then props.state.isNotificationsTooltipActive else false

	local isFullscreen = props.state.isFullscreen
	local isCrossFade = props.state.isCrossFade
	local currentIndex = props.state.currentIndex
	local nextIndex = props.state.nextIndex
	local mediaGalleryShowIndex = props.state.mediaGalleryShowIndex
	local v43, sideMargin, headerBarBackgroundHeight

	if tokens then
		v43 = tokens.thumbnailSize
		sideMargin = tokens.sideMargin
		headerBarBackgroundHeight = tokens.headerBarBackgroundHeight
	else
		sideMargin = nil
		v43 = nil
		headerBarBackgroundHeight = nil
	end

	local v44 = nil

	if deviceType2 == deviceType.Tablet then
		v44 = math.min(props.props.viewHeight / 3, 500)
		v43 = 200
	elseif not v39 then
		v44 = 208
	end

	local v46 = v39 and v41
	local v47 = getFFlagNotificationsForceEnableEDPDiscoverability() and true
		or props.props.enableNotificationsDiscoverability
	local notificationsCanEnableExperience = props.props.notificationsCanEnableExperience

	if
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module6.getShouldInterleaveSdui())
		and props.props.edpServerIxpVariables
		and props.props.edpServerIxpVariables.hideNotifyButton == true
	then
		v47 = false
	end

	local filter = Cryo.List.filter
	local v49

	if not v39 then
		local v51 = {
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5),
			icon = images["icons/actions/friends/friendsplaying"],
			userInteractionEnabled = true,
			showBackground = true,
			onActivated = props.openShareContextualMenu,
			size = props.props.iconButtonSize,
			backgroundColor = 0
		}
		local v52 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
		v51.backgroundColor = v52
		v49 = { props = v51 } or nil
	end

	local v51 = {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.fromScale(0.5, 0.5),
		icon = images["icons/common/more"],
		userInteractionEnabled = true,
		showBackground = true,
		onActivated = props.openMoreContextualMenu,
		size = props.props.iconButtonSize,
		backgroundColor = 0
	}
	local v52 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
	v51.backgroundColor = v52
	local v53

	if v47 and notificationsCanEnableExperience then
		local v55 = {
			["anchorPoint"] = nil,
			["anchorPoint"] = nil,
			["anchorPoint"] = nil,
			["anchorPoint"] = nil,
			["anchorPoint"] = nil,
			["anchorPoint"] = nil,
			["anchorPoint"] = nil,
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5)
		}
		local v56 = if props.props.gameFollowings and props.props.gameFollowings.isFollowed then images["icons/common/notificationOn"] else images["icons/common/notificationOff"]
		v55.icon = v56

		v55.userInteractionEnabled = true
		v55.showBackground = true
		v55.onActivated = props.toggleFollowExperience
		v55.size = props.props.iconButtonSize
		local v57 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
		v55.backgroundColor = v57
		v55[Roact.Children] = module40() and {
			Tooltip = React.createElement(FtuxTooltipAnchor, {
				isActive = v42,
				preferredOrientation = tooltipOrientation.Bottom
			})
		} or nil
		v53 = { props = v55 } or nil
	end

	local v54 = filter({
		v49,
		{ props = v51 },
		v53
	}, function(p2): boolean
		return p2 ~= nil
	end)

	local v55 = nil
	local v56

	if v39 then
		local licenseDescription = if props.props.gameDetail then props.props.gameDetail.licenseDescription or nil else nil

		v56 = (v46 or licenseDescription) and {} or v55

		if v46 then
			local v58 = {
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.fromScale(0, 0.5),
				text = v41,
				horizontalPadding = tokens.actionBarTextButtonPadding.X,
				verticalPadding = tokens.actionBarTextButtonPadding.Y,
				userInteractionEnabled = true,
				showBackground = true,
				size = props.props.textButtonSize,
				onActivated = function()
					props.props.openExperienceGuidelinesExplained(universeId, true)
				end,
				backgroundColor = 0
			}
			local v59 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
			v58.backgroundColor = v59
			table.insert(v56, { props = v58 })
		end

		if licenseDescription then
			local v58 = {
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.fromScale(0, 0.5),
				text = licenseDescription,
				horizontalPadding = tokens.actionBarTextButtonPadding.X,
				verticalPadding = tokens.actionBarTextButtonPadding.Y,
				userInteractionEnabled = false,
				showBackground = true,
				size = props.props.textButtonSize,
				backgroundColor = 0
			}
			local v59 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
			v58.backgroundColor = v59
			table.insert(v56, { props = v58 })
		end
	elseif v46 then
		v56 = { nil }

		local v58 = {
			anchorPoint = Vector2.new(0, 0.5),
			position = UDim2.fromScale(0, 0.5),
			text = v41,
			horizontalPadding = tokens.actionBarTextButtonPadding.X,
			verticalPadding = tokens.actionBarTextButtonPadding.Y,
			userInteractionEnabled = true,
			showBackground = true,
			size = props.props.textButtonSize,
			onActivated = function()
				props.props.openExperienceGuidelinesExplained(universeId, true)
			end,
			backgroundColor = 0
		}
		local v59 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
		v58.backgroundColor = v59
		v56[1] = { props = v58 }
	else
		v56 = nil
	end

	local v57 = props.props.canExpandActionBarForSecondaryButton
		and props.props.secondaryPlayButtonState ~= nil

	return withLocalization({ buttonText = textKey })(function(p2)
		local v58 = p2.buttonText

		if playButtonProps.localizedFiatPrice then
			v58 = playButtonProps.localizedFiatPrice
		elseif price then
			v58 = props.getAbbreviateCount(price)
		end

		local v59 = {
			deviceType = deviceType2,
			thumbnailImageUrl = url,
			titleText = titleText,
			hideCloseButton = props.props.hideCloseButton,
			actionBarLabelText = props.props.playButtonContextualMessage,
			renderActionBarLabelImpressionsDetector = 0,
			renderInfoContent = 0,
			onClose = 0,
			bannerImageUrl = 0,
			actionBarProps = 0,
			actionBarWidth = 0,
			actionBarHeight = 0,
			componentList = 0,
			isFullscreen = 0,
			renderFullscreenContent = 0,
			backgroundContentOverride = 0,
			sideMargin = 0,
			startingOffsetPosition = 0,
			thumbnailHeight = 0,
			headerBarBackgroundHeight = 0,
			dualPanelBreakpoint = 1e999,
			maxContentWidth = 850,
			tokens = 0,
			disableStickyActionBar = 0,
			containerRef = 0
		}
		local v60 = if props.props.playButtonContextualMessage then props.renderActionBarLabelImpressionsDetector else nil
		v59.renderActionBarLabelImpressionsDetector = v60

		v59.renderInfoContent = props.renderInfoContent(
			tokens,
			universeId,
			name2,
			id,
			kind,
			props.props.creatorVerified or false,
			description,
			playsAnsVisitsInfo.plays,
			playsAnsVisitsInfo.totalUpVotes,
			playsAnsVisitsInfo.totalDownVotes,
			v40
		)

		v59.onClose = props.onClose
		local v61

		if fFlagLuaAppEdpFixDefaultBanner then
			v61 = props.props.defaultBannerUrl

			if not v61 then
				local bannerImageId = props.state.bannerImageId or props.props.bannerImageId
				v61 = not bannerImageId and "" or "rbxassetid://" .. bannerImageId
			end
		else
			local bannerImageId = props.state.bannerImageId or props.props.bannerImageId
			v61 = not bannerImageId and "" or "rbxassetid://" .. bannerImageId
		end

		v59.bannerImageUrl = v61

		local v62 = {
			iconSize = props.props.tokens.iconSize,
			buttonHeight = props.props.actionBarHeight,
			buttonPadding = tokens.headerItemPadding,
			button = 0,
			buttonOverride = 0,
			icons = 0,
			textButtons = 0
		}
		local v63

		if not (fFlagLuaAppUnifyPlayButtonNonMobileEdp and (not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.props.hasUnifiedPlayButtonIxp)) then
			v63 = { props = 0 }
			local v64

			if getFFlagIsSquadEnabled() and playButtonProps.showSquadButton then
				v64 = { button = 0, overflow = 0, size = 0 }
				local v65 = {
					onActivated = props.onPlayButtonActivated,
					icon = 0,
					text = 0,
					isDisabled = 0
				}
				local v66 = if icon then images[icon] else nil
				v65.icon = v66
				v65.text = v58
				v65.isDisabled = playButtonProps.isDisabled
				v64.button = v65

				v64.overflow = {
					isDisabled = playButtonProps.isSquadButtonDisabled,
					onActivated = props.props.onPlaySquadButtonActivated
				}

				v64.size = props.props.playButtonSize
			else
				v64 = {
					onActivated = props.onPlayButtonActivated,
					icon = 0,
					text = 0,
					isDisabled = 0,
					isLoading = 0,
					buttonType = 0,
					size = 0,
					buttonRef = 0,
					DO_NOT_USE_useUIBloxButton = 0
				}
				local v65 = if icon then images[icon] else nil
				v64.icon = v65
				v64.text = v58
				v64.isDisabled = playButtonProps.isDisabled
				v64.isLoading = playButtonProps.isLoading
				v64.buttonType = playButtonProps.buttonType
				v64.size = props.props.playButtonSize
				v64.buttonRef = props.props.playButtonRef
				v64.DO_NOT_USE_useUIBloxButton = (getFFlagUIBloxUseFoundationButton() or fFlagLuaAppPlayButtonOptOutFoundationButton)
					and true
					or nil
			end

			v63.props = v64
		end

		v62.button = v63
		local v64

		if
			fFlagLuaAppUnifyPlayButtonNonMobileEdp
			and (not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.props.hasUnifiedPlayButtonIxp)
			or props.props.secondaryPlayButtonState ~= nil
		then
			local createElement = Roact.createElement
			local v66 = {
				universeId = universeId,
				referralSource = props.props.referralSource,
				launchSource = "ExperienceDetailsPage",
				fillBehavior = "Fill",
				experienceJoinData = props.props.experienceJoinData,
				placeId = props.props.placeIdOverride,
				buttonSize = 0,
				squadButtonMenuDirection = 0,
				useUIBloxButton = 0,
				testId = "--experience-details--play-button"
			}
			local v67 = if v39 then buttonSize.Medium else buttonSize.Large
			v66.buttonSize = v67

			local v68 = if fFlagLuaAppUnifiedPlayButtonSquadMenuDirection then menuDirection.Down else nil
			v66.squadButtonMenuDirection = v68

			v66.useUIBloxButton = props.props.unifyToUIBloxIxp
			v64 = createElement(playButton, v66)
		end

		v62.buttonOverride = v64

		v62.icons = v54
		v62.textButtons = v56
		v59.actionBarProps = v62

		local v65 = if getFFlagIsSquadEnabled() and playButtonProps.showSquadButton then props.applyTokenScaling(420 + (not v57 and 0 or defineFastInt2)) else props.applyTokenScaling(380 + (not v57 and 0 or defineFastInt2))
		v59.actionBarWidth = v65

		v59.actionBarHeight = props.props.actionBarHeight
		local getBodyComponentListProps = props.getBodyComponentListProps

		local gameDetailsPageDataStatus = props.props.gameDetailsPageDataStatus

		local plays = playsAnsVisitsInfo.plays
		local visits = playsAnsVisitsInfo.visits

		local communityLinksEnabled = props.props.communityLinksEnabled
		local communityLinkVariant = props.props.communityLinkVariant
		local detailsPageConfiguration = props.props.detailsPageConfiguration or v38

		local bannerImageId = props.props.bannerImageId
		local refundPolicy = if props.props.gameDetail then props.props.gameDetail.refundPolicy else nil
		local experienceDetailsNoticeType2 = props.props.experienceDetailsNoticeType
		local sduiFeedItemConfigs

		if
			fFlagLuaAppEdpBackendV2SduiInterleaveDefault
			or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module6.getShouldInterleaveSdui()
		then
			sduiFeedItemConfigs = props.props.sduiFeedItemConfigs
		end

		local webViewSupport = props.props.webViewSupport
		local openWebview = props.props.openWebview
		local linking = props.props.linking
		local playWithRewardData = if fFlagEnablePlayWithRewardNonPeekviewEdp then props.props.playWithRewardData else nil
		local showPlayWithReward = if fFlagEnablePlayWithRewardNonPeekviewEdp then props.props.showPlayWithReward else nil
		local isPlayable = if fFlagEnablePlayWithRewardNonPeekviewEdp then props.props.isPlayable else nil
		local v75 = if fFlagEnablePlayWithRewardNonPeekviewEdp then rootPlaceId else nil
		local placeIdOverride = if fFlagEnablePlayWithRewardNonPeekviewEdp then props.props.placeIdOverride else nil
		local experienceJoinData = if fFlagEnablePlayWithRewardNonPeekviewEdp then props.props.experienceJoinData else nil
		local v76 = if fFlagLuaAppEdpNonSduiBuildAttribution then v40 else nil
		v59.componentList = getBodyComponentListProps(
			universeId,
			gameDetailsPageDataStatus,
			description,
			name,
			plays,
			visits,
			socialLinks,
			communityLink,
			communityLinksEnabled,
			communityLinkVariant,
			detailsPageConfiguration,
			isFullscreen,
			v39,
			bannerImageId,
			refundPolicy,
			experienceDetailsNoticeType2,
			sduiFeedItemConfigs,
			igrsRating,
			igrsRatingDisplayMessage,
			webViewSupport,
			openWebview,
			linking,
			playWithRewardData,
			showPlayWithReward,
			isPlayable,
			v75,
			placeIdOverride,
			experienceJoinData,
			v76
		)

		v59.isFullscreen = isFullscreen
		v59.renderFullscreenContent = props.renderFullscreenContent(
			universeId,
			mediaGalleryShowIndex,
			isFullscreen,
			isCrossFade,
			currentIndex,
			nextIndex
		)

		local v77 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then props.renderBackgroundContent(isFullscreen, v39, universeId) else nil
		v59.backgroundContentOverride = v77

		v59.sideMargin = sideMargin

		v59.startingOffsetPosition = v44

		v59.thumbnailHeight = v43
		v59.headerBarBackgroundHeight = headerBarBackgroundHeight

		v59.tokens = tokens and {
			thumbnailMargin = tokens.thumbnailMargin,
			thumbnailShadowHeight = tokens.thumbnailShadowHeight,
			headerGradientHeight = tokens.headerGradientHeight,
			headerBottomMargin = tokens.headerBottomMargin,
			animationConfig = tokens.animationConfig,
			itemPadding = tokens.itemPadding,
			safeAreaSize = tokens.safeAreaSize,
			trailingWhitespace = tokens.trailingWhitespace,
			actionBarHeight = props.props.actionBarHeight
		} or nil

		v59.disableStickyActionBar = props.props.disableStickyActionBar
		v59.containerRef = props.props.containerRef

		return Roact.createElement(detailsPageSelector, {
			deviceType = deviceType2,
			detailsPageProps = v59
		})
	end)
end

local function ExperienceDetailsPageFn(props)
	if fFlagEDPTTITrackingEnabled then
		local v39 = useFirstMediaCarouselImageUri(props.universeId)
		module37(edpttiConstants.EDP_IMPLEMENTATION.LEGACY_FULL_PAGE, props.universeId, v39)
	end

	local v39 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then module6.getShouldHydrateLegacy() else nil
	local v40

	if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v40 = module6.getShouldInterleaveSdui()
	end

	local v41, v42, v43

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		local v44 = module31.useSduiContextFromSignalAndProcessConfigs(
			module32.getUnprocessedEdpStoreKey((tostring(props.universeId))),
			module32.getEdpStoreKey((tostring(props.universeId))),
			fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v40
		)

		v41 = module31.useSduiEdpFeedItemConfigs({
			sduiContext = v44,
			storeKey = module32.getEdpStoreKey((tostring(props.universeId))),
			portraitLayoutConfig = v6,
			landscapeLayoutConfig = v8,
			defaultLayoutOrder = v6.SduiFeedItemsDefault,
			logLayoutConflictFn = module30.logSduiLayoutOrderConflict,
			shouldInterleaveSdui = fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v40
		})

		v42 = module33()

		if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
			v43 = module34(props.universeId)
		end
	end

	local v44 = useUiModeInfo()
	local v45 = ReactFocusNavigation.useFocusGuiObject()
	local v46

	if fFlagLuaAppEdpConsoleMediaGalleryVideo then
		local rootPlaceId = props.gameDetail and props.gameDetail.rootPlaceId
			or props.gameInfo and props.gameInfo.placeId

		local universeId = props.universeId
		local mediaGalleryVideoPreviewEnabledIxp

		if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
			mediaGalleryVideoPreviewEnabledIxp = props.mediaGalleryVideoPreviewEnabledIxp
		end

		local v49 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then v39 else nil
		local v50 = module38(universeId, rootPlaceId, true, mediaGalleryVideoPreviewEnabledIxp, v49)

		v46 = useMediaGalleryVideoAnalytics(props.universeId, rootPlaceId, v50)
	end

	local v47 = if fFlagMigrateGameInfoToStore then GameHydrationReact.useGameVotes(props.universeId) else nil

	local state, setState = React.useState(nil)

	local v48 = not props.tokens and 0 or props.tokens.iconSize
	local udim = if v44.uiMode == uiMode.TenFoot then UDim2.fromOffset(v48, v48) else nil
	local udim2 = UDim2.fromOffset(0, v48)
	v48 = props.tokens and props.tokens.actionBarHeight or v48
	local udim3 = UDim2.new(1, 0, 0, v48)
	local v49 = useTokens()

	local ref = React.useRef(nil)
	ref.current = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v50 = Responsive.useBreakpointXOrLarger(Responsive.Keys.Medium)

	local current = ref.current

	local v51 = useCloseWithBackButton(setState, props.onClose)

	local state2, setState2 = React.useState(nil)

	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if state2 == nil then
			ref2.current = false
		elseif state2 and ref.current and not ref2.current then
			v45(state2)
			ref2.current = true
		end
	end, { state2, v45 })

	React.useEffect(function()
		local v53 = -1
		local selectionChangedConnection

		if state then
			selectionChangedConnection = state.SelectionChanged:Connect(function(p2, instance, instance2)
				if
					instance2 == nil
					or instance == nil
					or not (instance2:IsDescendantOf(state) and instance:IsDescendantOf(state))
				then
					return
				end

				instance2.SelectionOrder = v53
				v53 -= 1
			end)
		else
			selectionChangedConnection = nil
		end

		return function()
			if selectionChangedConnection then
				selectionChangedConnection:Disconnect()
			end
		end
	end, { state })

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join
	local v54 = {
		foundationTokens = v49,
		uiModeInfo = v44,
		canExpandActionBarForSecondaryButton = v50,
		focusGuiObject = v45,
		iconButtonSize = udim,
		textButtonSize = udim2,
		playButtonSize = udim3,
		actionBarHeight = v48,
		playButtonRef = setState2,
		containerRef = v51,
		storeVotes = nil,
		sduiFeedItemConfigs = nil,
		disableStickyActionBar = nil,
		hideCloseButton = nil,
		videoAnalytics = nil,
		shouldHydrateLegacyIxp = nil,
		shouldInterleaveSduiIxp = nil,
		edpServerIxpVariables = nil,
		edpPerUniverseVisibilityVariables = nil
	}

	if not fFlagMigrateGameInfoToStore then
		v47 = nil
	end

	v54.storeVotes = v47

	if not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v40) then
		v41 = nil
	end

	v54.sduiFeedItemConfigs = v41

	v54.disableStickyActionBar = current
	v54.hideCloseButton = current

	if not fFlagLuaAppEdpConsoleMediaGalleryVideo then
		v46 = nil
	end

	v54.videoAnalytics = v46

	if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
		v39 = nil
	end

	v54.shouldHydrateLegacyIxp = v39
	v54.shouldInterleaveSduiIxp = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then v40 else nil

	if not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v40) then
		v42 = nil
	end

	v54.edpServerIxpVariables = v42

	if not (fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable and (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v40)) then
		v43 = nil
	end

	v54.edpPerUniverseVisibilityVariables = v43
	return createElement(extended, join(v54, props))
end

return ExperienceDetailsPageFn
