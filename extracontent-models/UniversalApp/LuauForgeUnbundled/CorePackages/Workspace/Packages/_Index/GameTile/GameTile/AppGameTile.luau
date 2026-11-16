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
local formatExperienceRating = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/formatExperienceRating")
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
local defineFastFlag = game:DefineFastFlag("LuaAppUseRatingFormatHelper2", false)

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
local defineFastFlag2 = game:DefineFastFlag("LuaAppKeepTileBadgesDuringVideo", false)
local fFlagLuaAppVideoTileDisableActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppVideoTileDisableActivation
local fFlagLuaAppFixHiddenTileVideoCleanup = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppFixHiddenTileVideoCleanup

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUsePrevalidatedVideoGamePlayability
local fFlagLuaAppContinueSortInstantPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppContinueSortInstantPlay

local fFlagLuaAppGameTileExtractGameDetailsCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGameTileExtractGameDetailsCallback
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local module44 = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/InstantPlayLauncher")
local InstantPlayButton = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/InstantPlayButton")
local fFlagLuaAppGenreRatingFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGenreRatingFooter

local fFlagLuaAppGameTileSelectionVideoPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGameTileSelectionVideoPlayback

local fFlagLuaAppSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppSuppressVideoDetectorDuringScroll
local fFlagLuaAppHomeThumbnailPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeThumbnailPrefetch
local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeMomentVideoFallback
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagMigrateGameInfoToStore

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
local v15 = if fFlagMigrateGameInfoToStore then t.optional(t.string) else t.string
v8.name = v15
local v16 = if not fFlagMigrateGameInfoToStore then t.number else nil
v8.totalUpVotes = v16
local v17 = if not fFlagMigrateGameInfoToStore then t.number else nil
v8.totalDownVotes = v17
v8.friendActivityTitle = t.optional(t.string)
v8.friendVisitedString = t.optional(t.string)
v8.imageThumbnail = t.string
v8.wideThumbnail = t.optional(t.string)
v8.videoThumbnail = t.optional(t.string)
local v18 = if fFlagLuaAppHomeMomentVideoFallback then t.optional(t.string) else nil
v8.videoAccessContext = v18
v8.rating = t.optional(t.string)
v8.showAgeRating = t.optional(t.boolean)
v8.ageRatingText = t.optional(t.string)
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
local v19 = if fFlagLuaAppGameTileSelectionVideoPlayback then t.boolean else nil
v8.isSelected = v19
v8.isVideoPlaying = t.boolean
v8.tileBadges = t.optional(t.table)
v8.users = t.optional(t.table)
v8.inGameUsersByGame = t.optional(t.table)
v8.hasInGameFriends = t.boolean
local v20 = if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then t.table else nil
v8.inGameUserIds = v20
v8.badgeOverride = t.optional(t.table)
v8.forceHideAgeRatings = t.optional(t.boolean)
local v21 = if fFlagLuaAppGameDetailsAttributionFix then t.optional(t.callback) else nil
v8.onGameTileActivated = v21
local v22 = if fFlagLuaAppGameDetailsAttributionFix then t.optional(t.callback) else nil
v8.recordSponsoredGameClick = v22
v8.overflowMenuOpen = t.optional(t.boolean)
v8.hoverKey = t.optional(t.string)
v8.triggerFeedback = t.callback
v8.videoPlaybackDetector = t.optional(t.table)
local v23 = if fFlagLuaAppContinueSortInstantPlay then t.optional(t.boolean) else nil
v8.enableInstantPlay = v23
local v24 = if fFlagLuaAppContinueSortInstantPlay then t.optional(t.string) else nil
v8.instantPlayTreatment = v24
local v25 = if fFlagLuaAppContinueSortInstantPlay then t.optional(t.boolean) else nil
v8.isTouchPreferredInput = v25
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

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
			universeId = self.props.entry.universeId,
			onChange = function(p2)
				self:setState({
					gameInfo = p2.gameInfo or none,
					storeVotes = p2.votes or none
				})
			end
		})
	end

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
				local v29 = {
					universeId = self.props.universeId,
					sortId = self.props.topicId
				}

				self.props.triggerFeedback("TileLongPress", "Press", self.props.appPage or "Unknown", v29)
			end

			getOverflowMenuSignalStore().openMenu(self.props.hoverKey)
			local v29 = {}

			for k, availableMenuItem in self.props.availableMenuItems do
				table.insert(v29, k)
			end

			self.onMenuOpenChanged(false, table.concat(v29, ","))
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
	local v29

	if fFlagLuaAppContinueSortInstantPlay then
		v29 = self.reportExperienceLaunched
	else
		v29 = function(...)
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

	self.reportExperienceLaunchedFromActionBar = v29

	function self.renderAppExperienceActionRow(p2)
		local createElement = Roact.createElement
		local v31 = {
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
		local v32

		if fFlagLuaAppGameTileExtractGameDetailsCallback then
			v32 = self.onGameDetailsActivated
		elseif fFlagLuaAppGameDetailsAttributionFix then
			v32 = function()
				self.props.onGameTileActivated(self.isMounted)
			end
		else
			v32 = self.onActivated
		end

		v31.openGameDetails = v32

		v31.entry = self.props.entry
		v31.launchExperienceEventContext = self.props.launchExperienceEventContext
		v31.horizontalPadding = self.props.useGridTile and 0 or nil
		v31.index = self.props.index
		v31.isUnifiedGameTileEnabled = fFlagLuaAppUnifyPlayButtonTile and true or nil
		v31.placeIdOverride = self.props.entry.placeIdOverride
		v31.launchDataOverride = self.props.entry.launchDataOverride
		return createElement(AppExperienceActionRow, v31)
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
			local v30 = {
				source = self.props.source,
				index = self.props.index,
				referralSource = self.props.referralSource,
				onPeekViewClosed = self.props.onPeekViewClosed,
				placeIdOverride = self.props.entry.placeIdOverride,
				experienceJoinData = 0
			}

			local v32 = if self.props.entry.launchDataOverride then self.props.entry.launchDataOverride else nil
			v30.experienceJoinData = {
				launchData = v32,
				tileType = self.props.entry.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile,
				nativeAdData = self.props.entry.adId
			}

			if getFFlagEnableNavigationPerformanceIntervals() then
				intervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
			end

			self.props.navigateToGameDetails(navigationUniverseId, v30)

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
			local v30

			if fFlagMigrateGameInfoToStore then
				local gameInfo = self.state.gameInfo
				v30 = self.props.game

				if not v30 then
					v30 = if gameInfo then toLegacyGameInfoModel(gameInfo) else nil
				end
			else
				v30 = self.props.game
			end

			local tileSize = self.getTileSize()
			self.props.openContextualMenu(v30, tileSize, self.getTilePosition())
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
			local v30 = p2[item]

			if v30 and v30.isFriend then
				table.insert(result, { userId = v30.id, displayName = v30.displayName })
			end
		end

		local v30 = sortFriendsByPresenceAndRecencyFactory("displayName")
		table.sort(result, v30)

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
	local v26

	if fFlagLuaAppContinueSortInstantPlay then
		v26 = fn(self.props.enableInstantPlay, self.props.instantPlayTreatment)
	end

	if fFlagLuaAppContinueSortInstantPlay and (v26.isTreatment2 or v26.isTreatment3) then
		return React.createElement(InstantPlayButton, {
			onActivated = self.onInstantPlayActivated,
			showIcon = v26.isTreatment2,
			showText = v26.isTreatment3
		})
	end

	local v27 = self.props.useHoverTile or self.props.useExperienceTileMetadata

	local friendFooterEnabled = self.props.friendFooterEnabled
	local v28 = self.props.hasInGameFriends
	local inGameUserIds

	if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		inGameUserIds = self.props.inGameUserIds
	end

	local users = self.props.users
	local inGameUsersByGame = self.props.inGameUsersByGame
	local v29

	if not fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		v29 = self.getSortedFriends(users, inGameUsersByGame)
	end

	if friendFooterEnabled then
		if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			v28 = inGameUserIds and #inGameUserIds > 0
		end
	else
		v28 = friendFooterEnabled
	end

	local v30 = self.props.friendVisits and #self.props.friendVisits > 0

	local footerLayoutData = self.props.footerLayoutData
	local v31

	if not (footerLayoutData == nil or footerLayoutData.type ~= "TextLabel") then
		local text = footerLayoutData.text

		if text ~= nil then
			v31 = text.textLiteral
		end
	end

	local v32 = if fFlagLuaAppGenreRatingFooter then fn2(self.props.footerLayoutData) else nil

	local flag = false
	local v33 = nil

	if fFlagMigrateGameInfoToStore then
		if not (self.props.hidePlayButton or self.props.forceHideAgeRatings) then
			local gameInfo = self.state.gameInfo
			local gameMinimumAge = gameInfo and gameInfo.gameMinimumAge or 0
			v33 = gameInfo and gameInfo.gameAgeDisplayName or ""

			if gameMinimumAge == 0 or v33 == "" then
				v33 = nil
			end
		end
	else
		v33 = self.props.ageRatingText
	end

	if self.props.isHovered then
		if v33 and not self.props.hidePlayButton then
			v31 = v33
			flag = true
		end
	else
		local v34

		if fFlagLuaAppGameTileSelectionVideoPlayback then
			v34 = self.props.isSelected
		else
			v34 = self.state.isSelected
		end

		if v34 and v33 and not self.props.hidePlayButton then
			v31 = v33
			flag = true
		end
	end

	local v34 = v31 ~= nil
	local v35 = if fFlagLuaAppGenreRatingFooter then v32 ~= nil else nil
	local entry = self.props.entry
	local isShowSponsoredLabel = entry.isSponsored
		and (entry.isShowSponsoredLabel or self.props.isSponsoredFooterAllowed or self.props.isSponsoredRatingFooterAllowed)

	if
		fFlagLuaAppMigrateGameTileFixConsoleMetadataText
		and self.props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow
		and self.props.useExperienceTileMetadata
		and (isShowSponsoredLabel or v34 or fFlagLuaAppGenreRatingFooter and v35)
		or self.props.compactMetadataFormat
	then
		v27 = false
	end

	local v36, v37

	if fFlagMigrateGameInfoToStore then
		local storeVotes = self.state.storeVotes
		v36 = not storeVotes and 0 or storeVotes.upVotes
		v37 = if storeVotes then storeVotes.downVotes else 0
	else
		v36 = self.props.totalUpVotes
		v37 = self.props.totalDownVotes
	end

	local createElement = Roact.createElement

	local v41 = if self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Footer then self.props.entry.playerCount else nil
	local v39 = {
		stats = { totalUpVotes = v36, totalDownVotes = v37, playerCount = v41 },
		isGridTile = self.props.useGridTile,
		hideGameStats = self.props.hideGameStats,
		useLargerFont = v27,
		isUnifiedGameTile = true,
		gameTileLayoutType = self.props.gameTileLayoutType,
		compactMetadataFormat = self.props.compactMetadataFormat,
		hideRating = 0,
		hidePlayerCount = 0
	}
	local v42 = if fFlagLuaAppNarrowTileHideRating then self.props.hideRating else nil
	v39.hideRating = v42
	local v43 = if fFlagLuaAppNarrowTileHidePlayerCount then self.props.hidePlayerCount else nil
	v39.hidePlayerCount = v43
	local element = createElement(GameStats, v39)

	if self.props.hideMetadata then
		if not self.props.isHovered then
			return nil
		end

		if isShowSponsoredLabel then
			return React.createElement(GridTileSponsoredFooter, {
				useLargerFont = v27,
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
				text = v31,
				useLargerFont = v27,
				isUnifiedGameTile = true
			})
		end

		return nil
	end

	if isShowSponsoredLabel then
		return (React.createElement(GridTileSponsoredFooter, {
			useLargerFont = v27,
			onActivateSponsoredTooltip = self.onActivateSponsoredTooltip,
			isUnifiedGameTile = true,
			gameTileLayoutType = self.props.gameTileLayoutType,
			isNarrowScreenXSmall = self.props.isNarrowScreenXSmall,
			enableSponsoredFeedback = self.props.enableSponsoredFeedback,
			isSponsoredRatingFooterAllowed = self.props.isSponsoredRatingFooterAllowed,
			gameStatsElement = element
		}))
	end

	if fFlagLuaAppGenreRatingFooter and v35 and not flag then
		return (React.createElement(RatingWithGenreFooter, {
			useLargerFont = v27,
			totalUpVotes = v36,
			totalDownVotes = v37,
			genreText = v32,
			isUnifiedGameTile = true
		}))
	end

	if v34 then
		return (React.createElement(GridTileTextFooter, {
			text = v31,
			useLargerFont = v27,
			isUnifiedGameTile = true
		}))
	end

	if v28 then
		if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			return (Roact.createElement(gridTileFriendFooter, {
				showOnlineBorder = false,
				useLargerFont = v27,
				friendUserIds = inGameUserIds,
				onFriendFooterActivated = self.onFriendFooterActivated
			}))
		end

		return (Roact.createElement(gridTileFriendFooter, {
			showOnlineBorder = false,
			friends = v29,
			useLargerFont = v27
		}))
	end

	if self.props.friendVisitedString then
		return (Roact.createElement(GridTileIconTextFooter, {
			icon = images["icons/menu/recent"],
			text = self.props.friendVisitedString,
			iconSize = v27 and 32 or 24,
			useLargerFont = v27
		}))
	end

	if not v30 then
		return element
	end

	if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		return (Roact.createElement(gridTileFriendFooter, {
			showOnlineBorder = false,
			friendUserIds = self.getVisitedFriends(),
			useLargerFont = v27
		}))
	end

	return (Roact.createElement(gridTileFriendFooter, {
		showOnlineBorder = false,
		friends = self.getVisitedFriends(),
		useLargerFont = v27
	}))
end

function extended:renderContent(reducedMotion, p2, p3)
	local size = self.props.Size or UDim2.fromScale(1, 1)
	local imageThumbnail = self.props.imageThumbnail
	local onGameTileActivated = self.props.onGameTileActivated
	local v26

	if fFlagLuaAppContinueSortInstantPlay then
		v26 = fn(self.props.enableInstantPlay, self.props.instantPlayTreatment)
	end

	local v27 = self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Always
		or self.props.isHovered and self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Hover

	local imageAspectRatio = GameTileViewConfig.getImageAspectRatio(self.props.gameTileLayoutType)
	local gridTilesFooter = self:renderGridTilesFooter()
	local name

	if not self.props.hideTitle then
		if fFlagMigrateGameInfoToStore then
			name = self.props.name or self.state.gameInfo and self.state.gameInfo.name or ""
		else
			name = self.props.name
		end
	end

	local v28

	if v27 then
		v28 = React.createElement(GameStats, {
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
	local v29

	if self.props.isHidden then
		v29 = React.createElement(HiddenTileContent, {
			appPage = self.props.appPage,
			collectionId = self.props.topicId,
			setGameHidden = self.props.setGameHidden,
			universeId = self.props.universeId,
			parentRef = self.props.hoverRef,
			isSponsored = self.props.entry.isSponsored
		})
	elseif self.props.videoThumbnail then
		local createElement = React.createElement
		local v31 = {
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
		local v32 = if fFlagLuaAppHomeMomentVideoFallback then self.props.videoAccessContext else nil
		v31.accessContext = v32
		v31.image = imageThumbnail
		v31.playing = self.props.isVideoPlaying

		v31.Size = UDim2.fromScale(1, 1)
		v31.isTileContained = self.props.isContained
		v31.cornerRadius = p2.Tokens.Size.Size_200
		local v33

		if not fFlagLuaAppVideoTileDisableActivation then
			if fFlagLuaAppContinueSortInstantPlay and v26.isTreatment1 then
				v33 = self.onInstantPlayActivated
			elseif fFlagLuaAppEdpMediaGalleryFullScreen then
				if fFlagLuaAppGameTileExtractGameDetailsCallback then
					v33 = self.onGameDetailsActivated
				else
					v33 = fFlagLuaAppGameDetailsAttributionFix and function()
						onGameTileActivated(self.isMounted)
					end or self.onActivated
				end
			end
		end

		v31.onActivated = v33

		v31.itemIndex = self.props.index
		v31.videoAnalytics = self.props.videoAnalytics
		v31.universeId = self.props.universeId
		local v34 = if self.props.videoPlaybackContext then self.props.videoPlaybackContext.videoPlaybackCoordinator else nil
		v31.videoPlaybackCoordinator = v34
		v29 = createElement(GameTileVideoThumbnail, v31)
	end

	if defineFastFlag2 or not self.props.isVideoPlaying then
		if self.props.tileBadges then
			v28 = Roact.createFragment({
				SocialFeaturePill = v28,
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = self.props.tileBadges
				})
			})
		end
	else
		v28 = nil
	end

	if fFlagLuaAppContinueSortInstantPlay and v26.isTreatment1 and not self.props.isHidden then
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

		if v28 then
			v28 = Roact.createFragment({ Existing = v28, PlayOverlay = element })
		else
			v28 = element
		end
	end

	local isHidden = self.props.isHidden
	local v30

	if next(self.props.availableMenuItems) ~= nil then
		local createElement, v31, v32, isSelected, onGameDetailsActivated

		if self.props.isHovered or self.props.overflowMenuOpen then
			if not isHidden then
				createElement = React.createElement
				v31 = if fFlagLuaAppGameTileNotInterestedDirectAction then GameTileContextualActions else GameTileOverflowMenu
				v32 = {
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

				v32.isSelected = isSelected

				v32.universeId = self.props.universeId
				v32.placeId = self.props.entry.placeId
				v32.collectionId = self.props.topicId
				v32.appPage = self.props.appPage
				v32.setGameHidden = self.props.setGameHidden
				v32.menuKey = self.props.hoverKey
				v32.menuOpen = self.props.overflowMenuOpen
				v32.onMenuOpenChanged = self.onMenuOpenChanged
				v32.parentRef = self.props.hoverRef
				v32.isSponsored = self.props.entry.isSponsored
				v32.payerName = self.props.entry.payerName
				v32.sponsoredUserCohort = self.props.sponsoredUserCohort
				v32.adId = self.props.entry.adId
				v32.availableMenuItems = self.props.availableMenuItems

				if fFlagLuaAppContinueSortInstantPlay and v26.isActive then
					onGameDetailsActivated = self.onGameDetailsActivated
				end

				v32.onGameDetailsActivated = onGameDetailsActivated
				v30 = createElement(v31, v32)
			end
		else
			local v33

			if fFlagLuaAppGameTileSelectionVideoPlayback then
				v33 = self.props.isSelected
			else
				v33 = self.state.isSelected
			end

			if v33 then
				if not isHidden then
					createElement = React.createElement
					v31 = if fFlagLuaAppGameTileNotInterestedDirectAction then GameTileContextualActions else GameTileOverflowMenu
					v32 = {
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

					v32.isSelected = isSelected

					v32.universeId = self.props.universeId
					v32.placeId = self.props.entry.placeId
					v32.collectionId = self.props.topicId
					v32.appPage = self.props.appPage
					v32.setGameHidden = self.props.setGameHidden
					v32.menuKey = self.props.hoverKey
					v32.menuOpen = self.props.overflowMenuOpen
					v32.onMenuOpenChanged = self.onMenuOpenChanged
					v32.parentRef = self.props.hoverRef
					v32.isSponsored = self.props.entry.isSponsored
					v32.payerName = self.props.entry.payerName
					v32.sponsoredUserCohort = self.props.sponsoredUserCohort
					v32.adId = self.props.entry.adId
					v32.availableMenuItems = self.props.availableMenuItems

					if fFlagLuaAppContinueSortInstantPlay and v26.isActive then
						onGameDetailsActivated = self.onGameDetailsActivated
					end

					v32.onGameDetailsActivated = onGameDetailsActivated
					v30 = createElement(v31, v32)
				end
			end
		end
	end

	local createElement = React.createElement
	local v32 = {
		Size = size,
		ZIndex = self.props.ZIndex,
		BackgroundTransparency = 1,
		LayoutOrder = self.props.layoutOrder,
		ref = self.gameTileRef
	}

	local createElement2 = React.createElement
	local v35 = {
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

	local v36 = if not (fFlagLuaAppMigrateGameTileHoverFixes or self.props.useGridTile) then p2.Tokens.Size.Size_200 else nil
	v35.hoverPadding = v36

	v35.numLinesForTitle = self.props.contentTextLineCount
	v35.numLinesForMetadata = self.props.metadataTextLineCount
	v35.imageAspectRatio = imageAspectRatio
	v35.isContained = self.props.isContained
	v35.containmentSidePadding = GameTileViewConfig.getContainmentSidePadding(
		p2.Tokens,
		self.props.gameTileLayoutType,
		self.props.foundationTokens
	)

	v35.Size = UDim2.fromScale(1, 1)
	v35.image = imageThumbnail
	v35.thumbnailComponent = v29

	if isHidden then
		name = nil
	end

	v35.title = name
	v35.isDisabled = isHidden and true or self.props.isDisabled
	local v37

	if fFlagLuaAppContinueSortInstantPlay and v26.isTreatment1 and not isHidden then
		v37 = self.onInstantPlayActivated
	elseif fFlagLuaAppGameTileExtractGameDetailsCallback then
		v37 = if isHidden then self.onActivated else self.onGameDetailsActivated
	else
		v37 = fFlagLuaAppGameDetailsAttributionFix and not isHidden and function()
			onGameTileActivated(self.isMounted)
		end or self.onActivated
	end

	v35.onActivated = v37

	v35.onGuiStateChanged = self.props.onGuiStateChanged
	v35.onSelectionGained = self.onSelectionGained
	v35.onSelectionLost = self.onSelectionLost
	local v38 = if not isHidden then self.onTouchLongPress else nil
	v35.onTouchLongPress = v38

	local v39 = if fFlagLuaAppContinueSortInstantPlay and v26.isTreatment1 and not isHidden then self.onGameDetailsActivated else nil
	v35.onMetadataActivated = v39

	v35.reducedMotion = reducedMotion
	v35.isHovered = not isHidden and self.props.isHovered
	v35.forwardRef = self.props.hoverRef
	v35.hidePlayButton = isHidden and true or self.props.hidePlayButton
	local v41

	if not (self.props.hidePlayButton or isHidden or fFlagLuaAppContinueSortInstantPlay and v26.isActive) then
		local createElement3 = React.createElement
		local v43 = {
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
		local v44

		if fFlagLuaAppGameTileExtractGameDetailsCallback then
			v44 = self.onGameDetailsActivated
		else
			v44 = fFlagLuaAppGameDetailsAttributionFix and function()
				onGameTileActivated(self.isMounted)
			end or self.onActivated
		end

		v43.openGameDetails = v44

		v43.entry = self.props.entry
		v43.launchExperienceEventContext = self.props.launchExperienceEventContext
		v43.fetchDelayInSeconds = game:GetFastInt("LuaAppGameTileHoverDelayMs") / 1000
		v43.index = self.props.index

		v43.height = playButtonHeight
		v43.showButtonText = imageAspectRatio > 1
		v43.isUnifiedGameTileEnabled = fFlagLuaAppUnifyPlayButtonTile and true or nil
		v43.placeIdOverride = self.props.entry.placeIdOverride
		v43.launchDataOverride = self.props.entry.launchDataOverride
		v41 = createElement3(AppExperienceActionRow, v43)
	end

	v35.hoverActionRow = v41

	if isHidden then
		v28 = nil
	end

	v35.thumbnailOverlay = v28
	v35.overflowMenu = v30

	if isHidden then
		gridTilesFooter = nil
	end

	v35.footerMetadata = gridTilesFooter

	v35.textSizeOffset = self.props.textSizeOffset
	v35.hideMetadata = self.props.hideMetadata

	local v42 = if fFlagLuaAppContinueSortInstantPlay then self.props.isTouchPreferredInput else nil
	v35.isTouchPreferredInput = v42
	local v33 = {
		Tile = createElement2(GameTileView, v35),
		VideoPlaybackDetector = self.props.videoPlaybackDetector,
		InstantPlayLauncher = 0
	}

	local v43 = if fFlagLuaAppContinueSortInstantPlay and v26.isActive and self.state.instantPlayRequested then React.createElement(module44, {
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
	v33.InstantPlayLauncher = v43
	return createElement("Frame", v32, v33)
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

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription.dispose()
	end
end

function extended.didUpdate(object, data)
	if fFlagMigrateGameInfoToStore then
		object.gameInfoSubscription.update(object.props.entry.universeId)
	end

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

local function formatRating(p2, p3)
	if p2 + p3 == 0 then
		return "--"
	end

	return tostring((math.floor(p2 / (p2 + p3) * 100 + 0.5))) .. "%"
end

local v26 = RoactRodux.connect(function(p2, data)
	local universeId = data.entry.universeId
	local v27

	if not fFlagLuaAppGameDetailsAttributionFix then
		if
			data.entry.navigationUniverseId
			and data.entry.navigationUniverseId ~= ""
			and data.entry.navigationUniverseId ~= "0"
		then
			v27 = data.entry.navigationUniverseId
		else
			v27 = data.entry.universeId
		end
	end

	local v28 = p2.Personalization[gameInfosReducer.key][universeId]
	local totalUpVotes, totalDownVotes

	if not fFlagMigrateGameInfoToStore then
		totalUpVotes = v28 and v28.totalUpVotes or 0
		totalDownVotes = v28 and v28.totalDownVotes or 0
	end

	local friendActivityTitle = if v28 then v28.friendActivityTitle or nil else nil

	local v29 = nil
	local v30 = nil
	local minimumAge, ageRecommendationDisplayName

	if not fFlagMigrateGameInfoToStore then
		minimumAge = v28 and v28.minimumAge or 0
		ageRecommendationDisplayName = v28 and v28.ageRecommendationDisplayName or ""
	end

	local v31

	if data.gameTileLayoutType == "Event" then
		v31 = data.playButtonStyle ~= GameTileConstants.PlayButtonStyleValues.Enabled
	elseif data.gameTileLayoutType == "Wide" then
		v31 = data.playButtonStyle == GameTileConstants.PlayButtonStyleValues.Disabled
	else
		v31 = false
	end

	if not fFlagMigrateGameInfoToStore then
		if v31 or data.forceHideAgeRatings then
			v29 = false
		elseif minimumAge == 0 or ageRecommendationDisplayName == "" then
			v29 = false
		else
			v30 = ageRecommendationDisplayName
			v29 = true
		end
	end

	local v32 = getGameTileLayoutData(v28, data.topicId)

	local gameIconUrl = data.gameIconUrl
	local v33, v34

	if fFlagLuaAppHomeThumbnailPrefetch then
		local function resolveThumbnail(p3)
			return v5({
				iconUrl = gameIconUrl,
				universeId = universeId,
				placeId = data.entry.placeId,
				useGridTile = p3,
				perEntryWideAssetId = data.entry.primaryWideImageAssetId,
				game = v28,
				topicId = data.topicId
			})
		end

		local useGridTile = data.useGridTile == true
		v33 = v5({
			iconUrl = gameIconUrl,
			universeId = universeId,
			placeId = data.entry.placeId,
			useGridTile = useGridTile,
			perEntryWideAssetId = data.entry.primaryWideImageAssetId,
			game = v28,
			topicId = data.topicId
		})

		if data.useGridTile then
			v34 = v33
		else
			v34 = v5({
				iconUrl = gameIconUrl,
				universeId = universeId,
				placeId = data.entry.placeId,
				useGridTile = true,
				perEntryWideAssetId = data.entry.primaryWideImageAssetId,
				game = v28,
				topicId = data.topicId
			})
		end
	else
		local v35

		if data.entry.primaryWideImageAssetId then
			v35 = data.entry.primaryWideImageAssetId
		else
			v35 = ItemLayoutDataParsingUtils.getWideImageAssetId(v32)
		end

		if not v35 then
			v35 = if v28 then v28.primaryWideAssetId or nil else nil
		end

		v34 = formatExperienceThumbnail(v35, data.entry.placeId)

		v33 = if data.useGridTile then v34 else formatExperienceIcon(gameIconUrl, universeId)
	end

	local accessContext = nil
	local v35

	if fFlagLuaAppHomeMomentVideoFallback then
		local v36 = getLayoutDataVideo(v32, data.entry.primaryWideVideoAssetId)
		v35 = v36 and v36.assetId
		accessContext = v36 and v36.accessContext
	elseif data.entry.primaryWideVideoAssetId then
		v35 = data.entry.primaryWideVideoAssetId
	else
		v35 = v32 and v32.primaryMediaAsset and v32.primaryMediaAsset.wideVideoAssetId
	end

	local v36 = if v35 then `rbxassetid://{v35}` else nil
	local v37

	if not (fFlagMigrateGameInfoToStore or not (data.useHoverTile or data.useExperienceTileMetadata)) then
		if defineFastFlag then
			v37 = formatExperienceRating(totalUpVotes, totalDownVotes, nil, true)
		else
			v37 = totalUpVotes + totalDownVotes == 0 and "--"
				or tostring((math.floor(totalUpVotes / (totalUpVotes + totalDownVotes) * 100 + 0.5))) .. "%"
		end
	end

	local friendVisits = v28 and v28.friendVisits or v6
	local friendVisitedString = if v28 and v28.friendVisitedString ~= "" then v28.friendVisitedString else nil

	local footer = if v32 then v32.footer or nil else nil
	local title

	if fFlagMigrateGameInfoToStore then
		title = v32 and v32.title
	else
		title = v32 and v32.title or v28 and v28.name or ""
	end

	local v38 = {
		game = v28,
		universeId = universeId,
		navigationUniverseId = nil,
		name = nil,
		totalUpVotes = nil,
		totalDownVotes = nil,
		imageThumbnail = nil,
		wideThumbnail = nil,
		videoThumbnail = nil,
		videoAccessContext = nil,
		friendActivityTitle = nil,
		rating = nil,
		showAgeRating = nil,
		ageRatingText = nil,
		friendVisits = nil,
		friendVisitedString = nil,
		hidePlayButton = nil,
		footerLayoutData = nil
	}

	if fFlagLuaAppGameDetailsAttributionFix then
		v27 = nil
	end

	v38.navigationUniverseId = v27
	v38.name = title
	v38.totalUpVotes = totalUpVotes
	v38.totalDownVotes = totalDownVotes
	v38.imageThumbnail = v33
	v38.wideThumbnail = v34
	v38.videoThumbnail = v36

	if not fFlagLuaAppHomeMomentVideoFallback then
		accessContext = nil
	end

	v38.videoAccessContext = accessContext
	v38.friendActivityTitle = friendActivityTitle
	v38.rating = v37
	v38.showAgeRating = v29
	v38.ageRatingText = v30
	v38.friendVisits = friendVisits
	v38.friendVisitedString = friendVisitedString
	v38.hidePlayButton = v31
	v38.footerLayoutData = footer
	return v38
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
	v26 = roactServices.connect({ networking = roactNetworking })(v26)
end

local function fn3(props)
	local ref = React.useRef(nil)
	local v27 = useTokens()
	local v28 = props.useHoverTile

	local v29 = GameHydrationReact.useGameIcon(props.entry.universeId)

	local formatted = `{props.impressionsTag or ""}_{props.index or "0"}_{props.gameTileLayoutType or "Narrow"}`

	if props.impressionsTag == nil or props.index == nil then
		v28 = false
	end

	local v30 = useIsHoveredTile(ref, formatted, v28)

	local v31 = useUiModeInfo().uiMode == uiMode.TenFoot
	local v32 = v31 and true or props.useHoverTile

	if props.useExperienceTileMetadata ~= nil then
		v31 = props.useExperienceTileMetadata
	end

	local v33 = useValidTileBadges(props.entry.universeId, props.topicId, props.badgeOverride)

	local v34 = useSelector(function(p2)
		return p2.LocalUserId
	end)
	local v35

	if not fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		v35 = useSelector(function(p2)
			return p2.Users
		end)
	end

	local v36 = useSelector(function(p2)
		return p2.InGameUsersByGame[props.entry.universeId]
	end)

	local v37 = useHasInGameFriends(v34, v35, v36)
	local v38

	if fFlagGameTileMigrateOffLegacyPresence then
		v38 = useGetOnlineFriendsByUniverseId(props.entry.universeId)
	else
		v38 = nil
	end

	local v39

	if fFlagGameTileMigrateOffLegacyPresence then
		v39 = React.useMemo(function()
			return Cryo.List.map(v38 or {}, function(p2)
				return p2.id
			end)
		end, { v38 })
	end

	if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		if not fFlagGameTileMigrateOffLegacyPresence then
			v39 = useInGameUserIds(v34, v36)
		end
	else
		v39 = nil
	end

	local state, setState = React.useState(false)

	local state2 = nil
	local v40 = nil
	local v41, v42

	if fFlagLuaAppGameTileSelectionVideoPlayback then
		local setState2
		state2, setState2 = React.useState(false)
		v40 = setState2

		v41 = React.useCallback(function(p2, p3, p4)
			v40(true)

			if props.onSelectionGained then
				props.onSelectionGained(p2, p3, p4)
			end
		end, { props.onSelectionGained })

		v42 = React.useCallback(function()
			v40(false)

			if props.onSelectionLost then
				props.onSelectionLost()
			end
		end, { props.onSelectionLost })
	end

	local v43

	if props.videoPlaybackContext == nil then
		v43 = false
	else
		v43 = props.videoPlaybackContext.disablePlayback == true
	end

	local v44 = fFlagLuaAppSuppressVideoDetectorDuringScroll

	if v44 then
		if props.videoPlaybackContext == nil then
			v44 = false
		else
			v44 = props.videoPlaybackContext.disableDetectors == true
		end
	end

	React.useEffect(function()
		if fFlagLuaAppFixHiddenTileVideoCleanup and props.isHidden or v43 then
			setState(false)
		end
	end, { props.isHidden, v43 })
	local v45, v46, v47, v48

	if fFlagLuaAppGameDetailsAttributionFix then
		v45 = useRoactService(roactNetworking)

		if
			props.entry.navigationUniverseId
			and props.entry.navigationUniverseId ~= ""
			and props.entry.navigationUniverseId ~= "0"
		then
			v46 = props.entry.navigationUniverseId
		else
			v46 = props.entry.universeId
		end

		v47 = React.useCallback(function()
			local entry = props.entry

			if entry.isSponsored then
				sponsoredGamesRecordClick(v45, entry.adId)
			end
		end, { v45, props.entry.isSponsored, props.entry.adId })

		local useCallback = React.useCallback
		local function fn4(p2)
			if props.isHovered then
				HoverTileCoordinator.default:reset()
			end

			if props.videoPlaybackContext and props.videoPlaybackContext.videoPlaybackCoordinator then
				props.videoPlaybackContext.videoPlaybackCoordinator:reset(
					VideoEndReason.TileClicked,
					nil,
					v46,
					nil
				)
			else
				videoPlaybackCoordinator.default:reset(VideoEndReason.TileClicked, nil, v46, nil)
			end

			if p2 then
				if props.onActivated then
					props.onActivated()
				end

				local v49 = {
					source = props.source,
					index = props.index,
					referralSource = props.referralSource,
					onPeekViewClosed = props.onPeekViewClosed,
					placeIdOverride = props.entry.placeIdOverride,
					experienceJoinData = 0
				}

				local v51 = if props.entry.launchDataOverride then props.entry.launchDataOverride else nil
				v49.experienceJoinData = {
					launchData = v51,
					tileType = props.entry.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile,
					nativeAdData = props.entry.adId
				}

				if getFFlagEnableNavigationPerformanceIntervals() then
					intervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
				end

				props.navigateToGameDetails(v46, v49)

				props.reportGameDetailOpened(props.index, v46)

				v47()
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
		local v50 = v46
		local v51 = v47
		local placeIdOverride = props.entry.placeIdOverride
		local launchDataOverride = props.entry.launchDataOverride
		local v52 = if props.videoPlaybackContext then props.videoPlaybackContext.videoPlaybackCoordinator else nil
		v48 = useCallback(fn4, {
			isHovered,
			index,
			videoAnalytics,
			onActivated,
			source,
			referralSource,
			onPeekViewClosed,
			navigateToGameDetails,
			reportGameDetailOpened,
			v50,
			v51,
			placeIdOverride,
			launchDataOverride,
			v52
		})
	else
		v45 = nil
		v46 = nil
		v47 = nil
	end

	local v49 = useOverflowMenuOpen(formatted)
	local v50 = useTriggerFeedback()
	local v51

	if fFlagLuaAppContinueSortInstantPlay then
		v51 = fn(props.enableInstantPlay, props.instantPlayTreatment)
	else
		v51 = nil
	end

	local useMemo = React.useMemo
	local function fn4()
		local v53 = {
			isSponsored = props.entry.isSponsored,
			enableExplicitFeedback = props.enableExplicitFeedback,
			enableSponsoredFeedback = props.enableSponsoredFeedback,
			enableReportAd = props.enableReportAd,
			enableGameDetails = 0,
			enableReportExperience = 0
		}
		local v54 = if fFlagLuaAppContinueSortInstantPlay then v51.isTreatment1 else nil
		v53.enableGameDetails = v54

		local v55 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
		v53.enableReportExperience = v55
		return getAvailableGameTileOverflowMenuItems(v53)
	end

	local isSponsored = props.entry.isSponsored
	local enableExplicitFeedback = props.enableExplicitFeedback
	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local isTreatment1 = if fFlagLuaAppContinueSortInstantPlay then v51.isTreatment1 else nil
	local v53 = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
	local v54 = useMemo(fn4, {
		isSponsored,
		enableExplicitFeedback,
		enableSponsoredFeedback,
		enableReportAd,
		isTreatment1,
		v53
	})

	local v55 = useHasVideoThumbnailSelector(props.entry.universeId, props.topicId)

	local v56 = props.entry.primaryWideVideoAssetId ~= nil or v55

	local videoPlaybackContext = props.videoPlaybackContext
	local v58 = if fFlagLuaAppTileVideoCandidateOnly then v56 else nil
	local v59 = if fFlagLuaAppFixHiddenTileVideoCleanup then props.isHidden else nil
	useTagAsViewportAutoplayCandidate(
		ref,
		videoPlaybackContext,
		v58,
		v59,
		nil,
		nil,
		nil,
		fFlagLuaAppOneByTwoHoverIdleAutoplay and v56 and {
			videoKey = formatted,
			isUserIntentModeAutoplayCandidate = false
		} or nil
	)
	local v60

	if not (fFlagLuaAppGameTileSelectionVideoPlayback or not fFlagLuaAppEdpMediaGalleryVideoPreview) then
		v60 = usePreferredInput()
	end

	local v61

	if v56 and not (props.isHidden or fFlagLuaAppSuppressVideoDetectorDuringScroll and v44) and not v43 then
		local createElement = React.createElement
		local v63 = {
			videoKey = formatted,
			itemIndex = props.index,
			universeId = props.entry.universeId,
			tileRef = ref,
			isHoverSupported = v28,
			isHovered = v30,
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

		local v65 = if not (fFlagLuaAppGameTileSelectionVideoPlayback or not fFlagLuaAppEdpMediaGalleryVideoPreview) then v60 == Responsive.Input.Touch else nil
		v63.autoplay = v65

		v63.onPlaybackChange = setState
		v63.videoAnalytics = props.videoAnalytics
		v63.videoDwellTimeInSec = fIntLuaAppGameTileVideoDwellTimeInSec
		v63.videoVisiblePercent = fIntLuaAppGameTileVideoVisiblePercent

		local v66 = if fFlagLuaAppUsePrevalidatedVideoGamePlayability then props.hasPrevalidatedVideoGamePlayability else nil
		v63.hasPrevalidatedVideoGamePlayability = v66

		v63.pageContext = props.appPage
		v63.videoPlaybackContext = props.videoPlaybackContext
		v61 = createElement(GameVideoPlaybackDetector, v63)
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	if not fFlagLuaAppGameTileSelectionVideoPlayback then
		state2 = nil
	end

	if not fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		v39 = nil
	end

	local v63 = {
		useExperienceTileMetadata = v31,
		hasBackground = v32,
		gameIconUrl = v29,
		hoverRef = ref,
		isHoverSupported = v28,
		isHovered = v30,
		isSelected = state2,
		isVideoPlaying = state,
		tileBadges = v33,
		foundationTokens = v27,
		users = v35,
		inGameUsersByGame = v36,
		hasInGameFriends = v37,
		inGameUserIds = v39,
		networking = if fFlagLuaAppGameDetailsAttributionFix then v45 else nil,
		navigationUniverseId = if fFlagLuaAppGameDetailsAttributionFix then v46 else nil,
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
		v48 = nil
	end

	v63.onGameTileActivated = v48
	v63.recordSponsoredGameClick = if fFlagLuaAppGameDetailsAttributionFix then v47 else nil
	v63.overflowMenuOpen = v49
	v63.hoverKey = formatted
	v63.triggerFeedback = v50
	v63.availableMenuItems = v54

	if not fFlagLuaAppGameTileSelectionVideoPlayback then
		v41 = props.onSelectionGained
	end

	v63.onSelectionGained = v41

	if not fFlagLuaAppGameTileSelectionVideoPlayback then
		v42 = props.onSelectionLost
	end

	v63.onSelectionLost = v42

	v63.videoPlaybackDetector = v61
	return (createElement(v26, join(props, v63)))
end

if fFlagSignalsNavP3fGameDetails then
	fn3 = React.memo(fn3)
end

return fn3
