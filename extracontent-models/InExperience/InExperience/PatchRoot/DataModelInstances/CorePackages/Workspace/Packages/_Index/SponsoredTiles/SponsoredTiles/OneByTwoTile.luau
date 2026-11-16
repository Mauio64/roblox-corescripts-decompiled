local SponsoredTiles = script:FindFirstAncestor("SponsoredTiles")

local parent = SponsoredTiles.Parent
local GameTile = require(parent.GameTile)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local Image = Foundation.Image
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local GamePlayButton = require(parent.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local DiscoveryTypes = require(parent.DiscoveryTypes)
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local GameHydrationReact = require(parent.GameHydrationReact)
local GameInfosRodux = require(parent.GameInfosRodux)
local useGameInfosSelector = GameInfosRodux.useGameInfosSelector
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppSessionService = RoactServiceTags.AppSessionService
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local SponsoredTilesTelemetry = require(parent.SponsoredTilesTelemetry)
local OneByTwoTileTelemetry = SponsoredTilesTelemetry.OneByTwoTileTelemetry
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
require(SponsoredTiles.types)

local VideoPlayer = require(parent.VideoPlayer)
local VideoDisplay = VideoPlayer.VideoDisplay
local VideoLoadingState = VideoPlayer.VideoLoadingState

local VideoUtils = require(parent.VideoUtils)
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local VideoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate
local AdsViewportAutoplayCandidateTag = require(script.Parent.AdsViewportAutoplayCandidateTag)
local useTagAsAdsViewportAutoplayCandidate = require(script.Parent.useTagAsAdsViewportAutoplayCandidate)
local getPlaybackDetectionMethod = VideoUtils.getPlaybackDetectionMethod
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason

local SponsoredAdViewability = require(parent.SponsoredAdViewability)
local useTagAsSponsoredAdViewabilityCandidate = SponsoredAdViewability.useTagAsSponsoredAdViewabilityCandidate
local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility

local useIsHoveredTile = GameTile.useIsHoveredTile
local useValidTileBadges = GameTile.useValidTileBadges
local GameTileThumbnailBadges = GameTile.GameTileThumbnailBadges
local HoverTileCoordinator = GameTile.HoverTileCoordinator
local TileVideoBlockingConfig = GameTile.TileVideoBlockingConfig
local getAvailableGameTileOverflowMenuItems = GameTile.getAvailableGameTileOverflowMenuItems
local SpanTileOverflowMenu = require(SponsoredTiles.SpanTileOverflowMenu.SpanTileOverflowMenu)

local AppBlox = require(parent.AppBlox)
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local InteractionFeedback = require(parent.InteractionFeedback)
local useTriggerFeedback = InteractionFeedback.useTriggerFeedback

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
local FFlagLuaAppFeatureTileHapticsFix = SharedFlags.FFlagLuaAppFeatureTileHapticsFix
local FIntLuaAppGameTileVideoDwellTimeInSec = SharedFlags.FIntLuaAppGameTileVideoDwellTimeInSec
local FIntLuaAppGameTileVideoVisiblePercent = SharedFlags.FIntLuaAppGameTileVideoVisiblePercent
local FFlagLuaAppGameTileSelectionVideoPlayback = SharedFlags.FFlagLuaAppGameTileSelectionVideoPlayback
local FFlagLuaAppSuppressVideoDetectorDuringScroll = SharedFlags.FFlagLuaAppSuppressVideoDetectorDuringScroll

local FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll = SharedFlags.FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll
local FFlagLuaAppSduiSponsoredOneByTwoTile = SharedFlags.FFlagLuaAppSduiSponsoredOneByTwoTile
local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local defineFastFlag = game:DefineFastFlag("LuaAppDefaultGameAdTileText", false)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay

local FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = SharedFlags.FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback
local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local FFlagLuaAppEnableOneByTwoTileFunnelTelemetry = SharedFlags.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local FFlagLuaAppSponsoredTileBadgeContentPadding = require(SponsoredTiles.Flags.FFlagLuaAppSponsoredTileBadgeContentPadding)
local FFlagLuaAppAdClickoutEvent = require(SponsoredTiles.Flags.FFlagLuaAppAdClickoutEvent)

local defineFastInt = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentLandscape", 40)
local defineFastInt2 = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentSquare", 25)

local defineFastInt3 = game:DefineFastInt("LuaAppOneByTwoTileGradientBottomTransparencyPercent", 25)

local defineFastInt4 = game:DefineFastInt("LuaAppOneByTwoTileGradientTopTransparencyPercent", 100)

local defineFastInt5 = game:DefineFastInt("LuaAppOneByTwoTileGradientBottomHeightPercent", 50)

local v = defineFastInt / 100
local v2 = defineFastInt2 / 100
local v3 = FFlagLuaAppFeatureTileHapticsFix and "TileLongPress" or "OneByTwoTileLongPress"
local v4 = defineFastInt3 / 100
local v5 = defineFastInt4 / 100
local v6 = defineFastInt5 / 100

local function getTextOrDefault(p: string?, p2: string?) -- 2 equivalent calls inferred from this helper
	if p ~= nil and p ~= "" then
		return p
	end

	return if not (p2 == nil or p2 == "") then p2 else nil
end

local function OneByTwoTile(props)
	local v7 = useTokens()
	local v8 = Responsive.useResponsive({ Responsive.BreakpointConfig.sizes.Small }) == Responsive.Keys.Small

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local hoverKey = props.hoverKey
	local isHoverSupported = Responsive.useLastInput() ~= Responsive.Input.Touch
	local isHovered = useIsHoveredTile(ref, hoverKey, isHoverSupported)
	local v9 = Responsive.usePreferredInput()
	local isSponsored

	if props.adId == nil then
		isSponsored = false
	else
		isSponsored = props.adId ~= ""
	end

	local v10 = props.contentType == OmniRecommendationsContentType.AdLink

	if v10 then
		local v11 = props.clickoutUrl ~= nil and props.clickoutUrl ~= ""
		assert(v11, "OneByTwoTile AdLink requires clickoutUrl")
	else
		local v11 = props.universeId ~= nil and props.universeId ~= ""
		assert(v11, "OneByTwoTile Game requires universeId")
	end

	local headline = props.headline
	local subtitle = props.subtitle
	local name = nil
	local v11 = nil

	if defineFastFlag then
		if FFlagMigrateGameInfoToStore then
			local v12 = GameHydrationReact.useGameInfo(props.universeId or "")

			if v12 then
				name = v12.name
				v11 = v12.gameAgeDisplayName
			end
		else
			local v12 = useGameInfosSelector(props.universeId or "")

			if v12 then
				name = v12.name
				v11 = v12.ageRecommendationDisplayName
			end
		end

		if props.contentType == OmniRecommendationsContentType.Game then
			headline = getTextOrDefault(headline, name) -- inferred equivalent call
			subtitle = getTextOrDefault(subtitle, v11) -- inferred equivalent call
		end
	end

	local state, setState = React.useState(false)
	local v12 = useOverflowMenuOpen(hoverKey)
	local v13 = useTriggerFeedback()
	local ref3 = React.useRef(false)
	local v14

	if props.cellVerticalPadding == nil then
		if not (props.size == nil or not (props.size.Height.Scale > 1)) then
			v14 = props.size.Height.Offset / (props.size.Height.Scale - 1)
		end
	else
		v14 = props.cellVerticalPadding
	end

	local v15 = v14 == nil
	local v16 = v14 or v7.Gap.Large

	React.useEffect(function()
		if v15 then
			DiscoveryEventErrorLogger.reportError(
				"SponsoredTiles",
				"OneByTwoTile: could not resolve cellVerticalPadding for a 1x2 tile"
			)
		end
	end, { v15 })

	React.useEffect(function()
		if
			props.alignmentType ~= GameCollectionItemTypes.AlignmentType.LeftPin
			and props.alignmentType ~= GameCollectionItemTypes.AlignmentType.RightPin
		then
			DiscoveryEventErrorLogger.reportError(
				"SponsoredTiles",
				"OneByTwoTile: 1x2 tile is neither left- nor right-pinned",
				{ alignmentType = tostring(props.alignmentType) }
			)
		end
	end, { props.alignmentType })

	if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		React.useEffect(function()
			if props.oneByTwoTileFlowId then
				OneByTwoTileTelemetry.logOneByTwoTileRendered({
					oneByTwoTileFlowId = props.oneByTwoTileFlowId,
					recommendationsRequestId = props.recommendationsRequestId,
					topicId = props.topicId,
					contentType = props.contentType,
					adId = props.adId,
					componentType = GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
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

	local viewportVideoAutoplayController, videoPlaybackCoordinator, v17

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		if props.videoPlaybackContext then
			viewportVideoAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController
		else
			viewportVideoAutoplayController = nil
		end

		local v18 = FFlagLuaAppOneByTwoHoverIdleAutoplay

		if v18 then
			if viewportVideoAutoplayController == nil then
				v18 = false
			else
				v18 = viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			end
		end

		local v19

		if isSponsored then
			v19 = `{hoverKey}|{props.adId}`
		else
			v19 = hoverKey
		end

		local state2, setState2 = React.useState(nil)
		local v20

		if state2 == v19 then
			v20 = true
		elseif viewportVideoAutoplayController == nil then
			v20 = false
		else
			v20 = viewportVideoAutoplayController:hasCompletedAdsPlayback(v19)
		end

		videoPlaybackCoordinator = React.useMemo(function()
			if not viewportVideoAutoplayController or v18 or v20 then
				return nil
			end

			local adsPlaybackCoordinator = viewportVideoAutoplayController:getAdsPlaybackCoordinator()

			if adsPlaybackCoordinator then
				return adsPlaybackCoordinator
			end

			local v21 = VideoPlaybackCoordinator.new()
			viewportVideoAutoplayController:attachAdsPlaybackCoordinator(v21, AdsViewportAutoplayCandidateTag)

			return v21
		end, { viewportVideoAutoplayController, v18, v20 })
		local v21

		if videoPlaybackCoordinator then
			v21 = viewportVideoAutoplayController
		end

		useTagAsAdsViewportAutoplayCandidate(ref, v21)
		local v22 = videoPlaybackCoordinator ~= nil
		v17 = React.useCallback(function()
			local current = ref.current

			if v22 and viewportVideoAutoplayController and current then
				viewportVideoAutoplayController:completeAdsPlayback(current, v19)
				setState2(v19)
			end
		end, { v22, viewportVideoAutoplayController, v19 })
	else
		videoPlaybackCoordinator = nil
		viewportVideoAutoplayController = nil
		v17 = nil
	end

	local videoKey

	if FFlagLuaAppOneByTwoHoverIdleAutoplay and isSponsored then
		videoKey = `{hoverKey}|{props.adId}`
	else
		videoKey = hoverKey
	end

	local v18

	if not (FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and videoPlaybackCoordinator) then
		v18 = props.videoPlaybackContext
	end

	useTagAsViewportAutoplayCandidate(
		ref,
		v18,
		true,
		nil,
		2,
		v16,
		props.alignmentType,
		FFlagLuaAppOneByTwoHoverIdleAutoplay and {
			videoKey = videoKey,
			isUserIntentModeAutoplayCandidate = true
		} or nil
	)

	local ref4 = React.useRef(nil)

	useTagAsSponsoredAdViewabilityCandidate(ref, isSponsored and {
		encryptedAdTrackingData = props.adId,
		tileType = GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
		mediaType = "video",
		videoPlaybackStateRef = ref4,
		videoSource = `rbxassetid://{props.primaryVideoAssetId}`
	} or nil)

	if not (FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and videoPlaybackCoordinator) then
		if props.videoPlaybackContext then
			videoPlaybackCoordinator = props.videoPlaybackContext.videoPlaybackCoordinator
		else
			videoPlaybackCoordinator = VideoPlaybackCoordinator.default
		end
	end

	if not FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		if FFlagLuaAppOneByTwoHoverIdleAutoplay and props.videoPlaybackContext then
			viewportVideoAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController
		else
			viewportVideoAutoplayController = nil
		end
	end

	local v19 = FFlagLuaAppOneByTwoHoverIdleAutoplay

	if v19 then
		if isHoverSupported then
			if viewportVideoAutoplayController == nil then
				v19 = false
			else
				v19 = viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			end
		else
			v19 = isHoverSupported
		end
	end

	local useMemo = React.useMemo
	local function fn()
		local v20 = {
			isSponsored = isSponsored,
			enableSponsoredFeedback = props.enableSponsoredFeedback,
			enableReportAd = props.enableReportAd,
			enableReportExperience = 0,
			enableExplicitFeedback = 0
		}
		local enableReportExperience

		if FFlagLuaAppEnableReportExperience and not v10 then
			enableReportExperience = props.enableReportExperience
		end

		v20.enableReportExperience = enableReportExperience
		local enableExplicitFeedback

		if not v10 then
			enableExplicitFeedback = props.enableExplicitFeedback
		end

		v20.enableExplicitFeedback = enableExplicitFeedback
		return getAvailableGameTileOverflowMenuItems(v20)
	end

	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local v20

	if FFlagLuaAppEnableReportExperience then
		v20 = props.enableReportExperience
	end

	local availableMenuItems = useMemo(fn, {
		isSponsored,
		v10,
		enableSponsoredFeedback,
		enableReportAd,
		v20,
		props.enableExplicitFeedback
	})

	local v21 = React.useCallback(function()
		ref3.current = false
	end, {})

	local onSelectionGained = props.onSelectionGained
	local v22 = React.useCallback(function()
		setState(true)

		if onSelectionGained then
			onSelectionGained()
		end
	end, { onSelectionGained })

	local onSelectionLost = props.onSelectionLost
	local v23 = React.useCallback(function()
		setState(false)

		if onSelectionLost then
			onSelectionLost()
		end
	end, { onSelectionLost })

	local useCallback = React.useCallback
	local function fn2()
		local current = ref3.current
		ref3.current = true

		if FFlagLuaAppSduiSponsoredOneByTwoTile and current == false and props.onTouchLongPress then
			props.onTouchLongPress()
		elseif current == false and next(availableMenuItems) ~= nil then
			if v13 and not v12 then
				local v24 = {
					universeId = tostring(props.universeId or ""),
					sortId = props.topicId
				}

				v13(v3, "Press", props.appPage or "Unknown", v24)
			end

			getOverflowMenuSignalStore().openMenu(hoverKey)
		end
	end

	local appPage = props.appPage
	local topicId = props.topicId
	local universeId = props.universeId
	local v24

	if FFlagLuaAppSduiSponsoredOneByTwoTile then
		v24 = props.onTouchLongPress
	end

	local v25 = useCallback(fn2, {
		hoverKey,
		appPage,
		topicId,
		universeId,
		v13,
		v12,
		availableMenuItems,
		v24
	})

	local ref5 = React.useRef(0)

	local state2, setState2 = React.useState(nil)

	local state3, setState3 = React.useState(VideoLoadingState.Idle)
	local function onLoadingStateChanged(p)
		if p ~= VideoLoadingState.Idle then
			setState3(p)
		end
	end
	local onVideoLoaded = React.useCallback(function(duration: number, loadTime: number)
		ref5.current = 0
		OneByTwoTileTelemetry.logOneByTwoTileVideoLoaded(duration, loadTime, props.adId)
		setState2({ duration = duration, loadTime = loadTime })
	end, { setState2, props.adId })

	local useCallback2 = React.useCallback
	local function fn3()
		ref5.current = 0

		if props.videoAnalytics then
			props.videoAnalytics.reportVideoLoop(props.index, videoPlaybackCoordinator.currentPlaybackSessionId)
		end

		if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and v17 then
			v17()
		end
	end

	local videoAnalytics = props.videoAnalytics

	local index = props.index
	local v26

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		v26 = v17
	end

	local onVideoLooped = useCallback2(fn3, { videoAnalytics, videoPlaybackCoordinator, index, v26 })
	local onVideoEnded

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		onVideoEnded = React.useCallback(function()
			local current = ref.current

			if current == nil then
				DiscoveryEventErrorLogger.reportError(
					"SponsoredTiles",
					"OneByTwoTile: tile ref missing when reporting video completion"
				)
			elseif viewportVideoAutoplayController then
				viewportVideoAutoplayController:onVideoCompleted(current)
			end
		end, { viewportVideoAutoplayController, ref })
	end

	local onVideoProgressChanged = React.useCallback(function(current: number)
		ref5.current = current
	end, {})

	local state4, setState4 = React.useState(false)
	React.useEffect(function()
		local v27 = state2

		if not state4 or v27 == nil then
			return
		end

		local currentPlaybackSessionId = videoPlaybackCoordinator.currentPlaybackSessionId

		if currentPlaybackSessionId == nil then
			return
		end

		if props.videoAnalytics then
			props.videoAnalytics.reportVideoLoad(props.index, currentPlaybackSessionId, v27.duration, v27.loadTime)
			setState2(nil)
		end
	end, { state4, state2, videoPlaybackCoordinator, props.videoAnalytics, props.index, setState2 })
	local v27

	if props.videoPlaybackContext == nil then
		v27 = false
	else
		v27 = props.videoPlaybackContext.disablePlayback == true
	end

	local v28 = FFlagLuaAppSuppressVideoDetectorDuringScroll and FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll

	if v28 then
		if props.videoPlaybackContext == nil then
			v28 = false
		else
			v28 = props.videoPlaybackContext.disableDetectors == true
		end
	end

	React.useEffect(function()
		if v27 then
			setState4(false)
		end
	end, { v27 })

	local state5, setState5 = React.useState(false)

	local v29 = useCanDevicePlayVideoPreview(TileVideoBlockingConfig, props.universeId or "", props.pageContext or "")

	local onPlaybackCandidate = React.useCallback(function()
		setState5(v29())
	end, { v29 })
	React.useEffect(onPlaybackCandidate, { onPlaybackCandidate })

	local v30 = useRoactService(RoactNetworking)
	local v31 = useRoactService(AppSessionService)
	local v32 = useNavigation()
	local v47 = useLocalization({ joinButtonText = "Common.VisitGame.Label.Play" })
	local v48

	if v10 then
		v48 = props.ctaText
	elseif props.ctaText == "" then
		v48 = v47.joinButtonText
	else
		v48 = props.ctaText
	end

	local v49

	if v10 then
		if props.clickoutUrl == nil or props.clickoutUrl == "" then
			v49 = false
		else
			v49 = v48 ~= ""
		end
	else
		v49 = v10
	end

	local launchExperienceEventContext = props.launchExperienceEventContext
		or DiscoveryAnalytics.Constants.Context.ExperienceTile

	local v50 = React.useCallback(function()
		if props.adId then
			sponsoredGamesRecordClick(v30, props.adId)
		end
	end, { v30, props.adId })

	local reportExperienceLaunched2 = React.useCallback(function(p: string?)
		if v31 then
			SetGamePlaySession(v31, SessionType.StructuralIdentifier.GamePlayFromHoverTile, true)
		end

		if isHovered then
			HoverTileCoordinator.default:reset()
		end

		if props.reportExperienceLaunched then
			local v52 = {
				placeId = props.placeId,
				universeId = props.universeId,
				adId = props.adId,
				tileType = GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
				placeIdOverride = props.placeIdOverride,
				launchDataOverride = props.launchDataOverride
			}

			local reportExperienceLaunched = props.reportExperienceLaunched

			local referralSource = props.referralSource

			local index2 = props.index

			if not FFlagLuaAppDemoModePlayButtonTelemetry then
				p = nil
			end

			reportExperienceLaunched(v52, referralSource, "OneByTwoTile", launchExperienceEventContext, index2, p)
		end
	end, {
		v31,
		props.reportExperienceLaunched,
		props.placeId,
		props.universeId,
		props.adId,
		props.placeIdOverride,
		props.launchDataOverride,
		props.referralSource,
		launchExperienceEventContext,
		props.index,
		isHovered
	})

	local useCallback3 = React.useCallback
	local function fn4()
		if ref3.current then
			ref3.current = false
			return
		end

		if isHovered then
			HoverTileCoordinator.default:reset()
		end

		if not state5 or state3 ~= VideoLoadingState.Loaded then
			return
		end

		OneByTwoTileTelemetry.logOneByTwoTileActivated()
		local current = ref5.current
		videoPlaybackCoordinator:reset(VideoEndReason.TileClicked, nil, props.universeId, nil)
		local navigate = v32.navigate
		local featureTileAdPlayer = AppPage.FeatureTileAdPlayer
		local extraProps = {
			videoAssetId = props.primaryVideoAssetId,
			imageAssetId = props.primaryImageAssetId,
			startPlaybackProgress = current,
			attributionThumbnailAssetId = props.attributionThumbnailAssetId,
			videoPlaybackContext = props.videoPlaybackContext,
			title = headline,
			subtitle = subtitle,
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
			source = GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
			launchExperienceEventContext = launchExperienceEventContext,
			reportGameDetailOpened = props.reportGameDetailOpened,
			reportExperienceLaunched = props.reportExperienceLaunched,
			onOpenGameDetails = 0,
			disableGameLaunchSponsoredClickRecording = 0
		}
		local onOpenGameDetails

		if FFlagLuaAppSduiSponsoredOneByTwoTile then
			onOpenGameDetails = props.onOpenGameDetails
		end

		extraProps.onOpenGameDetails = onOpenGameDetails
		local disableGameLaunchSponsoredClickRecording

		if FFlagLuaAppSduiSponsoredOneByTwoTile then
			disableGameLaunchSponsoredClickRecording = props.disableGameLaunchSponsoredClickRecording
		end

		extraProps.disableGameLaunchSponsoredClickRecording = disableGameLaunchSponsoredClickRecording
		navigate(featureTileAdPlayer, { extraProps = extraProps })
	end
	local v52 = {
		isHovered,
		v32,
		videoPlaybackCoordinator,
		props.universeId,
		props.primaryVideoAssetId,
		props.primaryImageAssetId,
		props.attributionThumbnailAssetId,
		props.videoPlaybackContext,
		headline,
		subtitle,
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
	local onOpenGameDetails

	if FFlagLuaAppSduiSponsoredOneByTwoTile then
		onOpenGameDetails = props.onOpenGameDetails
	end

	local v53

	if FFlagLuaAppSduiSponsoredOneByTwoTile then
		v53 = props.disableGameLaunchSponsoredClickRecording
	end

	v52[17], v52[18], v52[19], v52[20], v52[21], v52[22], v52[23], v52[24], v52[25], v52[26], v52[27], v52[28], v52[29] = ctaText, placeId, placeIdOverride, launchDataOverride, referralSource, launchExperienceEventContext, index2, reportGameDetailOpened, reportExperienceLaunched, onOpenGameDetails, v53, state5, state3
	local v54 = useCallback3(fn4, v52)

	local useCallback4 = React.useCallback
	local function fn5()
		OneByTwoTileTelemetry.logOneByTwoTileGameJoinInitiated()
		OneByTwoTileTelemetry.logOneByTwoTileCtaActivated(OneByTwoTileTelemetry.CtaType.GameJoin)

		if FFlagLuaAppSduiSponsoredOneByTwoTile then
			if not props.disableGameLaunchSponsoredClickRecording then
				v50()
			end
		else
			v50()
		end
	end

	local v56

	if FFlagLuaAppSduiSponsoredOneByTwoTile then
		v56 = props.disableGameLaunchSponsoredClickRecording
	end

	local onActivated = useCallback4(fn5, { v50, v56 })

	local useCallback5 = React.useCallback
	local function fn6()
		if not v49 then
			return
		end

		OneByTwoTileTelemetry.logOneByTwoTileCtaActivated(OneByTwoTileTelemetry.CtaType.Clickout)
		v50()

		if FFlagLuaAppAdClickoutEvent then
			local adId = props.adId

			if adId ~= nil and adId ~= "" then
				SponsoredTilesTelemetry.Events.adClickout(
					adId,
					GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
					props.clickoutUrl
				)
			end
		end

		v32.navigate(AppPage.GenericWebPage, {
			detail = props.clickoutUrl,
			extraProps = { showDomainAsTitle = true }
		})
	end

	local clickoutUrl = props.clickoutUrl
	local v59

	if FFlagLuaAppAdClickoutEvent then
		v59 = props.adId
	end

	local v60 = useCallback5(fn6, { v49, v32, clickoutUrl, v50, v59 })

	React.useEffect(function()
		ImpressionsTagUtility.AddTag(ref2, props.impressionsTag, props.index)
		return function()
			ImpressionsTagUtility.RemoveTag(ref2, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local tileBadgesByPosition = useValidTileBadges(props.universeId or "", props.topicId, props.badgeOverride)

	local logoAspectRatio = tonumber(props.logoAspectRatio)
	local aspectRatio = not (logoAspectRatio and logoAspectRatio > 0) and 1 or logoAspectRatio
	local v63 = if aspectRatio == 3 then v else v2
	local v64, v65, v66, v67, size_500, v68, buttonSize, v70, v71

	if v8 then
		v64 = v7.Padding.Medium
		v65 = v7.Typography.TitleLarge
		v66 = v7.Typography.BodySmall
		v67 = v7.Size.Size_600
		size_500 = v7.Size.Size_500
		v68 = v7.Gap.XXSmall
		buttonSize = ButtonSize.Small
		v70 = v7.Size.Size_800
		v71 = v7.Typography.TitleSmall
	else
		v64 = v7.Padding.Large
		v65 = v7.Typography.HeadingMedium
		v66 = v7.Typography.BodyMedium
		v67 = v7.Size.Size_800
		size_500 = v7.Size.Size_500
		v68 = v7.Gap.XSmall
		buttonSize = ButtonSize.Medium
		v70 = v7.Size.Size_1000
		v71 = v7.Typography.TitleMedium
	end

	local createElement = React.createElement
	local size

	if FFlagLuaAppSduiSponsoredOneByTwoTile then
		size = props.rootSize
	end

	local v73 = {
		Size = size,
		LayoutOrder = props.index,
		ZIndex = props.zIndex,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = ref2
	}

	local createElement2 = React.createElement
	local v77 = {
		ref = ref,
		Size = props.size or UDim2.fromScale(1, 1),
		BackgroundColor3 = v7.Color.Surface.Surface_100.Color3,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Text = "",
		AutoButtonColor = false,
		SelectionOrder = props.SelectionOrder,
		[React.Event.Activated] = v54,
		[React.Event.TouchLongPress] = v25,
		[React.Event.SelectionGained] = v22,
		[React.Event.SelectionLost] = v23,
		[React.Change.GuiState] = v21
	}
	local children = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v7.Radius.Medium) }),
		Video = 0,
		GradientOverlayBottom = 0,
		TileBadge = 0,
		Logo = 0,
		OverflowMenu = 0,
		BottomStack = 0
	}

	local createElement3 = React.createElement
	local v78 = {
		video = `rbxassetid://{props.primaryVideoAssetId}`,
		thumbnail = `rbxassetid://{props.primaryImageAssetId}`,
		shouldStartPlayback = state4,
		loadImmediately = state5 and state3 ~= VideoLoadingState.Failed,
		muted = true,
		looped = not FFlagLuaAppOneByTwoHoverIdleAutoplay or (not v19 or isHovered),
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Crop,
		cornerRadius = v7.Radius.Medium,
		ZIndex = 0,
		onVideoLoaded = onVideoLoaded,
		onLoadingStateChanged = onLoadingStateChanged,
		onVideoEnded = 0,
		onVideoLooped = 0,
		onVideoProgressChanged = 0,
		videoPlaybackStateRef = 0
	}

	if not (FFlagLuaAppOneByTwoHoverIdleAutoplay and v19) then
		onVideoEnded = nil
	end

	v78.onVideoEnded = onVideoEnded

	v78.onVideoLooped = onVideoLooped
	v78.onVideoProgressChanged = onVideoProgressChanged

	if not isSponsored then
		ref4 = nil
	end

	v78.videoPlaybackStateRef = ref4
	children.Video = createElement3(VideoDisplay, v78)

	children.GradientOverlayBottom = React.createElement("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v7.Color.Extended.Black.Black_100.Color3,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 1
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v7.Radius.Medium) }),
		UIGradientBottom = React.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, v5),
				NumberSequenceKeypoint.new(1 - v6, v5),
				NumberSequenceKeypoint.new(1, v4)
			})
		})
	})
	local tileBadge

	if tileBadgesByPosition then
		local createElement4 = React.createElement
		local v81 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2 }

		local createElement5 = React.createElement
		local padding

		if FFlagLuaAppSponsoredTileBadgeContentPadding then
			padding = v64
		end

		tileBadge = createElement4("Frame", v81, {
			Badge = createElement5(GameTileThumbnailBadges, {
				tileBadgesByPosition = tileBadgesByPosition,
				padding = padding
			})
		})
	end

	children.TileBadge = tileBadge
	local logo

	if props.logoImageAssetId then
		logo = React.createElement(Image, {
			Image = `rbxassetid://{props.logoImageAssetId}`,
			Position = UDim2.new(1, -v7.Padding.Medium, 0, v7.Padding.Medium),
			tag = "anchor-top-right",
			Size = UDim2.new(v63, 0, 1, 0),
			aspectRatio = aspectRatio,
			ZIndex = 2
		})
	end

	children.Logo = logo
	local overflowMenu

	if FFlagLuaAppSduiSponsoredOneByTwoTile and props.renderOverflowMenu then
		overflowMenu = props.renderOverflowMenu({
			isHovered = isHovered,
			isSelected = state,
			menuKey = hoverKey,
			parentRef = ref
		})
	else
		local createElement4 = React.createElement
		local v82 = {
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
			isSponsored = isSponsored,
			contentType = props.contentType,
			setGameHidden = 0,
			isHovered = 0,
			isSelected = 0,
			availableMenuItems = 0
		}
		local setGameHidden

		if FFlagLuaAppSduiSponsoredOneByTwoTile then
			setGameHidden = props.setGameHidden or function() end
		else
			setGameHidden = props.setGameHidden
		end

		v82.setGameHidden = setGameHidden

		v82.isHovered = isHovered
		v82.isSelected = state
		v82.availableMenuItems = availableMenuItems
		overflowMenu = createElement4(SpanTileOverflowMenu, v82)
	end

	children.OverflowMenu = overflowMenu

	local createElement4 = React.createElement
	local v83 = {
		Size = UDim2.new(1, -2 * v64, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, v64, 1, -v64),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local v84 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v64)
		}),
		TextStack = 0,
		CtaButton = 0
	}

	local createElement5 = React.createElement
	local v86 = {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v87 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v68)
		}),
		Headline = 0,
		Subtitle = 0
	}
	local headline2

	if headline then
		local createElement6 = React.createElement
		local v90 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 2 * v67),
			BackgroundTransparency = 1,
			Text = headline,
			Font = 0,
			FontFace = 0,
			LineHeight = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = true,
			TextTruncate = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v65.Font
		end

		v90.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v65.Font)
		end

		v90.FontFace = fontFace

		v90.LineHeight = v65.LineHeight
		v90.TextSize = v65.FontSize
		v90.TextColor3 = v7.LightMode.ActionOverMedia.Foreground.Color3
		v90.TextXAlignment = Enum.TextXAlignment.Left
		v90.TextYAlignment = Enum.TextYAlignment.Bottom

		v90.TextTruncate = Enum.TextTruncate.AtEnd
		headline2 = createElement6("TextLabel", v90)
	end

	v87.Headline = headline2
	local subtitle2

	if subtitle then
		local createElement6 = React.createElement
		local v91 = {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, size_500),
			BackgroundTransparency = 1,
			Text = subtitle,
			Font = 0,
			FontFace = 0,
			LineHeight = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = false,
			TextTruncate = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v66.Font
		end

		v91.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v66.Font)
		end

		v91.FontFace = fontFace

		v91.LineHeight = v66.LineHeight
		v91.TextSize = v66.FontSize
		v91.TextColor3 = v7.LightMode.ActionOverMedia.Foreground.Color3
		v91.TextXAlignment = Enum.TextXAlignment.Left
		v91.TextYAlignment = Enum.TextYAlignment.Top

		v91.TextTruncate = Enum.TextTruncate.AtEnd
		subtitle2 = createElement6("TextLabel", v91)
	end

	v87.Subtitle = subtitle2
	v84.TextStack = createElement5("Frame", v86, v87)
	local ctaButton

	if v10 then
		if v49 then
			local createElement6 = React.createElement
			local v92 = {}
			v92.LayoutOrder = 2
			v92.Size = UDim2.fromOffset(0, v70)
			v92.AutomaticSize = Enum.AutomaticSize.X
			v92.BackgroundColor3 = v7.Color.Extended.White.White_20.Color3
			v92.BackgroundTransparency = v7.Color.Extended.White.White_20.Transparency
			v92.BorderSizePixel = 0
			v92.Text = v48
			v92.TextColor3 = v7.LightMode.ActionOverMedia.Foreground.Color3
			local font

			if not FoundationFontFaceMigration then
				font = v71.Font
			end

			v92.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(v71.Font)
			end

			v92.FontFace = fontFace

			v92.TextSize = v71.FontSize
			v92[React.Event.Activated] = v60
			ctaButton = createElement6("TextButton", v92, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v7.Radius.Medium)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v7.Padding.Large),
					PaddingRight = UDim.new(0, v7.Padding.Large)
				})
			})
		end
	elseif props.universeId then
		local createElement6 = React.createElement
		local v91 = {
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
		local placeId2

		if props.placeIdOverride then
			placeId2 = props.placeIdOverride
		else
			placeId2 = props.placeId
		end

		v91.placeId = placeId2
		v91.referralSource = props.referralSource
		v91.eventContext = launchExperienceEventContext

		v91.playableText = v48

		v91.buttonSize = buttonSize

		v91.onActivated = onActivated
		v91.reportExperienceLaunched = reportExperienceLaunched2
		v91.experienceJoinData = {
			launchData = props.launchDataOverride,
			tileType = GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
			nativeAdData = props.adId
		}
		ctaButton = createElement6(PlayButton, v91)
	end

	v84.CtaButton = ctaButton
	children.BottomStack = createElement4("Frame", v83, v84)
	local element = createElement("Frame", v73, {
		Container = createElement2("TextButton", v77, children)
	})
	local v91

	if FFlagLuaAppOneByTwoHoverIdleAutoplay or FFlagLuaAppGameTileSelectionVideoPlayback then
		v91 = getPlaybackDetectionMethod(v9, isHoverSupported)
	end

	local createElement6 = React.createElement
	local fragment = React.Fragment
	local videoPlaybackDetector

	if not (v27 or FFlagLuaAppSuppressVideoDetectorDuringScroll and v28) then
		local createElement7 = React.createElement

		if not FFlagLuaAppOneByTwoHoverIdleAutoplay then
			videoKey = hoverKey
		end

		local v95 = {
			videoKey = videoKey,
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
		local playbackDetectionMethod

		if FFlagLuaAppGameTileSelectionVideoPlayback or FFlagLuaAppOneByTwoHoverIdleAutoplay then
			playbackDetectionMethod = v91
		end

		v95.playbackDetectionMethod = playbackDetectionMethod

		if FFlagLuaAppGameTileSelectionVideoPlayback then
			isHoverSupported = nil
		end

		v95.isHoverSupported = isHoverSupported
		v95.autoplay = not FFlagLuaAppGameTileSelectionVideoPlayback or nil
		v95.isHovered = isHovered
		local hasVideoPlaybackUserIntent

		if FFlagLuaAppOneByTwoHoverIdleAutoplay and v91 == VideoPlaybackDetectionMethod.Hover then
			hasVideoPlaybackUserIntent = isHovered
		end

		v95.hasVideoPlaybackUserIntent = hasVideoPlaybackUserIntent

		v95.onPlaybackChange = setState4
		v95.videoAnalytics = props.videoAnalytics
		v95.videoDwellTimeInSec = FIntLuaAppGameTileVideoDwellTimeInSec
		v95.videoVisiblePercent = FIntLuaAppGameTileVideoVisiblePercent
		v95.videoPlaybackCoordinator = videoPlaybackCoordinator
		local viewportVideoAutoplayController2

		if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			viewportVideoAutoplayController2 = viewportVideoAutoplayController
		elseif props.videoPlaybackContext then
			viewportVideoAutoplayController2 = props.videoPlaybackContext.viewportVideoAutoplayController
		end

		v95.viewportVideoAutoplayController = viewportVideoAutoplayController2

		v95.isVideoEligible = state5
		v95.onPlaybackCandidate = onPlaybackCandidate
		videoPlaybackDetector = createElement7(VideoPlaybackDetector, v95)
	end

	return createElement6(fragment, nil, {
		Tile = element,
		VideoPlaybackDetector = videoPlaybackDetector
	})
end

return React.memo(OneByTwoTile)
