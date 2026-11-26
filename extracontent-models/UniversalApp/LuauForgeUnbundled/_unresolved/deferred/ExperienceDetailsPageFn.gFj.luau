local LocalizationService = game:GetService("LocalizationService")
local IXPService = game:GetService("IXPService")
local AppStorageService = game:GetService("AppStorageService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
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
local gameStats = require("@luauforge/bundled/gDC").GameStats
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module6 = require("@luauforge/deferred/gBX")
local module7 = require("@luauforge/deferred/gDP")
local videoPlaybackCoordinator = require("@luauforge/bundled/gDL").VideoPlaybackCoordinator
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local module9 = require("@luauforge/bundled/dXA")

local experienceCommunityLink = require("@luauforge/bundled/dEj").Components.ExperienceCommunityLink
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local module10 = require("@luauforge/bundled/ehL")
local focusNavigableSurfaceWrapper = module10.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module10.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module10.FocusNavigationEventNameEnum

local ageRecommendationDetails = require("@luauforge/bundled/dBl").AgeRecommendations.AgeRecommendationDetails
local experienceDetailsNoticeType = require("@luauforge/bundled/cBc").ExperienceDetailsNoticeType
local enumGameDetailErrorTypes = require("@luauforge/bundled/cBc").EnumGameDetailErrorTypes

local modules = require("@luauforge/bundled/dtb").Modules
local experienceRatings = modules.LuaApp.Components.ExperienceDetails.ExperienceRatings
local getPlayButtonProps = modules.LuaApp.Common.Experience.getPlayButtonProps
local module11 = require("@luauforge/bundled/fIC")
local playButton = module11.PlayButton
local playWithRewardComponent = require("@luauforge/deferred/gBY").PlayWithRewardComponent

local checkAndFormatPossibleLink = require("@luauforge/bundled/ehg").checkAndFormatPossibleLink

local retrievalStatus2 = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus

local module12 = require("@luauforge/bundled/dzD")
local module13 = require("@luauforge/bundled/fBF")
local module14 = require("@luauforge/deferred/fGi")
local module15 = require("@luauforge/deferred/gDx")
local module16 = require("@luauforge/deferred/gDZ")

local FtuxTooltipAnchor = require("@game/CoreGui/RobloxGui/Modules/Chrome/Integrations/FtuxTooltipAnchor")
local module18 = require("@luauforge/deferred/gDF")
local module19 = require("@luauforge/deferred/gCX")
local module20 = require("@luauforge/deferred/gDh")
local module21 = require("@luauforge/deferred/gDY")
local module22 = require("@luauforge/deferred/gCU")
local module23 = require("@luauforge/deferred/gFk")
local module24 = require("@luauforge/deferred/gCY")
local module25 = require("@luauforge/deferred/gDK")
local module26 = require("@luauforge/deferred/gDD")
local module27 = require("@luauforge/deferred/gEV")
local module28 = require("@luauforge/deferred/gEa")
local module29 = require("@luauforge/deferred/gBM")
local module30 = require("@luauforge/bundled/dDZ")
local module31 = require("@luauforge/deferred/gBN")
local module32 = require("@luauforge/deferred/gCa")

local module33 = require("@luauforge/deferred/gCb")

local module34 = require("@luauforge/deferred/gCN")
local playButtonContextualMessageImpressionsDetector = module11.PlayButtonContextualMessageImpressionsDetector

local module35 = require("@luauforge/bundled/dKu")
local edpttiConstants = module35.EDPTTIConstants
local fFlagEDPTTITrackingEnabled = module35.FFlagEDPTTITrackingEnabled
local module36 = require("@luauforge/deferred/gEY")
local useFirstMediaCarouselImageUri = require("@luauforge/deferred/gEZ").useFirstMediaCarouselImageUri
local module37 = require("@luauforge/deferred/gDV")

local useMediaGalleryVideoAnalytics = require("@luauforge/deferred/gDW").useMediaGalleryVideoAnalytics

local getFFlagEnableTenftUiDetailsMoreDropupMenu = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableTenftUiDetailsMoreDropupMenu

local getFFlagExpDetailsUseSelectionBumpers = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagExpDetailsUseSelectionBumpers
local module38 = require("@luauforge/deferred/gDI")

local module39 = require("@luauforge/deferred/gDf")
local module40 = require("@luauforge/deferred/gDg")

local getFFlagConsoleApplyTokenizationEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagConsoleApplyTokenizationEdp
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local getFFlagNotificationsForceEnableEDPDiscoverability = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagNotificationsForceEnableEDPDiscoverability

local fFlagLuaAppDesktopMediaGalleryTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDesktopMediaGalleryTelemetry

local fFlagLuaAppEdpFixDefaultBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpFixDefaultBanner
local fFlagSongEdpCarouselIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSongEdpCarouselIxp

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local module41 = require("@luauforge/deferred/gDm")
local module42 = require("@luauforge/deferred/gDn")

local module43 = require("@luauforge/deferred/gDo")

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppUnifyPlayButtonNonMobileEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifyPlayButtonNonMobileEdp

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagLuaAppEdpNonSduiBuildAttribution = SharedFlags.FFlagLuaAppEdpNonSduiBuildAttribution

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable

local fFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifyPlayButtonAllSurfacesIxp

local fFlagLuaAppUnifiedPlayButtonSquadMenuDirection = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifiedPlayButtonSquadMenuDirection
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local fFlagLuaAppAddSocialLinkClickTelemetryToEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddSocialLinkClickTelemetryToEdp

local fFlagEnablePlayWithRewardNonPeekviewEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlayWithRewardNonPeekviewEdp

local getFFlagUIBloxUseFoundationButton = require("@game/CorePackages/Workspace/Packages/SharedFlags").UIBlox.GetFFlagUIBloxUseFoundationButton

local fFlagLuaAppPlayButtonOptOutFoundationButton = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppPlayButtonOptOutFoundationButton
local fFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideo
local fFlagLuaAppEdpConsoleMediaGalleryVideoMute = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideoMute
local fFlagLuaAppUpdateFailedStateEdpIcon = SharedFlags.FFlagLuaAppUpdateFailedStateEdpIcon
local defineFastInt = game:DefineFastInt("PlayWithRewardNonPeekviewEdpLayoutOrder", 75)
local defineFastInt2 = game:DefineFastInt("LuaAppEDPSecondaryButtonExpansion", 200)

local v5 = {
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

local v7 = {
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

v7.PlayWithReward = defineFastInt

v7.BuildAttributionDisclaimer = fFlagLuaAppEdpNonSduiBuildAttribution and 1050 or nil

local extended = Roact.PureComponent:extend("ExperienceDetailsPage")

local strictInterface = t.strictInterface
local v8 = {}
v8.universeId = t.string
v8.referralSource = t.optional(t.string)

local v9 = if fFlagLuaAppUnifyPlayButtonNonMobileEdp or fFlagEnablePlayWithRewardNonPeekviewEdp then t.optional(t.table) else nil
v8.experienceJoinData = v9

v8.placeIdOverride = t.optional(t.string)
v8.onClose = t.callback

v8.thumbnail = t.optional(t.table)
v8.bannerImageId = t.optional(t.string)
local v10 = if fFlagLuaAppEdpFixDefaultBanner then t.optional(t.string) else nil
v8.defaultBannerUrl = v10
v8.gameInfo = t.optional(t.table)
v8.storeVotes = t.optional(t.table)
v8.gameDetail = t.optional(t.table)
v8.gameDetailError = t.optional(t.table)
v8.creatorVerified = t.optional(t.boolean)
v8.gameDetailsPageDataStatus = t.optional(t.string)
v8.gameProductInfo = t.optional(t.table)
v8.socialLinks = t.optional(t.table)
v8.ageRecommendations = t.optional(ageRecommendationDetails.validateModel)
v8.communityLink = t.optional(t.table)
v8.gameFollowings = t.optional(t.table)

local v11 = if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then t.optional(t.table) else nil
v8.sduiFeedItemConfigs = v11

local v12 = if fFlagEnablePlayWithRewardNonPeekviewEdp then t.optional(t.table) else nil
v8.playWithRewardData = v12
local v13 = if fFlagEnablePlayWithRewardNonPeekviewEdp then t.optional(t.boolean) else nil
v8.showPlayWithReward = v13
local v14 = if fFlagEnablePlayWithRewardNonPeekviewEdp then t.optional(t.boolean) else nil
v8.isPlayable = v14

v8.communityLinksEnabled = t.optional(t.boolean)
v8.communityLinkVariant = t.optional(t.string)
v8.enableNotificationsDiscoverability = t.optional(t.boolean)
local v15 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then t.optional(t.boolean) else nil
v8.mediaGalleryRedesignEnabledIxp = v15

local v16 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then t.optional(t.boolean) else nil
v8.mediaGalleryVideoPreviewEnabledIxp = v16

local v17 = if fFlagSongEdpCarouselIxp then t.optional(t.boolean) else nil
v8.showSongCarousel = v17
local v18 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v8.shouldHydrateLegacyIxp = v18
local v19 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then t.optional(t.boolean) else nil
v8.shouldInterleaveSduiIxp = v19

local v20 = if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then t.optional(t.table) else nil
v8.edpServerIxpVariables = v20

local v21 = if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then t.optional(t.table) else nil
v8.edpPerUniverseVisibilityVariables = v21

v8.hideCloseButton = t.optional(t.boolean)
local v22 = if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then t.optional(t.boolean) else nil
v8.hasUnifiedPlayButtonIxp = v22
local v23 = if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then t.optional(t.boolean) else nil
v8.unifyToUIBloxIxp = v23

v8.fetchGameDetailsPageData = t.callback
v8.openLeaveRobloxAlertUIBlox = t.callback
v8.openMoreContextualMenu = t.callback
v8.openShareContextualMenu = t.callback
v8.closeAlert = t.callback
v8.openVerifiedBadgeModal = t.optional(t.callback)
local v24 = if not module41 then t.callback else nil
v8.openCreatorPage = v24
local v25 = if module41 then t.optional(t.callback) else nil
v8.openCommunityProfilePage = v25
local v26 = if module41 then t.optional(t.callback) else nil
v8.openUserProfilePage = v26
v8.openExperienceGuidelinesExplained = t.callback
v8.toggleFollowExperience = t.optional(t.callback)
v8.openRefundPolicyLearnMorePage = t.callback
v8.openWebview = t.callback

local v27 = if fFlagLuaAppDesktopMediaGalleryTelemetry and not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v8.onMediaGalleryPreviewActivated = v27

local v28 = if fFlagLuaAppDesktopMediaGalleryTelemetry and not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v8.onMediaGalleryThumbnailActivated = v28

local v29 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v8.onMediaGalleryMediaChanged = v29
local v30 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v8.onMediaGalleryEnterFullscreen = v30
local v31 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then t.optional(t.callback) else nil
v8.onMediaGalleryExitFullscreen = v31
local v32 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then t.optional(t.table) else nil
v8.videoAnalytics = v32

v8.linking = t.table

v8.playabilityStatus = t.optional(t.table)
v8.playButtonState = t.string
v8.secondaryPlayButtonState = t.optional(t.string)
v8.onPlayButtonActivated = t.callback
local v33 = if getFFlagIsSquadEnabled() then t.callback else nil
v8.onPlaySquadButtonActivated = v33
v8.playButtonContextualMessage = t.optional(t.string)
v8.canExpandActionBarForSecondaryButton = t.optional(t.boolean)

v8.deviceType = t.optional(t.string)
v8.detailsPageConfiguration = t.optional(t.table)

v8.viewWidth = t.optional(t.number)
v8.viewHeight = t.optional(t.number)

v8.setControllerBarNavigation = t.optional(t.callback)
v8.uiModeInfo = t.optional(t.any)
v8.focusGuiObject = t.optional(t.callback)

local strictInterface2 = t.strictInterface
local v34 = {
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
local v35 = if getFFlagConsoleApplyTokenizationEdp() then t.optional(t.number) else nil
v34.expandableAreaHeightOffset = v35
v34.actionBarHeight = t.optional(t.number)
v8.tokens = strictInterface2(v34)

v8.webViewSupport = t.boolean
v8.notificationsCanEnableExperience = t.optional(t.boolean)
v8.experienceDetailsNoticeType = t.optional(t.string)

v8.iconButtonSize = t.optional(t.UDim2)
v8.textButtonSize = t.optional(t.UDim2)
v8.playButtonSize = t.optional(t.UDim2)
v8.actionBarHeight = t.optional(t.number)

v8.statsAndInfoRef = t.optional(t.table)
v8.playButtonRef = t.optional(t.union(t.table, t.callback))
v8.containerRef = t.optional(t.union(t.table, t.callback))

v8.foundationTokens = t.optional(t.table)
v8.disableStickyActionBar = t.optional(t.boolean)
extended.validateProps = strictInterface(v8)

local function createImageURL(p2)
	if p2 then
		return "rbxassetid://" .. p2
	end

	return ""
end

local v36 = {
	showEventsList = true,
	showLogoTraySection = true,
	showCornerGradientPropEnabled = false,
	showCommunityLink = false
}

function extended:init()
	local v37 = localization.new(LocalizationService.RobloxLocaleId)
	function self.applyTokenScaling(p2)
		return p2 * self.props.foundationTokens.Stroke.Standard
	end

	function self.getAbbreviateCount(p2)
		return abbreviateCount(p2, v37:GetLocale())
	end

	function self.upperString(p2)
		return string.upper(v37:Format(p2))
	end

	function self.onPlayButtonActivated()
		return self.props.onPlayButtonActivated()
	end

	function self.openMoreContextualMenu(p2)
		local universeId = self.props.universeId
		local vector2 = nil

		local v38 = self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot
		local udim

		if getFFlagEnableTenftUiDetailsMoreDropupMenu() and v38 then
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

	function self.getPlaysAnsVisitsInfo(p2, p3)
		local storeVotes = self.props.storeVotes
		return {
			plays = p2 and p2.playing or p3 and p3.playerCount or nil,
			visits = p2 and p2.visits or nil,
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
		if module39() then
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
				local v38 = if module38 then props.Tokens.Typography.TitleLarge else props.Font.Header2

				local v39 = if module38 then v38.FontSize else v38.RelativeSize * props.Font.BaseSize
				local textMuted = props.Theme.TextMuted

				if module42 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(module43)
				end

				if not (p9 and p7) then
					return self.getStyledTextLabel(p9, v38, textMuted)
				end

				local v40 = {
					name = appPage.GenericWebPage,
					detail = urlBuilder.game.info.creator({
						creatorType = p4,
						creatorId = p3
					}),
					extraProps = {
						title = v37:Format("Feature.GameDetails.Label.Developer"),
						transitionAnimation = module13.SlideInFromRight
					}
				}

				local createElement = Roact.createElement
				local v42 = {
					["Text"] = p9,
					FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
					TextColor3 = textMuted.Color,
					LayoutOrder = 2,
					AutoButtonColor = false,
					LineHeight = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = v39,
					BackgroundTransparency = 1
				}

				local tag = React.Tag
				local v43 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-experience-creator") else nil
				v42[tag] = v43

				v42[Roact.Event.Activated] = function()
					if module41 then
						if p4 == "User" then
							self.props.openUserProfilePage(p3, "ExperienceDetailsPage:SubTitle")
						elseif p4 == "Group" then
							self.props.openCommunityProfilePage(p3, "ExperienceDetailsPage:SubTitle")
						end
					else
						self.props.openCreatorPage(v40)
					end
				end

				return createElement("TextButton", v42)
			end)
		end

		local createElement = Roact.createElement
		local emojiWrapper = VerifiedBadges.EmojiWrapper
		local v38 = {
			emoji = not p6 and "" or VerifiedBadges.emoji.verified,
			layoutOrder = 2,
			onActivated = 0
		}

		local v39 = if p6 and p7 then self.props.openVerifiedBadgeModal else nil
		v38.onActivated = v39
		local element = createElement(emojiWrapper, v38, {
			userText = withStyle(function(props)
				local v40 = if module38 then props.Tokens.Typography.TitleLarge else props.Font.Header2

				local v41 = if module38 then v40.FontSize else v40.RelativeSize * props.Font.BaseSize
				local textMuted = props.Theme.TextMuted

				if module42 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(module43)
				end

				if not (p2 and p7) then
					return self.getStyledTextLabel(p2, v40, textMuted)
				end

				local v42 = {
					name = appPage.GenericWebPage,
					detail = urlBuilder.game.info.creator({
						creatorType = p4,
						creatorId = p3
					}),
					extraProps = {
						title = v37:Format("Feature.GameDetails.Label.Developer"),
						transitionAnimation = module13.SlideInFromRight
					}
				}

				local createElement2 = Roact.createElement
				local v44 = {
					["Text"] = p2,
					FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
					TextColor3 = textMuted.Color,
					LayoutOrder = 2,
					AutoButtonColor = false,
					LineHeight = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = v41,
					BackgroundTransparency = 1
				}

				local tag = React.Tag
				local v45 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-experience-creator") else nil
				v44[tag] = v45

				v44[Roact.Event.Activated] = function()
					if module41 then
						if p4 == "User" then
							self.props.openUserProfilePage(p3, "ExperienceDetailsPage:SubTitle")
						elseif p4 == "Group" then
							self.props.openCommunityProfilePage(p3, "ExperienceDetailsPage:SubTitle")
						end
					else
						self.props.openCreatorPage(v42)
					end
				end

				return createElement2("TextButton", v44)
			end)
		})

		if not fFlagLuaAppEdpNonSduiBuildAttribution or p2 == nil or not p8 then
			return element
		end

		local v40 = if p6 then `{p2}{module3.emoji.verified}` else p2
		local v41 = module20(v37, true, v40)

		if v41 == nil then
			return element
		end

		return fn(v41)
	end

	function self.renderTextOverride(p2, p3, p4, p5)
		return Roact.createElement(VerifiedBadges.EmojiWrapper, {
			emoji = not p5 and "" or VerifiedBadges.emoji.verified,
			layoutOrder = 0,
			size = UDim2.fromScale(0, 1)
		}, {
			userText = withStyle(function(data)
				local v38 = if module38 then data.Tokens.Typography.TitleLarge else data.Font.Header2
				local textEmphasis = data.Theme.TextEmphasis
				return self.getStyledTextLabel(p2, v38, textEmphasis)
			end)
		})
	end

	self.renderExperienceGuidelines = memoize(function(p2)
		local createElement = React.createElement
		local v39 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			BackgroundTransparency = 1
		}

		local v40 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4)
			}),
			ExperienceTagsContainer = 0
		}

		local createElement2 = React.createElement
		local v42 = {
			areTagsInteractable = true,
			includeAgeRecommendations = true,
			universeId = p2,
			LayoutOrder = 1,
			hideCloseButton = self.props.hideCloseButton,
			shouldHydrateLegacyIxp = 0
		}

		local v43 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
		v42.shouldHydrateLegacyIxp = v43
		v40.ExperienceTagsContainer = createElement2(module26, v42)
		return createElement("Frame", v39, v40)
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

			local v38 = headerDescriptionLineHeight * math.floor(font.BaseSize * font.Body.RelativeSize) * p2.headerDescriptionMaxRows
			local v39

			if module38 then
				v39 = props.Tokens.Typography.BodyLarge.FontSize
			else
				v39 = font.BaseSize * font.Body.RelativeSize
			end

			local v40 = if module38 then props.Tokens.Typography.BodyLarge.Font else font.Body.Font

			local y = getTextSize(p3, v39, v40, Vector2.new(1e999, 1e999)).Y

			local createElement = Roact.createElement
			local v42 = {
				Size = UDim2.new(1, 0, 0, (math.min(y, v38))),
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				ClipsDescendants = true
			}

			local createElement2 = Roact.createElement
			local v45 = {
				text = p3,
				fontStyle = 0,
				colorStyle = 0,
				size = 0,
				richText = false,
				fluidSizing = false,
				lineHeight = 0
			}

			local v46 = if module38 then props.Tokens.Typography.BodyLarge else font.Body
			v45.fontStyle = v46

			v45.colorStyle = props.Theme.TextEmphasis
			v45.size = UDim2.fromScale(1, 1)

			v45.lineHeight = headerDescriptionLineHeight
			return createElement("Frame", v42, {
				GameDescriptionText = createElement2(styledTextLabel, v45)
			})
		end)
	end

	function self.renderInfoContent(p2, p3, p4, p5, p6, p7, list, p8, p9, p10, p11)
		local v38 = self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot
		local headerItemPadding = p2 and p2.headerItemPadding or 0

		local v39 = if v38 then not (list == nil) and #list > 0 else v38
		local v40 = not v38

		return function()
			local v41

			if module41 then
				local renderSubtitleTextOverride = self.renderSubtitleTextOverride

				local v47 = self.props.uiModeInfo.uiMode ~= uiMode.TenFoot
				local v48 = if fFlagLuaAppEdpNonSduiBuildAttribution then p11 else nil
				v41 = renderSubtitleTextOverride(p4, p5, p6, p3, p7, v47, v48)
			else
				local renderSubtitleTextOverride = self.renderSubtitleTextOverride
				local v48 = if fFlagLuaAppEdpNonSduiBuildAttribution then p11 else nil
				v41 = renderSubtitleTextOverride(p4, p5, p6, p3, p7, nil, v48)
			end

			local createElement = Roact.createElement
			local v43 = {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			}

			local v44 = {
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, headerItemPadding)
				}),
				SubtitleText = v41,
				Padding = 0,
				PlayStats = 0,
				Description = 0,
				ExperienceGuidelinesComponent = 0
			}

			local v45 = if headerItemPadding then Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, headerItemPadding)
			}) else nil
			v44.Padding = v45

			local v46 = if v38 then self.renderInlinePlayerCountAndLikes(p8, p9, p10) else nil
			v44.PlayStats = v46

			local v47 = if v39 then self.renderBriefDescription(p2, list) else nil
			v44.Description = v47

			local v48 = if v40 then self.renderExperienceGuidelines(p3) else nil
			v44.ExperienceGuidelinesComponent = v48
			return createElement("Frame", v43, v44)
		end
	end

	self.renderPlaysAndVisits = memoize(function(p2, p3)
		return function()
			return Roact.createElement(playerCount, {
				layoutOrder = 1,
				countLeft = {
					countText = p2 == nil and "--" or self.getAbbreviateCount(p2),
					labelText = self.upperString("Feature.GameDetails.Label.Playing"),
					icon = images["icons/status/games/people-playing_large"]
				},
				countRight = {
					countText = p3 == nil and "--" or self.getAbbreviateCount(p3),
					labelText = self.upperString("Feature.GameDetails.Label.Visits"),
					icon = images["icons/status/games/sessions_large"]
				}
			})
		end
	end)

	function self.onFocusChanged(p2)
		if self.props.setControllerBarNavigation then
			self.props.setControllerBarNavigation(not p2)
		end
	end

	self.renderDescription = memoize(function(p2, p3)
		return function()
			return Roact.createElement(module18, {
				dataStatus = retrievalStatus.fromRawValue(p2),
				descriptionText = p3,
				onFocusChanged = self.onFocusChanged,
				universeId = self.props.universeId,
				pageContext = appPage.ExperienceDetail,
				componentType = "gameDescription"
			})
		end
	end)

	self.renderNotice = memoize(function(p2)
		return function()
			return withLocalization({
				noticeHeader = "Feature.ExperienceDetails.Body.NotesTitle",
				noticeText = "Feature.ExperienceDetails.Notes.InExperiencePurchase"
			})(function(p3)
				return Roact.createElement(module18, {
					dataStatus = retrievalStatus.fromRawValue(p2),
					headerText = p3.noticeHeader,
					descriptionText = p3.noticeText,
					onFocusChanged = self.onFocusChanged,
					universeId = self.props.universeId,
					pageContext = appPage.ExperienceDetail,
					componentType = "gameNotice"
				})
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
			local v39 = {
				igrsRating = p2,
				igrsRatingDisplayMessage = p3,
				onActivated = 0
			}
			local v40

			if p4 then
				v40 = function()
					callback(
						module12.INDONESIAN_CONTENT_MATURITY_URL,
						v37:Format("Feature.GameDetails.Label.ContentMaturity")
					)
				end
			else
				v40 = function()
					module14(p5, module12.INDONESIAN_CONTENT_MATURITY_URL)
				end
			end

			v39.onActivated = v40
			return createElement(module21, v39)
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
			local v40 = {
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

			local v41 = if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then self.props.universeId else nil
			v40.universeId = v41
			return createElement(fragment, nil, {
				ExperienceLogoTray = createElement2(module22, v40),
				EdpSocialLinksImpressionsDetector = Roact.createElement(module34, {
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
		local v38 = self.props.uiModeInfo and self.props.uiModeInfo.uiMode == uiMode.TenFoot

		if not self.state.isFullscreen and v38 and self.props.setControllerBarNavigation then
			self.props.setControllerBarNavigation(false)
		end

		self:setState({
			isFullscreen = true,
			mediaGalleryShowIndex = p2,
			currentIndex = if v38 then p2 else nil
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
				local v39 = {
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

				local v40 = if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then self.consoleVideoMuteSignal else nil
				v39.toggleMuteSignal = v40

				local v41 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then self.props.videoAnalytics else nil
				v39.videoAnalytics = v41

				local v42 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then self.videoPlaybackCoordinator else nil
				v39.videoPlaybackCoordinator = v42

				local v43 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
				v39.shouldHydrateLegacyIxp = v43
				return createElement(module25, v39)
			end
		end

		return function()
			local createElement = Roact.createElement
			local v39 = {
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

			local v40 = if fFlagLuaAppEdpMediaGalleryFullScreen then self.state.mediaGalleryShowIndex else nil
			v39.startIndex = v40
			v39.onPreviewActivated = self.onMediaGalleryPreviewActivated

			local v41 = if fFlagLuaAppDesktopMediaGalleryTelemetry and not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then self.props.onMediaGalleryThumbnailActivated else nil
			v39.onThumbnailActivated = v41

			local v42 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then self.props.onMediaGalleryMediaChanged else nil
			v39.onMediaGalleryMediaChanged = v42
			local v43 = if fFlagLuaAppEdpMediaGalleryFullScreen and (fFlagLuaAppEdpMediaGalleryAutoAdvance or fFlagLuaAppEdpMediaGalleryVideoPreview) then p3 else nil
			v39.isOccluded = v43

			local v44 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then self.props.mediaGalleryRedesignEnabledIxp else nil
			v39.mediaGalleryRedesignEnabledIxp = v44

			local v45 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then self.props.mediaGalleryVideoPreviewEnabledIxp else nil
			v39.mediaGalleryVideoPreviewEnabledIxp = v45

			local v46 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v39.shouldHydrateLegacyIxp = v46
			return createElement(module25, v39)
		end
	end)

	self.renderExperienceRating = memoize(function(p2)
		return function()
			local createElement = Roact.createElement
			local v39 = {
				universeId = p2,
				height = math.floor((self.applyTokenScaling(72))),
				shouldHydrateLegacyIxp = 0,
				styleProps = 0
			}

			local v40 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v39.shouldHydrateLegacyIxp = v40

			v39.styleProps = {
				statWidgetIconSize = math.floor((self.applyTokenScaling(48)))
			}
			return createElement(experienceRatings, v39)
		end
	end)

	self.renderExperienceInfoTable = memoize(function(p2)
		return function()
			local createElement = Roact.createElement

			local statsAndInfoRefsByRef = { [Roact.Ref] = self.props.statsAndInfoRef }

			local createElement2 = Roact.createElement
			local v40 = {
				renderTextOverride = self.renderTextOverride,
				universeId = p2,
				key = "ExperienceInfoTable",
				shouldHydrateLegacyIxp = 0,
				hideCloseButton = 0
			}

			local v41 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v40.shouldHydrateLegacyIxp = v41

			v40.hideCloseButton = self.props.hideCloseButton
			return createElement("Folder", statsAndInfoRefsByRef, createElement2(module23, v40))
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
			local v39 = {
				universeId = p2,
				referralSource = "expDetailsPage",
				defaultThumbnail = 0
			}

			local v40 = if p3 then "rbxassetid://" .. p3 else nil
			v39.defaultThumbnail = v40
			return createElement(module15, v39)
		end
	end)

	self.renderRecommendedExperiencesCarousel = memoize(function(p2)
		return function()
			local createElement = Roact.createElement
			local v39 = { universeId = p2, shouldHydrateLegacyIxp = 0, pageContext = 0 }

			local v40 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v39.shouldHydrateLegacyIxp = v40

			v39.pageContext = appPage.ExperienceDetail
			return createElement(module27, v39)
		end
	end)

	if fFlagSongEdpCarouselIxp then
		self.renderExperienceSongsCarousel = memoize(function(p2, value)
			return function()
				return React.createElement(module28, {
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
			return withStyle(function(p3)
				return Roact.createElement(module16, {
					refundPolicy = p2,
					paddingTop = p3.Tokens.Size.Size_600
				})
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
		local v38 = data.showLogoTraySection and items and next(items)

		local v39 = data.showCommunityLink

		if v39 then
			v39 = if p9 then p10 == "banner" and p8 else p9
		end

		local showEventsList = data.showEventsList

		local v40 = self.props.webViewSupport and p14 ~= nil

		local v41 = fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
			and (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and self.props.shouldInterleaveSduiIxp)
			and (not self.props.edpPerUniverseVisibilityVariables or self.props.edpPerUniverseVisibilityVariables.hidePlayWithReward == true)
		local v42

		if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
			v42 = fFlagEnablePlayWithRewardNonPeekviewEdp and p23 and p22 and p21 and not v41
		end

		local v43 = v5.Description
		local v44 = v5.MediaGallery

		if not p12 then
			v44 = v43
		end

		local eventsListRedesign = v5.EventsListRedesign
		local eventsListRedesign2 = v7.EventsListRedesign
		local left = contentPosition.Left

		if not p12 then
			v43 = v5.MediaGalleryMediaFirst
		end

		local v45 = {
			portraitLayoutOrder = v43,
			landscapeLayoutOrder = v7.MediaGallery,
			landscapePosition = contentPosition.Right,
			showCornerGradient = 0,
			useSelectionBumper = 0,
			renderComponent = 0
		}
		local v46 = if data.showCornerGradientPropEnabled then false else nil
		v45.showCornerGradient = v46
		v45.useSelectionBumper = getFFlagExpDetailsUseSelectionBumpers() and true or nil
		v45.renderComponent = self.renderMediaGallery(p2, p11)
		local result = {
			MediaGallery = v45,
			Description = {
				portraitLayoutOrder = v44,
				landscapeLayoutOrder = v7.Description,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderDescription(p3, p4)
			},
			IgrsRatingLabel = p16 and {
				portraitLayoutOrder = v5.IgrsRatingLabel,
				landscapeLayoutOrder = v7.IgrsRatingLabel,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderIgrsRatingLabel(p16, p17, p18, p19, p20)
			} or nil,
			ExperienceRatings = (not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module6.getShouldInterleaveSdui()) or not self.props.edpServerIxpVariables or self.props.edpServerIxpVariables.hideGameRatings ~= true) and {
				portraitLayoutOrder = v5.ExperienceRatings,
				landscapeLayoutOrder = v7.ExperienceRatings,
				landscapePosition = contentPosition.Left,
				useSelectionBumper = getFFlagExpDetailsUseSelectionBumpers() and true or nil,
				renderComponent = self.renderExperienceRating(p2)
			} or nil,
			PlaysAndVisits = (not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module6.getShouldInterleaveSdui()) or not self.props.edpServerIxpVariables or self.props.edpServerIxpVariables.showVisitsInInfoList ~= true) and {
				portraitLayoutOrder = v5.PlaysAndVisits,
				landscapeLayoutOrder = v7.PlaysAndVisits,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderPlaysAndVisits(p6, p7)
			} or nil,
			CommunityLink = v39 and {
				portraitLayoutOrder = v5.CommunityLink,
				landscapeLayoutOrder = v7.CommunityLink,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderCommunityLink(p8, p5, p2)
			} or nil,
			ExperienceInfoTable = {
				portraitLayoutOrder = v5.ExperienceInfoTable,
				landscapeLayoutOrder = v7.ExperienceInfoTable,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderExperienceInfoTable(p2)
			},
			BuildAttributionDisclaimer = fFlagLuaAppEdpNonSduiBuildAttribution and p27 and p12 and {
				portraitLayoutOrder = v5.BuildAttributionDisclaimer,
				landscapeLayoutOrder = v7.BuildAttributionDisclaimer,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderBuildAttributionDisclaimer()
			} or nil,
			RefundPolicy = v40 and {
				portraitLayoutOrder = v5.RefundPolicy,
				landscapeLayoutOrder = v7.RefundPolicy,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderRefundPolicy(p14)
			} or nil,
			LogoTraySection = v38 and {
				portraitLayoutOrder = v5.LogoTraySection,
				landscapeLayoutOrder = v7.LogoTraySection,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderLogoTray(items, p20)
			} or nil,
			EventsList = showEventsList and {
				portraitLayoutOrder = eventsListRedesign,
				landscapeLayoutOrder = eventsListRedesign2,
				landscapePosition = left,
				renderComponent = self.renderEventsList(p2, p13)
			} or nil,
			Notice = p15 == experienceDetailsNoticeType.InExperiencePurchase and {
				portraitLayoutOrder = v5.Notice,
				landscapeLayoutOrder = v7.Notice,
				landscapePosition = contentPosition.Left,
				renderComponent = self.renderNotice(p3)
			} or nil,
			RecommendedExperiences = {
				portraitLayoutOrder = v5.RecommendedExperiences,
				portraitZIndex = 2,
				landscapeLayoutOrder = v7.RecommendedExperiences,
				landscapePosition = contentPosition.Right,
				useSelectionBumper = getFFlagExpDetailsUseSelectionBumpers() and true or nil,
				renderComponent = self.renderRecommendedExperiencesCarousel(p2)
			},
			ExperienceSongsCarousel = fFlagSongEdpCarouselIxp and self.props.showSongCarousel and {
				portraitLayoutOrder = v5.ExperienceSongsCarousel,
				portraitZIndex = 1,
				landscapeLayoutOrder = v7.ExperienceSongsCarousel,
				landscapePosition = contentPosition.Right,
				renderComponent = self.renderExperienceSongsCarousel(p2, p5)
			} or nil,
			PlayWithReward = 0
		}

		if not fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
			v42 = fFlagEnablePlayWithRewardNonPeekviewEdp and p23 and p22 and p21
		end

		result.PlayWithReward = v42
			and {
				portraitLayoutOrder = v5.PlayWithReward,
				landscapeLayoutOrder = v7.PlayWithReward,
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
				local v40 = {
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

				local v41 = if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then self.consoleVideoMuteSignal else nil
				v40.toggleMuteSignal = v41

				local v42 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then self.props.videoAnalytics else nil
				v40.videoAnalytics = v42

				local v43 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then self.videoPlaybackCoordinator else nil
				v40.videoPlaybackCoordinator = v43

				local v44 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
				v40.shouldHydrateLegacyIxp = v44
				return createElement(module25, v40)
			end
		end

		return function()
			local createElement = Roact.createElement
			local v40 = {
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
				isIsolated = true,
				customEventHandlers = self.focusEventHandlers
			}

			local createElement2 = Roact.createElement
			local v43 = {
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

			local v44 = if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then self.props.onMediaGalleryMediaChanged else nil
			v43.onMediaGalleryMediaChanged = v44

			v43.startIndex = if fFlagLuaAppEdpMediaGalleryFullScreen then p3 else nil
			local v46 = if fFlagLuaAppEdpMediaGalleryFullScreen then self.exitFullscreen else nil
			v43.exitFullscreen = v46

			local v47 = if fFlagLuaAppEdpMediaGalleryRedesignIxp then self.props.mediaGalleryRedesignEnabledIxp else nil
			v43.mediaGalleryRedesignEnabledIxp = v47

			local v48 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then self.props.mediaGalleryVideoPreviewEnabledIxp else nil
			v43.mediaGalleryVideoPreviewEnabledIxp = v48

			local v49 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then self.props.shouldHydrateLegacyIxp else nil
			v43.shouldHydrateLegacyIxp = v49
			return createElement(focusNavigableSurfaceWrapper, v40, {
				ExperienceMediaGallery = createElement2(module25, v43)
			})
		end
	end)

	self.renderBackgroundContent = fFlagLuaAppEdpConsoleMediaGalleryVideo and function(p2, p3, p4)
		if not p3 or self.state.selectedVideoId == nil or p2 then
			return nil
		end

		local createElement = Roact.createElement
		local v40 = {
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

		local v41 = if fFlagLuaAppEdpConsoleMediaGalleryVideoMute then self.consoleVideoMuteSignal else nil
		v40.toggleMuteSignal = v41

		v40.videoPlaybackCoordinator = self.videoPlaybackCoordinator
		return createElement(module7, v40)
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

			local v41 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then p4 or Roact.None else nil

			local v42 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then p5 or Roact.None else nil
			self:setState({
				bannerImageId = p3,
				nextIndex = p2,
				selectedVideoId = v41,
				selectedVideoThumbnail = v42
			})
		end

		function self.mediaGalleryGainFocused(p2)
			if not p2 then
				local v40 = {
					bannerImageId = self.props.bannerImageId,
					selectedVideoId = 0,
					selectedVideoThumbnail = 0
				}
				local v41 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then Roact.None else nil
				v40.selectedVideoId = v41
				local v42 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then Roact.None else nil
				v40.selectedVideoThumbnail = v42
				self:setState(v40)
			end
		end
	end

	if module39() then
		self.isMounted = false

		local success, result = pcall(function()
			return AppStorageService:GetItem("ShowNotificationsOptInTooltip")
		end)
		local v39 = if success then result == "true" else false
		self.showTooltip = v39
		self:setState({ isNotificationsTooltipActive = self.showTooltip })
	end
end

function extended:didMount()
	self.checkCommunityLinkExposureLogging()

	if module39() then
		self.isMounted = true

		if self.showTooltip then
			pcall(function()
				AppStorageService:SetItem("ShowNotificationsOptInTooltip", "false")
				AppStorageService:Flush()
			end)
		end

		Promise.delay(module40()):andThen(function()
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
	if self.props.gameDetailsPageDataStatus == retrievalStatus2.Failed and not self.props.gameInfo then
		return self:renderOnFailed()
	end

	return self:renderOnLoaded()
end

function extended.renderOnFailed(p2)
	return withLocalization({
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
		experienceUnavailableMessage = "Feature.GamePage.QuickLaunch.LaunchError.TemporarilyUnavailable"
	})(function(p3)
		local v37 = p2.props.gameDetailError
			and p2.props.gameDetailError.errorType == enumGameDetailErrorTypes.ExperienceUnavailable

		if fFlagLuaAppUpdateFailedStateEdpIcon then
			return withStyle(function(p4)
				local createElement = Roact.createElement
				local v39 = {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = p4.Theme.BackgroundDefault.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0
				}

				local createElement2 = Roact.createElement
				local v42 = {
					icon = images["icons/status/error_large"],
					onActivated = 0,
					text = 0
				}
				local v43 = if not v37 then p2.props.fetchGameDetailsPageData else nil
				v42.onActivated = v43

				local v44 = if v37 then p3.experienceUnavailableMessage else p3.failedMessage
				v42.text = v44
				local v40 = {
					EmptyState = createElement2(emptyState, v42),
					CloseButton = 0
				}

				local v45 = if not p2.props.hideCloseButton then Roact.createElement(iconButton, {
					Position = UDim2.fromOffset(12, 12),
					ZIndex = 2,
					icon = iconName.X,
					isCircular = true,
					onActivated = p2.onClose,
					size = buttonSize.Medium,
					variant = buttonVariant.Utility,
					testId = "--discovery-edp-iconbutton-close"
				}) else nil
				v40.CloseButton = v45
				return createElement("Frame", v39, v40)
			end)
		end

		local createElement = Roact.createElement
		local v40 = if not v37 then p2.props.fetchGameDetailsPageData else nil

		local v41 = if v37 then p3.experienceUnavailableMessage else p3.failedMessage
		return createElement(emptyState, { onActivated = v40, text = v41 })
	end)
end

function extended:willUnmount()
	if module39() then
		self.isMounted = false
	end
end

function extended.renderOnLoaded(props)
	local deviceType2 = props.props.deviceType
	local universeId = props.props.universeId
	local gameInfo = props.props.gameInfo
	local thumbnail = props.props.thumbnail
	local tokens = props.props.tokens
	local v37 = props.props.uiModeInfo and props.props.uiModeInfo.uiMode == uiMode.TenFoot

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
	local v38 = if fFlagLuaAppEdpNonSduiBuildAttribution then module19(gameDetail) else nil
	local name2 = if gameDetail then gameDetail.creator.name or nil else nil
	local id = if gameDetail then gameDetail.creator.id or nil else nil
	local kind = if gameDetail then gameDetail.creator.type or nil else nil
	local v39, igrsRating, igrsRatingDisplayMessage

	if props.props.ageRecommendations then
		local summary = props.props.ageRecommendations.summary

		if summary and summary.ageRecommendation then
			if summary.ageRecommendation.displayNameWithHeaderShort then
				v39 = summary.ageRecommendation.displayNameWithHeaderShort
			else
				v39 = summary.ageRecommendation.displayName
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
	local v40 = if module39() then props.state.isNotificationsTooltipActive else false

	local isFullscreen = props.state.isFullscreen
	local isCrossFade = props.state.isCrossFade
	local currentIndex = props.state.currentIndex
	local nextIndex = props.state.nextIndex
	local mediaGalleryShowIndex = props.state.mediaGalleryShowIndex
	local v41, sideMargin, headerBarBackgroundHeight

	if tokens then
		v41 = tokens.thumbnailSize
		sideMargin = tokens.sideMargin
		headerBarBackgroundHeight = tokens.headerBarBackgroundHeight
	else
		sideMargin = nil
		v41 = nil
		headerBarBackgroundHeight = nil
	end

	local v42 = nil

	if deviceType2 == deviceType.Tablet then
		v42 = math.min(props.props.viewHeight / 3, 500)
		v41 = 200
	elseif not v37 then
		v42 = 208
	end

	local v44 = v37 and v39
	local v45 = getFFlagNotificationsForceEnableEDPDiscoverability() and true
		or props.props.enableNotificationsDiscoverability
	local notificationsCanEnableExperience = props.props.notificationsCanEnableExperience

	if
		(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module6.getShouldInterleaveSdui())
		and props.props.edpServerIxpVariables
		and props.props.edpServerIxpVariables.hideNotifyButton == true
	then
		v45 = false
	end

	local filter = Cryo.List.filter
	local v47

	if not v37 then
		local v49 = {
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5),
			icon = images["icons/actions/friends/friendsplaying"],
			userInteractionEnabled = true,
			showBackground = true,
			onActivated = props.openShareContextualMenu,
			size = props.props.iconButtonSize,
			backgroundColor = 0
		}
		local v50 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
		v49.backgroundColor = v50
		v47 = { props = v49 } or nil
	end

	local v49 = {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.fromScale(0.5, 0.5),
		icon = images["icons/common/more"],
		userInteractionEnabled = true,
		showBackground = true,
		onActivated = props.openMoreContextualMenu,
		size = props.props.iconButtonSize,
		backgroundColor = 0
	}
	local v50 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
	v49.backgroundColor = v50
	local v51

	if v45 and notificationsCanEnableExperience then
		local v53 = {
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
		local v54 = if props.props.gameFollowings and props.props.gameFollowings.isFollowed then images["icons/common/notificationOn"] else images["icons/common/notificationOff"]
		v53.icon = v54

		v53.userInteractionEnabled = true
		v53.showBackground = true
		v53.onActivated = props.toggleFollowExperience
		v53.size = props.props.iconButtonSize
		local v55 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
		v53.backgroundColor = v55
		v53[Roact.Children] = module39() and {
			Tooltip = React.createElement(FtuxTooltipAnchor, {
				isActive = v40,
				preferredOrientation = tooltipOrientation.Bottom
			})
		} or nil
		v51 = { props = v53 } or nil
	end

	local v52 = filter({
		v47,
		{ props = v49 },
		v51
	}, function(p2): boolean
		return p2 ~= nil
	end)

	local v53 = nil
	local v54

	if v37 then
		local licenseDescription = if props.props.gameDetail then props.props.gameDetail.licenseDescription or nil else nil

		v54 = (v44 or licenseDescription) and {} or v53

		if v44 then
			local v56 = {
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.fromScale(0, 0.5),
				text = v39,
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
			local v57 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
			v56.backgroundColor = v57
			table.insert(v54, { props = v56 })
		end

		if licenseDescription then
			local v56 = {
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
			local v57 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
			v56.backgroundColor = v57
			table.insert(v54, { props = v56 })
		end
	elseif v44 then
		v54 = { nil }

		local v56 = {
			anchorPoint = Vector2.new(0, 0.5),
			position = UDim2.fromScale(0, 0.5),
			text = v39,
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
		local v57 = if tokens then tokens.actionBarButtonBackgroundColor or nil else nil
		v56.backgroundColor = v57
		v54[1] = { props = v56 }
	else
		v54 = nil
	end

	local v55 = props.props.canExpandActionBarForSecondaryButton
		and props.props.secondaryPlayButtonState ~= nil

	return withLocalization({ buttonText = textKey })(function(p2)
		local v56 = p2.buttonText

		if playButtonProps.localizedFiatPrice then
			v56 = playButtonProps.localizedFiatPrice
		elseif price then
			v56 = props.getAbbreviateCount(price)
		end

		local v57 = {
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
		local v58 = if props.props.playButtonContextualMessage then props.renderActionBarLabelImpressionsDetector else nil
		v57.renderActionBarLabelImpressionsDetector = v58

		v57.renderInfoContent = props.renderInfoContent(
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
			v38
		)

		v57.onClose = props.onClose
		local v59

		if fFlagLuaAppEdpFixDefaultBanner then
			v59 = props.props.defaultBannerUrl

			if not v59 then
				local bannerImageId = props.state.bannerImageId or props.props.bannerImageId
				v59 = not bannerImageId and "" or "rbxassetid://" .. bannerImageId
			end
		else
			local bannerImageId = props.state.bannerImageId or props.props.bannerImageId
			v59 = not bannerImageId and "" or "rbxassetid://" .. bannerImageId
		end

		v57.bannerImageUrl = v59

		local v60 = {
			iconSize = props.props.tokens.iconSize,
			buttonHeight = props.props.actionBarHeight,
			buttonPadding = tokens.headerItemPadding,
			button = 0,
			buttonOverride = 0,
			icons = 0,
			textButtons = 0
		}
		local v61

		if not (fFlagLuaAppUnifyPlayButtonNonMobileEdp and (not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.props.hasUnifiedPlayButtonIxp)) then
			v61 = { props = 0 }
			local v62

			if getFFlagIsSquadEnabled() and playButtonProps.showSquadButton then
				v62 = { button = 0, overflow = 0, size = 0 }
				local v63 = {
					onActivated = props.onPlayButtonActivated,
					icon = 0,
					text = 0,
					isDisabled = 0
				}
				local v64 = if icon then images[icon] else nil
				v63.icon = v64
				v63.text = v56
				v63.isDisabled = playButtonProps.isDisabled
				v62.button = v63

				v62.overflow = {
					isDisabled = playButtonProps.isSquadButtonDisabled,
					onActivated = props.props.onPlaySquadButtonActivated
				}

				v62.size = props.props.playButtonSize
			else
				v62 = {
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
				local v63 = if icon then images[icon] else nil
				v62.icon = v63
				v62.text = v56
				v62.isDisabled = playButtonProps.isDisabled
				v62.isLoading = playButtonProps.isLoading
				v62.buttonType = playButtonProps.buttonType
				v62.size = props.props.playButtonSize
				v62.buttonRef = props.props.playButtonRef
				v62.DO_NOT_USE_useUIBloxButton = (getFFlagUIBloxUseFoundationButton() or fFlagLuaAppPlayButtonOptOutFoundationButton)
					and true
					or nil
			end

			v61.props = v62
		end

		v60.button = v61
		local v62

		if
			fFlagLuaAppUnifyPlayButtonNonMobileEdp
			and (not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp or props.props.hasUnifiedPlayButtonIxp)
			or props.props.secondaryPlayButtonState ~= nil
		then
			local createElement = Roact.createElement
			local v64 = {
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
			local v65 = if v37 then buttonSize.Medium else buttonSize.Large
			v64.buttonSize = v65

			local v66 = if fFlagLuaAppUnifiedPlayButtonSquadMenuDirection then menuDirection.Down else nil
			v64.squadButtonMenuDirection = v66

			v64.useUIBloxButton = props.props.unifyToUIBloxIxp
			v62 = createElement(playButton, v64)
		end

		v60.buttonOverride = v62

		v60.icons = v52
		v60.textButtons = v54
		v57.actionBarProps = v60

		local v63 = if getFFlagIsSquadEnabled() and playButtonProps.showSquadButton then props.applyTokenScaling(420 + (not v55 and 0 or defineFastInt2)) else props.applyTokenScaling(380 + (not v55 and 0 or defineFastInt2))
		v57.actionBarWidth = v63

		v57.actionBarHeight = props.props.actionBarHeight
		local getBodyComponentListProps = props.getBodyComponentListProps

		local gameDetailsPageDataStatus = props.props.gameDetailsPageDataStatus

		local plays = playsAnsVisitsInfo.plays
		local visits = playsAnsVisitsInfo.visits

		local communityLinksEnabled = props.props.communityLinksEnabled
		local communityLinkVariant = props.props.communityLinkVariant
		local detailsPageConfiguration = props.props.detailsPageConfiguration or v36

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
		local v73 = if fFlagEnablePlayWithRewardNonPeekviewEdp then rootPlaceId else nil
		local placeIdOverride = if fFlagEnablePlayWithRewardNonPeekviewEdp then props.props.placeIdOverride else nil
		local experienceJoinData = if fFlagEnablePlayWithRewardNonPeekviewEdp then props.props.experienceJoinData else nil
		local v74 = if fFlagLuaAppEdpNonSduiBuildAttribution then v38 else nil
		v57.componentList = getBodyComponentListProps(
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
			v37,
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
			v73,
			placeIdOverride,
			experienceJoinData,
			v74
		)

		v57.isFullscreen = isFullscreen
		v57.renderFullscreenContent = props.renderFullscreenContent(
			universeId,
			mediaGalleryShowIndex,
			isFullscreen,
			isCrossFade,
			currentIndex,
			nextIndex
		)

		local v75 = if fFlagLuaAppEdpConsoleMediaGalleryVideo then props.renderBackgroundContent(isFullscreen, v37, universeId) else nil
		v57.backgroundContentOverride = v75

		v57.sideMargin = sideMargin

		v57.startingOffsetPosition = v42

		v57.thumbnailHeight = v41
		v57.headerBarBackgroundHeight = headerBarBackgroundHeight

		v57.tokens = tokens and {
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

		v57.disableStickyActionBar = props.props.disableStickyActionBar
		v57.containerRef = props.props.containerRef

		return Roact.createElement(detailsPageSelector, {
			deviceType = deviceType2,
			detailsPageProps = v57
		})
	end)
end

local function ExperienceDetailsPageFn(props)
	if fFlagEDPTTITrackingEnabled then
		local v37 = useFirstMediaCarouselImageUri(props.universeId)
		module36(edpttiConstants.EDP_IMPLEMENTATION.LEGACY_FULL_PAGE, props.universeId, v37)
	end

	local v37 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then module6.getShouldHydrateLegacy() else nil
	local v38

	if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v38 = module6.getShouldInterleaveSdui()
	end

	local v39, v40, v41

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		local v42 = module30.useSduiContextFromSignalAndProcessConfigs(
			module31.getUnprocessedEdpStoreKey((tostring(props.universeId))),
			module31.getEdpStoreKey((tostring(props.universeId))),
			fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v38
		)

		v39 = module30.useSduiEdpFeedItemConfigs({
			sduiContext = v42,
			storeKey = module31.getEdpStoreKey((tostring(props.universeId))),
			portraitLayoutConfig = v5,
			landscapeLayoutConfig = v7,
			defaultLayoutOrder = v5.SduiFeedItemsDefault,
			logLayoutConflictFn = module29.logSduiLayoutOrderConflict,
			shouldInterleaveSdui = fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v38
		})

		v40 = module32()

		if fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then
			v41 = module33(props.universeId)
		end
	end

	local v42 = useUiModeInfo()
	local v43 = ReactFocusNavigation.useFocusGuiObject()
	local v44

	if fFlagLuaAppEdpConsoleMediaGalleryVideo then
		local rootPlaceId = props.gameDetail and props.gameDetail.rootPlaceId
			or props.gameInfo and props.gameInfo.placeId

		local universeId = props.universeId
		local mediaGalleryVideoPreviewEnabledIxp

		if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
			mediaGalleryVideoPreviewEnabledIxp = props.mediaGalleryVideoPreviewEnabledIxp
		end

		local v47 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then v37 else nil
		local v48 = module37(universeId, rootPlaceId, true, mediaGalleryVideoPreviewEnabledIxp, v47)

		v44 = useMediaGalleryVideoAnalytics(props.universeId, rootPlaceId, v48)
	end

	local v45 = GameHydrationReact.useGameVotes(props.universeId)

	local state, setState = React.useState(nil)

	local v46 = not props.tokens and 0 or props.tokens.iconSize
	local udim = if v42.uiMode == uiMode.TenFoot then UDim2.fromOffset(v46, v46) else nil
	local udim2 = UDim2.fromOffset(0, v46)
	v46 = props.tokens and props.tokens.actionBarHeight or v46
	local udim3 = UDim2.new(1, 0, 0, v46)
	local v47 = useTokens()

	local ref = React.useRef(nil)
	ref.current = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v48 = Responsive.useBreakpointXOrLarger(Responsive.Keys.Medium)

	local current = ref.current

	local v49 = useCloseWithBackButton(setState, props.onClose)

	local state2, setState2 = React.useState(nil)

	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if state2 == nil then
			ref2.current = false
		elseif state2 and ref.current and not ref2.current then
			v43(state2)
			ref2.current = true
		end
	end, { state2, v43 })

	React.useEffect(function()
		local v51 = -1
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

				instance2.SelectionOrder = v51
				v51 -= 1
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
	local v52 = {
		foundationTokens = v47,
		uiModeInfo = v42,
		canExpandActionBarForSecondaryButton = v48,
		focusGuiObject = v43,
		iconButtonSize = udim,
		textButtonSize = udim2,
		playButtonSize = udim3,
		actionBarHeight = v46,
		playButtonRef = setState2,
		containerRef = v49,
		storeVotes = v45,
		sduiFeedItemConfigs = nil,
		disableStickyActionBar = nil,
		hideCloseButton = nil,
		videoAnalytics = nil,
		shouldHydrateLegacyIxp = nil,
		shouldInterleaveSduiIxp = nil,
		edpServerIxpVariables = nil,
		edpPerUniverseVisibilityVariables = nil
	}

	if not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v38) then
		v39 = nil
	end

	v52.sduiFeedItemConfigs = v39

	v52.disableStickyActionBar = current
	v52.hideCloseButton = current

	if not fFlagLuaAppEdpConsoleMediaGalleryVideo then
		v44 = nil
	end

	v52.videoAnalytics = v44

	if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
		v37 = nil
	end

	v52.shouldHydrateLegacyIxp = v37
	v52.shouldInterleaveSduiIxp = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then v38 else nil

	if not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v38) then
		v40 = nil
	end

	v52.edpServerIxpVariables = v40

	if not (fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable and (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and v38)) then
		v41 = nil
	end

	v52.edpPerUniverseVisibilityVariables = v41
	return createElement(extended, join(v52, props))
end

return ExperienceDetailsPageFn
