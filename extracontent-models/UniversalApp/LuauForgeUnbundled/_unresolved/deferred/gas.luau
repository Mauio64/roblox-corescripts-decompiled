local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")

local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local getFirstFocusableDescendant = require("@luauforge/bundled/eeo").getFirstFocusableDescendant
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local React = require(CorePackages.Packages.React)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
require("@luauforge/bundled/dBU")
local playabilityStatusEnum = require("@luauforge/bundled/cyO").PlayabilityStatusEnum
local playButtonStates = require("@luauforge/bundled/fWH").PlayButtonStates
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local usePlayWithRewardData = require("@luauforge/deferred/fXc").usePlayWithRewardData
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/deferred/fXb")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local useDeviceType = RobloxAppHooks.useDeviceType
local useRoactService = RobloxAppHooks.useRoactService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local hasPageInCurrentRoute = require("@luauforge/bundled/fXq").hasPageInCurrentRoute
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectCurrentLegacyRoute = NavigationRodux.Selectors.selectCurrentLegacyRoute
local fFlagSignalsNavP3fGameDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3fGameDetails
local getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local sessionType = require("@luauforge/bundled/foF").SessionType

local gameDetailsEvents = require("@luauforge/bundled/dpZ").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents
local follow = gameDetailsEvents.Follow
local mediaGalleryActivated = gameDetailsEvents.MediaGalleryActivated
local mediaGalleryMediaChanged = gameDetailsEvents.MediaGalleryMediaChanged
local mediaGalleryEnterFullscreen = gameDetailsEvents.MediaGalleryEnterFullscreen
local mediaGalleryExitFullscreen = gameDetailsEvents.MediaGalleryExitFullscreen

local module4 = require("@luauforge/deferred/gat")
local module5 = require("@luauforge/deferred/gav")
local module6 = require("@luauforge/deferred/gaw")
local module7 = require("@luauforge/deferred/fYm")
local module8 = require("@luauforge/deferred/gax")
local module9 = require("@luauforge/deferred/gay")

local module10 = require("@luauforge/deferred/fXf")
local module11 = require("@luauforge/deferred/gaz")
local module12 = require("@luauforge/deferred/fYR")
local module13 = require("@luauforge/deferred/fYe")

local module14 = require("@luauforge/deferred/gau")
local module15 = require("@luauforge/deferred/fYN")
local module16 = require("@luauforge/deferred/fYO")

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable

local getNotificationsExperienceDetailsVariant = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetNotificationsExperienceDetailsVariant
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppPlayButtonLoadingDurationTelemetry

local getFFlagNotificationsForceEnableEDPDiscoverability = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagNotificationsForceEnableEDPDiscoverability

local fFlagLuaAppDesktopMediaGalleryTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDesktopMediaGalleryTelemetry

local fFlagLuaAppEdpFixDefaultBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpFixDefaultBanner

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local fFlagSongEdpCarouselIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSongEdpCarouselIxp
local module17 = require("@luauforge/deferred/fYq")

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppUnifyPlayButtonNonMobileEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifyPlayButtonNonMobileEdp

local fFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUnifyPlayButtonAllSurfacesIxp

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents

local fFlagExtendScrollingFramesBySafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagExtendScrollingFramesBySafeInsets

local fFlagEnablePlayWithRewardNonPeekviewEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlayWithRewardNonPeekviewEdp

local fFlagLuaAppEdpKeepFullPageOnPortraitRotation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpKeepFullPageOnPortraitRotation

local fFlagLuaAppLogExposurePlayButtonUX = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppLogExposurePlayButtonUX

local function ExperienceDetailsContainer(props)
	local v5 = useAppPolicy(function(data)
		return {
			roundedCorners = data.getUseRoundedCorners(),
			webViewSupport = data.getWebViewSupport(),
			notificationsCanEnableExperience = data.getNotificationsCanReceiveExperience(),
			experienceDetailsNoticeType = data.getExperienceDetailsNoticeType()
		}
	end)

	local v6 = useRoactService(roactNetworking)
	local v7 = useRoactService(appLinking)
	local v8 = useRoactService(appEventIngestService)
	local v9 = useRoactService(appSessionService)

	local v10 = useSelector(function(p2)
		return { screenSize = p2.ScreenSize, globalGuiInset = p2.GlobalGuiInset }
	end)

	local v11 = if not fFlagSignalsNavP3fGameDetails then useSelector(selectCurrentLegacyRoute) else nil
	local v12, state, setState

	if fFlagEnablePlayWithRewardNonPeekviewEdp then
		if
			props.playabilityStatus == nil
			or props.playabilityStatus.playabilityStatus ~= playabilityStatusEnum.Playable
		then
			v12 = false
		else
			v12 = props.playButtonState == playButtonStates.Playable
		end

		state, setState = React.useState(false)
	else
		setState = nil
	end

	local v13 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then module.getShouldHydrateLegacy() else nil

	local v14 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then module.getShouldInterleaveSdui() else nil
	local v15

	if
		fFlagEnablePlayWithRewardNonPeekviewEdp
		and fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
	then
		v15 = module10(props.universeId)
	end

	if fFlagLuaAppEdpBackendV2HydrateLegacyIxp or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		React.useEffect(function()
			IXPService:LogUserLayerExposure(appUserLayers.ExperienceDetailsPageExposureLayer)
		end, {})
	end

	local v17 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then v13 else nil
	local v18 = module4(props, v17)
	local v20 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then v13 else nil
	local v21 = module7(v20)
	local universeId

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		universeId = props.universeId
	end

	if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
		v13 = nil
	end

	local v23 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then v14 else nil
	local v24 = module5(universeId, v13, v23)

	local v25 = useDispatch()

	local v26 = useDeviceType()

	if fFlagLuaAppEdpKeepFullPageOnPortraitRotation and props.deviceType then
		v26 = props.deviceType
	end

	local v27

	if module16() and module15() then
		local v28 = useUiModeInfo()
		v27 = React.useCallback(function()
			return v24.fetchGameDetailsPageData(v6, props.universeId, v28)
		end, { v6, props.universeId, v28 })
	else
		v27 = React.useCallback(function()
			return v24.fetchGameDetailsPageData(v6, props.universeId, nil)
		end, { v6, props.universeId })
	end

	local v28 = useUserExperiment({ appUserLayers.EDPCommunityLinksLayer }, function(p2)
		return (p2[appUserLayers.EDPCommunityLinksLayer] or {}).communityLinkDisplayConfig or {}
	end, false)

	local v29 = getFFlagNotificationsForceEnableEDPDiscoverability() and true
		or useUserExperiment({ appUserLayers.ExperienceDetailsPageLayer }, function(p2): boolean
			return ((p2[appUserLayers.ExperienceDetailsPageLayer] or {})[getNotificationsExperienceDetailsVariant.getNotificationsVariantFieldName] or -1) == 2
		end, true)
	local v30

	if fFlagSongEdpCarouselIxp then
		v30 = useUserExperiment({ appUserLayers.ExperienceDetailsPageExposureLayer }, function(p2)
			return (p2[appUserLayers.ExperienceDetailsPageExposureLayer] or {}).showSongCarousel
		end, true)
	end

	local v31, v32

	if fFlagLuaAppEdpMediaGalleryRedesignIxp or fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
		v31, v32 = useUserExperiment({ appUserLayers.ExperienceDetailsPageExposureLayer }, function(p2)
			local v33 = p2[appUserLayers.ExperienceDetailsPageExposureLayer] or {}
			local mediaGalleryRedesignEnabled = if fFlagLuaAppEdpMediaGalleryRedesignIxp then v33.MediaGalleryRedesignEnabled else nil

			if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
				return mediaGalleryRedesignEnabled, v33.MediaGalleryVideoPreviewEnabled
			end

			return mediaGalleryRedesignEnabled, nil
		end, true)
	end

	local v33, v34

	if fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v33, v34 = useUserExperiment({ appUserLayers.PlayButtonUXExposureLayer }, function(p2)
			local v35 = p2[appUserLayers.PlayButtonUXExposureLayer] or {}
			return v35.HasUnifiedPlayButton, v35.UnifyToUIBlox
		end, true)
	end

	if fFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function()
			IXPService:LogUserLayerExposure(appUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	React.useEffect(function()
		v27()
	end, { props.universeId })
	local playWithRewardData, showPlayWithReward

	if fFlagEnablePlayWithRewardNonPeekviewEdp then
		local v35 = fFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable

		if v35 then
			if fFlagLuaAppEdpBackendV2SduiInterleaveDefault then
				v35 = not v15 or v15.hidePlayWithReward == true
			else
				v35 = fFlagLuaAppEdpBackendV2SduiInterleaveIxp

				if v35 then
					v35 = if v14 then not v15 or v15.hidePlayWithReward == true else v14
				end
			end
		end

		local v36 = React.useCallback(function()
			setState(false)
		end, {})
		local v38 = {
			universeId = props.universeId,
			shouldFetch = 0,
			onFetchDispatched = 0
		}

		if state then
			state = v18.gameDetailsPageDataStatus == retrievalStatus.Done and not v35
		end

		v38.shouldFetch = state

		v38.onFetchDispatched = v36
		local v39 = usePlayWithRewardData(v38)

		playWithRewardData = v39.playWithRewardData
		showPlayWithReward = v39.showPlayWithReward
	end

	local v35 = React.useCallback(function(p2, p3)
		local rootPlaceId = v18.gameDetail and v18.gameDetail.rootPlaceId
			or v18.gameInfo and v18.gameInfo.placeId

		if rootPlaceId == nil or p2 == nil then
			return
		end

		v25(module13(
			v6,
			p2,
			p3,
			v29,
			v18.notificationsEnabled and v18.notificationsEnabled.count or 0,
			v18.notificationsEnabled and v18.notificationsEnabled.limit or 0
		))

		follow(
			v8,
			"ExperienceDetailsActionBar",
			rootPlaceId,
			not p3,
			fFlagLuaAppAddUniverseIdToEngagementEvents and { universeId = p2 } or nil
		)
	end, { v25, v6, v8, props.universeId, v18 })
	local v36, v37

	if fFlagLuaAppDesktopMediaGalleryTelemetry and not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		local useCallback = React.useCallback
		local function fn(p2)
			local rootPlaceId = v18.gameDetail and v18.gameDetail.rootPlaceId
				or v18.gameInfo and v18.gameInfo.placeId

			if rootPlaceId then
				local v42 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
				mediaGalleryActivated(v8, "ExperienceDetailsPage", rootPlaceId, {
					selectedIndex = p2,
					universeId = v42
				})
			end
		end

		local v39 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
		v36 = useCallback(fn, { v8, v18, v39 })

		local useCallback2 = React.useCallback
		local function fn2(p2, p3)
			local rootPlaceId = v18.gameDetail and v18.gameDetail.rootPlaceId
				or v18.gameInfo and v18.gameInfo.placeId

			if rootPlaceId and p2 ~= p3 then
				local v44 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
				mediaGalleryMediaChanged(v8, "ExperienceDetailsPage", rootPlaceId, {
					previousIndex = p2,
					selectedIndex = p3,
					universeId = v44
				})
			end
		end

		local v41 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
		v37 = useCallback2(fn2, { v8, v18, v41 })
	end

	local v38, v39, v40

	if fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		local useCallback = React.useCallback
		local function fn(p2, p3, p4, p5)
			local rootPlaceId = v18.gameDetail and v18.gameDetail.rootPlaceId
				or v18.gameInfo and v18.gameInfo.placeId

			if rootPlaceId then
				local v45 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
				mediaGalleryMediaChanged(v8, "ExperienceDetailsPage", rootPlaceId, {
					imageAssetId = p2,
					videoAssetId = p3,
					isYouTubeVideo = p4,
					autoAdvance = p5,
					universeId = v45
				})
			end
		end

		local v42 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
		v38 = useCallback(fn, { v8, v18, v42 })

		local useCallback2 = React.useCallback
		local function fn2(p2, p3)
			local rootPlaceId = v18.gameDetail and v18.gameDetail.rootPlaceId
				or v18.gameInfo and v18.gameInfo.placeId

			if rootPlaceId then
				local v47 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
				mediaGalleryEnterFullscreen(v8, "ExperienceDetailsPage", rootPlaceId, {
					selectedIndex = p2,
					isVideo = p3,
					universeId = v47
				})
			end
		end

		local v44 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
		v39 = useCallback2(fn2, { v8, v18, v44 })

		local useCallback3 = React.useCallback
		local function fn3(p2, p3)
			local rootPlaceId = v18.gameDetail and v18.gameDetail.rootPlaceId
				or v18.gameInfo and v18.gameInfo.placeId

			if rootPlaceId then
				local v49 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
				mediaGalleryExitFullscreen(v8, "ExperienceDetailsPage", rootPlaceId, {
					selectedIndex = p2,
					isVideo = p3,
					universeId = v49
				})
			end
		end

		local v46 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then props.universeId else nil
		v40 = useCallback3(fn3, { v8, v18, v46 })
	end

	local function fn()
		local v41

		if fFlagSignalsNavP3fGameDetails then
			v41 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
		else
			v41 = v11
		end

		v21.navigateBack()

		if not (hasPageInCurrentRoute(v41, appPage.GameDetail, true) or hasPageInCurrentRoute(v41, appPage.ExperienceDetail, true)) then
			v9:RemoveSession(sessionType.StructuralIdentifier.GameDetailSource)
		end
	end

	local v43 = React.useCallback(fn, { v21, if not fFlagSignalsNavP3fGameDetails then v11 else nil })

	local screenSize = v10.screenSize

	local safeZoneOffsets = GuiService:GetSafeZoneOffsets()

	local offset = getSafeAreaSize(screenSize, safeZoneOffsets).Y.Offset

	local udim = UDim2.new(1, 0, 1, 0)

	if v5.roundedCorners then
		udim = UDim2.new(1, 0, 1, 0)
	end

	local creator = v18.gameDetail and v18.gameDetail.creator
	local v44 = if module14() then creator and creator.hasVerifiedBadge else v18.creatorVerified

	local v45 = module9()

	local v46 = module6()

	local ref = React.useRef(nil)
	local v47 = React.useCallback(function()
		if ref.current then
			GuiService.SelectedCoreObject = getFirstFocusableDescendant(ref.current)
		end
	end, {})
	local v48, v49 = module8(React.useCallback(function(p2)
		props.onPlayButtonActivated()
	end, { props.onPlayButtonActivated }), v47)

	local createElement = React.createElement
	local v51 = {
		ref = v48,
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, safeZoneOffsets.top),
		Size = udim,
		BackgroundTransparency = 1,
		ClipsDescendants = not fFlagExtendScrollingFramesBySafeInsets
	}

	local v52 = { ExperienceDetailsPage = 0, NavigationEvents = 0 }
	local createElement2 = React.createElement
	local experienceDetailsPage = props.ExperienceDetailsPage or module11
	local v53 = {}
	v53.universeId = props.universeId
	v53.referralSource = props.referralSource

	local v54 = if fFlagLuaAppUnifyPlayButtonNonMobileEdp or fFlagEnablePlayWithRewardNonPeekviewEdp then props.experienceJoinData else nil
	v53.experienceJoinData = v54

	v53.placeIdOverride = props.placeIdOverride
	v53.onClose = v43
	v53.statsAndInfoRef = ref

	v53.thumbnail = v18.thumbnail
	v53.bannerImageId = v18.bannerImageId
	local v55 = if fFlagLuaAppEdpFixDefaultBanner then v18.defaultBannerUrl else nil
	v53.defaultBannerUrl = v55
	v53.gameInfo = v18.gameInfo
	v53.gameDetail = v18.gameDetail
	v53.gameDetailError = v18.gameDetailError
	v53.creatorVerified = v44
	v53.gameDetailsPageDataStatus = v18.gameDetailsPageDataStatus
	v53.gameProductInfo = v18.gameProductInfo
	v53.socialLinks = v18.socialLinks
	v53.ageRecommendations = v18.ageRecommendations
	v53.communityLink = v18.communityLink
	v53.communityLinksEnabled = v28.inTreatment
	v53.communityLinkVariant = v28.linkVariant
	v53.gameFollowings = v18.gameFollowings
	v53.enableNotificationsDiscoverability = v29

	if not fFlagLuaAppEdpMediaGalleryRedesignIxp then
		v31 = nil
	end

	v53.mediaGalleryRedesignEnabledIxp = v31

	if not fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
		v32 = nil
	end

	v53.mediaGalleryVideoPreviewEnabledIxp = v32

	if not fFlagSongEdpCarouselIxp then
		v30 = nil
	end

	v53.showSongCarousel = v30

	if not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v33 = nil
	end

	v53.hasUnifiedPlayButtonIxp = v33

	if not fFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v34 = nil
	end

	v53.unifyToUIBloxIxp = v34

	v53.fetchGameDetailsPageData = v27

	v53.openLeaveRobloxAlertUIBlox = v21.openLeaveRobloxAlertUIBlox
	v53.openVerifiedBadgeModal = v21.openVerifiedBadgeModal
	v53.closeAlert = v21.closeAlert
	v53.openMoreContextualMenu = v21.openMoreContextualMenu
	v53.openShareContextualMenu = v21.openShareContextualMenu

	local v56 = if not module17 then v21.openCreatorPage else nil
	v53.openCreatorPage = v56

	local v57 = if module17 then v21.openCommunityProfilePage else nil
	v53.openCommunityProfilePage = v57

	local v58 = if module17 then v21.openUserProfilePage else nil
	v53.openUserProfilePage = v58

	v53.openExperienceGuidelinesExplained = v21.openExperienceGuidelinesExplained
	v53.setControllerBarNavigation = v49
	v53.playabilityStatus = props.playabilityStatus
	v53.playButtonState = props.playButtonState
	v53.secondaryPlayButtonState = props.secondaryPlayButtonState
	v53.onPlayButtonActivated = props.onPlayButtonActivated
	local v59 = if getFFlagIsSquadEnabled() then props.onPlaySquadButtonActivated else nil
	v53.onPlaySquadButtonActivated = v59
	v53.playButtonContextualMessage = props.playButtonContextualMessage

	if not v29 then
		v35 = nil
	end

	v53.toggleFollowExperience = v35

	if not fFlagLuaAppDesktopMediaGalleryTelemetry or fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v36 = nil
	end

	v53.onMediaGalleryPreviewActivated = v36

	if not fFlagLuaAppDesktopMediaGalleryTelemetry or fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v37 = nil
	end

	v53.onMediaGalleryThumbnailActivated = v37

	if not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v38 = nil
	end

	v53.onMediaGalleryMediaChanged = v38

	if not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v39 = nil
	end

	v53.onMediaGalleryEnterFullscreen = v39

	if not fFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v40 = nil
	end

	v53.onMediaGalleryExitFullscreen = v40

	v53.openRefundPolicyLearnMorePage = v21.openRefundPolicyLearnMorePage
	v53.openWebview = v21.openWebview

	v53.linking = v7

	v53.deviceType = v26
	v53.viewHeight = offset

	v53.detailsPageConfiguration = v45
	v53.tokens = v46

	v53.webViewSupport = v5.webViewSupport
	v53.notificationsCanEnableExperience = v5.notificationsCanEnableExperience
	v53.experienceDetailsNoticeType = v5.experienceDetailsNoticeType

	if not fFlagEnablePlayWithRewardNonPeekviewEdp then
		playWithRewardData = nil
	end

	v53.playWithRewardData = playWithRewardData

	if not fFlagEnablePlayWithRewardNonPeekviewEdp then
		showPlayWithReward = nil
	end

	v53.showPlayWithReward = showPlayWithReward

	if not fFlagEnablePlayWithRewardNonPeekviewEdp then
		v12 = nil
	end

	v53.isPlayable = v12
	v52.ExperienceDetailsPage = createElement2(experienceDetailsPage, v53)
	local v60

	if fFlagEnablePlayWithRewardNonPeekviewEdp then
		v60 = React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = function()
				setState(true)
			end
		})
	end

	v52.NavigationEvents = v60
	return createElement("Frame", v51, v52)
end

return (module12.connect(function(data)
	local v5 = {
		universeId = data.universeId,
		launchSource = "ExperienceDetailsPage",
		referralSource = data.referralSource,
		extraParams = 0,
		placeId = 0,
		shouldReportLoadingDurationTelemetry = 0
	}
	local v6 = if data.experienceJoinData then data.experienceJoinData else nil
	v5.extraParams = v6
	v5.placeId = data.placeIdOverride
	v5.shouldReportLoadingDurationTelemetry = fFlagLuaAppPlayButtonLoadingDurationTelemetry and true or nil
	return v5
end, function(data, p2)
	local v5 = {
		playabilityStatus = data.playabilityStatus,
		playButtonState = data.playButtonState,
		secondaryPlayButtonState = data.secondaryPlayButtonState,
		onPlayButtonActivated = data.onPlayButtonActivated,
		onPlaySquadButtonActivated = 0,
		playButtonContextualMessage = 0
	}
	local v6 = if getFFlagIsSquadEnabled() then data.onPlaySquadButtonActivated else nil
	v5.onPlaySquadButtonActivated = v6

	v5.playButtonContextualMessage = data.playButtonContextualMessage
	return v5
end)(ExperienceDetailsContainer))
