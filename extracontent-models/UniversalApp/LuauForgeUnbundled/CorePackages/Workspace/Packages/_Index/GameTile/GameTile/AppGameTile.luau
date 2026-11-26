local ContentProvider = game:GetService("ContentProvider")

local GridTileIconTextFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileIconTextFooter")
local gridTileFriendFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileFriendFooter").GridTileFriendFooter
local GridTileTextFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileTextFooter")
local GameStats = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GameStats")
local GridTileSponsoredFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileSponsoredFooter")
local RatingWithGenreFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/RatingWithGenreFooter")
local GameTileThumbnailBadges = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Overlays/GameTileThumbnailBadges")
local sortFriendsByPresenceAndRecencyFactory = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/sortFriendsByPresenceAndRecencyFactory")
local OpenCentralOverlayForPlacesList = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/OpenCentralOverlayForPlacesList")
local GameTileView = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileView")
local AppExperienceActionRow = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/AppExperienceActionRow")
local GameTileConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants")
local OpenSponsoredTooltip = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/OpenSponsoredTooltip")
local GameTileTypes = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")
local useIsHoveredTile = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/useIsHoveredTile")
local HoverTileCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/HoverTileCoordinator")
local getGameTileLayoutData = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getGameTileLayoutData")
local GameTileViewConfig = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileViewConfig")
local useHasInGameFriends = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/useHasInGameFriends")
local useInGameUserIds = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/useInGameUserIds")

local useValidTileBadges = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Overlays/useValidTileBadges")
local GameTileVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileVideoThumbnail")
local VideoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Video/Analytics/VideoEndReason")
local GameVideoPlaybackDetector = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Video/GameVideoPlaybackDetector")
local useHasVideoThumbnailSelector = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Video/useHasVideoThumbnailSelector")
local getLayoutDataVideo = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getLayoutDataVideo")
local formatExperienceIcon = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/formatExperienceIcon")
local formatExperienceThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/formatExperienceThumbnail")
local HiddenTileContent = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/HiddenGameTile/HiddenTileContent")
local ItemLayoutDataParsingUtils = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/ItemLayoutDataParsingUtils")

local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryTypes").GameCollectionItemTypes
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local none = React.None
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactRodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags").RoactNetworking
local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/VideoUtils")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/t")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")
local fFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails

local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local aspectRatioModeEnum = UIBlox.App.Tile.AspectRatioModeEnum
local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Impressions").ImpressionsTagUtility
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks").useUiModeInfo
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks").useRoactService
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums").UiMode
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppCommonLib").memoize
local intervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/IntervalPerformanceTracker").IntervalPerformanceTracker
local gameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameInfosRodux").GameInfosReducer
local toLegacyGameInfoModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameInfosRodux").toLegacyGameInfoModel
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils").Hooks.RoactRodux.useSelector
require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DataHydration")
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameHydrationReact")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation").Hooks.useTokens
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/InteractionFeedback").useTriggerFeedback
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryAnalytics")
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate

local discoveryAppLaunchTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppLaunchTracker").DiscoveryAppLaunchTracker

local getFFlagEnableNavigationPerformanceIntervals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").GetFFlagEnableNavigationPerformanceIntervals
local fFlagLuaAppMigrateGameTileHoverFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppMigrateGameTileHoverFixes

local fFlagLuaAppMigrateGameTileFixConsoleMetadataText = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppMigrateGameTileFixConsoleMetadataText

local fFlagLuaAppUnifyPlayButtonTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUnifyPlayButtonTile
local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview
local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen
local fFlagLuaAppGameDetailsAttributionFix = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGameDetailsAttributionFix

local fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix
local fFlagGameTileMigrateOffLegacyPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagGameTileMigrateOffLegacyPresence
local useGetOnlineFriendsByUniverseId

if fFlagGameTileMigrateOffLegacyPresence then
	useGetOnlineFriendsByUniverseId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/FriendsHydrationReact").useGetOnlineFriendsByUniverseId
else
	useGetOnlineFriendsByUniverseId = nil
end

local fFlagLuaAppEnableReportExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEnableReportExperience
local fFlagLuaAppNarrowTileHideRating = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppNarrowTileHideRating
local fFlagLuaAppNarrowTileHidePlayerCount = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppNarrowTileHidePlayerCount
local fIntLuaAppGameTileVideoDwellTimeInSec = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FIntLuaAppGameTileVideoDwellTimeInSec
local fIntLuaAppGameTileVideoVisiblePercent = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FIntLuaAppGameTileVideoVisiblePercent
local fFlagLuaAppTileVideoCandidateOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppTileVideoCandidateOnly
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay
local defineFastFlag = game:DefineFastFlag("LuaAppKeepTileBadgesDuringVideo", false)
local fFlagLuaAppVideoTileDisableActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppVideoTileDisableActivation
local fFlagLuaAppFixHiddenTileVideoCleanup = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppFixHiddenTileVideoCleanup

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUsePrevalidatedVideoGamePlayability
local fFlagLuaAppContinueSortInstantPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppContinueSortInstantPlay

local fFlagLuaAppGameTileExtractGameDetailsCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGameTileExtractGameDetailsCallback
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local module43 = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/InstantPlayLauncher")
local InstantPlayButton = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/InstantPlayButton")
local fFlagLuaAppGenreRatingFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGenreRatingFooter

local fFlagLuaAppGameTileSelectionVideoPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGameTileSelectionVideoPlayback

local fFlagLuaAppSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppSuppressVideoDetectorDuringScroll
local fFlagLuaAppHomeThumbnailPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeThumbnailPrefetch
local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeMomentVideoFallback

local v5 = if fFlagLuaAppHomeThumbnailPrefetch then require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/resolveGameTileThumbnailUri") else nil

local videoPlaybackCoordinator = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/VideoUtils").VideoPlaybackCoordinator

local GameTileContextualActions = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileContextualActions")
local GameTileOverflowMenu = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileOverflowMenu")
local getAvailableGameTileOverflowMenuItems = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getAvailableGameTileOverflowMenuItems")

local v6 = {}

game:DefineFastInt("LuaAppGameTileHoverDelayMs", 130)

local function getHoverDelay()
	return game:GetFastInt("LuaAppGameTileHoverDelayMs") / 1000
end

local v7 = fFlagLuaAppContinueSortInstantPlay
	and {
		Treatment1 = "SDUI.InstantPlay.Treatment1",
		Treatment2 = "SDUI.InstantPlay.Treatment2",
		Treatment3 = "SDUI.InstantPlay.Treatment3"
	}
	or nil
local set

if fFlagLuaAppContinueSortInstantPlay then
	set = {}
	set[v7.Treatment1] = true
	set[v7.Treatment2] = true
	set[v7.Treatment3] = true
else
	set = nil
end

local frozen

if fFlagLuaAppContinueSortInstantPlay then
	frozen = table.freeze({
		isActive = false,
		isTreatment1 = false,
		isTreatment2 = false,
		isTreatment3 = false
	})
else
	frozen = nil
end

local fn = fFlagLuaAppContinueSortInstantPlay and function(p2, p3)
	local v8 = p2 == true and p3 ~= nil and set[p3] == true

	if v8 then
		return {
			isActive = true,
			isTreatment1 = p3 == v7.Treatment1,
			isTreatment2 = p3 == v7.Treatment2,
			isTreatment3 = p3 == v7.Treatment3
		}
	end

	return frozen
end or nil

local extended = Roact.PureComponent:extend("AppGameTile")

local strictInterface = t.strictInterface
local v8 = {}
v8.entry = t.table
v8.reportGameDetailOpened = t.callback

v8.reportExperienceLaunched = t.optional(t.callback)
v8.Size = t.optional(t.union(t.UDim2, t.table))
v8.ZIndex = t.optional(t.number)
v8.useHoverTile = t.optional(t.boolean)
v8.hasBackground = t.boolean
v8.useGridTile = t.boolean
v8.playerCountStyle = t.optional(t.string)
v8.isSponsoredFooterAllowed = t.optional(t.boolean)
v8.isSponsoredRatingFooterAllowed = t.optional(t.boolean)
v8.useExperienceTileMetadata = t.boolean
v8.hideGameStats = t.optional(t.boolean)
v8.gameTileLayoutType = t.optional(t.string)
v8.topicId = t.optional(t.string)
v8.playButtonStyle = t.optional(t.string)
v8.onGuiStateChanged = t.optional(t.callback)
v8.isDisabled = t.optional(t.boolean)
v8.onActivated = t.optional(t.callback)
local v9 = if fFlagLuaAppGameTileSelectionVideoPlayback then t.callback else t.optional(t.callback)
v8.onSelectionGained = v9
local v10 = if fFlagLuaAppGameTileSelectionVideoPlayback then t.callback else t.optional(t.callback)
v8.onSelectionLost = v10
v8.friendFooterEnabled = t.optional(t.boolean)
v8.index = t.optional(t.number)
v8.layoutOrder = t.optional(t.number)
v8.source = t.optional(t.string)
v8.referralSource = t.optional(t.string)
v8.onPeekViewClosed = t.optional(t.callback)
v8.rowNum = t.optional(t.number)
v8.showFriendActivity = t.boolean
v8.contentTextLineCount = t.optional(t.number)
v8.metadataTextLineCount = t.optional(t.number)
v8.thumbnailAspectRatioOverride = t.optional(t.string)
v8.impressionsTag = t.optional(t.string)
v8.launchExperienceEventContext = t.optional(t.string)
v8.navigateToGameDetails = t.callback
v8.isContained = t.optional(t.boolean)
v8.hideTitle = t.optional(t.boolean)
v8.hideMetadata = t.optional(t.boolean)
v8.textSizeOffset = t.optional(t.number)
v8.foundationTokens = t.optional(t.table)
v8.videoAnalytics = t.optional(t.table)

local v11 = if fFlagLuaAppUsePrevalidatedVideoGamePlayability then t.optional(t.boolean) else nil
v8.hasPrevalidatedVideoGamePlayability = v11

v8.videoPlaybackContext = t.optional(t.table)
v8.SelectionOrder = t.optional(t.number)
v8.enableExplicitFeedback = t.optional(t.boolean)
v8.setGameHidden = t.optional(t.callback)
v8.appPage = t.optional(t.string)
v8.isHidden = t.optional(t.boolean)
v8.isNarrowScreenXSmall = t.optional(t.boolean)

v8.sponsoredUserCohort = t.optional(t.string)
v8.enableSponsoredFeedback = t.optional(t.boolean)
v8.availableMenuItems = t.optional(t.table)
v8.enableReportAd = t.optional(t.boolean)
local v12 = if fFlagLuaAppEnableReportExperience then t.optional(t.boolean) else nil
v8.enableReportExperience = v12
v8.compactMetadataFormat = t.optional(t.boolean)
local v13 = if fFlagLuaAppNarrowTileHideRating then t.optional(t.boolean) else nil
v8.hideRating = v13
local v14 = if fFlagLuaAppNarrowTileHidePlayerCount then t.optional(t.boolean) else nil
v8.hidePlayerCount = v14

v8.game = t.optional(t.table)
v8.universeId = t.string
v8.navigationUniverseId = t.optional(t.string)
v8.name = t.optional(t.string)
v8.friendActivityTitle = t.optional(t.string)
v8.friendVisitedString = t.optional(t.string)
v8.imageThumbnail = t.string
v8.wideThumbnail = t.optional(t.string)
v8.videoThumbnail = t.optional(t.string)
local v15 = if fFlagLuaAppHomeMomentVideoFallback then t.optional(t.string) else nil
v8.videoAccessContext = v15
v8.friendVisits = t.table
v8.hidePlayButton = t.boolean
v8.footerLayoutData = t.optional(t.table)

v8.openContextualMenu = t.callback
v8.openSponsoredTooltip = t.callback

v8.networking = t.callback

v8.hoverRef = t.table
v8.isHoverSupported = t.optional(t.boolean)
v8.isHovered = t.optional(t.boolean)
v8.gameIconUrl = t.optional(t.string)
local v16 = if fFlagLuaAppGameTileSelectionVideoPlayback then t.boolean else nil
v8.isSelected = v16
v8.isVideoPlaying = t.boolean
v8.tileBadges = t.optional(t.table)
v8.users = t.optional(t.table)
v8.inGameUsersByGame = t.optional(t.table)
v8.hasInGameFriends = t.boolean
local v17 = if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then t.table else nil
v8.inGameUserIds = v17
v8.badgeOverride = t.optional(t.table)
v8.forceHideAgeRatings = t.optional(t.boolean)
local v18 = if fFlagLuaAppGameDetailsAttributionFix then t.optional(t.callback) else nil
v8.onGameTileActivated = v18
local v19 = if fFlagLuaAppGameDetailsAttributionFix then t.optional(t.callback) else nil
v8.recordSponsoredGameClick = v19
v8.overflowMenuOpen = t.optional(t.boolean)
v8.hoverKey = t.optional(t.string)
v8.triggerFeedback = t.callback
v8.videoPlaybackDetector = t.optional(t.table)
local v20 = if fFlagLuaAppContinueSortInstantPlay then t.optional(t.boolean) else nil
v8.enableInstantPlay = v20
local v21 = if fFlagLuaAppContinueSortInstantPlay then t.optional(t.string) else nil
v8.instantPlayTreatment = v21
local v22 = if fFlagLuaAppContinueSortInstantPlay then t.optional(t.boolean) else nil
v8.isTouchPreferredInput = v22
extended.validateProps = strictInterface(v8)

local narrow = GameTileTypes.GameTileLayoutType.Narrow
extended.defaultProps = {
	useHoverTile = false,
	hasBackground = false,
	useExperienceTileMetadata = false,
	useGridTile = false,
	thumbnailAspectRatioOverride = aspectRatioModeEnum.Square,
	gameTileLayoutType = narrow,
	contentTextLineCount = GameTileConstants.TileTextLines[narrow].titleTextLines,
	hideGameStats = false
}

function extended:init()
	if discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then
		discoveryAppLaunchTracker.default:trackTileInit()
	end

	self.state = {
		isHovered = false,
		canDisplayFriendFooter = false,
		isSelected = if not fFlagLuaAppGameTileSelectionVideoPlayback then false else nil,
		instantPlayRequested = if fFlagLuaAppContinueSortInstantPlay then false else nil
	}

	self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
		universeId = self.props.entry.universeId,
		onChange = function(p2)
			self:setState({
				gameInfo = p2.gameInfo or none,
				storeVotes = p2.votes or none
			})
		end
	})

	function self.onMenuOpenChanged(p2, p3)
		gameTileOverflowMenuAction({
			universeId = self.props.universeId,
			sortId = self.props.topicId,
			actionType = p2 and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened",
			availableMenuItems = p3
		}, self.props.appPage or "Unknown")
	end

	function self.onTouchLongPress()
		if next(self.props.availableMenuItems) ~= nil then
			if self.props.triggerFeedback and not self.props.overflowMenuOpen then
				local v26 = {
					universeId = self.props.universeId,
					sortId = self.props.topicId
				}

				self.props.triggerFeedback("TileLongPress", "Press", self.props.appPage or "Unknown", v26)
			end

			getOverflowMenuSignalStore().openMenu(self.props.hoverKey)
			local v26 = {}

			for k, availableMenuItem in self.props.availableMenuItems do
				table.insert(v26, k)
			end

			self.onMenuOpenChanged(false, table.concat(v26, ","))
		end
	end

	self.reportExperienceLaunched = fFlagLuaAppContinueSortInstantPlay and function(...)
		if fFlagLuaAppGameDetailsAttributionFix then
			self.props.recordSponsoredGameClick()
		else
			self.recordSponsoredGameClick()
		end

		if self.props.isHovered then
			HoverTileCoordinator.default:reset()
		end

		if self.props.reportExperienceLaunched then
			self.props.reportExperienceLaunched(...)
		end

		if self.props.videoPlaybackContext and self.props.videoPlaybackContext.videoPlaybackCoordinator then
			self.props.videoPlaybackContext.videoPlaybackCoordinator:reset(
				VideoEndReason.ExperienceLaunched,
				nil,
				self.props.navigationUniverseId,
				nil
			)
		else
			videoPlaybackCoordinator.default:reset(
				VideoEndReason.ExperienceLaunched,
				nil,
				self.props.navigationUniverseId,
				nil
			)
		end
	end or nil

	self.reportExperienceLaunchedFromInstantPlay = fFlagLuaAppContinueSortInstantPlay and function(p2)
		local reportExperienceLaunched = self.reportExperienceLaunched
		local entry = self.props.entry
		local referralSource = self.props.referralSource

		local instantPlay = DiscoveryAnalytics.Constants.Context.InstantPlay
		local index = self.props.index

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			p2 = nil
		end

		reportExperienceLaunched(entry, referralSource, "ExperienceTile", instantPlay, index, p2)
	end or nil
	local v26

	if fFlagLuaAppContinueSortInstantPlay then
		v26 = self.reportExperienceLaunched
	else
		v26 = function(...)
			if fFlagLuaAppGameDetailsAttributionFix then
				self.props.recordSponsoredGameClick()
			else
				self.recordSponsoredGameClick()
			end

			if self.props.isHovered then
				HoverTileCoordinator.default:reset()
			end

			if self.props.reportExperienceLaunched then
				self.props.reportExperienceLaunched(...)
			end

			if
				self.props.videoPlaybackContext
				and self.props.videoPlaybackContext.videoPlaybackCoordinator
			then
				self.props.videoPlaybackContext.videoPlaybackCoordinator:reset(
					VideoEndReason.ExperienceLaunched,
					nil,
					self.props.navigationUniverseId,
					nil
				)
			else
				videoPlaybackCoordinator.default:reset(
					VideoEndReason.ExperienceLaunched,
					nil,
					self.props.navigationUniverseId,
					nil
				)
			end
		end
	end

	self.reportExperienceLaunchedFromActionBar = v26

	function self.renderAppExperienceActionRow(p2)
		local createElement = Roact.createElement
		local v28 = {
			universeId = self.props.navigationUniverseId,
			referralSource = self.props.referralSource,
			launchSource = "ExperienceTile",
			reportExperienceLaunched = self.reportExperienceLaunchedFromActionBar,
			openGameDetails = 0,
			entry = 0,
			launchExperienceEventContext = 0,
			horizontalPadding = 0,
			index = 0,
			isUnifiedGameTileEnabled = 0,
			placeIdOverride = 0,
			launchDataOverride = 0
		}
		local v29

		if fFlagLuaAppGameTileExtractGameDetailsCallback then
			v29 = self.onGameDetailsActivated
		elseif fFlagLuaAppGameDetailsAttributionFix then
			v29 = function()
				self.props.onGameTileActivated(self.isMounted)
			end
		else
			v29 = self.onActivated
		end

		v28.openGameDetails = v29

		v28.entry = self.props.entry
		v28.launchExperienceEventContext = self.props.launchExperienceEventContext
		v28.horizontalPadding = self.props.useGridTile and 0 or nil
		v28.index = self.props.index
		v28.isUnifiedGameTileEnabled = fFlagLuaAppUnifyPlayButtonTile and true or nil
		v28.placeIdOverride = self.props.entry.placeIdOverride
		v28.launchDataOverride = self.props.entry.launchDataOverride
		return createElement(AppExperienceActionRow, v28)
	end

	self.onInstantPlayActivated = fFlagLuaAppContinueSortInstantPlay and function()
		if fn(self.props.enableInstantPlay, self.props.instantPlayTreatment).isActive then
			self:setState({ instantPlayRequested = true })
		end
	end or nil

	self.onInstantPlayAttemptCompleted = fFlagLuaAppContinueSortInstantPlay and function()
		self:setState({ instantPlayRequested = false })
	end or nil

	function self.onHoverChanged(p2)
		if p2 and self.props.triggerFeedback then
			self.props.triggerFeedback("Default", "Hover")
		end

		self:setState({ isHovered = p2 })
	end

	self.gameTileRef = Roact.createRef()

	function self.getTilePosition()
		if self.gameTileRef.current then
			return self.gameTileRef.current.AbsolutePosition
		end

		return nil
	end

	function self.getTileSize()
		if self.gameTileRef.current then
			return self.gameTileRef.current.AbsoluteSize
		end

		return nil
	end

	self.recordSponsoredGameClick = not fFlagLuaAppGameDetailsAttributionFix and function()
		local networking = self.props.networking
		local entry = self.props.entry

		if entry.isSponsored then
			sponsoredGamesRecordClick(networking, entry.adId)
		end
	end or nil

	self.onActivated = not fFlagLuaAppGameDetailsAttributionFix and function()
		if self.props.isHovered then
			HoverTileCoordinator.default:reset()
		end

		if self.props.videoPlaybackContext and self.props.videoPlaybackContext.videoPlaybackCoordinator then
			self.props.videoPlaybackContext.videoPlaybackCoordinator:reset(
				VideoEndReason.TileClicked,
				nil,
				self.props.navigationUniverseId,
				nil
			)
		else
			videoPlaybackCoordinator.default:reset(
				VideoEndReason.TileClicked,
				nil,
				self.props.navigationUniverseId,
				nil
			)
		end

		if self.isMounted then
			if self.props.onActivated then
				self.props.onActivated()
			end

			local navigationUniverseId = self.props.navigationUniverseId
			local v27 = {
				source = self.props.source,
				index = self.props.index,
				referralSource = self.props.referralSource,
				onPeekViewClosed = self.props.onPeekViewClosed,
				placeIdOverride = self.props.entry.placeIdOverride,
				experienceJoinData = 0
			}

			local v29 = if self.props.entry.launchDataOverride then self.props.entry.launchDataOverride else nil
			v27.experienceJoinData = {
				launchData = v29,
				tileType = self.props.entry.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile,
				nativeAdData = self.props.entry.adId
			}

			if getFFlagEnableNavigationPerformanceIntervals() then
				intervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
			end

			self.props.navigateToGameDetails(navigationUniverseId, v27)

			local index = self.props.index
			self.props.reportGameDetailOpened(index, navigationUniverseId)

			self.recordSponsoredGameClick()
		end
	end or nil

	self.onGameDetailsActivated = fFlagLuaAppGameDetailsAttributionFix and function()
		self.props.onGameTileActivated(self.isMounted)
	end or self.onActivated

	function self.onFriendFooterActivated()
		if self.isMounted then
			local gameInfo = self.state.gameInfo
			local v27 = self.props.game

			if not v27 then
				v27 = if gameInfo then toLegacyGameInfoModel(gameInfo) else nil
			end

			local tileSize = self.getTileSize()
			self.props.openContextualMenu(v27, tileSize, self.getTilePosition())
		end
	end

	function self.onActivateSponsoredTooltip()
		if self.isMounted then
			self.props.openSponsoredTooltip(Responsive.GetInputModeStore(false).getLastInputType(false))
		end
	end

	function self.loadWideThumbnail()
		local wideThumbnail = self.props.wideThumbnail

		if wideThumbnail ~= nil then
			task.spawn(function()
				ContentProvider:PreloadAsync({ wideThumbnail })
			end)
		end
	end

	function self.getVisitedFriends()
		local friendVisits = self.props.friendVisits
		local result = {}

		for i = 1, #friendVisits do
			local userId = tostring(friendVisits[i].userId)

			if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
				table.insert(result, userId)
			elseif self.props.users and self.props.users[userId] then
				table.insert(result, {
					userId = userId,
					displayName = self.props.users[userId].displayName
				})
			end
		end

		return result
	end

	self.getSortedFriends = memoize(function(p2, items)
		if not (p2 and items) then
			return {}
		end

		local result = {}

		for k, item in pairs(items) do
			local v27 = p2[item]

			if v27 and v27.isFriend then
				table.insert(result, { userId = v27.id, displayName = v27.displayName })
			end
		end

		local v27 = sortFriendsByPresenceAndRecencyFactory("displayName")
		table.sort(result, v27)

		return result
	end)

	function self.onSelectionGained()
		if not fFlagLuaAppGameTileSelectionVideoPlayback then
			self:setState({ isSelected = true })
		end

		if self.props.onSelectionGained or fFlagLuaAppGameTileSelectionVideoPlayback then
			self.props.onSelectionGained(
				self.props.entry,
				self.props.index,
				self.props.navigationUniverseId
			)
		end
	end
	function self.onSelectionLost()
		if not fFlagLuaAppGameTileSelectionVideoPlayback then
			self:setState({ isSelected = false })
		end

		if self.props.onSelectionLost or fFlagLuaAppGameTileSelectionVideoPlayback then
			self.props.onSelectionLost()
		end
	end
end

local function getTextLiteralForTextFooter(p2)
	if not (p2 ~= nil and p2.type == "TextLabel") then
		return nil
	end

	local text = p2.text

	if text == nil then
		return nil
	end

	return text.textLiteral
end

local fn2 = fFlagLuaAppGenreRatingFooter and function(p2)
	if not (p2 ~= nil and p2.type == "RatingWithGenre") then
		return nil
	end

	local genre = p2.genre

	if genre == nil then
		return nil
	end

	return genre.textLiteral
end or nil

function extended:renderGridTilesFooter()
	local v23

	if fFlagLuaAppContinueSortInstantPlay then
		v23 = fn(self.props.enableInstantPlay, self.props.instantPlayTreatment)
	end

	if fFlagLuaAppContinueSortInstantPlay and (v23.isTreatment2 or v23.isTreatment3) then
		return React.createElement(InstantPlayButton, {
			onActivated = self.onInstantPlayActivated,
			showIcon = v23.isTreatment2,
			showText = v23.isTreatment3
		})
	end

	local v24 = self.props.useHoverTile or self.props.useExperienceTileMetadata

	local friendFooterEnabled = self.props.friendFooterEnabled
	local v25 = self.props.hasInGameFriends
	local inGameUserIds

	if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		inGameUserIds = self.props.inGameUserIds
	end

	local users = self.props.users
	local inGameUsersByGame = self.props.inGameUsersByGame
	local v26

	if not fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		v26 = self.getSortedFriends(users, inGameUsersByGame)
	end

	if friendFooterEnabled then
		if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			v25 = inGameUserIds and #inGameUserIds > 0
		end
	else
		v25 = friendFooterEnabled
	end

	local v27 = self.props.friendVisits and #self.props.friendVisits > 0

	local footerLayoutData = self.props.footerLayoutData
	local v28

	if not (footerLayoutData == nil or footerLayoutData.type ~= "TextLabel") then
		local text = footerLayoutData.text

		if text ~= nil then
			v28 = text.textLiteral
		end
	end

	local v29 = if fFlagLuaAppGenreRatingFooter then fn2(self.props.footerLayoutData) else nil

	local flag = false
	local gameAgeDisplayName

	if not (self.props.hidePlayButton or self.props.forceHideAgeRatings) then
		local gameInfo = self.state.gameInfo
		local gameMinimumAge = gameInfo and gameInfo.gameMinimumAge or 0
		gameAgeDisplayName = gameInfo and gameInfo.gameAgeDisplayName or ""

		if gameMinimumAge == 0 or gameAgeDisplayName == "" then
			gameAgeDisplayName = nil
		end
	end

	if self.props.isHovered then
		if gameAgeDisplayName and not self.props.hidePlayButton then
			v28 = gameAgeDisplayName
			flag = true
		end
	else
		local v30

		if fFlagLuaAppGameTileSelectionVideoPlayback then
			v30 = self.props.isSelected
		else
			v30 = self.state.isSelected
		end

		if v30 and gameAgeDisplayName and not self.props.hidePlayButton then
			v28 = gameAgeDisplayName
			flag = true
		end
	end

	local v30 = v28 ~= nil
	local v31 = if fFlagLuaAppGenreRatingFooter then v29 ~= nil else nil
	local entry = self.props.entry
	local isShowSponsoredLabel = entry.isSponsored
		and (entry.isShowSponsoredLabel or self.props.isSponsoredFooterAllowed or self.props.isSponsoredRatingFooterAllowed)

	if
		fFlagLuaAppMigrateGameTileFixConsoleMetadataText
		and self.props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow
		and self.props.useExperienceTileMetadata
		and (isShowSponsoredLabel or v30 or fFlagLuaAppGenreRatingFooter and v31)
		or self.props.compactMetadataFormat
	then
		v24 = false
	end

	local storeVotes = self.state.storeVotes
	local v32 = not storeVotes and 0 or storeVotes.upVotes
	local v33 = not storeVotes and 0 or storeVotes.downVotes

	local createElement = Roact.createElement

	local v37 = if self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Footer then self.props.entry.playerCount else nil
	local v35 = {
		stats = { totalUpVotes = v32, totalDownVotes = v33, playerCount = v37 },
		isGridTile = self.props.useGridTile,
		hideGameStats = self.props.hideGameStats,
		useLargerFont = v24,
		isUnifiedGameTile = true,
		gameTileLayoutType = self.props.gameTileLayoutType,
		compactMetadataFormat = self.props.compactMetadataFormat,
		hideRating = 0,
		hidePlayerCount = 0
	}
	local v38 = if fFlagLuaAppNarrowTileHideRating then self.props.hideRating else nil
	v35.hideRating = v38
	local v39 = if fFlagLuaAppNarrowTileHidePlayerCount then self.props.hidePlayerCount else nil
	v35.hidePlayerCount = v39
	local element = createElement(GameStats, v35)

	if self.props.hideMetadata then
		if not self.props.isHovered then
			return nil
		end

		if isShowSponsoredLabel then
			return React.createElement(GridTileSponsoredFooter, {
				useLargerFont = v24,
				onActivateSponsoredTooltip = self.onActivateSponsoredTooltip,
				isUnifiedGameTile = true,
				gameTileLayoutType = self.props.gameTileLayoutType,
				isNarrowScreenXSmall = self.props.isNarrowScreenXSmall,
				enableSponsoredFeedback = self.props.enableSponsoredFeedback,
				isSponsoredRatingFooterAllowed = self.props.isSponsoredRatingFooterAllowed,
				gameStatsElement = element
			})
		end

		if flag then
			return React.createElement(GridTileTextFooter, {
				text = v28,
				useLargerFont = v24,
				isUnifiedGameTile = true
			})
		end

		return nil
	end

	if isShowSponsoredLabel then
		return (React.createElement(GridTileSponsoredFooter, {
			useLargerFont = v24,
			onActivateSponsoredTooltip = self.onActivateSponsoredTooltip,
			isUnifiedGameTile = true,
			gameTileLayoutType = self.props.gameTileLayoutType,
			isNarrowScreenXSmall = self.props.isNarrowScreenXSmall,
			enableSponsoredFeedback = self.props.enableSponsoredFeedback,
			isSponsoredRatingFooterAllowed = self.props.isSponsoredRatingFooterAllowed,
			gameStatsElement = element
		}))
	end

	if fFlagLuaAppGenreRatingFooter and v31 and not flag then
		return (React.createElement(RatingWithGenreFooter, {
			useLargerFont = v24,
			totalUpVotes = v32,
			totalDownVotes = v33,
			genreText = v29,
			isUnifiedGameTile = true
		}))
	end

	if v30 then
		return (React.createElement(GridTileTextFooter, {
			text = v28,
			useLargerFont = v24,
			isUnifiedGameTile = true
		}))
	end

	if v25 then
		if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			return (Roact.createElement(gridTileFriendFooter, {
				showOnlineBorder = false,
				useLargerFont = v24,
				friendUserIds = inGameUserIds,
				onFriendFooterActivated = self.onFriendFooterActivated
			}))
		end

		return (Roact.createElement(gridTileFriendFooter, {
			showOnlineBorder = false,
			friends = v26,
			useLargerFont = v24
		}))
	end

	if self.props.friendVisitedString then
		return (Roact.createElement(GridTileIconTextFooter, {
			icon = images["icons/menu/recent"],
			text = self.props.friendVisitedString,
			iconSize = v24 and 32 or 24,
			useLargerFont = v24
		}))
	end

	if not v27 then
		return element
	end

	if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		return (Roact.createElement(gridTileFriendFooter, {
			showOnlineBorder = false,
			friendUserIds = self.getVisitedFriends(),
			useLargerFont = v24
		}))
	end

	return (Roact.createElement(gridTileFriendFooter, {
		showOnlineBorder = false,
		friends = self.getVisitedFriends(),
		useLargerFont = v24
	}))
end

function extended:renderContent(reducedMotion, p2, p3)
	local size = self.props.Size or UDim2.fromScale(1, 1)
	local imageThumbnail = self.props.imageThumbnail
	local onGameTileActivated = self.props.onGameTileActivated
	local v23

	if fFlagLuaAppContinueSortInstantPlay then
		v23 = fn(self.props.enableInstantPlay, self.props.instantPlayTreatment)
	end

	local v24 = self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Always
		or self.props.isHovered and self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Hover

	local imageAspectRatio = GameTileViewConfig.getImageAspectRatio(self.props.gameTileLayoutType)
	local gridTilesFooter = self:renderGridTilesFooter()
	local name = not self.props.hideTitle
		and (self.props.name or self.state.gameInfo and self.state.gameInfo.name or "")
		or nil
	local v25

	if v24 then
		v25 = React.createElement(GameStats, {
			stats = {
				playerCount = self.props.entry.playerCount,
				displayConcurrentUsersPill = true
			}
		})
	end

	local playButtonHeight = GameTileViewConfig.getElementSizes(
		p2.Tokens,
		self.props.textSizeOffset,
		self.props.contentTextLineCount,
		self.props.foundationTokens,
		true
	).playButtonHeight
	local v26

	if self.props.isHidden then
		v26 = React.createElement(HiddenTileContent, {
			appPage = self.props.appPage,
			collectionId = self.props.topicId,
			setGameHidden = self.props.setGameHidden,
			universeId = self.props.universeId,
			parentRef = self.props.hoverRef,
			isSponsored = self.props.entry.isSponsored
		})
	elseif self.props.videoThumbnail then
		local createElement = React.createElement
		local v28 = {
			video = self.props.videoThumbnail,
			accessContext = 0,
			image = 0,
			playing = 0,
			looped = true,
			Size = 0,
			isTileContained = 0,
			cornerRadius = 0,
			ZIndex = -2,
			onActivated = 0,
			itemIndex = 0,
			videoAnalytics = 0,
			universeId = 0,
			videoPlaybackCoordinator = 0
		}
		local v29 = if fFlagLuaAppHomeMomentVideoFallback then self.props.videoAccessContext else nil
		v28.accessContext = v29
		v28.image = imageThumbnail
		v28.playing = self.props.isVideoPlaying

		v28.Size = UDim2.fromScale(1, 1)
		v28.isTileContained = self.props.isContained
		v28.cornerRadius = p2.Tokens.Size.Size_200
		local v30

		if not fFlagLuaAppVideoTileDisableActivation then
			if fFlagLuaAppContinueSortInstantPlay and v23.isTreatment1 then
				v30 = self.onInstantPlayActivated
			elseif fFlagLuaAppEdpMediaGalleryFullScreen then
				if fFlagLuaAppGameTileExtractGameDetailsCallback then
					v30 = self.onGameDetailsActivated
				else
					v30 = fFlagLuaAppGameDetailsAttributionFix and function()
						onGameTileActivated(self.isMounted)
					end or self.onActivated
				end
			end
		end

		v28.onActivated = v30

		v28.itemIndex = self.props.index
		v28.videoAnalytics = self.props.videoAnalytics
		v28.universeId = self.props.universeId
		local v31 = if self.props.videoPlaybackContext then self.props.videoPlaybackContext.videoPlaybackCoordinator else nil
		v28.videoPlaybackCoordinator = v31
		v26 = createElement(GameTileVideoThumbnail, v28)
	end

	if defineFastFlag or not self.props.isVideoPlaying then
		if self.props.tileBadges then
			v25 = Roact.createFragment({
				SocialFeaturePill = v25,
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = self.props.tileBadges
				})
			})
		end
	else
		v25 = nil
	end

	if fFlagLuaAppContinueSortInstantPlay and v23.isTreatment1 and not self.props.isHidden then
		local element = React.createElement(Foundation.View, {
			tag = "align-x-center align-y-center anchor-bottom-left size-600-600 radius-medium",
			backgroundStyle = p3.Color.Extended.Black.Black_70,
			Position = UDim2.new(0, p3.Padding.XSmall, 1, -p3.Padding.XSmall)
		}, {
			Icon = React.createElement(Foundation.Icon, {
				name = Foundation.Enums.IconName.PlaySmall,
				size = Foundation.Enums.IconSize.Small,
				style = p3.Color.Extended.White.White_100
			})
		})

		if v25 then
			v25 = Roact.createFragment({ Existing = v25, PlayOverlay = element })
		else
			v25 = element
		end
	end

	local isHidden = self.props.isHidden
	local v27

	if next(self.props.availableMenuItems) ~= nil then
		local createElement, v28, v29, isSelected, onGameDetailsActivated

		if self.props.isHovered or self.props.overflowMenuOpen then
			if not isHidden then
				createElement = React.createElement
				v28 = if fFlagLuaAppGameTileNotInterestedDirectAction then GameTileContextualActions else GameTileOverflowMenu
				v29 = {
					isHovered = self.props.isHovered,
					isSelected = 0,
					universeId = 0,
					placeId = 0,
					collectionId = 0,
					appPage = 0,
					setGameHidden = 0,
					menuKey = 0,
					menuOpen = 0,
					onMenuOpenChanged = 0,
					parentRef = 0,
					isSponsored = 0,
					payerName = 0,
					sponsoredUserCohort = 0,
					adId = 0,
					availableMenuItems = 0,
					onGameDetailsActivated = 0
				}

				if fFlagLuaAppGameTileSelectionVideoPlayback then
					isSelected = self.props.isSelected
				else
					isSelected = self.state.isSelected
				end

				v29.isSelected = isSelected

				v29.universeId = self.props.universeId
				v29.placeId = self.props.entry.placeId
				v29.collectionId = self.props.topicId
				v29.appPage = self.props.appPage
				v29.setGameHidden = self.props.setGameHidden
				v29.menuKey = self.props.hoverKey
				v29.menuOpen = self.props.overflowMenuOpen
				v29.onMenuOpenChanged = self.onMenuOpenChanged
				v29.parentRef = self.props.hoverRef
				v29.isSponsored = self.props.entry.isSponsored
				v29.payerName = self.props.entry.payerName
				v29.sponsoredUserCohort = self.props.sponsoredUserCohort
				v29.adId = self.props.entry.adId
				v29.availableMenuItems = self.props.availableMenuItems

				if fFlagLuaAppContinueSortInstantPlay and v23.isActive then
					onGameDetailsActivated = self.onGameDetailsActivated
				end

				v29.onGameDetailsActivated = onGameDetailsActivated
				v27 = createElement(v28, v29)
			end
		else
			local v30

			if fFlagLuaAppGameTileSelectionVideoPlayback then
				v30 = self.props.isSelected
			else
				v30 = self.state.isSelected
			end

			if v30 then
				if not isHidden then
					createElement = React.createElement
					v28 = if fFlagLuaAppGameTileNotInterestedDirectAction then GameTileContextualActions else GameTileOverflowMenu
					v29 = {
						isHovered = self.props.isHovered,
						isSelected = 0,
						universeId = 0,
						placeId = 0,
						collectionId = 0,
						appPage = 0,
						setGameHidden = 0,
						menuKey = 0,
						menuOpen = 0,
						onMenuOpenChanged = 0,
						parentRef = 0,
						isSponsored = 0,
						payerName = 0,
						sponsoredUserCohort = 0,
						adId = 0,
						availableMenuItems = 0,
						onGameDetailsActivated = 0
					}

					if fFlagLuaAppGameTileSelectionVideoPlayback then
						isSelected = self.props.isSelected
					else
						isSelected = self.state.isSelected
					end

					v29.isSelected = isSelected

					v29.universeId = self.props.universeId
					v29.placeId = self.props.entry.placeId
					v29.collectionId = self.props.topicId
					v29.appPage = self.props.appPage
					v29.setGameHidden = self.props.setGameHidden
					v29.menuKey = self.props.hoverKey
					v29.menuOpen = self.props.overflowMenuOpen
					v29.onMenuOpenChanged = self.onMenuOpenChanged
					v29.parentRef = self.props.hoverRef
					v29.isSponsored = self.props.entry.isSponsored
					v29.payerName = self.props.entry.payerName
					v29.sponsoredUserCohort = self.props.sponsoredUserCohort
					v29.adId = self.props.entry.adId
					v29.availableMenuItems = self.props.availableMenuItems

					if fFlagLuaAppContinueSortInstantPlay and v23.isActive then
						onGameDetailsActivated = self.onGameDetailsActivated
					end

					v29.onGameDetailsActivated = onGameDetailsActivated
					v27 = createElement(v28, v29)
				end
			end
		end
	end

	local createElement = React.createElement
	local v29 = {
		Size = size,
		ZIndex = self.props.ZIndex,
		BackgroundTransparency = 1,
		LayoutOrder = self.props.layoutOrder,
		ref = self.gameTileRef
	}

	local createElement2 = React.createElement
	local v32 = {
		SelectionOrder = self.props.SelectionOrder,
		Selectable = not isHidden,
		hoverPadding = 0,
		numLinesForTitle = 0,
		numLinesForMetadata = 0,
		imageAspectRatio = 0,
		isContained = 0,
		containmentSidePadding = 0,
		Size = 0,
		image = 0,
		thumbnailComponent = 0,
		title = 0,
		isDisabled = 0,
		onActivated = 0,
		onGuiStateChanged = 0,
		onSelectionGained = 0,
		onSelectionLost = 0,
		onTouchLongPress = 0,
		onMetadataActivated = 0,
		reducedMotion = 0,
		isHovered = 0,
		forwardRef = 0,
		hidePlayButton = 0,
		hoverActionRow = 0,
		thumbnailOverlay = 0,
		overflowMenu = 0,
		footerMetadata = 0,
		isUnifiedGameTile = true,
		textSizeOffset = 0,
		hideMetadata = 0,
		isTouchPreferredInput = 0
	}

	local v33 = if not (fFlagLuaAppMigrateGameTileHoverFixes or self.props.useGridTile) then p2.Tokens.Size.Size_200 else nil
	v32.hoverPadding = v33

	v32.numLinesForTitle = self.props.contentTextLineCount
	v32.numLinesForMetadata = self.props.metadataTextLineCount
	v32.imageAspectRatio = imageAspectRatio
	v32.isContained = self.props.isContained
	v32.containmentSidePadding = GameTileViewConfig.getContainmentSidePadding(
		p2.Tokens,
		self.props.gameTileLayoutType,
		self.props.foundationTokens
	)

	v32.Size = UDim2.fromScale(1, 1)
	v32.image = imageThumbnail
	v32.thumbnailComponent = v26

	if isHidden then
		name = nil
	end

	v32.title = name
	v32.isDisabled = isHidden and true or self.props.isDisabled
	local v34

	if fFlagLuaAppContinueSortInstantPlay and v23.isTreatment1 and not isHidden then
		v34 = self.onInstantPlayActivated
	elseif fFlagLuaAppGameTileExtractGameDetailsCallback then
		v34 = if isHidden then self.onActivated else self.onGameDetailsActivated
	else
		v34 = fFlagLuaAppGameDetailsAttributionFix and not isHidden and function()
			onGameTileActivated(self.isMounted)
		end or self.onActivated
	end

	v32.onActivated = v34

	v32.onGuiStateChanged = self.props.onGuiStateChanged
	v32.onSelectionGained = self.onSelectionGained
	v32.onSelectionLost = self.onSelectionLost
	local v35 = if not isHidden then self.onTouchLongPress else nil
	v32.onTouchLongPress = v35

	local v36 = if fFlagLuaAppContinueSortInstantPlay and v23.isTreatment1 and not isHidden then self.onGameDetailsActivated else nil
	v32.onMetadataActivated = v36

	v32.reducedMotion = reducedMotion
	v32.isHovered = not isHidden and self.props.isHovered
	v32.forwardRef = self.props.hoverRef
	v32.hidePlayButton = isHidden and true or self.props.hidePlayButton
	local v38

	if not (self.props.hidePlayButton or isHidden or fFlagLuaAppContinueSortInstantPlay and v23.isActive) then
		local createElement3 = React.createElement
		local v40 = {
			universeId = self.props.navigationUniverseId,
			referralSource = self.props.referralSource,
			launchSource = "ExperienceTile",
			reportExperienceLaunched = self.reportExperienceLaunchedFromActionBar,
			openGameDetails = 0,
			entry = 0,
			launchExperienceEventContext = 0,
			fetchDelayInSeconds = 0,
			index = 0,
			horizontalPadding = 0,
			verticalPadding = 0,
			height = 0,
			showButtonText = 0,
			isUnifiedGameTileEnabled = 0,
			placeIdOverride = 0,
			launchDataOverride = 0
		}
		local v41

		if fFlagLuaAppGameTileExtractGameDetailsCallback then
			v41 = self.onGameDetailsActivated
		else
			v41 = fFlagLuaAppGameDetailsAttributionFix and function()
				onGameTileActivated(self.isMounted)
			end or self.onActivated
		end

		v40.openGameDetails = v41

		v40.entry = self.props.entry
		v40.launchExperienceEventContext = self.props.launchExperienceEventContext
		v40.fetchDelayInSeconds = game:GetFastInt("LuaAppGameTileHoverDelayMs") / 1000
		v40.index = self.props.index

		v40.height = playButtonHeight
		v40.showButtonText = imageAspectRatio > 1
		v40.isUnifiedGameTileEnabled = fFlagLuaAppUnifyPlayButtonTile and true or nil
		v40.placeIdOverride = self.props.entry.placeIdOverride
		v40.launchDataOverride = self.props.entry.launchDataOverride
		v38 = createElement3(AppExperienceActionRow, v40)
	end

	v32.hoverActionRow = v38

	if isHidden then
		v25 = nil
	end

	v32.thumbnailOverlay = v25
	v32.overflowMenu = v27

	if isHidden then
		gridTilesFooter = nil
	end

	v32.footerMetadata = gridTilesFooter

	v32.textSizeOffset = self.props.textSizeOffset
	v32.hideMetadata = self.props.hideMetadata

	local v39 = if fFlagLuaAppContinueSortInstantPlay then self.props.isTouchPreferredInput else nil
	v32.isTouchPreferredInput = v39
	local v30 = {
		Tile = createElement2(GameTileView, v32),
		VideoPlaybackDetector = self.props.videoPlaybackDetector,
		InstantPlayLauncher = 0
	}

	local v40 = if fFlagLuaAppContinueSortInstantPlay and v23.isActive and self.state.instantPlayRequested then React.createElement(module43, {
		universeId = self.props.navigationUniverseId,
		referralSource = self.props.referralSource,
		eventContext = DiscoveryAnalytics.Constants.Context.InstantPlay,
		launchSource = "ExperienceTile",
		launchData = self.props.entry.launchDataOverride,
		placeId = self.props.entry.placeIdOverride,
		reportExperienceLaunched = self.reportExperienceLaunchedFromInstantPlay,
		openGameDetails = self.onGameDetailsActivated,
		onLaunchAttemptCompleted = self.onInstantPlayAttemptCompleted
	}) else nil
	v30.InstantPlayLauncher = v40
	return createElement("Frame", v29, v30)
end

function extended:render()
	if discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then
		discoveryAppLaunchTracker.default:trackTileRender()
	end

	if self.props.game == nil then
		return nil
	end

	return withStyle(function(p2)
		return self:renderContent(p2.Settings.ReducedMotion, p2, self.props.foundationTokens)
	end)
end

function extended:didMount()
	self.isMounted = true
	impressionsTagUtility.AddTag(self.gameTileRef, self.props.impressionsTag, self.props.index)

	if not self.props.useGridTile and self.props.friendFooterEnabled and self.props.hasInGameFriends then
		self:setState({ canDisplayFriendFooter = true })
	end

	if self.props.useGridTile then
		self.loadWideThumbnail()
	end
end

function extended:willUnmount()
	self.isMounted = false
	impressionsTagUtility.RemoveTag(self.gameTileRef, self.props.impressionsTag, self.props.index)
	self.gameInfoSubscription.dispose()
end

function extended.didUpdate(object, data)
	object.gameInfoSubscription.update(object.props.entry.universeId)

	if data.impressionsTag ~= object.props.impressionsTag or data.index ~= object.props.index then
		impressionsTagUtility.RemoveTag(object.gameTileRef, data.impressionsTag, data.index)
		impressionsTagUtility.AddTag(object.gameTileRef, object.props.impressionsTag, object.props.index)
	end

	if object.props.useGridTile and data.universeId ~= object.props.universeId then
		object.loadWideThumbnail()
	end

	if
		not object.props.useGridTile
		and (data.friendFooterEnabled ~= object.props.friendFooterEnabled or data.hasInGameFriends ~= object.props.hasInGameFriends)
		and object.props.friendFooterEnabled
		and object.props.hasInGameFriends
	then
		object:setState({ canDisplayFriendFooter = true })
	end
end

local v23 = RoactRodux.connect(function(p2, data)
	local universeId = data.entry.universeId
	local v24

	if not fFlagLuaAppGameDetailsAttributionFix then
		if
			data.entry.navigationUniverseId
			and data.entry.navigationUniverseId ~= ""
			and data.entry.navigationUniverseId ~= "0"
		then
			v24 = data.entry.navigationUniverseId
		else
			v24 = data.entry.universeId
		end
	end

	local v25 = p2.Personalization[gameInfosReducer.key][universeId]

	local friendActivityTitle = if v25 then v25.friendActivityTitle or nil else nil
	local v26

	if data.gameTileLayoutType == "Event" then
		v26 = data.playButtonStyle ~= GameTileConstants.PlayButtonStyleValues.Enabled
	elseif data.gameTileLayoutType == "Wide" then
		v26 = data.playButtonStyle == GameTileConstants.PlayButtonStyleValues.Disabled
	else
		v26 = false
	end

	local v27 = getGameTileLayoutData(v25, data.topicId)

	local gameIconUrl = data.gameIconUrl
	local v28, v29

	if fFlagLuaAppHomeThumbnailPrefetch then
		local function resolveThumbnail(p3)
			return v5({
				iconUrl = gameIconUrl,
				universeId = universeId,
				placeId = data.entry.placeId,
				useGridTile = p3,
				perEntryWideAssetId = data.entry.primaryWideImageAssetId,
				game = v25,
				topicId = data.topicId
			})
		end

		local useGridTile = data.useGridTile == true
		v28 = v5({
			iconUrl = gameIconUrl,
			universeId = universeId,
			placeId = data.entry.placeId,
			useGridTile = useGridTile,
			perEntryWideAssetId = data.entry.primaryWideImageAssetId,
			game = v25,
			topicId = data.topicId
		})

		if data.useGridTile then
			v29 = v28
		else
			v29 = v5({
				iconUrl = gameIconUrl,
				universeId = universeId,
				placeId = data.entry.placeId,
				useGridTile = true,
				perEntryWideAssetId = data.entry.primaryWideImageAssetId,
				game = v25,
				topicId = data.topicId
			})
		end
	else
		local v30

		if data.entry.primaryWideImageAssetId then
			v30 = data.entry.primaryWideImageAssetId
		else
			v30 = ItemLayoutDataParsingUtils.getWideImageAssetId(v27)
		end

		if not v30 then
			v30 = if v25 then v25.primaryWideAssetId or nil else nil
		end

		v29 = formatExperienceThumbnail(v30, data.entry.placeId)

		v28 = if data.useGridTile then v29 else formatExperienceIcon(gameIconUrl, universeId)
	end

	local accessContext = nil
	local v30

	if fFlagLuaAppHomeMomentVideoFallback then
		local v31 = getLayoutDataVideo(v27, data.entry.primaryWideVideoAssetId)
		v30 = v31 and v31.assetId
		accessContext = v31 and v31.accessContext
	elseif data.entry.primaryWideVideoAssetId then
		v30 = data.entry.primaryWideVideoAssetId
	else
		v30 = v27 and v27.primaryMediaAsset and v27.primaryMediaAsset.wideVideoAssetId
	end

	local v31 = if v30 then `rbxassetid://{v30}` else nil

	local friendVisits = v25 and v25.friendVisits or v6
	local friendVisitedString = if v25 and v25.friendVisitedString ~= "" then v25.friendVisitedString else nil

	local footer = if v27 then v27.footer or nil else nil

	local title = v27 and v27.title

	local v32 = {
		game = v25,
		universeId = universeId,
		navigationUniverseId = nil,
		name = nil,
		imageThumbnail = nil,
		wideThumbnail = nil,
		videoThumbnail = nil,
		videoAccessContext = nil,
		friendActivityTitle = nil,
		friendVisits = nil,
		friendVisitedString = nil,
		hidePlayButton = nil,
		footerLayoutData = nil
	}

	if fFlagLuaAppGameDetailsAttributionFix then
		v24 = nil
	end

	v32.navigationUniverseId = v24
	v32.name = title
	v32.imageThumbnail = v28
	v32.wideThumbnail = v29
	v32.videoThumbnail = v31

	if not fFlagLuaAppHomeMomentVideoFallback then
		accessContext = nil
	end

	v32.videoAccessContext = accessContext
	v32.friendActivityTitle = friendActivityTitle
	v32.friendVisits = friendVisits
	v32.friendVisitedString = friendVisitedString
	v32.hidePlayButton = v26
	v32.footerLayoutData = footer
	return v32
end, function(callback)
	return {
		openContextualMenu = function(p2, p3, p4)
			callback(OpenCentralOverlayForPlacesList(p2, p3, p4))
		end,
		openSponsoredTooltip = function(p2)
			return callback(OpenSponsoredTooltip(p2))
		end
	}
end)(extended)

if not fFlagLuaAppGameDetailsAttributionFix then
	v23 = roactServices.connect({ networking = roactNetworking })(v23)
end

local function fn3(props)
	local ref = React.useRef(nil)
	local v24 = useTokens()
	local v25 = props.useHoverTile

	local v26 = GameHydrationReact.useGameIcon(props.entry.universeId)

	local formatted = `{props.impressionsTag or ""}_{props.index or "0"}_{props.gameTileLayoutType or "Narrow"}`

	if props.impressionsTag == nil or props.index == nil then
		v25 = false
	end

	local v27 = useIsHoveredTile(ref, formatted, v25)

	local v28 = useUiModeInfo().uiMode == uiMode.TenFoot
	local v29 = v28 and true or props.useHoverTile

	if props.useExperienceTileMetadata ~= nil then
		v28 = props.useExperienceTileMetadata
	end

	local v30 = useValidTileBadges(props.entry.universeId, props.topicId, props.badgeOverride)

	local v31 = useSelector(function(p2)
		return p2.LocalUserId
	end)
	local v32

	if not fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		v32 = useSelector(function(p2)
			return p2.Users
		end)
	end

	local v33 = useSelector(function(p2)
		return p2.InGameUsersByGame[props.entry.universeId]
	end)

	local v34 = useHasInGameFriends(v31, v32, v33)
	local v35

	if fFlagGameTileMigrateOffLegacyPresence then
		v35 = useGetOnlineFriendsByUniverseId(props.entry.universeId)
	else
		v35 = nil
	end

	local v36

	if fFlagGameTileMigrateOffLegacyPresence then
		v36 = React.useMemo(function()
			return Cryo.List.map(v35 or {}, function(p2)
				return p2.id
			end)
		end, { v35 })
	end

	if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		if not fFlagGameTileMigrateOffLegacyPresence then
			v36 = useInGameUserIds(v31, v33)
		end
	else
		v36 = nil
	end

	local state, setState = React.useState(false)

	local state2 = nil
	local v37 = nil
	local v38, v39

	if fFlagLuaAppGameTileSelectionVideoPlayback then
		local setState2
		state2, setState2 = React.useState(false)
		v37 = setState2

		v38 = React.useCallback(function(p2, p3, p4)
			v37(true)

			if props.onSelectionGained then
				props.onSelectionGained(p2, p3, p4)
			end
		end, { props.onSelectionGained })

		v39 = React.useCallback(function()
			v37(false)

			if props.onSelectionLost then
				props.onSelectionLost()
			end
		end, { props.onSelectionLost })
	end

	local v40

	if props.videoPlaybackContext == nil then
		v40 = false
	else
		v40 = props.videoPlaybackContext.disablePlayback == true
	end

	local v41 = fFlagLuaAppSuppressVideoDetectorDuringScroll

	if v41 then
		if props.videoPlaybackContext == nil then
			v41 = false
		else
			v41 = props.videoPlaybackContext.disableDetectors == true
		end
	end

	React.useEffect(function()
		if fFlagLuaAppFixHiddenTileVideoCleanup and props.isHidden or v40 then
			setState(false)
		end
	end, { props.isHidden, v40 })
	local v42, v43, v44, v45

	if fFlagLuaAppGameDetailsAttributionFix then
		v42 = useRoactService(roactNetworking)

		if
			props.entry.navigationUniverseId
			and props.entry.navigationUniverseId ~= ""
			and props.entry.navigationUniverseId ~= "0"
		then
			v43 = props.entry.navigationUniverseId
		else
			v43 = props.entry.universeId
		end

		v44 = React.useCallback(function()
			local entry = props.entry

			if entry.isSponsored then
				sponsoredGamesRecordClick(v42, entry.adId)
			end
		end, { v42, props.entry.isSponsored, props.entry.adId })

		local useCallback = React.useCallback
		local function fn4(p2)
			if props.isHovered then
				HoverTileCoordinator.default:reset()
			end

			if props.videoPlaybackContext and props.videoPlaybackContext.videoPlaybackCoordinator then
				props.videoPlaybackContext.videoPlaybackCoordinator:reset(
					VideoEndReason.TileClicked,
					nil,
					v43,
					nil
				)
			else
				videoPlaybackCoordinator.default:reset(VideoEndReason.TileClicked, nil, v43, nil)
			end

			if p2 then
				if props.onActivated then
					props.onActivated()
				end

				local v46 = {
					source = props.source,
					index = props.index,
					referralSource = props.referralSource,
					onPeekViewClosed = props.onPeekViewClosed,
					placeIdOverride = props.entry.placeIdOverride,
					experienceJoinData = 0
				}

				local v48 = if props.entry.launchDataOverride then props.entry.launchDataOverride else nil
				v46.experienceJoinData = {
					launchData = v48,
					tileType = props.entry.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile,
					nativeAdData = props.entry.adId
				}

				if getFFlagEnableNavigationPerformanceIntervals() then
					intervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
				end

				props.navigateToGameDetails(v43, v46)

				props.reportGameDetailOpened(props.index, v43)

				v44()
			end
		end

		local isHovered = props.isHovered
		local index = props.index
		local videoAnalytics = props.videoAnalytics
		local onActivated = props.onActivated
		local source = props.source
		local referralSource = props.referralSource
		local onPeekViewClosed = props.onPeekViewClosed
		local navigateToGameDetails = props.navigateToGameDetails
		local reportGameDetailOpened = props.reportGameDetailOpened
		local v47 = v43
		local v48 = v44
		local placeIdOverride = props.entry.placeIdOverride
		local launchDataOverride = props.entry.launchDataOverride
		local v49 = if props.videoPlaybackContext then props.videoPlaybackContext.videoPlaybackCoordinator else nil
		v45 = useCallback(fn4, {
			isHovered,
			index,
			videoAnalytics,
			onActivated,
			source,
			referralSource,
			onPeekViewClosed,
			navigateToGameDetails,
			reportGameDetailOpened,
			v47,
			v48,
			placeIdOverride,
			launchDataOverride,
			v49
		})
	else
		v42 = nil
		v43 = nil
		v44 = nil
	end

	local v46 = useOverflowMenuOpen(formatted)
	local v47 = useTriggerFeedback()
	local v48

	if fFlagLuaAppContinueSortInstantPlay then
		v48 = fn(props.enableInstantPlay, props.instantPlayTreatment)
	else
		v48 = nil
	end

	local useMemo = React.useMemo
	local function fn4()
		local v50 = {
			isSponsored = props.entry.isSponsored,
			enableExplicitFeedback = props.enableExplicitFeedback,
			enableSponsoredFeedback = props.enableSponsoredFeedback,
			enableReportAd = props.enableReportAd,
			enableGameDetails = 0,
			enableReportExperience = 0
		}
		local v51 = if fFlagLuaAppContinueSortInstantPlay then v48.isTreatment1 else nil
		v50.enableGameDetails = v51

		local v52 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
		v50.enableReportExperience = v52
		return getAvailableGameTileOverflowMenuItems(v50)
	end

	local isSponsored = props.entry.isSponsored
	local enableExplicitFeedback = props.enableExplicitFeedback
	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local isTreatment1 = if fFlagLuaAppContinueSortInstantPlay then v48.isTreatment1 else nil
	local v50 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
	local v51 = useMemo(fn4, {
		isSponsored,
		enableExplicitFeedback,
		enableSponsoredFeedback,
		enableReportAd,
		isTreatment1,
		v50
	})

	local v52 = useHasVideoThumbnailSelector(props.entry.universeId, props.topicId)

	local v53 = props.entry.primaryWideVideoAssetId ~= nil or v52

	local videoPlaybackContext = props.videoPlaybackContext
	local v55 = if fFlagLuaAppTileVideoCandidateOnly then v53 else nil
	local v56 = if fFlagLuaAppFixHiddenTileVideoCleanup then props.isHidden else nil
	useTagAsViewportAutoplayCandidate(
		ref,
		videoPlaybackContext,
		v55,
		v56,
		nil,
		nil,
		nil,
		fFlagLuaAppOneByTwoHoverIdleAutoplay and v53 and {
			videoKey = formatted,
			isUserIntentModeAutoplayCandidate = false
		} or nil
	)
	local v57

	if not (fFlagLuaAppGameTileSelectionVideoPlayback or not fFlagLuaAppEdpMediaGalleryVideoPreview) then
		v57 = usePreferredInput()
	end

	local v58

	if v53 and not (props.isHidden or fFlagLuaAppSuppressVideoDetectorDuringScroll and v41) and not v40 then
		local createElement = React.createElement
		local v60 = {
			videoKey = formatted,
			itemIndex = props.index,
			universeId = props.entry.universeId,
			tileRef = ref,
			isHoverSupported = v25,
			isHovered = v27,
			isSelected = if fFlagLuaAppGameTileSelectionVideoPlayback then state2 else nil,
			autoplay = 0,
			onPlaybackChange = 0,
			videoAnalytics = 0,
			videoDwellTimeInSec = 0,
			videoVisiblePercent = 0,
			hasPrevalidatedVideoGamePlayability = 0,
			pageContext = 0,
			videoPlaybackContext = 0
		}

		local v62 = if not (fFlagLuaAppGameTileSelectionVideoPlayback or not fFlagLuaAppEdpMediaGalleryVideoPreview) then v57 == Responsive.Input.Touch else nil
		v60.autoplay = v62

		v60.onPlaybackChange = setState
		v60.videoAnalytics = props.videoAnalytics
		v60.videoDwellTimeInSec = fIntLuaAppGameTileVideoDwellTimeInSec
		v60.videoVisiblePercent = fIntLuaAppGameTileVideoVisiblePercent

		local v63 = if fFlagLuaAppUsePrevalidatedVideoGamePlayability then props.hasPrevalidatedVideoGamePlayability else nil
		v60.hasPrevalidatedVideoGamePlayability = v63

		v60.pageContext = props.appPage
		v60.videoPlaybackContext = props.videoPlaybackContext
		v58 = createElement(GameVideoPlaybackDetector, v60)
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	if not fFlagLuaAppGameTileSelectionVideoPlayback then
		state2 = nil
	end

	if not fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		v36 = nil
	end

	local v60 = {
		useExperienceTileMetadata = v28,
		hasBackground = v29,
		gameIconUrl = v26,
		hoverRef = ref,
		isHoverSupported = v25,
		isHovered = v27,
		isSelected = state2,
		isVideoPlaying = state,
		tileBadges = v30,
		foundationTokens = v24,
		users = v32,
		inGameUsersByGame = v33,
		hasInGameFriends = v34,
		inGameUserIds = v36,
		networking = if fFlagLuaAppGameDetailsAttributionFix then v42 else nil,
		navigationUniverseId = if fFlagLuaAppGameDetailsAttributionFix then v43 else nil,
		onGameTileActivated = nil,
		recordSponsoredGameClick = nil,
		overflowMenuOpen = nil,
		hoverKey = nil,
		triggerFeedback = nil,
		availableMenuItems = nil,
		onSelectionGained = 0,
		onSelectionLost = 0,
		videoPlaybackDetector = 0
	}

	if not fFlagLuaAppGameDetailsAttributionFix then
		v45 = nil
	end

	v60.onGameTileActivated = v45
	v60.recordSponsoredGameClick = if fFlagLuaAppGameDetailsAttributionFix then v44 else nil
	v60.overflowMenuOpen = v46
	v60.hoverKey = formatted
	v60.triggerFeedback = v47
	v60.availableMenuItems = v51

	if not fFlagLuaAppGameTileSelectionVideoPlayback then
		v38 = props.onSelectionGained
	end

	v60.onSelectionGained = v38

	if not fFlagLuaAppGameTileSelectionVideoPlayback then
		v39 = props.onSelectionLost
	end

	v60.onSelectionLost = v39

	v60.videoPlaybackDetector = v58
	return (createElement(v23, join(props, v60)))
end

if fFlagSignalsNavP3fGameDetails then
	fn3 = React.memo(fn3)
end

return fn3
