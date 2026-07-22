local ContentProvider = game:GetService("ContentProvider")
local GameTile = script:FindFirstAncestor("GameTile")
local GridTileIconTextFooter = require(GameTile.Footer.GridTileIconTextFooter)
local GridTileFriendFooter = require(GameTile.Footer.GridTileFriendFooter).GridTileFriendFooter
local GridTileTextFooter = require(GameTile.Footer.GridTileTextFooter)
local GameStats = require(GameTile.Footer.GameStats)
local GridTileSponsoredFooter = require(GameTile.Footer.GridTileSponsoredFooter)
local RatingWithGenreFooter = require(GameTile.Footer.RatingWithGenreFooter)
local GameTileThumbnailBadges = require(GameTile.Overlays.GameTileThumbnailBadges)
local sortFriendsByPresenceAndRecencyFactory = require(GameTile.sortFriendsByPresenceAndRecencyFactory)
local OpenCentralOverlayForPlacesList = require(GameTile.OpenCentralOverlayForPlacesList)
local GameTileView = require(GameTile.GameTileView)
local AppExperienceActionRow = require(GameTile.AppExperienceActionRow)
local GameTileConstants = require(GameTile.GameTileConstants)
local OpenSponsoredTooltip = require(GameTile.OpenSponsoredTooltip)
local GameTileTypes = require(GameTile.GameTileTypes)
local useIsHoveredTile = require(GameTile.useIsHoveredTile)
local HoverTileCoordinator = require(GameTile.HoverTileCoordinator)
local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local GameTileViewConfig = require(GameTile.GameTileViewConfig)
local useHasInGameFriends = require(GameTile.useHasInGameFriends)
local useInGameUserIds = require(GameTile.useInGameUserIds)
local useValidTileBadges = require(GameTile.Overlays.useValidTileBadges)
local GameTileVideoThumbnail = require(GameTile.GameTileVideoThumbnail)
local VideoEndReason = require(GameTile.Video.Analytics.VideoEndReason)
local GameVideoPlaybackDetector = require(GameTile.Video.GameVideoPlaybackDetector)
local useHasVideoThumbnailSelector = require(GameTile.Video.useHasVideoThumbnailSelector)
local formatExperienceIcon = require(GameTile.formatExperienceIcon)
local formatExperienceRating = require(GameTile.formatExperienceRating)
local formatExperienceThumbnail = require(GameTile.formatExperienceThumbnail)
local HiddenTileContent = require(GameTile.HiddenGameTile.HiddenTileContent)
local ItemLayoutDataParsingUtils = require(GameTile.ItemLayoutDataParsingUtils)
local GameTileParent = GameTile.Parent
local GameCollectionItemTypes = require(GameTileParent.DiscoveryTypes).GameCollectionItemTypes
local AppBlox = require(GameTileParent.AppBlox)
local React = require(GameTileParent.React)
local Roact = require(GameTileParent.Roact)
local RoactRodux = require(GameTileParent.RoactRodux)
local Cryo = require(GameTileParent.Cryo)
local RoactServices = require(GameTileParent.RoactServices).RoactServices
local RoactNetworking = require(GameTileParent.RoactServiceTags).RoactNetworking
local VideoUtils = require(GameTileParent.VideoUtils)
local t = require(GameTileParent.t)
local UIBlox = require(GameTileParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(GameTileParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local AspectRatioModeEnum = UIBlox.App.Tile.AspectRatioModeEnum
local ImpressionsTagUtility = require(GameTileParent.Impressions).ImpressionsTagUtility
local useUiModeInfo = require(GameTileParent.RobloxAppHooks).useUiModeInfo
local useRoactService = require(GameTileParent.RobloxAppHooks).useRoactService
local UiMode = require(GameTileParent.RobloxAppEnums).UiMode
local memoize = require(GameTileParent.AppCommonLib).memoize
local IntervalPerformanceTracker = require(GameTileParent.IntervalPerformanceTracker).IntervalPerformanceTracker
local GameIconReducer = require(GameTileParent.GameIconRodux).GameIcons.GameIconReducer
local GameInfosReducer = require(GameTileParent.GameInfosRodux).GameInfosReducer
local useSelector = require(GameTileParent.RoactUtils).Hooks.RoactRodux.useSelector
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local useTriggerFeedback = require(GameTileParent.InteractionFeedback).useTriggerFeedback
local DiscoveryAnalytics = require(GameTileParent.DiscoveryAnalytics)
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local Responsive = require(GameTileParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate
local DiscoveryAppLaunchTracker = require(GameTileParent.AppLaunchTracker).DiscoveryAppLaunchTracker
local GetFFlagEnableNavigationPerformanceIntervals = require(GameTileParent.SharedFlags).GetFFlagEnableNavigationPerformanceIntervals
local FFlagLuaAppGameTileInteractionFeedback = require(GameTileParent.SharedFlags).FFlagLuaAppGameTileInteractionFeedback
local FFlagLuaAppMigrateGameTileHoverFixes = require(GameTileParent.SharedFlags).FFlagLuaAppMigrateGameTileHoverFixes
local FFlagLuaAppMigrateGameTileFixConsoleMetadataText = require(GameTileParent.SharedFlags).FFlagLuaAppMigrateGameTileFixConsoleMetadataText
local FFlagLuaAppUnifyPlayButtonTile = require(GameTileParent.SharedFlags).FFlagLuaAppUnifyPlayButtonTile
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(GameTileParent.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppEdpMediaGalleryFullScreen = require(GameTileParent.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FFlagLuaAppGameDetailsAttributionFix = require(GameTileParent.SharedFlags).FFlagLuaAppGameDetailsAttributionFix
local v77 = game:DefineFastFlag("LuaAppUseRatingFormatHelper2", false)
local FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix = require(GameTileParent.SharedFlags).FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix
local FFlagLuaAppGameTileOverflowMenuTelemetry = require(GameTileParent.SharedFlags).FFlagLuaAppGameTileOverflowMenuTelemetry
local FFlagLuaAppHapticTriggeredTelemetry = require(GameTileParent.SharedFlags).FFlagLuaAppHapticTriggeredTelemetry
local FFlagLuaAppFixExplicitFeedbackTelemetry = require(GameTileParent.SharedFlags).FFlagLuaAppFixExplicitFeedbackTelemetry
local FFlagLuaAppEnableSponsoredReportAd = require(GameTileParent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppSupportSponsoredExplicitFeedback = require(GameTileParent.SharedFlags).FFlagLuaAppSupportSponsoredExplicitFeedback
local FFlagLuaAppTileVideoDeviceMemoryBlocking = require(GameTileParent.SharedFlags).FFlagLuaAppTileVideoDeviceMemoryBlocking
local FFlagLuaAppFixTwoByOneOverflowMenuTelemetry = require(GameTileParent.SharedFlags).FFlagLuaAppFixTwoByOneOverflowMenuTelemetry
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(GameTileParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppNarrowTileSmallerFooterFont = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont
local FFlagLuaAppNarrowTileHideRating = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileHideRating
local FFlagLuaAppNarrowTileHidePlayerCount = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
local FIntLuaAppGameTileVideoDwellTimeInSec = require(GameTileParent.SharedFlags).FIntLuaAppGameTileVideoDwellTimeInSec
local FIntLuaAppGameTileVideoVisiblePercent = require(GameTileParent.SharedFlags).FIntLuaAppGameTileVideoVisiblePercent
local FFlagLuaAppTileVideoCandidateOnly = require(GameTileParent.SharedFlags).FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppVideoTileDisableActivation = require(GameTileParent.SharedFlags).FFlagLuaAppVideoTileDisableActivation
local FFlagLuaAppFixHiddenTileVideoCleanup = require(GameTileParent.SharedFlags).FFlagLuaAppFixHiddenTileVideoCleanup
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(GameTileParent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
local v96 = game:DefineFastFlag("LuaAppStabilizeVideoTileReactRoot", false)
local FFlagLuaAppHomeReduceRenders = require(GameTileParent.SharedFlags).FFlagLuaAppHomeReduceRenders
local FFlagLuaAppGenreRatingFooter = require(GameTileParent.SharedFlags).FFlagLuaAppGenreRatingFooter
local FFlagLuaAppGameTileSelectionVideoPlayback = require(GameTileParent.SharedFlags).FFlagLuaAppGameTileSelectionVideoPlayback
local VideoPlaybackCoordinator = require(GameTileParent.VideoUtils).VideoPlaybackCoordinator
local GameTileOverflowMenu = require(GameTile.GameTileOverflowMenu)
local getAvailableGameTileOverflowMenuItems = require(GameTile.getAvailableGameTileOverflowMenuItems)
local t1 = {}

game:DefineFastInt("LuaAppGameTileHoverDelayMs", 130)

local function getHoverDelay() -- line: 135
	return game:GetFastInt("LuaAppGameTileHoverDelayMs") / 1000
end

local v105 = Roact.PureComponent:extend("AppGameTile")

v105.validateProps = t.strictInterface({
	entry = t.table,
	reportGameDetailOpened = t.callback,
	reportExperienceLaunched = t.optional(t.callback),
	Size = t.optional(t.union(t.UDim2, t.table)),
	ZIndex = t.optional(t.number),
	useHoverTile = t.optional(t.boolean),
	hasBackground = t.boolean,
	useGridTile = t.boolean,
	playerCountStyle = t.optional(t.string),
	isSponsoredFooterAllowed = t.optional(t.boolean),
	isSponsoredRatingFooterAllowed = t.optional(t.boolean),
	useExperienceTileMetadata = t.boolean,
	hideGameStats = t.optional(t.boolean),
	gameTileLayoutType = t.optional(t.string),
	topicId = t.optional(t.string),
	playButtonStyle = t.optional(t.string),
	onGuiStateChanged = if not FFlagLuaAppGameTileInteractionFeedback then nil else t.optional(t.callback),
	isDisabled = t.optional(t.boolean),
	onActivated = if not FFlagLuaAppGameTileInteractionFeedback then nil else t.optional(t.callback),
	onSelectionGained = if not FFlagLuaAppGameTileSelectionVideoPlayback then t.optional(t.callback) else t.callback,
	onSelectionLost = if not FFlagLuaAppGameTileSelectionVideoPlayback then t.optional(t.callback) else t.callback,
	friendFooterEnabled = t.optional(t.boolean),
	index = t.optional(t.number),
	layoutOrder = t.optional(t.number),
	source = t.optional(t.string),
	referralSource = t.optional(t.string),
	onPeekViewClosed = t.optional(t.callback),
	rowNum = t.optional(t.number),
	showFriendActivity = t.boolean,
	contentTextLineCount = t.optional(t.number),
	metadataTextLineCount = t.optional(t.number),
	thumbnailAspectRatioOverride = t.optional(t.string),
	impressionsTag = t.optional(t.string),
	launchExperienceEventContext = t.optional(t.string),
	navigateToGameDetails = t.callback,
	isContained = t.optional(t.boolean),
	hideTitle = t.optional(t.boolean),
	hideMetadata = t.optional(t.boolean),
	textSizeOffset = t.optional(t.number),
	foundationTokens = t.optional(t.table),
	videoAnalytics = t.optional(t.table),
	hasPrevalidatedVideoGamePlayability = if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t.optional(t.boolean),
	videoPlaybackContext = t.optional(t.table),
	SelectionOrder = t.optional(t.number),
	enableExplicitFeedback = t.optional(t.boolean),
	setGameHidden = t.optional(t.callback),
	appPage = t.optional(t.string),
	isHidden = t.optional(t.boolean),
	isNarrowScreenXSmall = t.optional(t.boolean),
	onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t.optional(t.callback),
	sponsoredUserCohort = t.optional(t.string),
	enableSponsoredFeedback = t.optional(t.boolean),
	availableMenuItems = t.optional(t.table),
	enableReportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else t.optional(t.boolean),
	compactMetadataFormat = if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else t.optional(t.boolean),
	hideRating = if not FFlagLuaAppNarrowTileHideRating then nil else t.optional(t.boolean),
	hidePlayerCount = if not FFlagLuaAppNarrowTileHidePlayerCount then nil else t.optional(t.boolean),
	game = t.optional(t.table),
	universeId = t.string,
	navigationUniverseId = t.optional(t.string),
	name = t.string,
	totalUpVotes = t.number,
	totalDownVotes = t.number,
	friendActivityTitle = t.optional(t.string),
	friendVisitedString = t.optional(t.string),
	imageThumbnail = t.string,
	wideThumbnail = t.optional(t.string),
	videoThumbnail = t.optional(t.string),
	rating = t.optional(t.string),
	showAgeRating = t.optional(t.boolean),
	ageRatingText = t.optional(t.string),
	friendVisits = t.table,
	hidePlayButton = t.boolean,
	footerLayoutData = t.optional(t.table),
	openContextualMenu = t.callback,
	openSponsoredTooltip = t.callback,
	networking = t.callback,
	hoverRef = t.table,
	isHoverSupported = t.optional(t.boolean),
	isHovered = t.optional(t.boolean),
	isSelected = if not FFlagLuaAppGameTileSelectionVideoPlayback then nil else t.boolean,
	isVideoPlaying = t.boolean,
	tileBadges = t.optional(t.table),
	users = t.optional(t.table),
	inGameUsersByGame = t.optional(t.table),
	hasInGameFriends = t.boolean,
	inGameUserIds = if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then nil else t.table,
	badgeOverride = t.optional(t.table),
	forceHideAgeRatings = t.optional(t.boolean),
	onGameTileActivated = if not FFlagLuaAppGameDetailsAttributionFix then nil else t.optional(t.callback),
	recordSponsoredGameClick = if not FFlagLuaAppGameDetailsAttributionFix then nil else t.optional(t.callback),
	overflowMenuOpen = t.optional(t.boolean),
	hoverKey = t.optional(t.string),
	triggerFeedback = t.callback,
	videoPlaybackDetector = if not v96 then nil else t.optional(t.table)
})

local Narrow = GameTileTypes.GameTileLayoutType.Narrow

v105.defaultProps = {
	useHoverTile = false,
	hasBackground = false,
	useExperienceTileMetadata = false,
	useGridTile = false,
	hideGameStats = false,
	thumbnailAspectRatioOverride = AspectRatioModeEnum.Square,
	gameTileLayoutType = Narrow,
	contentTextLineCount = GameTileConstants.TileTextLines[Narrow].titleTextLines
}

function v105.init(p1) -- line: 264
	-- upvalues: DiscoveryAppLaunchTracker (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), gameTileOverflowMenuAction (copy), FFlagLuaAppFixTwoByOneOverflowMenuTelemetry (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), getOverflowMenuSignalStore (copy), FFlagLuaAppGameDetailsAttributionFix (copy), HoverTileCoordinator (copy), VideoEndReason (copy), VideoPlaybackCoordinator (copy), Roact (copy), AppExperienceActionRow (copy), FFlagLuaAppUnifyPlayButtonTile (copy), sponsoredGamesRecordClick (copy), FFlagLuaAppGameTileInteractionFeedback (copy), GameCollectionItemTypes (copy), GetFFlagEnableNavigationPerformanceIntervals (copy), IntervalPerformanceTracker (copy), Responsive (copy), ContentProvider (copy), FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix (copy), memoize (copy), sortFriendsByPresenceAndRecencyFactory (copy)
	if DiscoveryAppLaunchTracker.isEnabled() and DiscoveryAppLaunchTracker.default then
		DiscoveryAppLaunchTracker.default:trackTileInit()
	end

	p1.state = {
		isHovered = false,
		canDisplayFriendFooter = false,
		isSelected = not not FFlagLuaAppGameTileSelectionVideoPlayback and nil
	}
	p1.onMenuOpenChanged = if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else function(b1: boolean, s1: string?) -- line: 276
		-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), p1 (copy), gameTileOverflowMenuAction (copy), FFlagLuaAppFixTwoByOneOverflowMenuTelemetry (copy)
		local t2 = {
			ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then p1.props.appPage else nil,
			universeId = p1.props.universeId,
			sortId = p1.props.topicId,
			actionType = not b1 and "GameTileOverflowMenuOpened" or "GameTileOverflowMenuClosed",
			availableMenuItems = s1
		}

		gameTileOverflowMenuAction(t2, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else p1.props.appPage or if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then nil else "Unknown")
	end

	function p1.onTouchLongPress() -- line: 296
		-- upvalues: p1 (copy), FFlagLuaAppHapticTriggeredTelemetry (copy), FFlagLuaAppFixTwoByOneOverflowMenuTelemetry (copy), getOverflowMenuSignalStore (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy)
		if next(p1.props.availableMenuItems) ~= nil then
			if p1.props.triggerFeedback and not p1.props.overflowMenuOpen then
				local v226 = if not FFlagLuaAppHapticTriggeredTelemetry then nil else {
					universeId = p1.props.universeId,
					sortId = p1.props.topicId
				}

				p1.props.triggerFeedback("TileLongPress", "Press", if not FFlagLuaAppHapticTriggeredTelemetry then nil else p1.props.appPage or if not FFlagLuaAppFixTwoByOneOverflowMenuTelemetry then nil else "Unknown", if not FFlagLuaAppHapticTriggeredTelemetry then nil else v226)
			end

			getOverflowMenuSignalStore().openMenu(p1.props.hoverKey)

			if FFlagLuaAppGameTileOverflowMenuTelemetry then
				local t3 = {}

				for v228, _ in p1.props.availableMenuItems do
					table.insert(t3, v228)
				end

				p1.onMenuOpenChanged(false, table.concat(t3, ","))
			end
		end
	end
	function p1.reportExperienceLaunchedFromActionBar(...) -- line: 330
		-- upvalues: FFlagLuaAppGameDetailsAttributionFix (copy), p1 (copy), HoverTileCoordinator (copy), VideoEndReason (copy), VideoPlaybackCoordinator (copy)
		if FFlagLuaAppGameDetailsAttributionFix then
			p1.props.recordSponsoredGameClick()
		else
			p1.recordSponsoredGameClick()
		end

		if p1.props.isHovered then
			HoverTileCoordinator.default:reset()
		end

		if p1.props.reportExperienceLaunched then
			p1.props.reportExperienceLaunched(...)
		end

		if p1.props.videoPlaybackContext and p1.props.videoPlaybackContext.videoPlaybackCoordinator then
			p1.props.videoPlaybackContext.videoPlaybackCoordinator:reset(VideoEndReason.ExperienceLaunched, nil, p1.props.navigationUniverseId, nil)

			return
		end

		VideoPlaybackCoordinator.default:reset(VideoEndReason.ExperienceLaunched, nil, p1.props.navigationUniverseId, nil)
	end
	function p1.renderAppExperienceActionRow(_) -- line: 363
		-- upvalues: Roact (copy), AppExperienceActionRow (copy), p1 (copy), FFlagLuaAppGameDetailsAttributionFix (copy), FFlagLuaAppUnifyPlayButtonTile (copy)
		return Roact.createElement(AppExperienceActionRow, {
			launchSource = "ExperienceTile",
			universeId = p1.props.navigationUniverseId,
			referralSource = p1.props.referralSource,
			reportExperienceLaunched = p1.reportExperienceLaunchedFromActionBar,
			openGameDetails = if not FFlagLuaAppGameDetailsAttributionFix then p1.onActivated else function() -- line: 370
				-- upvalues: p1 (copy)
				p1.props.onGameTileActivated(p1.isMounted)
			end,
			entry = p1.props.entry,
			launchExperienceEventContext = p1.props.launchExperienceEventContext,
			horizontalPadding = if not p1.props.useGridTile then nil else 0,
			index = p1.props.index,
			isUnifiedGameTileEnabled = not not FFlagLuaAppUnifyPlayButtonTile or nil,
			placeIdOverride = p1.props.entry.placeIdOverride,
			launchDataOverride = p1.props.entry.launchDataOverride
		})
	end
	function p1.onHoverChanged(p3) -- line: 384
		-- upvalues: p1 (copy)
		if p3 and p1.props.triggerFeedback then
			p1.props.triggerFeedback("Default", "Hover")
		end

		p1:setState({
			isHovered = p3
		})
	end

	p1.gameTileRef = Roact.createRef()

	function p1.getTilePosition() -- line: 396
		-- upvalues: p1 (copy)
		if p1.gameTileRef.current then
			return p1.gameTileRef.current.AbsolutePosition
		end

		return nil
	end
	function p1.getTileSize() -- line: 404
		-- upvalues: p1 (copy)
		if p1.gameTileRef.current then
			return p1.gameTileRef.current.AbsoluteSize
		end

		return nil
	end

	p1.recordSponsoredGameClick = not FFlagLuaAppGameDetailsAttributionFix and function() -- line: 414
		-- upvalues: p1 (copy), sponsoredGamesRecordClick (copy)
		local networking = p1.props.networking
		local entry = p1.props.entry

		if entry.isSponsored then
			sponsoredGamesRecordClick(networking, entry.adId)
		end
	end or nil
	p1.onActivated = not FFlagLuaAppGameDetailsAttributionFix and function() -- line: 425
		-- upvalues: p1 (copy), HoverTileCoordinator (copy), VideoEndReason (copy), VideoPlaybackCoordinator (copy), FFlagLuaAppGameTileInteractionFeedback (copy), GameCollectionItemTypes (copy), GetFFlagEnableNavigationPerformanceIntervals (copy), IntervalPerformanceTracker (copy)
		if p1.props.isHovered then
			HoverTileCoordinator.default:reset()
		end

		if p1.props.videoPlaybackContext and p1.props.videoPlaybackContext.videoPlaybackCoordinator then
			p1.props.videoPlaybackContext.videoPlaybackCoordinator:reset(VideoEndReason.TileClicked, nil, p1.props.navigationUniverseId, nil)
		else
			VideoPlaybackCoordinator.default:reset(VideoEndReason.TileClicked, nil, p1.props.navigationUniverseId, nil)
		end

		if p1.isMounted then
			if FFlagLuaAppGameTileInteractionFeedback and p1.props.onActivated then
				p1.props.onActivated()
			end

			local navigationUniverseId = p1.props.navigationUniverseId
			local t4 = {
				source = p1.props.source,
				index = p1.props.index,
				referralSource = p1.props.referralSource,
				onPeekViewClosed = p1.props.onPeekViewClosed,
				placeIdOverride = p1.props.entry.placeIdOverride,
				experienceJoinData = {
					launchData = if not p1.props.entry.launchDataOverride then nil else p1.props.entry.launchDataOverride,
					tileType = p1.props.entry.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile,
					nativeAdData = p1.props.entry.adId
				}
			}

			if GetFFlagEnableNavigationPerformanceIntervals() then
				IntervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
			end

			p1.props.navigateToGameDetails(navigationUniverseId, t4)

			local index = p1.props.index

			p1.props.reportGameDetailOpened(index, navigationUniverseId)
			p1.recordSponsoredGameClick()
		end
	end or nil

	function p1.onFriendFooterActivated() -- line: 482
		-- upvalues: p1 (copy)
		if p1.isMounted then
			local game2 = p1.props.game
			local v238 = p1.getTileSize()

			p1.props.openContextualMenu(game2, v238, p1.getTilePosition())
		end
	end
	function p1.onActivateSponsoredTooltip() -- line: 490
		-- upvalues: p1 (copy), Responsive (copy)
		if p1.isMounted then
			p1.props.openSponsoredTooltip(Responsive.GetInputModeStore(false).getLastInputType(false))
		end
	end
	function p1.loadWideThumbnail() -- line: 498
		-- upvalues: p1 (copy), ContentProvider (copy)
		local wideThumbnail = p1.props.wideThumbnail

		if wideThumbnail ~= nil then
			task.spawn(function() -- line: 501
				-- upvalues: ContentProvider (copy), wideThumbnail (copy)
				ContentProvider:PreloadAsync({ wideThumbnail })
			end)
		end
	end
	function p1.getVisitedFriends() -- line: 507
		-- upvalues: p1 (copy), FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix (copy)
		local t5 = {}
		local friendVisits = p1.props.friendVisits

		for i = 1, #friendVisits do
			local str = tostring(friendVisits[i].userId)

			if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
				table.insert(t5, str)
			elseif p1.props.users and p1.props.users[str] then
				local v244 = p1.props.users[str]

				table.insert(t5, {
					userId = str,
					displayName = v244.displayName
				})
			end
		end

		return t5
	end

	p1.getSortedFriends = memoize(function(p4, p5) -- line: 535
		-- upvalues: sortFriendsByPresenceAndRecencyFactory (copy)
		if not p4 or not p5 then
			return {}
		end

		local t6 = {}

		for _, v in pairs(p5) do
			local v250 = p4[v]

			if v250 and v250.isFriend then
				table.insert(t6, {
					userId = v250.id,
					displayName = v250.displayName
				})
			end
		end

		local v251 = sortFriendsByPresenceAndRecencyFactory("displayName")

		table.sort(t6, v251)

		return t6
	end)

	function p1.onSelectionGained() -- line: 557
		-- upvalues: FFlagLuaAppGameTileSelectionVideoPlayback (copy), p1 (copy)
		if not FFlagLuaAppGameTileSelectionVideoPlayback then
			p1:setState({
				isSelected = true
			})
		end

		if p1.props.onSelectionGained or FFlagLuaAppGameTileSelectionVideoPlayback then
			p1.props.onSelectionGained(p1.props.entry, p1.props.index, p1.props.navigationUniverseId)
		end
	end
	function p1.onSelectionLost() -- line: 567
		-- upvalues: FFlagLuaAppGameTileSelectionVideoPlayback (copy), p1 (copy)
		if not FFlagLuaAppGameTileSelectionVideoPlayback then
			p1:setState({
				isSelected = false
			})
		end

		if p1.props.onSelectionLost or FFlagLuaAppGameTileSelectionVideoPlayback then
			p1.props.onSelectionLost()
		end
	end
end

local function getTextLiteralForTextFooter(p6) -- line: 581
	if p6 == nil then
		return nil
	end

	if p6.type ~= "TextLabel" then
		return nil
	end

	local text = p6.text

	if text == nil then
		return nil
	end

	return text.textLiteral
end

local u108 = nil

if FFlagLuaAppGenreRatingFooter then
	function u108(p7) -- line: 597
		if p7 == nil then
			return nil
		end

		if p7.type ~= "RatingWithGenre" then
			return nil
		end

		local genre = p7.genre

		if genre == nil then
			return nil
		end

		return genre.textLiteral
	end
end

function v105.renderGridTilesFooter(p8) -- line: 612
	-- upvalues: FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix (copy), FFlagLuaAppGenreRatingFooter (copy), u108 (ref), FFlagLuaAppGameTileSelectionVideoPlayback (copy), FFlagLuaAppMigrateGameTileFixConsoleMetadataText (copy), GameTileTypes (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), Roact (copy), GameStats (copy), GameTileConstants (copy), FFlagLuaAppNarrowTileHideRating (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), React (copy), GridTileSponsoredFooter (copy), GridTileTextFooter (copy), RatingWithGenreFooter (copy), GridTileFriendFooter (copy), GridTileIconTextFooter (copy), Images (copy)
	local v117 = p8.props.useHoverTile or p8.props.useExperienceTileMetadata
	local friendFooterEnabled = p8.props.friendFooterEnabled
	local hasInGameFriends = p8.props.hasInGameFriends
	local v120 = if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then nil else p8.props.inGameUserIds
	local users = p8.props.users
	local inGameUsersByGame = p8.props.inGameUsersByGame
	local v123 = if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then p8.getSortedFriends(users, inGameUsersByGame) else nil
	local v124 = friendFooterEnabled and if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then hasInGameFriends else v120 and #v120 > 0
	local v125 = p8.props.friendVisits and #p8.props.friendVisits > 0
	local footerLayoutData = p8.props.footerLayoutData
	local v127

	if footerLayoutData == nil then
		v127 = nil
	elseif footerLayoutData.type ~= "TextLabel" then
		v127 = nil
	else
		local text = footerLayoutData.text

		v127 = if text ~= nil then text.textLiteral else nil
	end

	local v129 = nil

	if FFlagLuaAppGenreRatingFooter then
		v129 = u108(p8.props.footerLayoutData)
	end

	local v130 = false

	if (p8.props.isHovered or (if not FFlagLuaAppGameTileSelectionVideoPlayback then p8.state.isSelected else p8.props.isSelected)) and p8.props.ageRatingText and not p8.props.hidePlayButton then
		v127 = p8.props.ageRatingText
		v130 = true
	end

	local v131 = v127 ~= nil
	local v132 = nil

	if FFlagLuaAppGenreRatingFooter then
		v132 = v129 ~= nil
	end

	local entry = p8.props.entry
	local v134 = entry.isSponsored and (entry.isShowSponsoredLabel or (p8.props.isSponsoredFooterAllowed or p8.props.isSponsoredRatingFooterAllowed))

	if FFlagLuaAppMigrateGameTileFixConsoleMetadataText and p8.props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow and p8.props.useExperienceTileMetadata and (v134 or v131 or FFlagLuaAppGenreRatingFooter and v132) or FFlagLuaAppNarrowTileSmallerFooterFont and p8.props.compactMetadataFormat then
		v117 = false
	end

	local v135 = Roact.createElement(GameStats, {
		isUnifiedGameTile = true,
		stats = {
			totalUpVotes = p8.props.totalUpVotes,
			totalDownVotes = p8.props.totalDownVotes,
			playerCount = if p8.props.playerCountStyle ~= GameTileConstants.PlayerCountStyleValues.Footer then nil else p8.props.entry.playerCount
		},
		isGridTile = p8.props.useGridTile,
		hideGameStats = p8.props.hideGameStats,
		useLargerFont = v117,
		gameTileLayoutType = p8.props.gameTileLayoutType,
		compactMetadataFormat = if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else p8.props.compactMetadataFormat,
		hideRating = if not FFlagLuaAppNarrowTileHideRating then nil else p8.props.hideRating,
		hidePlayerCount = if not FFlagLuaAppNarrowTileHidePlayerCount then nil else p8.props.hidePlayerCount
	})

	if p8.props.hideMetadata then
		if p8.props.isHovered then
			if v134 then
				return React.createElement(GridTileSponsoredFooter, {
					isUnifiedGameTile = true,
					useLargerFont = v117,
					onActivateSponsoredTooltip = p8.onActivateSponsoredTooltip,
					gameTileLayoutType = p8.props.gameTileLayoutType,
					isNarrowScreenXSmall = p8.props.isNarrowScreenXSmall,
					enableSponsoredFeedback = p8.props.enableSponsoredFeedback,
					isSponsoredRatingFooterAllowed = p8.props.isSponsoredRatingFooterAllowed,
					gameStatsElement = v135
				})
			end

			if v130 then
				return React.createElement(GridTileTextFooter, {
					isUnifiedGameTile = true,
					text = v127,
					useLargerFont = v117
				})
			end
		end

		return nil
	end

	if v134 then
		return (React.createElement(GridTileSponsoredFooter, {
			isUnifiedGameTile = true,
			useLargerFont = v117,
			onActivateSponsoredTooltip = p8.onActivateSponsoredTooltip,
			gameTileLayoutType = p8.props.gameTileLayoutType,
			isNarrowScreenXSmall = p8.props.isNarrowScreenXSmall,
			enableSponsoredFeedback = p8.props.enableSponsoredFeedback,
			isSponsoredRatingFooterAllowed = p8.props.isSponsoredRatingFooterAllowed,
			gameStatsElement = v135
		}))
	end

	if FFlagLuaAppGenreRatingFooter and v132 and not v130 then
		return (React.createElement(RatingWithGenreFooter, {
			isUnifiedGameTile = true,
			useLargerFont = v117,
			totalUpVotes = p8.props.totalUpVotes,
			totalDownVotes = p8.props.totalDownVotes,
			genreText = v129
		}))
	end

	if v131 then
		return (React.createElement(GridTileTextFooter, {
			isUnifiedGameTile = true,
			text = v127,
			useLargerFont = v117
		}))
	end

	if v124 then
		if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			return (Roact.createElement(GridTileFriendFooter, {
				showOnlineBorder = false,
				useLargerFont = v117,
				friendUserIds = v120,
				onFriendFooterActivated = p8.onFriendFooterActivated
			}))
		end

		return (Roact.createElement(GridTileFriendFooter, {
			showOnlineBorder = false,
			friends = v123,
			useLargerFont = v117
		}))
	end

	if p8.props.friendVisitedString then
		return (Roact.createElement(GridTileIconTextFooter, {
			icon = Images["icons/menu/recent"],
			text = p8.props.friendVisitedString,
			iconSize = not v117 and 24 or 32,
			useLargerFont = v117
		}))
	end

	if v125 then
		if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			return (Roact.createElement(GridTileFriendFooter, {
				showOnlineBorder = false,
				friendUserIds = p8.getVisitedFriends(),
				useLargerFont = v117
			}))
		end

		return (Roact.createElement(GridTileFriendFooter, {
			showOnlineBorder = false,
			friends = p8.getVisitedFriends(),
			useLargerFont = v117
		}))
	end

	return v135
end
function v105.renderContent(p9, p10, p11, _) -- line: 794
	-- upvalues: GameTileConstants (copy), GameTileViewConfig (copy), React (copy), GameStats (copy), HiddenTileContent (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), GameTileVideoThumbnail (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagLuaAppVideoTileDisableActivation (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppGameDetailsAttributionFix (copy), Roact (copy), GameTileThumbnailBadges (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), GameTileOverflowMenu (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), FFlagLuaAppEnableSponsoredReportAd (copy), GameTileView (copy), FFlagLuaAppMigrateGameTileHoverFixes (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FFlagLuaAppGameTileInteractionFeedback (copy), AppExperienceActionRow (copy), FFlagLuaAppUnifyPlayButtonTile (copy), v96 (copy)
	local v140 = p9.props.Size or UDim2.fromScale(1, 1)
	local imageThumbnail = p9.props.imageThumbnail
	local onGameTileActivated = p9.props.onGameTileActivated
	local v143 = p9.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Always or p9.props.isHovered and p9.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Hover
	local v144 = GameTileViewConfig.getImageAspectRatio(p9.props.gameTileLayoutType)
	local v145 = p9:renderGridTilesFooter()
	local v146 = if not p9.props.hideTitle then p9.props.name else nil
	local v147 = if not v143 then nil else React.createElement(GameStats, {
		stats = {
			displayConcurrentUsersPill = true,
			playerCount = p9.props.entry.playerCount
		}
	})
	local playButtonHeight = GameTileViewConfig.getElementSizes(p11.Tokens, p9.props.textSizeOffset, p9.props.contentTextLineCount, p9.props.foundationTokens, true).playButtonHeight
	local v149 = if not p9.props.isHidden then if not p9.props.videoThumbnail then nil else React.createElement(GameTileVideoThumbnail, {
		looped = true,
		ZIndex = -2,
		video = p9.props.videoThumbnail,
		image = imageThumbnail,
		playing = p9.props.isVideoPlaying,
		Size = UDim2.fromScale(1, 1),
		isTileContained = p9.props.isContained,
		cornerRadius = if not FFlagRenameDeprecatedUIBloxTokens then p11.Tokens.Global.Space_100 else p11.Tokens.Size.Size_200,
		onActivated = if not FFlagLuaAppVideoTileDisableActivation then if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else if not FFlagLuaAppGameDetailsAttributionFix then p9.onActivated else function() -- line: 845
			-- upvalues: onGameTileActivated (copy), p9 (copy)
			onGameTileActivated(p9.isMounted)
		end else nil,
		itemIndex = p9.props.index,
		videoAnalytics = p9.props.videoAnalytics,
		universeId = p9.props.universeId,
		videoPlaybackCoordinator = if not p9.props.videoPlaybackContext then nil else p9.props.videoPlaybackContext.videoPlaybackCoordinator
	}) else React.createElement(HiddenTileContent, {
		appPage = p9.props.appPage,
		collectionId = p9.props.topicId,
		setGameHidden = p9.props.setGameHidden,
		universeId = p9.props.universeId,
		parentRef = p9.props.hoverRef,
		isSponsored = if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else p9.props.entry.isSponsored
	})
	local v150 = nil

	if not p9.props.isVideoPlaying then
		v150 = if not p9.props.tileBadges then v147 else Roact.createFragment({
			SocialFeaturePill = v147,
			Badge = React.createElement(GameTileThumbnailBadges, {
				tileBadgesByPosition = p9.props.tileBadges
			})
		})
	end

	local isHidden = p9.props.isHidden
	local v152 = if next(p9.props.availableMenuItems) == nil or (not p9.props.isHovered and (not p9.props.overflowMenuOpen and not (if not FFlagLuaAppGameTileSelectionVideoPlayback then p9.state.isSelected else p9.props.isSelected)) or isHidden) then nil else React.createElement(GameTileOverflowMenu, {
		isHovered = p9.props.isHovered,
		isSelected = if not FFlagLuaAppGameTileSelectionVideoPlayback then p9.state.isSelected else p9.props.isSelected,
		universeId = p9.props.universeId,
		collectionId = p9.props.topicId,
		appPage = p9.props.appPage,
		setGameHidden = p9.props.setGameHidden,
		menuKey = p9.props.hoverKey,
		menuOpen = p9.props.overflowMenuOpen,
		onMenuOpenChanged = if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else p9.onMenuOpenChanged,
		parentRef = p9.props.hoverRef,
		isSponsored = p9.props.entry.isSponsored,
		payerName = p9.props.entry.payerName,
		sponsoredUserCohort = p9.props.sponsoredUserCohort,
		adId = if not FFlagLuaAppEnableSponsoredReportAd then nil else p9.props.entry.adId,
		availableMenuItems = p9.props.availableMenuItems
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v140,
		ZIndex = p9.props.ZIndex,
		LayoutOrder = p9.props.layoutOrder,
		ref = p9.gameTileRef
	}, {
		Tile = React.createElement(GameTileView, {
			isUnifiedGameTile = true,
			SelectionOrder = p9.props.SelectionOrder,
			Selectable = not isHidden,
			hoverPadding = if FFlagLuaAppMigrateGameTileHoverFixes or p9.props.useGridTile then nil else if not FFlagRenameDeprecatedUIBloxTokens then p11.Tokens.Global.Space_100 else p11.Tokens.Size.Size_200,
			numLinesForTitle = p9.props.contentTextLineCount,
			numLinesForMetadata = p9.props.metadataTextLineCount,
			imageAspectRatio = v144,
			isContained = p9.props.isContained,
			containmentSidePadding = GameTileViewConfig.getContainmentSidePadding(p11.Tokens, p9.props.gameTileLayoutType, p9.props.foundationTokens),
			Size = UDim2.fromScale(1, 1),
			image = imageThumbnail,
			onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else p9.props.onTileImageLoaded,
			thumbnailComponent = v149,
			title = if not isHidden then v146 else nil,
			isDisabled = not not isHidden or p9.props.isDisabled,
			onActivated = if not FFlagLuaAppGameDetailsAttributionFix or isHidden then p9.onActivated else function() -- line: 935
				-- upvalues: onGameTileActivated (copy), p9 (copy)
				onGameTileActivated(p9.isMounted)
			end,
			onGuiStateChanged = if not FFlagLuaAppGameTileInteractionFeedback then nil else p9.props.onGuiStateChanged,
			onSelectionGained = p9.onSelectionGained,
			onSelectionLost = p9.onSelectionLost,
			onTouchLongPress = if isHidden then nil else p9.onTouchLongPress,
			reducedMotion = p10,
			isHovered = not isHidden and p9.props.isHovered,
			forwardRef = p9.props.hoverRef,
			hidePlayButton = not not isHidden or p9.props.hidePlayButton,
			hoverActionRow = if p9.props.hidePlayButton or isHidden then nil else React.createElement(AppExperienceActionRow, {
				launchSource = "ExperienceTile",
				horizontalPadding = 0,
				verticalPadding = 0,
				universeId = p9.props.navigationUniverseId,
				referralSource = p9.props.referralSource,
				reportExperienceLaunched = p9.reportExperienceLaunchedFromActionBar,
				openGameDetails = if not FFlagLuaAppGameDetailsAttributionFix then p9.onActivated else function() -- line: 954
					-- upvalues: onGameTileActivated (copy), p9 (copy)
					onGameTileActivated(p9.isMounted)
				end,
				entry = p9.props.entry,
				launchExperienceEventContext = p9.props.launchExperienceEventContext,
				fetchDelayInSeconds = game:GetFastInt("LuaAppGameTileHoverDelayMs") / 1000,
				index = p9.props.index,
				height = playButtonHeight,
				showButtonText = v144 > 1,
				isUnifiedGameTileEnabled = not not FFlagLuaAppUnifyPlayButtonTile or nil,
				placeIdOverride = p9.props.entry.placeIdOverride,
				launchDataOverride = p9.props.entry.launchDataOverride
			}),
			thumbnailOverlay = if not isHidden then v150 else nil,
			overflowMenu = v152,
			footerMetadata = if not isHidden then v145 else nil,
			textSizeOffset = p9.props.textSizeOffset,
			hideMetadata = p9.props.hideMetadata
		}),
		VideoPlaybackDetector = if not v96 then nil else p9.props.videoPlaybackDetector
	})
end
function v105.render(p13) -- line: 984
	-- upvalues: DiscoveryAppLaunchTracker (copy), withStyle (copy)
	if DiscoveryAppLaunchTracker.isEnabled() and DiscoveryAppLaunchTracker.default then
		DiscoveryAppLaunchTracker.default:trackTileRender()
	end

	if p13.props.game == nil then
		return nil
	end

	return withStyle(function(p14) -- line: 994
		-- upvalues: p13 (copy)
		local ReducedMotion = p14.Settings.ReducedMotion

		return p13:renderContent(ReducedMotion, p14, p13.props.foundationTokens)
	end)
end
function v105.didMount(p15) -- line: 1000
	-- upvalues: ImpressionsTagUtility (copy)
	p15.isMounted = true
	ImpressionsTagUtility.AddTag(p15.gameTileRef, p15.props.impressionsTag, p15.props.index)

	if not p15.props.useGridTile and (p15.props.friendFooterEnabled and p15.props.hasInGameFriends) then
		p15:setState({
			canDisplayFriendFooter = true
		})
	end

	if p15.props.useGridTile then
		p15.loadWideThumbnail()
	end
end
function v105.willUnmount(p16) -- line: 1015
	-- upvalues: ImpressionsTagUtility (copy)
	p16.isMounted = false
	ImpressionsTagUtility.RemoveTag(p16.gameTileRef, p16.props.impressionsTag, p16.props.index)
end
function v105.didUpdate(p17, p18) -- line: 1020
	-- upvalues: ImpressionsTagUtility (copy)
	if p18.impressionsTag ~= p17.props.impressionsTag or p18.index ~= p17.props.index then
		ImpressionsTagUtility.RemoveTag(p17.gameTileRef, p18.impressionsTag, p18.index)
		ImpressionsTagUtility.AddTag(p17.gameTileRef, p17.props.impressionsTag, p17.props.index)
	end

	if p17.props.useGridTile and p18.universeId ~= p17.props.universeId then
		p17.loadWideThumbnail()
	end

	if not p17.props.useGridTile and ((p18.friendFooterEnabled ~= p17.props.friendFooterEnabled or p18.hasInGameFriends ~= p17.props.hasInGameFriends) and p17.props.friendFooterEnabled and p17.props.hasInGameFriends) then
		p17:setState({
			canDisplayFriendFooter = true
		})
	end
end

local function formatRating(n1: number, n2: number) -- line: 1045
	if n1 + n2 == 0 then
		return "--"
	end

	return tostring((math.floor(n1 / (n1 + n2) * 100 + 0.5))) .. "%"
end

local u110 = RoactRodux.connect(function(p19, p20) -- line: 1053
	-- upvalues: FFlagLuaAppGameDetailsAttributionFix (copy), GameInfosReducer (copy), GameTileConstants (copy), getGameTileLayoutData (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), GameIconReducer (copy), formatExperienceIcon (copy), v77 (copy), formatExperienceRating (copy), FFlagLuaAppHomeReduceRenders (copy), t1 (copy)
	local universeId = p20.entry.universeId
	local v163 = nil

	if not FFlagLuaAppGameDetailsAttributionFix then
		v163 = if not p20.entry.navigationUniverseId or (p20.entry.navigationUniverseId == "" or p20.entry.navigationUniverseId == "0") then p20.entry.universeId else p20.entry.navigationUniverseId
	end

	local v164 = p19.Personalization[GameInfosReducer.key][universeId]
	local v165 = v164 and v164.totalUpVotes or 0
	local v166 = v164 and v164.totalDownVotes or 0
	local v167 = v164 and v164.friendActivityTitle or nil
	local v168 = nil
	local v169 = v164 and v164.minimumAge or 0
	local v170 = v164 and v164.ageRecommendationDisplayName or ""
	local v171 = if p20.gameTileLayoutType ~= "Event" then p20.gameTileLayoutType == "Wide" and p20.playButtonStyle == GameTileConstants.PlayButtonStyleValues.Disabled else p20.playButtonStyle ~= GameTileConstants.PlayButtonStyleValues.Enabled
	local v172

	if v171 or p20.forceHideAgeRatings then
		v172 = false
	elseif v169 ~= 0 and v170 ~= "" then
		v172 = true
		v168 = v170
	else
		v172 = false
	end

	local v173 = getGameTileLayoutData(v164, p20.topicId)
	local v174 = ((if not p20.entry.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v173) else p20.entry.primaryWideImageAssetId)) or (v164 and v164.primaryWideAssetId or nil)
	local v175 = formatExperienceThumbnail(v174, p20.entry.placeId)
	local v176 = if not p20.entry.primaryWideVideoAssetId then v173 and (v173.primaryMediaAsset and v173.primaryMediaAsset.wideVideoAssetId) else p20.entry.primaryWideVideoAssetId
	local v177 = if not v176 then nil else `rbxassetid://{ v176 }`
	local v178 = p19[GameIconReducer.key][universeId] and p19[GameIconReducer.key][universeId].url or nil
	local v179 = if not p20.useGridTile then formatExperienceIcon(v178, universeId) else v175
	local v180 = if not p20.useHoverTile and not p20.useExperienceTileMetadata then nil else if not v77 then if v165 + v166 ~= 0 then tostring((math.floor(v165 / (v165 + v166) * 100 + 0.5))) .. "%" else "--" else formatExperienceRating(v165, v166, nil, true)
	local v181 = v164 and v164.friendVisits or if not FFlagLuaAppHomeReduceRenders then {} else t1
	local v182 = if not v164 or v164.friendVisitedString == "" then nil else v164.friendVisitedString
	local v183 = v173 and v173.footer or nil
	local v184 = v173 and v173.title or (v164 and v164.name or "")

	return {
		game = v164,
		universeId = universeId,
		navigationUniverseId = if FFlagLuaAppGameDetailsAttributionFix then nil else v163,
		name = v184,
		totalUpVotes = v165,
		totalDownVotes = v166,
		imageThumbnail = v179,
		wideThumbnail = v175,
		videoThumbnail = v177,
		friendActivityTitle = v167,
		rating = v180,
		showAgeRating = v172,
		ageRatingText = v168,
		friendVisits = v181,
		friendVisitedString = v182,
		hidePlayButton = v171,
		footerLayoutData = v183
	}
end, function(p21) -- line: 1156
	-- upvalues: OpenCentralOverlayForPlacesList (copy), OpenSponsoredTooltip (copy)
	return {
		openContextualMenu = function(p22, p23, p24) -- line: 1158
			-- upvalues: p21 (copy), OpenCentralOverlayForPlacesList (copy)
			p21(OpenCentralOverlayForPlacesList(p22, p23, p24))
		end,
		openSponsoredTooltip = function(p25) -- line: 1161
			-- upvalues: p21 (copy), OpenSponsoredTooltip (copy)
			return p21(OpenSponsoredTooltip(p25))
		end
	}
end)(v105)

if not FFlagLuaAppGameDetailsAttributionFix then
	u110 = RoactServices.connect({
		networking = RoactNetworking
	})(u110)
end

return function(p26) -- line: 1173
	-- upvalues: React (copy), useTokens (copy), useIsHoveredTile (copy), useUiModeInfo (copy), UiMode (copy), useValidTileBadges (copy), useSelector (copy), FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix (copy), useHasInGameFriends (copy), useInGameUserIds (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), FFlagLuaAppFixHiddenTileVideoCleanup (copy), FFlagLuaAppGameDetailsAttributionFix (copy), useRoactService (copy), RoactNetworking (copy), sponsoredGamesRecordClick (copy), HoverTileCoordinator (copy), VideoEndReason (copy), VideoPlaybackCoordinator (copy), FFlagLuaAppGameTileInteractionFeedback (copy), GameCollectionItemTypes (copy), GetFFlagEnableNavigationPerformanceIntervals (copy), IntervalPerformanceTracker (copy), useOverflowMenuOpen (copy), useTriggerFeedback (copy), getAvailableGameTileOverflowMenuItems (copy), FFlagLuaAppEnableSponsoredReportAd (copy), v96 (copy), useHasVideoThumbnailSelector (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), usePreferredInput (copy), GameVideoPlaybackDetector (copy), Responsive (copy), FIntLuaAppGameTileVideoDwellTimeInSec (copy), FIntLuaAppGameTileVideoVisiblePercent (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), FFlagLuaAppTileVideoDeviceMemoryBlocking (copy), u110 (ref), Cryo (copy)
	local v187 = React.useRef(nil)
	local v188 = useTokens()
	local useHoverTile = p26.useHoverTile
	local v190 = `{ p26.impressionsTag or "" }_{ p26.index or "0" }_{ p26.gameTileLayoutType or "Narrow" }`

	if p26.impressionsTag == nil or p26.index == nil then
		useHoverTile = false
	end

	local v191 = useIsHoveredTile(v187, v190, useHoverTile)
	local v192 = useUiModeInfo().uiMode == UiMode.TenFoot
	local v193 = not not v192 or p26.useHoverTile
	local v194 = if p26.useExperienceTileMetadata == nil then v192 else p26.useExperienceTileMetadata
	local v195 = useValidTileBadges(p26.entry.universeId, p26.topicId, p26.badgeOverride)
	local v196 = useSelector(function(p27) -- line: 1196
		return p27.LocalUserId
	end)
	local v197 = nil

	if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		v197 = useSelector(function(p28) -- line: 1202
			return p28.Users
		end)
	end

	local v198 = useSelector(function(p29) -- line: 1207
		-- upvalues: p26 (copy)
		return p29.InGameUsersByGame[p26.entry.universeId]
	end)
	local v199 = useHasInGameFriends(v196, v197, v198)
	local v200 = if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then nil else useInGameUserIds(v196, v198)
	local v201, v202 = React.useState(false)
	local v203 = nil
	local u204 = nil
	local v205 = nil
	local v206 = nil

	if FFlagLuaAppGameTileSelectionVideoPlayback then
		local v207

		v203, v207 = React.useState(false)
		u204 = v207
		v205 = React.useCallback(function(p30, p31, p32) -- line: 1224
			-- upvalues: u204 (ref), p26 (copy)
			u204(true)

			if p26.onSelectionGained then
				p26.onSelectionGained(p30, p31, p32)
			end
		end, { p26.onSelectionGained })
		v206 = React.useCallback(function() -- line: 1232
			-- upvalues: u204 (ref), p26 (copy)
			u204(false)

			if p26.onSelectionLost then
				p26.onSelectionLost()
			end
		end, { p26.onSelectionLost })
	end

	if FFlagLuaAppFixHiddenTileVideoCleanup then
		React.useEffect(function() -- line: 1242
			-- upvalues: p26 (copy), v202 (copy)
			if p26.isHidden then
				v202(false)
			end
		end, { p26.isHidden })
	end

	local u208 = nil
	local u209 = nil
	local v210 = nil
	local u211 = nil

	if FFlagLuaAppGameDetailsAttributionFix then
		u208 = useRoactService(RoactNetworking)
		u209 = if not p26.entry.navigationUniverseId or (p26.entry.navigationUniverseId == "" or p26.entry.navigationUniverseId == "0") then p26.entry.universeId else p26.entry.navigationUniverseId
		u211 = React.useCallback(function() -- line: 1263
			-- upvalues: p26 (copy), sponsoredGamesRecordClick (copy), u208 (ref)
			local entry = p26.entry

			if entry.isSponsored then
				sponsoredGamesRecordClick(u208, entry.adId)
			end
		end, {
			u208,
			p26.entry.isSponsored,
			p26.entry.adId
		})
		v210 = React.useCallback(function(p33) -- line: 1272
			-- upvalues: p26 (copy), HoverTileCoordinator (copy), VideoEndReason (copy), u209 (ref), VideoPlaybackCoordinator (copy), FFlagLuaAppGameTileInteractionFeedback (copy), GameCollectionItemTypes (copy), GetFFlagEnableNavigationPerformanceIntervals (copy), IntervalPerformanceTracker (copy), u211 (ref)
			if p26.isHovered then
				HoverTileCoordinator.default:reset()
			end

			if p26.videoPlaybackContext and p26.videoPlaybackContext.videoPlaybackCoordinator then
				p26.videoPlaybackContext.videoPlaybackCoordinator:reset(VideoEndReason.TileClicked, nil, u209, nil)
			else
				VideoPlaybackCoordinator.default:reset(VideoEndReason.TileClicked, nil, u209, nil)
			end

			if p33 then
				if FFlagLuaAppGameTileInteractionFeedback and p26.onActivated then
					p26.onActivated()
				end

				local t7 = {
					source = p26.source,
					index = p26.index,
					referralSource = p26.referralSource,
					onPeekViewClosed = p26.onPeekViewClosed,
					placeIdOverride = p26.entry.placeIdOverride,
					experienceJoinData = {
						launchData = if not p26.entry.launchDataOverride then nil else p26.entry.launchDataOverride,
						tileType = p26.entry.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile,
						nativeAdData = p26.entry.adId
					}
				}

				if GetFFlagEnableNavigationPerformanceIntervals() then
					IntervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
				end

				p26.navigateToGameDetails(u209, t7)
				p26.reportGameDetailOpened(p26.index, u209)
				u211()
			end
		end, {
			p26.isHovered,
			p26.index,
			p26.videoAnalytics,
			p26.onActivated,
			p26.source,
			p26.referralSource,
			p26.onPeekViewClosed,
			p26.navigateToGameDetails,
			p26.reportGameDetailOpened,
			u209,
			u211,
			p26.entry.placeIdOverride,
			p26.entry.launchDataOverride,
			if not p26.videoPlaybackContext then nil else p26.videoPlaybackContext.videoPlaybackCoordinator
		})
	end

	local v212 = useOverflowMenuOpen(v190)
	local v213 = useTriggerFeedback()
	local v214 = React.useMemo(function() -- line: 1341
		-- upvalues: getAvailableGameTileOverflowMenuItems (copy), p26 (copy), FFlagLuaAppEnableSponsoredReportAd (copy)
		return getAvailableGameTileOverflowMenuItems({
			isSponsored = p26.entry.isSponsored,
			enableExplicitFeedback = p26.enableExplicitFeedback,
			enableSponsoredFeedback = p26.enableSponsoredFeedback,
			enableReportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else p26.enableReportAd
		})
	end, {
		p26.entry.isSponsored,
		p26.enableExplicitFeedback,
		p26.enableSponsoredFeedback,
		if not FFlagLuaAppEnableSponsoredReportAd then nil else p26.enableReportAd
	})
	local v215 = nil

	if v96 then
		local v216 = useHasVideoThumbnailSelector(p26.entry.universeId, p26.topicId)
		local v217 = p26.entry.primaryWideVideoAssetId ~= nil or v216

		useTagAsViewportAutoplayCandidate(v187, p26.videoPlaybackContext, if not FFlagLuaAppTileVideoCandidateOnly then nil else v217, if not FFlagLuaAppFixHiddenTileVideoCleanup then nil else p26.isHidden)

		local v218 = nil

		if not FFlagLuaAppGameTileSelectionVideoPlayback then
			v218 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else usePreferredInput()
		end

		v215 = if not v217 or p26.isHidden then nil else React.createElement(GameVideoPlaybackDetector, {
			videoKey = v190,
			itemIndex = p26.index,
			universeId = p26.entry.universeId,
			tileRef = v187,
			isHoverSupported = useHoverTile,
			isHovered = v191,
			isSelected = if not FFlagLuaAppGameTileSelectionVideoPlayback then nil else v203,
			autoplay = if not FFlagLuaAppGameTileSelectionVideoPlayback then if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else v218 == Responsive.Input.Touch else nil,
			onPlaybackChange = v202,
			videoAnalytics = p26.videoAnalytics,
			videoDwellTimeInSec = FIntLuaAppGameTileVideoDwellTimeInSec,
			videoVisiblePercent = FIntLuaAppGameTileVideoVisiblePercent,
			hasPrevalidatedVideoGamePlayability = if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else p26.hasPrevalidatedVideoGamePlayability,
			pageContext = if not FFlagLuaAppTileVideoDeviceMemoryBlocking then nil else p26.appPage,
			videoPlaybackContext = p26.videoPlaybackContext
		})
	end

	local v219 = React.createElement(u110, Cryo.Dictionary.join(p26, {
		useExperienceTileMetadata = v194,
		hasBackground = v193,
		hoverRef = v187,
		isHoverSupported = useHoverTile,
		isHovered = v191,
		isSelected = if not FFlagLuaAppGameTileSelectionVideoPlayback then nil else v203,
		isVideoPlaying = v201,
		tileBadges = v195,
		foundationTokens = v188,
		users = v197,
		inGameUsersByGame = v198,
		hasInGameFriends = v199,
		inGameUserIds = if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then nil else v200,
		networking = if not FFlagLuaAppGameDetailsAttributionFix then nil else u208,
		navigationUniverseId = if not FFlagLuaAppGameDetailsAttributionFix then nil else u209,
		onGameTileActivated = if not FFlagLuaAppGameDetailsAttributionFix then nil else v210,
		recordSponsoredGameClick = if not FFlagLuaAppGameDetailsAttributionFix then nil else u211,
		overflowMenuOpen = v212,
		hoverKey = v190,
		triggerFeedback = v213,
		availableMenuItems = v214,
		onSelectionGained = if not FFlagLuaAppGameTileSelectionVideoPlayback then p26.onSelectionGained else v205,
		onSelectionLost = if not FFlagLuaAppGameTileSelectionVideoPlayback then p26.onSelectionLost else v206,
		videoPlaybackDetector = if not v96 then nil else v215
	}))

	if v96 then
		return v219
	end

	local v220 = useHasVideoThumbnailSelector(p26.entry.universeId, p26.topicId)
	local v221 = p26.entry.primaryWideVideoAssetId ~= nil or v220

	useTagAsViewportAutoplayCandidate(v187, p26.videoPlaybackContext, if not FFlagLuaAppTileVideoCandidateOnly then nil else v221, if not FFlagLuaAppFixHiddenTileVideoCleanup then nil else p26.isHidden)

	local v222 = nil

	if not FFlagLuaAppGameTileSelectionVideoPlayback then
		v222 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else usePreferredInput()
	end

	if v221 and not p26.isHidden then
		return React.createElement(React.Fragment, {}, {
			GameTile = v219,
			VideoPlaybackDetector = React.createElement(GameVideoPlaybackDetector, {
				videoKey = v190,
				itemIndex = p26.index,
				universeId = p26.entry.universeId,
				tileRef = v187,
				isHoverSupported = useHoverTile,
				isHovered = v191,
				isSelected = if not FFlagLuaAppGameTileSelectionVideoPlayback then nil else v203,
				autoplay = if not FFlagLuaAppGameTileSelectionVideoPlayback then if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else v222 == Responsive.Input.Touch else nil,
				onPlaybackChange = v202,
				videoAnalytics = p26.videoAnalytics,
				videoDwellTimeInSec = FIntLuaAppGameTileVideoDwellTimeInSec,
				videoVisiblePercent = FIntLuaAppGameTileVideoVisiblePercent,
				hasPrevalidatedVideoGamePlayability = if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else p26.hasPrevalidatedVideoGamePlayability,
				pageContext = if not FFlagLuaAppTileVideoDeviceMemoryBlocking then nil else p26.appPage,
				videoPlaybackContext = p26.videoPlaybackContext
			})
		})
	end

	return v219
end
