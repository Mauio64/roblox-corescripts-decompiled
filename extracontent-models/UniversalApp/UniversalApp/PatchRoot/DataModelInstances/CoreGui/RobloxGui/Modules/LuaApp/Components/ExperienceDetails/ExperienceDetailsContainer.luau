local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local getFirstFocusableDescendant = require(CorePackages.Workspace.Packages.FocusNavigationUtils).getFirstFocusableDescendant
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local React = require(CorePackages.Packages.React)
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment

require(CorePackages.Workspace.Packages.PlayabilityRodux)

local PlayabilityStatusEnum = require(CorePackages.Workspace.Packages.DiscoveryTypes).PlayabilityStatusEnum
local PlayButtonStates = require(CorePackages.Workspace.Packages.GamePlayButton).PlayButtonStates
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local usePlayWithRewardData = require(CorePackages.Workspace.Packages.PlayWithRewardComponent).usePlayWithRewardData
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ExperienceDetailsExperimentation = require(script.Parent.ExperienceDetailsExperimentation)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local useDeviceType = RobloxAppHooks.useDeviceType
local useRoactService = RobloxAppHooks.useRoactService
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local hasPageInCurrentRoute = require(CorePackages.Workspace.Packages.DiscoveryRouting).hasPageInCurrentRoute
local selectCurrentLegacyRoute = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors.selectCurrentLegacyRoute
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local GameDetailsEvents = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents
local Follow = GameDetailsEvents.Follow
local MediaGalleryActivated = GameDetailsEvents.MediaGalleryActivated
local MediaGalleryMediaChanged = GameDetailsEvents.MediaGalleryMediaChanged
local MediaGalleryEnterFullscreen = GameDetailsEvents.MediaGalleryEnterFullscreen
local MediaGalleryExitFullscreen = GameDetailsEvents.MediaGalleryExitFullscreen
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useExperienceDetailsState = require(script.Parent.useExperienceDetailsState)
local useExperienceDetailsFetches = require(script.Parent.useExperienceDetailsFetches)
local useExperienceDetailsDesignTokens = require(script.Parent.Hooks.useExperienceDetailsDesignTokens)
local useExperienceDetailsNavigation = require(script.Parent.useExperienceDetailsNavigation)
local useExperienceDetailsFocusNavigationBindings = require(script.Parent.useExperienceDetailsFocusNavigationBindings)
local useExperienceDetailsConfiguration = require(script.Parent.useExperienceDetailsConfiguration)
local useEdpPerUniverseVisibilityVariablesForUniverse = require(Modules.LuaApp.Components.ExperienceDetails.Hooks.useEdpPerUniverseVisibilityVariablesForUniverse)
local ExperienceDetailsPage = require(Modules.LuaApp.Components.ExperienceDetails.ExperienceDetailsPage)
local LaunchExperienceConnector = require(Modules.LuaApp.Common.Experience.Connectors.LaunchExperienceConnector)
local SendGameFollow = require(Modules.LuaApp.Thunks.SendGameFollow)
local GetFFlagRemoveVerifiedBadgeReducer = require(Modules.LuaApp.Flags.GetFFlagRemoveVerifiedBadgeReducer)
local GetFFlagLuaAppLaunchConnectorFix = require(Modules.LuaApp.Flags.GetFFlagLuaAppLaunchConnectorFix)
local GetFFlagEnableBigGameIconInDetailsPage = require(Modules.LuaApp.Flags.GetFFlagEnableBigGameIconInDetailsPage)
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable
local GetNotificationsExperienceDetailsVariant = require(CorePackages.Workspace.Packages.SharedFlags).GetNotificationsExperienceDetailsVariant
local FFlagLuaAppEnablePlaySquadButton = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnablePlaySquadButton
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local GetFFlagNotificationsForceEnableEDPDiscoverability = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagNotificationsForceEnableEDPDiscoverability
local FFlagLuaAppDesktopMediaGalleryTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDesktopMediaGalleryTelemetry
local FFlagLuaAppEdpFixDefaultBanner = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpFixDefaultBanner
local FFlagLuaAppEdpMediaGalleryRedesignIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignIxp
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local FFlagSongEdpCarouselIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSongEdpCarouselIxp
local FFlagEnableCreatorSubtitleNavigation = require(Modules.LuaApp.Flags.FFlagEnableCreatorSubtitleNavigation)
local FFlagLuaAppEdpMediaGalleryRedesignTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignTelemetry
local FFlagLuaAppUnifyPlayButtonNonMobileEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUnifyPlayButtonNonMobileEdp
local FFlagLuaAppUnifyPlayButtonAllSurfacesIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUnifyPlayButtonAllSurfacesIxp
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents
local FFlagExtendScrollingFramesBySafeInsets = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExtendScrollingFramesBySafeInsets
local FFlagEnablePlayWithRewardNonPeekviewEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePlayWithRewardNonPeekviewEdp
local FFlagLuaAppEdpKeepFullPageOnPortraitRotation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpKeepFullPageOnPortraitRotation
local FFlagLuaAppLogExposurePlayButtonUX = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppLogExposurePlayButtonUX

local function ExperienceDetailsContainer(t1: {[any]: any}) -- line: 130
	-- upvalues: useAppPolicy (copy), useRoactService (copy), RoactNetworking (copy), AppLinking (copy), AppEventIngestService (copy), AppSessionService (copy), useSelector (copy), selectCurrentLegacyRoute (copy), FFlagEnablePlayWithRewardNonPeekviewEdp (copy), PlayabilityStatusEnum (copy), PlayButtonStates (copy), React (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ExperienceDetailsExperimentation (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable (copy), useEdpPerUniverseVisibilityVariablesForUniverse (copy), IXPService (copy), AppUserLayers (copy), useExperienceDetailsState (copy), useExperienceDetailsNavigation (copy), useExperienceDetailsFetches (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), useDispatch (copy), useDeviceType (copy), FFlagLuaAppEdpKeepFullPageOnPortraitRotation (copy), GetFFlagEnableBigGameIconInDetailsPage (copy), GetFFlagLuaAppLaunchConnectorFix (copy), useUiModeInfo (copy), useUserExperiment (copy), GetFFlagNotificationsForceEnableEDPDiscoverability (copy), GetNotificationsExperienceDetailsVariant (copy), FFlagSongEdpCarouselIxp (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), FFlagLuaAppUnifyPlayButtonAllSurfacesIxp (copy), FFlagLuaAppLogExposurePlayButtonUX (copy), usePlayWithRewardData (copy), RetrievalStatus (copy), SendGameFollow (copy), Follow (copy), FFlagLuaAppDesktopMediaGalleryTelemetry (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), MediaGalleryActivated (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), MediaGalleryMediaChanged (copy), MediaGalleryEnterFullscreen (copy), MediaGalleryExitFullscreen (copy), hasPageInCurrentRoute (copy), AppPage (copy), SessionType (copy), GuiService (copy), getSafeAreaSize (copy), GetFFlagRemoveVerifiedBadgeReducer (copy), useExperienceDetailsConfiguration (copy), useExperienceDetailsDesignTokens (copy), getFirstFocusableDescendant (copy), useExperienceDetailsFocusNavigationBindings (copy), FFlagExtendScrollingFramesBySafeInsets (copy), ExperienceDetailsPage (copy), FFlagLuaAppUnifyPlayButtonNonMobileEdp (copy), FFlagLuaAppEdpFixDefaultBanner (copy), FFlagEnableCreatorSubtitleNavigation (copy), FFlagLuaAppEnablePlaySquadButton (copy), RoactNavigation (copy)
	local v74 = useAppPolicy(function(p1) -- line: 132
		return {
			roundedCorners = p1.getUseRoundedCorners(),
			webViewSupport = p1.getWebViewSupport(),
			notificationsCanEnableExperience = p1.getNotificationsCanReceiveExperience(),
			experienceDetailsNoticeType = p1.getExperienceDetailsNoticeType()
		}
	end)
	local v75 = useRoactService(RoactNetworking)
	local v76 = useRoactService(AppLinking)
	local v77 = useRoactService(AppEventIngestService)
	local v78 = useRoactService(AppSessionService)
	local v79 = useSelector(function(p2) -- line: 148
		return {
			screenSize = p2.ScreenSize,
			globalGuiInset = p2.GlobalGuiInset
		}
	end)
	local v80 = useSelector(selectCurrentLegacyRoute)
	local v81 = nil
	local v82 = nil
	local u83 = nil

	if FFlagEnablePlayWithRewardNonPeekviewEdp then
		v81 = t1.playabilityStatus ~= nil and (t1.playabilityStatus.playabilityStatus == PlayabilityStatusEnum.Playable and t1.playButtonState == PlayButtonStates.Playable)

		local v84

		v82, v84 = React.useState(false)
		u83 = v84
	end

	local v85 = nil

	if FFlagLuaAppEdpBackendV2HydrateLegacyIxp then
		v85 = ExperienceDetailsExperimentation.getShouldHydrateLegacy()
	end

	local v86 = nil

	if FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		v86 = ExperienceDetailsExperimentation.getShouldInterleaveSdui()
	end

	local v87 = if not FFlagEnablePlayWithRewardNonPeekviewEdp or not FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable then nil else useEdpPerUniverseVisibilityVariablesForUniverse(t1.universeId)

	if FFlagLuaAppEdpBackendV2HydrateLegacyIxp or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		React.useEffect(function() -- line: 180
			-- upvalues: IXPService (copy), AppUserLayers (copy)
			IXPService:LogUserLayerExposure(AppUserLayers.ExperienceDetailsPageExposureLayer)
		end, {})
	end

	local v88 = useExperienceDetailsState(t1, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else v85)
	local v89 = useExperienceDetailsNavigation(if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else v85)
	local v90 = useExperienceDetailsFetches(if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else t1.universeId, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else v85, if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else v86)
	local v91 = useDispatch()
	local v92 = useDeviceType()
	local v93 = if not FFlagLuaAppEdpKeepFullPageOnPortraitRotation or not t1.deviceType then v92 else t1.deviceType
	local u95

	if GetFFlagEnableBigGameIconInDetailsPage() and GetFFlagLuaAppLaunchConnectorFix() then
		local v94 = useUiModeInfo()

		u95 = React.useCallback(function() -- line: 211
			-- upvalues: v90 (copy), v75 (copy), t1 (copy), v94 (copy)
			return v90.fetchGameDetailsPageData(v75, t1.universeId, v94)
		end, {
			v75,
			t1.universeId,
			v94
		})
	else
		u95 = React.useCallback(function() -- line: 215
			-- upvalues: v90 (copy), v75 (copy), t1 (copy)
			return v90.fetchGameDetailsPageData(v75, t1.universeId, nil)
		end, {
			v75,
			t1.universeId
		})
	end

	local v96 = useUserExperiment({ AppUserLayers.EDPCommunityLinksLayer }, function(p3) -- line: 222
		-- upvalues: AppUserLayers (copy)
		return (p3[AppUserLayers.EDPCommunityLinksLayer] or {}).communityLinkDisplayConfig or {}
	end, false)
	local v97 = not not GetFFlagNotificationsForceEnableEDPDiscoverability() or useUserExperiment({ AppUserLayers.ExperienceDetailsPageLayer }, function(p4) -- line: 231
		-- upvalues: AppUserLayers (copy), GetNotificationsExperienceDetailsVariant (copy)
		return ((p4[AppUserLayers.ExperienceDetailsPageLayer] or {})[GetNotificationsExperienceDetailsVariant.getNotificationsVariantFieldName] or -1) == 2
	end, true)
	local v98 = nil

	if FFlagSongEdpCarouselIxp then
		v98 = useUserExperiment({ AppUserLayers.ExperienceDetailsPageExposureLayer }, function(p5) -- line: 242
			-- upvalues: AppUserLayers (copy)
			return (p5[AppUserLayers.ExperienceDetailsPageExposureLayer] or {}).showSongCarousel
		end, true)
	end

	local v99 = nil
	local v100 = nil

	if FFlagLuaAppEdpMediaGalleryRedesignIxp or FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
		v99, v100 = useUserExperiment({ AppUserLayers.ExperienceDetailsPageExposureLayer }, function(p6) -- line: 254
			-- upvalues: AppUserLayers (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy)
			local v137 = p6[AppUserLayers.ExperienceDetailsPageExposureLayer] or {}
			local v138 = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else v137.MediaGalleryRedesignEnabled

			if FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
				return v138, v137.MediaGalleryVideoPreviewEnabled
			end

			return v138, nil
		end, true)
	end

	local v101 = nil
	local v102 = nil

	if FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then
		v101, v102 = useUserExperiment({ AppUserLayers.PlayButtonUXExposureLayer }, function(p7) -- line: 267
			-- upvalues: AppUserLayers (copy)
			local v140 = p7[AppUserLayers.PlayButtonUXExposureLayer] or {}

			return v140.HasUnifiedPlayButton, v140.UnifyToUIBlox
		end, true)
	end

	if FFlagLuaAppLogExposurePlayButtonUX then
		React.useEffect(function() -- line: 276
			-- upvalues: IXPService (copy), AppUserLayers (copy)
			IXPService:LogUserLayerExposure(AppUserLayers.PlayButtonUXExposureLayer)
		end, {})
	end

	React.useEffect(function() -- line: 281
		-- upvalues: u95 (ref)
		u95()
	end, { t1.universeId })

	local playWithRewardData = nil
	local showPlayWithReward = nil

	if FFlagEnablePlayWithRewardNonPeekviewEdp then
		local v105 = FFlagLuaAppEdpUseHidePlayWithRewardVisibilityVariable and ((FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and v86) and (v87 and v87.hidePlayWithReward == true))
		local v106 = React.useCallback(function() -- line: 292
			-- upvalues: u83 (ref)
			u83(false)
		end, {})
		local v107 = usePlayWithRewardData({
			universeId = t1.universeId,
			shouldFetch = v82 and (v88.gameDetailsPageDataStatus == RetrievalStatus.Done and not v105),
			onFetchDispatched = v106
		})

		playWithRewardData = v107.playWithRewardData
		showPlayWithReward = v107.showPlayWithReward
	end

	local v108 = React.useCallback(function(p8, p9) -- line: 306
		-- upvalues: v88 (copy), v91 (copy), SendGameFollow (copy), v75 (copy), v97 (copy), Follow (copy), v77 (copy)
		local v143 = v88.gameDetail and v88.gameDetail.rootPlaceId or v88.gameInfo and v88.gameInfo.placeId

		if v143 == nil or p8 == nil then
			return
		end

		local v144 = v88.notificationsEnabled and v88.notificationsEnabled.count or 0
		local v145 = v88.notificationsEnabled and v88.notificationsEnabled.limit or 0

		v91(SendGameFollow(v75, p8, p9, v97, v144, v145))
		Follow(v77, "ExperienceDetailsActionBar", v143, not p9)
	end, {
		v91,
		v75,
		v77,
		t1.universeId,
		v88
	})
	local v109 = nil
	local v110 = nil

	if FFlagLuaAppDesktopMediaGalleryTelemetry and not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v109 = React.useCallback(function(p10) -- line: 336
			-- upvalues: v88 (copy), MediaGalleryActivated (copy), v77 (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), t1 (copy)
			local v147 = v88.gameDetail and v88.gameDetail.rootPlaceId or v88.gameInfo and v88.gameInfo.placeId

			if v147 then
				MediaGalleryActivated(v77, "ExperienceDetailsPage", v147, {
					selectedIndex = p10,
					universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
				})
			end
		end, {
			v77,
			v88,
			if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
		})
		v110 = React.useCallback(function(p11, p12) -- line: 355
			-- upvalues: v88 (copy), MediaGalleryMediaChanged (copy), v77 (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), t1 (copy)
			local v150 = v88.gameDetail and v88.gameDetail.rootPlaceId or v88.gameInfo and v88.gameInfo.placeId

			if v150 and p11 ~= p12 then
				MediaGalleryMediaChanged(v77, "ExperienceDetailsPage", v150, {
					previousIndex = p11,
					selectedIndex = p12,
					universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
				})
			end
		end, {
			v77,
			v88,
			if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
		})
	end

	local v111 = nil
	local v112 = nil
	local v113 = nil

	if FFlagLuaAppEdpMediaGalleryRedesignTelemetry then
		v111 = React.useCallback(function(p13, p14, p15, p16) -- line: 381
			-- upvalues: v88 (copy), MediaGalleryMediaChanged (copy), v77 (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), t1 (copy)
			local v155 = v88.gameDetail and v88.gameDetail.rootPlaceId or v88.gameInfo and v88.gameInfo.placeId

			if v155 then
				MediaGalleryMediaChanged(v77, "ExperienceDetailsPage", v155, {
					imageAssetId = p13,
					videoAssetId = p14,
					isYouTubeVideo = p15,
					autoAdvance = p16,
					universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
				})
			end
		end, {
			v77,
			v88,
			if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
		})
		v112 = React.useCallback(function(p17, p18) -- line: 403
			-- upvalues: v88 (copy), MediaGalleryEnterFullscreen (copy), v77 (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), t1 (copy)
			local v158 = v88.gameDetail and v88.gameDetail.rootPlaceId or v88.gameInfo and v88.gameInfo.placeId

			if v158 then
				MediaGalleryEnterFullscreen(v77, "ExperienceDetailsPage", v158, {
					selectedIndex = p17,
					isVideo = p18,
					universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
				})
			end
		end, {
			v77,
			v88,
			if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
		})
		v113 = React.useCallback(function(p19, p20) -- line: 423
			-- upvalues: v88 (copy), MediaGalleryExitFullscreen (copy), v77 (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), t1 (copy)
			local v161 = v88.gameDetail and v88.gameDetail.rootPlaceId or v88.gameInfo and v88.gameInfo.placeId

			if v161 then
				MediaGalleryExitFullscreen(v77, "ExperienceDetailsPage", v161, {
					selectedIndex = p19,
					isVideo = p20,
					universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
				})
			end
		end, {
			v77,
			v88,
			if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t1.universeId
		})
	end

	local v114 = React.useCallback(function() -- line: 443
		-- upvalues: v89 (copy), hasPageInCurrentRoute (copy), v80 (copy), AppPage (copy), v78 (copy), SessionType (copy)
		v89.navigateBack()

		if not hasPageInCurrentRoute(v80, AppPage.GameDetail, true) and not hasPageInCurrentRoute(v80, AppPage.ExperienceDetail, true) then
			v78:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
		end
	end, {
		v89,
		v80
	})
	local screenSize = v79.screenSize
	local SafeZoneOffsets = GuiService:GetSafeZoneOffsets()
	local YOffset = getSafeAreaSize(screenSize, SafeZoneOffsets).Y.Offset
	local uDim2 = UDim2.new(1, 0, 1, 0)

	if v74.roundedCorners then
		uDim2 = UDim2.new(1, 0, 1, 0)
	end

	local v119 = v88.gameDetail and v88.gameDetail.creator
	local v120 = if not GetFFlagRemoveVerifiedBadgeReducer() then v88.creatorVerified else v119 and v119.hasVerifiedBadge
	local v121 = useExperienceDetailsConfiguration()
	local v122 = useExperienceDetailsDesignTokens()
	local v123 = React.useRef(nil)
	local v124 = React.useCallback(function() -- line: 479
		-- upvalues: v123 (copy), GuiService (copy), getFirstFocusableDescendant (copy)
		if v123.current then
			GuiService.SelectedCoreObject = getFirstFocusableDescendant(v123.current)
		end
	end, {})
	local v125 = React.useCallback(function(_) -- line: 489
		-- upvalues: t1 (copy)
		t1.onPlayButtonActivated()
	end, { t1.onPlayButtonActivated })
	local v126, v127 = useExperienceDetailsFocusNavigationBindings(v125, v124)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v126,
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, SafeZoneOffsets.top),
		Size = uDim2,
		ClipsDescendants = not FFlagExtendScrollingFramesBySafeInsets
	}, {
		ExperienceDetailsPage = React.createElement(t1.ExperienceDetailsPage or ExperienceDetailsPage, {
			universeId = t1.universeId,
			referralSource = t1.referralSource,
			experienceJoinData = if not FFlagLuaAppUnifyPlayButtonNonMobileEdp and not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else t1.experienceJoinData,
			placeIdOverride = t1.placeIdOverride,
			onClose = v114,
			statsAndInfoRef = v123,
			thumbnail = v88.thumbnail,
			bannerImageId = v88.bannerImageId,
			defaultBannerUrl = if not FFlagLuaAppEdpFixDefaultBanner then nil else v88.defaultBannerUrl,
			gameInfo = v88.gameInfo,
			gameDetail = v88.gameDetail,
			gameDetailError = v88.gameDetailError,
			creatorVerified = v120,
			gameDetailsPageDataStatus = v88.gameDetailsPageDataStatus,
			gameProductInfo = v88.gameProductInfo,
			socialLinks = v88.socialLinks,
			ageRecommendations = v88.ageRecommendations,
			communityLink = v88.communityLink,
			communityLinksEnabled = v96.inTreatment,
			communityLinkVariant = v96.linkVariant,
			gameFollowings = v88.gameFollowings,
			enableNotificationsDiscoverability = v97,
			mediaGalleryRedesignEnabledIxp = if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else v99,
			mediaGalleryVideoPreviewEnabledIxp = if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else v100,
			showSongCarousel = if not FFlagSongEdpCarouselIxp then nil else v98,
			hasUnifiedPlayButtonIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else v101,
			unifyToUIBloxIxp = if not FFlagLuaAppUnifyPlayButtonAllSurfacesIxp then nil else v102,
			fetchGameDetailsPageData = u95,
			openLeaveRobloxAlertUIBlox = v89.openLeaveRobloxAlertUIBlox,
			openVerifiedBadgeModal = v89.openVerifiedBadgeModal,
			closeAlert = v89.closeAlert,
			openMoreContextualMenu = v89.openMoreContextualMenu,
			openShareContextualMenu = v89.openShareContextualMenu,
			openCreatorPage = if not FFlagEnableCreatorSubtitleNavigation then v89.openCreatorPage else nil,
			openCommunityProfilePage = if not FFlagEnableCreatorSubtitleNavigation then nil else v89.openCommunityProfilePage,
			openUserProfilePage = if not FFlagEnableCreatorSubtitleNavigation then nil else v89.openUserProfilePage,
			openExperienceGuidelinesExplained = v89.openExperienceGuidelinesExplained,
			setControllerBarNavigation = v127,
			playabilityStatus = t1.playabilityStatus,
			playButtonState = t1.playButtonState,
			onPlayButtonActivated = t1.onPlayButtonActivated,
			onPlaySquadButtonActivated = if not FFlagLuaAppEnablePlaySquadButton then nil else t1.onPlaySquadButtonActivated,
			playButtonContextualMessage = t1.playButtonContextualMessage,
			toggleFollowExperience = if not v97 then nil else v108,
			onMediaGalleryPreviewActivated = if not FFlagLuaAppDesktopMediaGalleryTelemetry or FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else v109,
			onMediaGalleryThumbnailActivated = if not FFlagLuaAppDesktopMediaGalleryTelemetry or FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else v110,
			onMediaGalleryMediaChanged = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else v111,
			onMediaGalleryEnterFullscreen = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else v112,
			onMediaGalleryExitFullscreen = if not FFlagLuaAppEdpMediaGalleryRedesignTelemetry then nil else v113,
			openRefundPolicyLearnMorePage = v89.openRefundPolicyLearnMorePage,
			openWebview = v89.openWebview,
			linking = v76,
			deviceType = v93,
			viewHeight = YOffset,
			detailsPageConfiguration = v121,
			tokens = v122,
			webViewSupport = v74.webViewSupport,
			notificationsCanEnableExperience = v74.notificationsCanEnableExperience,
			experienceDetailsNoticeType = v74.experienceDetailsNoticeType,
			playWithRewardData = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else playWithRewardData,
			showPlayWithReward = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else showPlayWithReward,
			isPlayable = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else v81
		}),
		NavigationEvents = if not FFlagEnablePlayWithRewardNonPeekviewEdp then nil else React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = function() -- line: 608
				-- upvalues: u83 (ref)
				u83(true)
			end
		})
	})
end

return (LaunchExperienceConnector.connect(function(p22) -- line: 616
	-- upvalues: FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy)
	return {
		launchSource = "ExperienceDetailsPage",
		universeId = p22.universeId,
		referralSource = p22.referralSource,
		extraParams = if not p22.experienceJoinData then nil else p22.experienceJoinData,
		placeId = p22.placeIdOverride,
		shouldReportLoadingDurationTelemetry = not not FFlagLuaAppPlayButtonLoadingDurationTelemetry or nil
	}
end, function(p23, _) -- line: 625
	-- upvalues: FFlagLuaAppEnablePlaySquadButton (copy)
	return {
		playabilityStatus = p23.playabilityStatus,
		playButtonState = p23.playButtonState,
		onPlayButtonActivated = p23.onPlayButtonActivated,
		onPlaySquadButtonActivated = if not FFlagLuaAppEnablePlaySquadButton then nil else p23.onPlaySquadButtonActivated,
		playButtonContextualMessage = p23.playButtonContextualMessage
	}
end)(ExperienceDetailsContainer))
