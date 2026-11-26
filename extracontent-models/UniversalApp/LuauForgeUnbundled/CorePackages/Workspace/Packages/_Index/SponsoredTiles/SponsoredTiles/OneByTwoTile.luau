local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GameTile")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Responsive")
local image = Foundation.Image
local buttonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local playButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GamePlayButton").PlayButton
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Localization").Hooks.useLocalization
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryTypes")
local omniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local gameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/GameHydrationReact")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Navigation").useNavigation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppEnums").AppPage
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RoactServiceTags")
local roactNetworking = RoactServiceTags.RoactNetworking
local appSessionService = RoactServiceTags.AppSessionService
local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/RobloxAppSessionization")
local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryAnalytics")
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local SponsoredTilesTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SponsoredTilesTelemetry")
local oneByTwoTileTelemetry = SponsoredTilesTelemetry.OneByTwoTileTelemetry
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/DiscoveryUtils").DiscoveryEventErrorLogger
require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/types")
local openAdClickoutUrl = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/openAdClickoutUrl")

local VideoPlayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/VideoPlayer")
local videoDisplay = VideoPlayer.VideoDisplay
local videoLoadingState = VideoPlayer.VideoLoadingState

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/VideoUtils")
local videoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local videoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local videoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate
local AdsViewportAutoplayCandidateTag = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/AdsViewportAutoplayCandidateTag")
local useTagAsAdsViewportAutoplayCandidate = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/useTagAsAdsViewportAutoplayCandidate")
local getPlaybackDetectionMethod = VideoUtils.getPlaybackDetectionMethod
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local videoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason

local useTagAsSponsoredAdViewabilityCandidate = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SponsoredAdViewability").useTagAsSponsoredAdViewabilityCandidate
local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/Impressions").ImpressionsTagUtility

local useIsHoveredTile = GameTile.useIsHoveredTile
local useValidTileBadges = GameTile.useValidTileBadges
local gameTileThumbnailBadges = GameTile.GameTileThumbnailBadges
local hoverTileCoordinator = GameTile.HoverTileCoordinator
local tileVideoBlockingConfig = GameTile.TileVideoBlockingConfig
local getAvailableGameTileOverflowMenuItems = GameTile.getAvailableGameTileOverflowMenuItems
local SpanTileOverflowMenu = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/SpanTileOverflowMenu/SpanTileOverflowMenu")

local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/AppBlox")
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/InteractionFeedback").useTriggerFeedback

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/SharedFlags")
local fFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
local fFlagLuaAppFeatureTileHapticsFix = SharedFlags.FFlagLuaAppFeatureTileHapticsFix
local fIntLuaAppGameTileVideoDwellTimeInSec = SharedFlags.FIntLuaAppGameTileVideoDwellTimeInSec
local fIntLuaAppGameTileVideoVisiblePercent = SharedFlags.FIntLuaAppGameTileVideoVisiblePercent
local fFlagLuaAppGameTileSelectionVideoPlayback = SharedFlags.FFlagLuaAppGameTileSelectionVideoPlayback
local fFlagLuaAppSuppressVideoDetectorDuringScroll = SharedFlags.FFlagLuaAppSuppressVideoDetectorDuringScroll

local fFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll = SharedFlags.FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll
local fFlagLuaAppSduiSponsoredOneByTwoTile = SharedFlags.FFlagLuaAppSduiSponsoredOneByTwoTile
local fFlagLuaAppAdClickoutDeeplink = SharedFlags.FFlagLuaAppAdClickoutDeeplink
local fFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay

local fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = SharedFlags.FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback
local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = SharedFlags.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local FFlagLuaAppSponsoredTileBadgeContentPadding = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/Flags/FFlagLuaAppSponsoredTileBadgeContentPadding")
local FFlagLuaAppAdClickoutEvent = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/Flags/FFlagLuaAppAdClickoutEvent")

local defineFastInt = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentLandscape", 40)
local defineFastInt2 = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentSquare", 25)

local defineFastInt3 = game:DefineFastInt("LuaAppOneByTwoTileGradientBottomTransparencyPercent", 25)

local defineFastInt4 = game:DefineFastInt("LuaAppOneByTwoTileGradientTopTransparencyPercent", 100)

local defineFastInt5 = game:DefineFastInt("LuaAppOneByTwoTileGradientBottomHeightPercent", 50)

local v5 = defineFastInt / 100
local v6 = defineFastInt2 / 100
local v7 = fFlagLuaAppFeatureTileHapticsFix and "TileLongPress" or "OneByTwoTileLongPress"
local v8 = defineFastInt3 / 100
local v9 = defineFastInt4 / 100
local v10 = defineFastInt5 / 100

local function getTextOrDefault(p2, p3)
	if p2 ~= nil and p2 ~= "" then
		return p2
	end

	if p3 == nil or p3 == "" then
		return nil
	end

	return p3
end

local function OneByTwoTile(props)
	local v11 = useTokens()
	local v12 = Responsive.useResponsive({ Responsive.BreakpointConfig.sizes.Small }) == Responsive.Keys.Small

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local hoverKey = props.hoverKey
	local v13 = Responsive.useLastInput() ~= Responsive.Input.Touch
	local v14 = useIsHoveredTile(ref, hoverKey, v13)
	local v15 = Responsive.usePreferredInput()

	local v16 = not (props.adId == nil) and props.adId ~= ""
	local v17 = props.contentType == omniRecommendationsContentType.AdLink

	if v17 then
		local v18 = props.clickoutUrl ~= nil and props.clickoutUrl ~= ""
		assert(v18, "OneByTwoTile AdLink requires clickoutUrl")
	else
		local v18 = props.universeId ~= nil and props.universeId ~= ""
		assert(v18, "OneByTwoTile Game requires universeId")
	end

	local v18 = props.headline
	local v19 = props.subtitle

	local v20 = GameHydrationReact.useGameInfo(props.universeId or "")
	local name, gameAgeDisplayName

	if v20 then
		name = v20.name
		gameAgeDisplayName = v20.gameAgeDisplayName
	end

	if props.contentType == omniRecommendationsContentType.Game then
		if v18 == nil or v18 == "" then
			v18 = if not (name == nil or name == "") then name else nil
		end

		if v19 == nil or v19 == "" then
			if gameAgeDisplayName == nil or gameAgeDisplayName == "" then
				v19 = nil
			else
				v19 = gameAgeDisplayName
			end
		end
	end

	local state, setState = React.useState(false)
	local v21 = useOverflowMenuOpen(hoverKey)
	local v22 = useTriggerFeedback()
	local ref3 = React.useRef(false)
	local v23

	if props.cellVerticalPadding == nil then
		if not (props.size == nil or not (props.size.Height.Scale > 1)) then
			v23 = props.size.Height.Offset / (props.size.Height.Scale - 1)
		end
	else
		v23 = props.cellVerticalPadding
	end

	local v24 = v23 == nil
	local v25 = v23 or v11.Gap.Large

	React.useEffect(function()
		if v24 then
			discoveryEventErrorLogger.reportError(
				"SponsoredTiles",
				"OneByTwoTile: could not resolve cellVerticalPadding for a 1x2 tile"
			)
		end
	end, { v24 })

	React.useEffect(function()
		if
			props.alignmentType ~= gameCollectionItemTypes.AlignmentType.LeftPin
			and props.alignmentType ~= gameCollectionItemTypes.AlignmentType.RightPin
		then
			discoveryEventErrorLogger.reportError(
				"SponsoredTiles",
				"OneByTwoTile: 1x2 tile is neither left- nor right-pinned",
				{ alignmentType = tostring(props.alignmentType) }
			)
		end
	end, { props.alignmentType })

	if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		React.useEffect(function()
			if props.oneByTwoTileFlowId then
				oneByTwoTileTelemetry.logOneByTwoTileRendered({
					oneByTwoTileFlowId = props.oneByTwoTileFlowId,
					recommendationsRequestId = props.recommendationsRequestId,
					topicId = props.topicId,
					contentType = props.contentType,
					adId = props.adId,
					componentType = gameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
					alignmentType = props.alignmentType,
					isSdui = props.isSdui == true
				})
			end
		end, {
			props.oneByTwoTileFlowId,
			props.recommendationsRequestId,
			props.topicId,
			props.contentType,
			props.adId,
			props.alignmentType,
			props.isSdui
		})
	end

	local viewportVideoAutoplayController, v26, v27

	if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		if props.videoPlaybackContext then
			viewportVideoAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController
		else
			viewportVideoAutoplayController = nil
		end

		local v28 = fFlagLuaAppOneByTwoHoverIdleAutoplay

		if v28 then
			if viewportVideoAutoplayController == nil then
				v28 = false
			else
				v28 = viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			end
		end

		local v29 = if v16 then `{hoverKey}|{props.adId}` else hoverKey
		local state2, setState2 = React.useState(nil)
		local v30

		if state2 == v29 then
			v30 = true
		elseif viewportVideoAutoplayController == nil then
			v30 = false
		else
			v30 = viewportVideoAutoplayController:hasCompletedAdsPlayback(v29)
		end

		v26 = React.useMemo(function()
			if not viewportVideoAutoplayController or v28 or v30 then
				return nil
			end

			local adsPlaybackCoordinator = viewportVideoAutoplayController:getAdsPlaybackCoordinator()

			if adsPlaybackCoordinator then
				return adsPlaybackCoordinator
			end

			local v31 = videoPlaybackCoordinator.new()
			viewportVideoAutoplayController:attachAdsPlaybackCoordinator(v31, AdsViewportAutoplayCandidateTag)

			return v31
		end, { viewportVideoAutoplayController, v28, v30 })

		useTagAsAdsViewportAutoplayCandidate(ref, if v26 then viewportVideoAutoplayController else nil)
		local v33 = v26 ~= nil
		v27 = React.useCallback(function()
			local current = ref.current

			if v33 and viewportVideoAutoplayController and current then
				viewportVideoAutoplayController:completeAdsPlayback(current, v29)
				setState2(v29)
			end
		end, { v33, viewportVideoAutoplayController, v29 })
	else
		v26 = nil
		viewportVideoAutoplayController = nil
		v27 = nil
	end

	local v28

	if fFlagLuaAppOneByTwoHoverIdleAutoplay and v16 then
		v28 = `{hoverKey}|{props.adId}`
	else
		v28 = hoverKey
	end

	local v30 = if not (fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and v26) then props.videoPlaybackContext else nil
	useTagAsViewportAutoplayCandidate(
		ref,
		v30,
		true,
		nil,
		2,
		v25,
		props.alignmentType,
		fFlagLuaAppOneByTwoHoverIdleAutoplay and {
			videoKey = v28,
			isUserIntentModeAutoplayCandidate = true
		} or nil
	)

	local ref4 = React.useRef(nil)

	useTagAsSponsoredAdViewabilityCandidate(ref, v16 and {
		encryptedAdTrackingData = props.adId,
		tileType = gameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
		mediaType = "video",
		videoPlaybackStateRef = ref4,
		videoSource = `rbxassetid://{props.primaryVideoAssetId}`
	} or nil)

	if not (fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and v26) then
		if props.videoPlaybackContext then
			v26 = props.videoPlaybackContext.videoPlaybackCoordinator
		else
			v26 = videoPlaybackCoordinator.default
		end
	end

	if not fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		if fFlagLuaAppOneByTwoHoverIdleAutoplay and props.videoPlaybackContext then
			viewportVideoAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController
		else
			viewportVideoAutoplayController = nil
		end
	end

	local v32 = fFlagLuaAppOneByTwoHoverIdleAutoplay

	if v32 then
		if v13 then
			if viewportVideoAutoplayController == nil then
				v32 = false
			else
				v32 = viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			end
		else
			v32 = v13
		end
	end

	local useMemo = React.useMemo
	local function fn()
		local v34 = {
			isSponsored = v16,
			enableSponsoredFeedback = props.enableSponsoredFeedback,
			enableReportAd = props.enableReportAd,
			enableReportExperience = 0,
			enableExplicitFeedback = 0
		}

		local v35 = if fFlagLuaAppEnableReportExperience and not v17 then props.enableReportExperience else nil
		v34.enableReportExperience = v35

		local v36 = if not v17 then props.enableExplicitFeedback else nil
		v34.enableExplicitFeedback = v36
		return getAvailableGameTileOverflowMenuItems(v34)
	end

	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local v34 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
	local v35 = useMemo(fn, {
		v16,
		v17,
		enableSponsoredFeedback,
		enableReportAd,
		v34,
		props.enableExplicitFeedback
	})

	local v36 = React.useCallback(function()
		ref3.current = false
	end, {})

	local onSelectionGained = props.onSelectionGained
	local v37 = React.useCallback(function()
		setState(true)

		if onSelectionGained then
			onSelectionGained()
		end
	end, { onSelectionGained })

	local onSelectionLost = props.onSelectionLost
	local v38 = React.useCallback(function()
		setState(false)

		if onSelectionLost then
			onSelectionLost()
		end
	end, { onSelectionLost })

	local useCallback = React.useCallback
	local function fn2()
		local current = ref3.current
		ref3.current = true

		if fFlagLuaAppSduiSponsoredOneByTwoTile and current == false and props.onTouchLongPress then
			props.onTouchLongPress()
		elseif current == false and next(v35) ~= nil then
			if v22 and not v21 then
				local v39 = {
					universeId = tostring(props.universeId or ""),
					sortId = props.topicId
				}

				v22(v7, "Press", props.appPage or "Unknown", v39)
			end

			getOverflowMenuSignalStore().openMenu(hoverKey)
		end
	end

	local appPage2 = props.appPage
	local topicId = props.topicId
	local universeId = props.universeId

	local v40 = if fFlagLuaAppSduiSponsoredOneByTwoTile then props.onTouchLongPress else nil
	local v41 = useCallback(fn2, {
		hoverKey,
		appPage2,
		topicId,
		universeId,
		v22,
		v21,
		v35,
		v40
	})

	local ref5 = React.useRef(0)

	local state2, setState2 = React.useState(nil)

	local state3, setState3 = React.useState(videoLoadingState.Idle)
	local function onLoadingStateChanged(p2)
		if p2 ~= videoLoadingState.Idle then
			setState3(p2)
		end
	end
	local v42 = React.useCallback(function(p2, p3)
		ref5.current = 0
		oneByTwoTileTelemetry.logOneByTwoTileVideoLoaded(p2, p3, props.adId)
		setState2({ duration = p2, loadTime = p3 })
	end, { setState2, props.adId })

	local function fn3()
		ref5.current = 0

		if props.videoAnalytics then
			props.videoAnalytics.reportVideoLoop(props.index, v26.currentPlaybackSessionId)
		end

		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and v27 then
			v27()
		end
	end

	local v45 = React.useCallback(fn3, {
		props.videoAnalytics,
		v26,
		props.index,
		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then v27 else nil
	})
	local v46

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		v46 = React.useCallback(function()
			local current = ref.current

			if current == nil then
				discoveryEventErrorLogger.reportError(
					"SponsoredTiles",
					"OneByTwoTile: tile ref missing when reporting video completion"
				)
			elseif viewportVideoAutoplayController then
				viewportVideoAutoplayController:onVideoCompleted(current)
			end
		end, { viewportVideoAutoplayController, ref })
	end

	local v47 = React.useCallback(function(current)
		ref5.current = current
	end, {})

	local state4, setState4 = React.useState(false)
	React.useEffect(function()
		local v48 = state2

		if not state4 or v48 == nil then
			return
		end

		local currentPlaybackSessionId = v26.currentPlaybackSessionId

		if currentPlaybackSessionId == nil then
			return
		end

		if props.videoAnalytics then
			props.videoAnalytics.reportVideoLoad(
				props.index,
				currentPlaybackSessionId,
				v48.duration,
				v48.loadTime
			)
			setState2(nil)
		end
	end, { state4, state2, v26, props.videoAnalytics, props.index, setState2 })
	local v48

	if props.videoPlaybackContext == nil then
		v48 = false
	else
		v48 = props.videoPlaybackContext.disablePlayback == true
	end

	local v49 = fFlagLuaAppSuppressVideoDetectorDuringScroll
		and fFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll

	if v49 then
		if props.videoPlaybackContext == nil then
			v49 = false
		else
			v49 = props.videoPlaybackContext.disableDetectors == true
		end
	end

	React.useEffect(function()
		if v48 then
			setState4(false)
		end
	end, { v48 })

	local state5, setState5 = React.useState(false)

	local v50 = useCanDevicePlayVideoPreview(
		tileVideoBlockingConfig,
		props.universeId or "",
		props.pageContext or ""
	)

	local v51 = React.useCallback(function()
		setState5(v50())
	end, { v50 })
	React.useEffect(v51, { v51 })

	local v52 = useRoactService(roactNetworking)
	local v53 = useRoactService(appSessionService)
	local v54 = useNavigation()
	local v55 = useLocalization({ joinButtonText = "Common.VisitGame.Label.Play" })
	local v56

	if v17 then
		v56 = props.ctaText
	else
		v56 = if props.ctaText == "" then v55.joinButtonText else props.ctaText
	end

	local v57

	if v17 then
		v57 = not (props.clickoutUrl == nil or props.clickoutUrl == "") and v56 ~= ""
	else
		v57 = v17
	end

	local launchExperienceEventContext = props.launchExperienceEventContext
		or DiscoveryAnalytics.Constants.Context.ExperienceTile

	local v58 = React.useCallback(function()
		if props.adId then
			sponsoredGamesRecordClick(v52, props.adId)
		end
	end, { v52, props.adId })

	local v59 = React.useCallback(function(p2)
		if v53 then
			setGamePlaySession(v53, sessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		if v14 then
			hoverTileCoordinator.default:reset()
		end

		if props.reportExperienceLaunched then
			local v60 = {
				placeId = props.placeId,
				universeId = props.universeId,
				adId = props.adId,
				tileType = gameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
				placeIdOverride = props.placeIdOverride,
				launchDataOverride = props.launchDataOverride
			}

			local reportExperienceLaunched = props.reportExperienceLaunched

			local referralSource = props.referralSource

			local index2 = props.index

			if not fFlagLuaAppDemoModePlayButtonTelemetry then
				p2 = nil
			end

			reportExperienceLaunched(
				v60,
				referralSource,
				"OneByTwoTile",
				launchExperienceEventContext,
				index2,
				p2
			)
		end
	end, {
		v53,
		props.reportExperienceLaunched,
		props.placeId,
		props.universeId,
		props.adId,
		props.placeIdOverride,
		props.launchDataOverride,
		props.referralSource,
		launchExperienceEventContext,
		props.index,
		v14
	})

	local useCallback3 = React.useCallback
	local function fn4()
		if ref3.current then
			ref3.current = false
			return
		end

		if v14 then
			hoverTileCoordinator.default:reset()
		end

		if not state5 or state3 ~= videoLoadingState.Loaded then
			return
		end

		oneByTwoTileTelemetry.logOneByTwoTileActivated()
		local current = ref5.current
		v26:reset(videoEndReason.TileClicked, nil, props.universeId, nil)
		local navigate = v54.navigate
		local featureTileAdPlayer = appPage.FeatureTileAdPlayer
		local v61 = {
			videoAssetId = props.primaryVideoAssetId,
			imageAssetId = props.primaryImageAssetId,
			startPlaybackProgress = current,
			attributionThumbnailAssetId = props.attributionThumbnailAssetId,
			videoPlaybackContext = props.videoPlaybackContext,
			title = v18,
			subtitle = v19,
			contentType = props.contentType,
			payerName = props.payerName,
			sponsoredUserCohort = props.sponsoredUserCohort,
			adId = props.adId,
			enableReportAd = props.enableReportAd,
			clickoutUrl = props.clickoutUrl,
			ctaText = props.ctaText,
			universeId = props.universeId,
			index = props.index,
			placeId = props.placeId,
			placeIdOverride = props.placeIdOverride,
			launchDataOverride = props.launchDataOverride,
			referralSource = props.referralSource,
			source = gameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
			launchExperienceEventContext = launchExperienceEventContext,
			reportGameDetailOpened = props.reportGameDetailOpened,
			reportExperienceLaunched = props.reportExperienceLaunched,
			onOpenGameDetails = 0,
			disableGameLaunchSponsoredClickRecording = 0
		}
		local v62 = if fFlagLuaAppSduiSponsoredOneByTwoTile then props.onOpenGameDetails else nil
		v61.onOpenGameDetails = v62

		local v63 = if fFlagLuaAppSduiSponsoredOneByTwoTile then props.disableGameLaunchSponsoredClickRecording else nil
		v61.disableGameLaunchSponsoredClickRecording = v63
		navigate(featureTileAdPlayer, { extraProps = v61 })
	end
	local v60 = {
		v14,
		v54,
		v26,
		props.universeId,
		props.primaryVideoAssetId,
		props.primaryImageAssetId,
		props.attributionThumbnailAssetId,
		props.videoPlaybackContext,
		v18,
		v19,
		props.contentType,
		props.payerName,
		props.sponsoredUserCohort,
		props.adId,
		props.enableReportAd,
		props.clickoutUrl,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	local ctaText = props.ctaText
	local placeId = props.placeId
	local placeIdOverride = props.placeIdOverride
	local launchDataOverride = props.launchDataOverride
	local referralSource = props.referralSource

	local index2 = props.index
	local reportGameDetailOpened = props.reportGameDetailOpened
	local reportExperienceLaunched = props.reportExperienceLaunched
	local onOpenGameDetails = if fFlagLuaAppSduiSponsoredOneByTwoTile then props.onOpenGameDetails else nil
	local v61 = if fFlagLuaAppSduiSponsoredOneByTwoTile then props.disableGameLaunchSponsoredClickRecording else nil

	v60[17], v60[18], v60[19], v60[20], v60[21], v60[22], v60[23], v60[24], v60[25], v60[26], v60[27], v60[28], v60[29] = ctaText, placeId, placeIdOverride, launchDataOverride, referralSource, launchExperienceEventContext, index2, reportGameDetailOpened, reportExperienceLaunched, onOpenGameDetails, v61, state5, state3
	local v62 = useCallback3(fn4, v60)

	local useCallback4 = React.useCallback
	local function fn5()
		oneByTwoTileTelemetry.logOneByTwoTileGameJoinInitiated()
		oneByTwoTileTelemetry.logOneByTwoTileCtaActivated(oneByTwoTileTelemetry.CtaType.GameJoin)

		if fFlagLuaAppSduiSponsoredOneByTwoTile then
			if not props.disableGameLaunchSponsoredClickRecording then
				v58()
			end
		else
			v58()
		end
	end

	local v64 = if fFlagLuaAppSduiSponsoredOneByTwoTile then props.disableGameLaunchSponsoredClickRecording else nil
	local v65 = useCallback4(fn5, { v58, v64 })

	local useCallback5 = React.useCallback
	local function fn6()
		if not v57 then
			return
		end

		oneByTwoTileTelemetry.logOneByTwoTileCtaActivated(oneByTwoTileTelemetry.CtaType.Clickout)
		v58()

		if FFlagLuaAppAdClickoutEvent then
			local adId = props.adId

			if adId ~= nil and adId ~= "" then
				SponsoredTilesTelemetry.Events.adClickout(
					adId,
					gameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
					props.clickoutUrl
				)
			end
		end

		if fFlagLuaAppAdClickoutDeeplink then
			openAdClickoutUrl(v54, props.clickoutUrl)
		else
			v54.navigate(appPage.GenericWebPage, {
				detail = props.clickoutUrl,
				extraProps = { showDomainAsTitle = true }
			})
		end
	end

	local clickoutUrl = props.clickoutUrl

	local v67 = if FFlagLuaAppAdClickoutEvent then props.adId else nil
	local v68 = useCallback5(fn6, { v57, v54, clickoutUrl, v58, v67 })

	React.useEffect(function()
		impressionsTagUtility.AddTag(ref2, props.impressionsTag, props.index)
		return function()
			impressionsTagUtility.RemoveTag(ref2, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local v69 = useValidTileBadges(props.universeId or "", props.topicId, props.badgeOverride)

	local logoAspectRatio = tonumber(props.logoAspectRatio)
	local v70 = not (logoAspectRatio and logoAspectRatio > 0) and 1 or logoAspectRatio
	local v71 = if v70 == 3 then v5 else v6
	local v72, v73, v74, v75, size_500, v76, v77, v78, v79

	if v12 then
		v72 = v11.Padding.Medium
		v73 = v11.Typography.TitleLarge
		v74 = v11.Typography.BodySmall
		v75 = v11.Size.Size_600
		size_500 = v11.Size.Size_500
		v76 = v11.Gap.XXSmall
		v77 = buttonSize.Small
		v78 = v11.Size.Size_800
		v79 = v11.Typography.TitleSmall
	else
		v72 = v11.Padding.Large
		v73 = v11.Typography.HeadingMedium
		v74 = v11.Typography.BodyMedium
		v75 = v11.Size.Size_800
		size_500 = v11.Size.Size_500
		v76 = v11.Gap.XSmall
		v77 = buttonSize.Medium
		v78 = v11.Size.Size_1000
		v79 = v11.Typography.TitleMedium
	end

	local createElement = React.createElement
	local v82 = if fFlagLuaAppSduiSponsoredOneByTwoTile then props.rootSize else nil
	local v81 = {
		Size = v82,
		LayoutOrder = props.index,
		ZIndex = props.zIndex,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = ref2
	}

	local createElement2 = React.createElement
	local v85 = {
		ref = ref,
		Size = props.size or UDim2.fromScale(1, 1),
		BackgroundColor3 = v11.Color.Surface.Surface_100.Color3,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Text = "",
		AutoButtonColor = false,
		SelectionOrder = props.SelectionOrder,
		[React.Event.Activated] = v62,
		[React.Event.TouchLongPress] = v41,
		[React.Event.SelectionGained] = v37,
		[React.Event.SelectionLost] = v38,
		[React.Change.GuiState] = v36
	}
	local children = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v11.Radius.Medium)
		}),
		Video = 0,
		GradientOverlayBottom = 0,
		TileBadge = 0,
		Logo = 0,
		OverflowMenu = 0,
		BottomStack = 0
	}

	local createElement3 = React.createElement
	local v87 = {
		video = `rbxassetid://{props.primaryVideoAssetId}`,
		thumbnail = `rbxassetid://{props.primaryImageAssetId}`,
		shouldStartPlayback = state4,
		loadImmediately = state5 and state3 ~= videoLoadingState.Failed,
		muted = true,
		looped = not fFlagLuaAppOneByTwoHoverIdleAutoplay or (not v32 or v14),
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Crop,
		cornerRadius = v11.Radius.Medium,
		ZIndex = 0,
		onVideoLoaded = v42,
		onLoadingStateChanged = onLoadingStateChanged,
		onVideoEnded = 0,
		onVideoLooped = 0,
		onVideoProgressChanged = 0,
		videoPlaybackStateRef = 0
	}

	if not (fFlagLuaAppOneByTwoHoverIdleAutoplay and v32) then
		v46 = nil
	end

	v87.onVideoEnded = v46

	v87.onVideoLooped = v45
	v87.onVideoProgressChanged = v47

	if not v16 then
		ref4 = nil
	end

	v87.videoPlaybackStateRef = ref4
	children.Video = createElement3(videoDisplay, v87)

	children.GradientOverlayBottom = React.createElement("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v11.Color.Extended.Black.Black_100.Color3,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 1
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v11.Radius.Medium)
		}),
		UIGradientBottom = React.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, v9),
				NumberSequenceKeypoint.new(1 - v10, v9),
				NumberSequenceKeypoint.new(1, v8)
			})
		})
	})
	local v88

	if v69 then
		v88 = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2 },
			{
				Badge = React.createElement(gameTileThumbnailBadges, {
					tileBadgesByPosition = v69,
					padding = if FFlagLuaAppSponsoredTileBadgeContentPadding then v72 else nil
				})
			}
		)
	end

	children.TileBadge = v88

	local v89 = if props.logoImageAssetId then React.createElement(image, {
		Image = `rbxassetid://{props.logoImageAssetId}`,
		Position = UDim2.new(1, -v11.Padding.Medium, 0, v11.Padding.Medium),
		tag = "anchor-top-right",
		Size = UDim2.new(v71, 0, 1, 0),
		aspectRatio = v70,
		ZIndex = 2
	}) else nil
	children.Logo = v89
	local v90

	if fFlagLuaAppSduiSponsoredOneByTwoTile and props.renderOverflowMenu then
		v90 = props.renderOverflowMenu({
			isHovered = v14,
			isSelected = state,
			menuKey = hoverKey,
			parentRef = ref
		})
	else
		local createElement4 = React.createElement
		local v92 = {
			hoverKey = hoverKey,
			parentRef = ref,
			zIndex = 4,
			universeId = props.universeId,
			placeId = props.placeId,
			adId = props.adId,
			payerName = props.payerName,
			sponsoredUserCohort = props.sponsoredUserCohort,
			appPage = props.appPage,
			topicId = props.topicId,
			isSponsored = v16,
			contentType = props.contentType,
			setGameHidden = 0,
			isHovered = 0,
			isSelected = 0,
			availableMenuItems = 0
		}
		local v93

		if fFlagLuaAppSduiSponsoredOneByTwoTile then
			v93 = props.setGameHidden or function() end
		else
			v93 = props.setGameHidden
		end

		v92.setGameHidden = v93

		v92.isHovered = v14
		v92.isSelected = state
		v92.availableMenuItems = v35
		v90 = createElement4(SpanTileOverflowMenu, v92)
	end

	children.OverflowMenu = v90

	local createElement4 = React.createElement
	local v92 = {
		Size = UDim2.new(1, -2 * v72, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, v72, 1, -v72),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local v93 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v72)
		}),
		TextStack = 0,
		CtaButton = 0
	}

	local createElement5 = React.createElement
	local v95 = {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v96 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v76)
		}),
		Headline = 0,
		Subtitle = 0
	}

	local v97 = if v18 then React.createElement("TextLabel", {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 2 * v75),
		BackgroundTransparency = 1,
		Text = v18,
		FontFace = normalizeFontFace(v73.Font),
		LineHeight = v73.LineHeight,
		TextSize = v73.FontSize,
		TextColor3 = v11.LightMode.ActionOverMedia.Foreground.Color3,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.AtEnd
	}) else nil
	v96.Headline = v97

	local v98 = if v19 then React.createElement("TextLabel", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, size_500),
		BackgroundTransparency = 1,
		Text = v19,
		FontFace = normalizeFontFace(v74.Font),
		LineHeight = v74.LineHeight,
		TextSize = v74.FontSize,
		TextColor3 = v11.LightMode.ActionOverMedia.Foreground.Color3,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = false,
		TextTruncate = Enum.TextTruncate.AtEnd
	}) else nil
	v96.Subtitle = v98
	v93.TextStack = createElement5("Frame", v95, v96)
	local v99

	if v17 then
		if v57 then
			v99 = React.createElement("TextButton", {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(0, v78),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = v11.Color.Extended.White.White_20.Color3,
				BackgroundTransparency = v11.Color.Extended.White.White_20.Transparency,
				BorderSizePixel = 0,
				Text = v56,
				TextColor3 = v11.LightMode.ActionOverMedia.Foreground.Color3,
				FontFace = normalizeFontFace(v79.Font),
				TextSize = v79.FontSize,
				[React.Event.Activated] = v68
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v11.Radius.Medium)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v11.Padding.Large),
					PaddingRight = UDim.new(0, v11.Padding.Large)
				})
			})
		end
	elseif props.universeId then
		local createElement6 = React.createElement
		local v101 = {
			LayoutOrder = 2,
			universeId = props.universeId,
			placeId = 0,
			referralSource = 0,
			eventContext = 0,
			launchSource = "OneByTwoTile",
			playableText = 0,
			hidePlayableIcon = true,
			buttonSize = 0,
			preferSecondaryPlayButton = true,
			onActivated = 0,
			reportExperienceLaunched = 0,
			experienceJoinData = 0
		}
		local v102 = if props.placeIdOverride then props.placeIdOverride else props.placeId
		v101.placeId = v102
		v101.referralSource = props.referralSource
		v101.eventContext = launchExperienceEventContext

		v101.playableText = v56

		v101.buttonSize = v77

		v101.onActivated = v65
		v101.reportExperienceLaunched = v59
		v101.experienceJoinData = {
			launchData = props.launchDataOverride,
			tileType = gameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
			nativeAdData = props.adId
		}
		v99 = createElement6(playButton, v101)
	end

	v93.CtaButton = v99
	children.BottomStack = createElement4("Frame", v92, v93)
	local element = createElement("Frame", v81, {
		Container = createElement2("TextButton", v85, children)
	})
	local v100

	if fFlagLuaAppOneByTwoHoverIdleAutoplay or fFlagLuaAppGameTileSelectionVideoPlayback then
		v100 = getPlaybackDetectionMethod(v15, v13)
	end

	local createElement6 = React.createElement
	local fragment = React.Fragment
	local v103

	if not (v48 or fFlagLuaAppSuppressVideoDetectorDuringScroll and v49) then
		local createElement7 = React.createElement

		if not fFlagLuaAppOneByTwoHoverIdleAutoplay then
			v28 = hoverKey
		end

		local v105 = {
			videoKey = v28,
			itemIndex = props.index,
			itemFrameRef = ref,
			playbackDetectionMethod = 0,
			isHoverSupported = 0,
			autoplay = 0,
			isHovered = 0,
			hasVideoPlaybackUserIntent = 0,
			onPlaybackChange = 0,
			videoAnalytics = 0,
			videoDwellTimeInSec = 0,
			videoVisiblePercent = 0,
			videoPlaybackCoordinator = 0,
			viewportVideoAutoplayController = 0,
			isVideoEligible = 0,
			onPlaybackCandidate = 0
		}
		local v106 = if fFlagLuaAppGameTileSelectionVideoPlayback or fFlagLuaAppOneByTwoHoverIdleAutoplay then v100 else nil
		v105.playbackDetectionMethod = v106

		if fFlagLuaAppGameTileSelectionVideoPlayback then
			v13 = nil
		end

		v105.isHoverSupported = v13
		v105.autoplay = not fFlagLuaAppGameTileSelectionVideoPlayback or nil
		v105.isHovered = v14

		local v107 = if fFlagLuaAppOneByTwoHoverIdleAutoplay and v100 == videoPlaybackDetectionMethod.Hover then v14 else nil
		v105.hasVideoPlaybackUserIntent = v107

		v105.onPlaybackChange = setState4
		v105.videoAnalytics = props.videoAnalytics
		v105.videoDwellTimeInSec = fIntLuaAppGameTileVideoDwellTimeInSec
		v105.videoVisiblePercent = fIntLuaAppGameTileVideoVisiblePercent
		v105.videoPlaybackCoordinator = v26
		local v108

		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			v108 = viewportVideoAutoplayController
		elseif props.videoPlaybackContext then
			v108 = props.videoPlaybackContext.viewportVideoAutoplayController
		end

		v105.viewportVideoAutoplayController = v108

		v105.isVideoEligible = state5
		v105.onPlaybackCandidate = v51
		v103 = createElement7(videoPlaybackDetector, v105)
	end

	return createElement6(fragment, nil, {
		Tile = element,
		VideoPlaybackDetector = v103
	})
end

return React.memo(OneByTwoTile)
