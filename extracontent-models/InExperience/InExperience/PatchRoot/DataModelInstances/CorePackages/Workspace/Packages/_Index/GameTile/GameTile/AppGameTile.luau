local ContentProvider = game:GetService("ContentProvider")
local GameTile = script:FindFirstAncestor("GameTile")
local GridTileIconTextFooter = require(GameTile.Footer.GridTileIconTextFooter)
local GridTileFriendFooter = require(GameTile.Footer.GridTileFriendFooter)
local gridTileFriendFooter = GridTileFriendFooter.GridTileFriendFooter
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
local getLayoutDataVideo = require(GameTile.getLayoutDataVideo)
local formatExperienceIcon = require(GameTile.formatExperienceIcon)
local formatExperienceThumbnail = require(GameTile.formatExperienceThumbnail)
local HiddenTileContent = require(GameTile.HiddenGameTile.HiddenTileContent)
local ItemLayoutDataParsingUtils = require(GameTile.ItemLayoutDataParsingUtils)

local parent = GameTile.Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local AppBlox = require(parent.AppBlox)
local React = require(parent.React)
local None = React.None
local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local VideoUtils = require(parent.VideoUtils)
local t = require(parent.t)
local UIBlox = require(parent.UIBlox)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails

local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local AspectRatioModeEnum = UIBlox.App.Tile.AspectRatioModeEnum
local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local RobloxAppHooks2 = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks2.useRoactService
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize
local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local intervalPerformanceTracker = IntervalPerformanceTracker.IntervalPerformanceTracker
local GameInfosRodux = require(parent.GameInfosRodux)
local GameInfosReducer = GameInfosRodux.GameInfosReducer
local GameInfosRodux2 = require(parent.GameInfosRodux)
local toLegacyGameInfoModel = GameInfosRodux2.toLegacyGameInfoModel
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
require(parent.DataHydration)
local GameHydrationReact = require(parent.GameHydrationReact)
local Foundation2 = require(parent.Foundation)
local useTokens = Foundation2.Hooks.useTokens
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
local InteractionFeedback = require(parent.InteractionFeedback)
local useTriggerFeedback = InteractionFeedback.useTriggerFeedback
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick

local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate

local AppLaunchTracker = require(parent.AppLaunchTracker)
local DiscoveryAppLaunchTracker = AppLaunchTracker.DiscoveryAppLaunchTracker

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableNavigationPerformanceIntervals = SharedFlags2.GetFFlagEnableNavigationPerformanceIntervals
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameTileHoverFixes = SharedFlags3.FFlagLuaAppMigrateGameTileHoverFixes

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameTileFixConsoleMetadataText = SharedFlags4.FFlagLuaAppMigrateGameTileFixConsoleMetadataText

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonTile = SharedFlags5.FFlagLuaAppUnifyPlayButtonTile
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryVideoPreview = SharedFlags6.FFlagLuaAppEdpMediaGalleryVideoPreview
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryFullScreen = SharedFlags7.FFlagLuaAppEdpMediaGalleryFullScreen
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppGameDetailsAttributionFix = SharedFlags8.FFlagLuaAppGameDetailsAttributionFix

local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix = SharedFlags9.FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix
local SharedFlags10 = require(parent.SharedFlags)
local FFlagGameTileMigrateOffLegacyPresence = SharedFlags10.FFlagGameTileMigrateOffLegacyPresence
local useGetOnlineFriendsByUniverseId

if FFlagGameTileMigrateOffLegacyPresence then
	local FriendsHydrationReact = require(parent.FriendsHydrationReact)
	useGetOnlineFriendsByUniverseId = FriendsHydrationReact.useGetOnlineFriendsByUniverseId
else
	useGetOnlineFriendsByUniverseId = nil
end

local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppEnableReportExperience = SharedFlags11.FFlagLuaAppEnableReportExperience
local SharedFlags12 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHideRating = SharedFlags12.FFlagLuaAppNarrowTileHideRating
local SharedFlags13 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHidePlayerCount = SharedFlags13.FFlagLuaAppNarrowTileHidePlayerCount
local SharedFlags14 = require(parent.SharedFlags)
local FIntLuaAppGameTileVideoDwellTimeInSec = SharedFlags14.FIntLuaAppGameTileVideoDwellTimeInSec
local SharedFlags15 = require(parent.SharedFlags)
local FIntLuaAppGameTileVideoVisiblePercent = SharedFlags15.FIntLuaAppGameTileVideoVisiblePercent
local SharedFlags16 = require(parent.SharedFlags)
local FFlagLuaAppTileVideoCandidateOnly = SharedFlags16.FFlagLuaAppTileVideoCandidateOnly
local SharedFlags17 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags17.FFlagLuaAppOneByTwoHoverIdleAutoplay
local defineFastFlag = game:DefineFastFlag("LuaAppKeepTileBadgesDuringVideo", false)
local SharedFlags18 = require(parent.SharedFlags)
local FFlagLuaAppVideoTileDisableActivation = SharedFlags18.FFlagLuaAppVideoTileDisableActivation
local SharedFlags19 = require(parent.SharedFlags)
local FFlagLuaAppFixHiddenTileVideoCleanup = SharedFlags19.FFlagLuaAppFixHiddenTileVideoCleanup

local SharedFlags20 = require(parent.SharedFlags)
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = SharedFlags20.FFlagLuaAppUsePrevalidatedVideoGamePlayability
local SharedFlags21 = require(parent.SharedFlags)
local FFlagLuaAppContinueSortInstantPlay = SharedFlags21.FFlagLuaAppContinueSortInstantPlay

local SharedFlags22 = require(parent.SharedFlags)
local FFlagLuaAppGameTileExtractGameDetailsCallback = SharedFlags22.FFlagLuaAppGameTileExtractGameDetailsCallback
local SharedFlags23 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags23.FFlagLuaAppDemoModePlayButtonTelemetry
local InstantPlayLauncher = require(GameTile.InstantPlayLauncher)
local InstantPlayButton = require(GameTile.InstantPlayButton)
local SharedFlags24 = require(parent.SharedFlags)
local FFlagLuaAppGenreRatingFooter = SharedFlags24.FFlagLuaAppGenreRatingFooter

local SharedFlags25 = require(parent.SharedFlags)
local FFlagLuaAppGameTileSelectionVideoPlayback = SharedFlags25.FFlagLuaAppGameTileSelectionVideoPlayback

local SharedFlags26 = require(parent.SharedFlags)
local FFlagLuaAppSuppressVideoDetectorDuringScroll = SharedFlags26.FFlagLuaAppSuppressVideoDetectorDuringScroll
local SharedFlags27 = require(parent.SharedFlags)
local FFlagLuaAppHomeThumbnailPrefetch = SharedFlags27.FFlagLuaAppHomeThumbnailPrefetch
local SharedFlags28 = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags28.FFlagLuaAppHomeMomentVideoFallback
local resolveGameTileThumbnailUri

if FFlagLuaAppHomeThumbnailPrefetch then
	resolveGameTileThumbnailUri = require(GameTile.resolveGameTileThumbnailUri)
else
	resolveGameTileThumbnailUri = nil
end

local VideoUtils2 = require(parent.VideoUtils)
local VideoPlaybackCoordinator = VideoUtils2.VideoPlaybackCoordinator

local GameTileContextualActions = require(GameTile.GameTileContextualActions)
local GameTileOverflowMenu = require(GameTile.GameTileOverflowMenu)
local getAvailableGameTileOverflowMenuItems = require(GameTile.getAvailableGameTileOverflowMenuItems)

local v = {}

game:DefineFastInt("LuaAppGameTileHoverDelayMs", 130)

local function getHoverDelay() -- 1 equivalent call inferred from this helper
	return game:GetFastInt("LuaAppGameTileHoverDelayMs") / 1000
end

local v2 = FFlagLuaAppContinueSortInstantPlay
	and {
		Treatment1 = "SDUI.InstantPlay.Treatment1",
		Treatment2 = "SDUI.InstantPlay.Treatment2",
		Treatment3 = "SDUI.InstantPlay.Treatment3"
	}
	or nil
local set

if FFlagLuaAppContinueSortInstantPlay then
	set = {}
	set[v2.Treatment1] = true
	set[v2.Treatment2] = true
	set[v2.Treatment3] = true
else
	set = nil
end

local frozen

if FFlagLuaAppContinueSortInstantPlay then
	frozen = table.freeze({
		isActive = false,
		isTreatment1 = false,
		isTreatment2 = false,
		isTreatment3 = false
	})
else
	frozen = nil
end

local fn = FFlagLuaAppContinueSortInstantPlay and function(flag: boolean?, p: string?)
	local v3

	if flag == true and p ~= nil then
		v3 = set[p] == true
	else
		v3 = false
	end

	if v3 then
		return {
			isActive = true,
			isTreatment1 = p == v2.Treatment1,
			isTreatment2 = p == v2.Treatment2,
			isTreatment3 = p == v2.Treatment3
		}
	end

	return frozen
end or nil

local extended = Roact.PureComponent:extend("AppGameTile")

local strictInterface = t.strictInterface
local v3 = {}
v3.entry = t.table
v3.reportGameDetailOpened = t.callback

v3.reportExperienceLaunched = t.optional(t.callback)
v3.Size = t.optional(t.union(t.UDim2, t.table))
v3.ZIndex = t.optional(t.number)
v3.useHoverTile = t.optional(t.boolean)
v3.hasBackground = t.boolean
v3.useGridTile = t.boolean
v3.playerCountStyle = t.optional(t.string)
v3.isSponsoredFooterAllowed = t.optional(t.boolean)
v3.isSponsoredRatingFooterAllowed = t.optional(t.boolean)
v3.useExperienceTileMetadata = t.boolean
v3.hideGameStats = t.optional(t.boolean)
v3.gameTileLayoutType = t.optional(t.string)
v3.topicId = t.optional(t.string)
v3.playButtonStyle = t.optional(t.string)
v3.onGuiStateChanged = t.optional(t.callback)
v3.isDisabled = t.optional(t.boolean)
v3.onActivated = t.optional(t.callback)
local onSelectionGained

if FFlagLuaAppGameTileSelectionVideoPlayback then
	onSelectionGained = t.callback
else
	onSelectionGained = t.optional(t.callback)
end

v3.onSelectionGained = onSelectionGained
local onSelectionLost

if FFlagLuaAppGameTileSelectionVideoPlayback then
	onSelectionLost = t.callback
else
	onSelectionLost = t.optional(t.callback)
end

v3.onSelectionLost = onSelectionLost
v3.friendFooterEnabled = t.optional(t.boolean)
v3.index = t.optional(t.number)
v3.layoutOrder = t.optional(t.number)
v3.source = t.optional(t.string)
v3.referralSource = t.optional(t.string)
v3.onPeekViewClosed = t.optional(t.callback)
v3.rowNum = t.optional(t.number)
v3.showFriendActivity = t.boolean
v3.contentTextLineCount = t.optional(t.number)
v3.metadataTextLineCount = t.optional(t.number)
v3.thumbnailAspectRatioOverride = t.optional(t.string)
v3.impressionsTag = t.optional(t.string)
v3.launchExperienceEventContext = t.optional(t.string)
v3.navigateToGameDetails = t.callback
v3.isContained = t.optional(t.boolean)
v3.hideTitle = t.optional(t.boolean)
v3.hideMetadata = t.optional(t.boolean)
v3.textSizeOffset = t.optional(t.number)
v3.foundationTokens = t.optional(t.table)
v3.videoAnalytics = t.optional(t.table)
local hasPrevalidatedVideoGamePlayability

if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
	hasPrevalidatedVideoGamePlayability = t.optional(t.boolean)
end

v3.hasPrevalidatedVideoGamePlayability = hasPrevalidatedVideoGamePlayability

v3.videoPlaybackContext = t.optional(t.table)
v3.SelectionOrder = t.optional(t.number)
v3.enableExplicitFeedback = t.optional(t.boolean)
v3.setGameHidden = t.optional(t.callback)
v3.appPage = t.optional(t.string)
v3.isHidden = t.optional(t.boolean)
v3.isNarrowScreenXSmall = t.optional(t.boolean)

v3.sponsoredUserCohort = t.optional(t.string)
v3.enableSponsoredFeedback = t.optional(t.boolean)
v3.availableMenuItems = t.optional(t.table)
v3.enableReportAd = t.optional(t.boolean)
local enableReportExperience

if FFlagLuaAppEnableReportExperience then
	enableReportExperience = t.optional(t.boolean)
end

v3.enableReportExperience = enableReportExperience
v3.compactMetadataFormat = t.optional(t.boolean)
local hideRating

if FFlagLuaAppNarrowTileHideRating then
	hideRating = t.optional(t.boolean)
end

v3.hideRating = hideRating
local hidePlayerCount

if FFlagLuaAppNarrowTileHidePlayerCount then
	hidePlayerCount = t.optional(t.boolean)
end

v3.hidePlayerCount = hidePlayerCount

v3.game = t.optional(t.table)
v3.universeId = t.string
v3.navigationUniverseId = t.optional(t.string)
v3.name = t.optional(t.string)
v3.friendActivityTitle = t.optional(t.string)
v3.friendVisitedString = t.optional(t.string)
v3.imageThumbnail = t.string
v3.wideThumbnail = t.optional(t.string)
v3.videoThumbnail = t.optional(t.string)
local videoAccessContext

if FFlagLuaAppHomeMomentVideoFallback then
	videoAccessContext = t.optional(t.string)
end

v3.videoAccessContext = videoAccessContext
v3.friendVisits = t.table
v3.hidePlayButton = t.boolean
v3.footerLayoutData = t.optional(t.table)

v3.openContextualMenu = t.callback
v3.openSponsoredTooltip = t.callback

v3.networking = t.callback

v3.hoverRef = t.table
v3.isHoverSupported = t.optional(t.boolean)
v3.isHovered = t.optional(t.boolean)
v3.gameIconUrl = t.optional(t.string)
local isSelected2

if FFlagLuaAppGameTileSelectionVideoPlayback then
	isSelected2 = t.boolean
end

v3.isSelected = isSelected2
v3.isVideoPlaying = t.boolean
v3.tileBadges = t.optional(t.table)
v3.users = t.optional(t.table)
v3.inGameUsersByGame = t.optional(t.table)
v3.hasInGameFriends = t.boolean
local inGameUserIds2

if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
	inGameUserIds2 = t.table
end

v3.inGameUserIds = inGameUserIds2
v3.badgeOverride = t.optional(t.table)
v3.forceHideAgeRatings = t.optional(t.boolean)
local onGameTileActivated2

if FFlagLuaAppGameDetailsAttributionFix then
	onGameTileActivated2 = t.optional(t.callback)
end

v3.onGameTileActivated = onGameTileActivated2
local recordSponsoredGameClick

if FFlagLuaAppGameDetailsAttributionFix then
	recordSponsoredGameClick = t.optional(t.callback)
end

v3.recordSponsoredGameClick = recordSponsoredGameClick
v3.overflowMenuOpen = t.optional(t.boolean)
v3.hoverKey = t.optional(t.string)
v3.triggerFeedback = t.callback
v3.videoPlaybackDetector = t.optional(t.table)
local enableInstantPlay

if FFlagLuaAppContinueSortInstantPlay then
	enableInstantPlay = t.optional(t.boolean)
end

v3.enableInstantPlay = enableInstantPlay
local instantPlayTreatment

if FFlagLuaAppContinueSortInstantPlay then
	instantPlayTreatment = t.optional(t.string)
end

v3.instantPlayTreatment = instantPlayTreatment
local isTouchPreferredInput

if FFlagLuaAppContinueSortInstantPlay then
	isTouchPreferredInput = t.optional(t.boolean)
end

v3.isTouchPreferredInput = isTouchPreferredInput
extended.validateProps = strictInterface(v3)

local Narrow = GameTileTypes.GameTileLayoutType.Narrow
extended.defaultProps = {
	useHoverTile = false,
	hasBackground = false,
	useExperienceTileMetadata = false,
	useGridTile = false,
	thumbnailAspectRatioOverride = AspectRatioModeEnum.Square,
	gameTileLayoutType = Narrow,
	contentTextLineCount = GameTileConstants.TileTextLines[Narrow].titleTextLines,
	hideGameStats = false
}

function extended:init()
	if DiscoveryAppLaunchTracker.isEnabled() and DiscoveryAppLaunchTracker.default then
		DiscoveryAppLaunchTracker.default:trackTileInit()
	end

	local isSelected

	if not FFlagLuaAppGameTileSelectionVideoPlayback then
		isSelected = false
	end

	self.state = {
		isHovered = false,
		canDisplayFriendFooter = false,
		isSelected = isSelected,
		instantPlayRequested = not FFlagLuaAppContinueSortInstantPlay and nil
	}

	self.gameInfoSubscription = GameHydrationReact.subscribeGameInfo({
		universeId = self.props.entry.universeId,
		onChange = function(p)
			self:setState({
				gameInfo = p.gameInfo or None,
				storeVotes = p.votes or None
			})
		end
	})

	function self.onMenuOpenChanged(flag: boolean, availableMenuItems: string?)
		gameTileOverflowMenuAction({
			universeId = self.props.universeId,
			sortId = self.props.topicId,
			actionType = flag and "GameTileOverflowMenuClosed" or "GameTileOverflowMenuOpened",
			availableMenuItems = availableMenuItems
		}, self.props.appPage or "Unknown")
	end

	function self.onTouchLongPress()
		if next(self.props.availableMenuItems) ~= nil then
			if self.props.triggerFeedback and not self.props.overflowMenuOpen then
				local v4 = { universeId = self.props.universeId, sortId = self.props.topicId }

				self.props.triggerFeedback("TileLongPress", "Press", self.props.appPage or "Unknown", v4)
			end

			getOverflowMenuSignalStore().openMenu(self.props.hoverKey)
			local v4 = {}

			for k, _ in self.props.availableMenuItems do
				table.insert(v4, k)
			end

			self.onMenuOpenChanged(false, table.concat(v4, ","))
		end
	end

	self.reportExperienceLaunched = FFlagLuaAppContinueSortInstantPlay and function(...)
		if FFlagLuaAppGameDetailsAttributionFix then
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
			VideoPlaybackCoordinator.default:reset(
				VideoEndReason.ExperienceLaunched,
				nil,
				self.props.navigationUniverseId,
				nil
			)
		end
	end or nil

	self.reportExperienceLaunchedFromInstantPlay = FFlagLuaAppContinueSortInstantPlay and function(p: string?)
		local reportExperienceLaunched = self.reportExperienceLaunched
		local entry = self.props.entry
		local referralSource = self.props.referralSource

		local instantPlay = DiscoveryAnalytics.Constants.Context.InstantPlay
		local index = self.props.index

		if not FFlagLuaAppDemoModePlayButtonTelemetry then
			p = nil
		end

		reportExperienceLaunched(entry, referralSource, "ExperienceTile", instantPlay, index, p)
	end or nil
	local reportExperienceLaunchedFromActionBar

	if FFlagLuaAppContinueSortInstantPlay then
		reportExperienceLaunchedFromActionBar = self.reportExperienceLaunched
	else
		reportExperienceLaunchedFromActionBar = function(...)
			if FFlagLuaAppGameDetailsAttributionFix then
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
				VideoPlaybackCoordinator.default:reset(
					VideoEndReason.ExperienceLaunched,
					nil,
					self.props.navigationUniverseId,
					nil
				)
			end
		end
	end

	self.reportExperienceLaunchedFromActionBar = reportExperienceLaunchedFromActionBar

	function self.renderAppExperienceActionRow(_)
		local createElement = Roact.createElement
		local v4 = {
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
		local openGameDetails

		if FFlagLuaAppGameTileExtractGameDetailsCallback then
			openGameDetails = self.onGameDetailsActivated
		elseif FFlagLuaAppGameDetailsAttributionFix then
			openGameDetails = function()
				self.props.onGameTileActivated(self.isMounted)
			end
		else
			openGameDetails = self.onActivated
		end

		v4.openGameDetails = openGameDetails

		v4.entry = self.props.entry
		v4.launchExperienceEventContext = self.props.launchExperienceEventContext
		v4.horizontalPadding = self.props.useGridTile and 0 or nil
		v4.index = self.props.index
		v4.isUnifiedGameTileEnabled = FFlagLuaAppUnifyPlayButtonTile and true or nil
		v4.placeIdOverride = self.props.entry.placeIdOverride
		v4.launchDataOverride = self.props.entry.launchDataOverride
		return createElement(AppExperienceActionRow, v4)
	end

	self.onInstantPlayActivated = FFlagLuaAppContinueSortInstantPlay and function()
		if fn(self.props.enableInstantPlay, self.props.instantPlayTreatment).isActive then
			self:setState({ instantPlayRequested = true })
		end
	end or nil

	self.onInstantPlayAttemptCompleted = FFlagLuaAppContinueSortInstantPlay and function()
		self:setState({ instantPlayRequested = false })
	end or nil

	function self.onHoverChanged(isHovered)
		if isHovered and self.props.triggerFeedback then
			self.props.triggerFeedback("Default", "Hover")
		end

		self:setState({ isHovered = isHovered })
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

	self.recordSponsoredGameClick = not FFlagLuaAppGameDetailsAttributionFix and function()
		local networking = self.props.networking
		local entry = self.props.entry

		if entry.isSponsored then
			sponsoredGamesRecordClick(networking, entry.adId)
		end
	end or nil

	self.onActivated = not FFlagLuaAppGameDetailsAttributionFix and function()
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
			VideoPlaybackCoordinator.default:reset(
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
			local v4 = {
				source = self.props.source,
				index = self.props.index,
				referralSource = self.props.referralSource,
				onPeekViewClosed = self.props.onPeekViewClosed,
				placeIdOverride = self.props.entry.placeIdOverride,
				experienceJoinData = 0
			}
			local launchData

			if self.props.entry.launchDataOverride then
				launchData = self.props.entry.launchDataOverride
			end

			v4.experienceJoinData = {
				launchData = launchData,
				tileType = self.props.entry.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile,
				nativeAdData = self.props.entry.adId
			}

			if GetFFlagEnableNavigationPerformanceIntervals() then
				intervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
			end

			self.props.navigateToGameDetails(navigationUniverseId, v4)

			local index = self.props.index
			self.props.reportGameDetailOpened(index, navigationUniverseId)

			self.recordSponsoredGameClick()
		end
	end or nil

	self.onGameDetailsActivated = FFlagLuaAppGameDetailsAttributionFix and function()
		self.props.onGameTileActivated(self.isMounted)
	end or self.onActivated

	function self.onFriendFooterActivated()
		if self.isMounted then
			local gameInfo = self.state.gameInfo
			local v4 = self.props.game

			if not v4 then
				if gameInfo then
					v4 = toLegacyGameInfoModel(gameInfo)
				else
					v4 = nil
				end
			end

			local tileSize = self.getTileSize()
			self.props.openContextualMenu(v4, tileSize, self.getTilePosition())
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

			if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
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

	self.getSortedFriends = memoize(function(p, items)
		if not (p and items) then
			return {}
		end

		local result = {}

		for _, item in pairs(items) do
			local v4 = p[item]

			if v4 and v4.isFriend then
				table.insert(result, { userId = v4.id, displayName = v4.displayName })
			end
		end

		local v4 = sortFriendsByPresenceAndRecencyFactory("displayName")
		table.sort(result, v4)

		return result
	end)

	function self.onSelectionGained()
		if not FFlagLuaAppGameTileSelectionVideoPlayback then
			self:setState({ isSelected = true })
		end

		if self.props.onSelectionGained or FFlagLuaAppGameTileSelectionVideoPlayback then
			self.props.onSelectionGained(self.props.entry, self.props.index, self.props.navigationUniverseId)
		end
	end
	function self.onSelectionLost()
		if not FFlagLuaAppGameTileSelectionVideoPlayback then
			self:setState({ isSelected = false })
		end

		if self.props.onSelectionLost or FFlagLuaAppGameTileSelectionVideoPlayback then
			self.props.onSelectionLost()
		end
	end
end

local function getTextLiteralForTextFooter(footerLayoutData) -- 1 equivalent call inferred from this helper
	if not (footerLayoutData ~= nil and footerLayoutData.type == "TextLabel") then
		return nil
	end

	local text = footerLayoutData.text

	return if text ~= nil then text.textLiteral else nil
end

local fn2 = FFlagLuaAppGenreRatingFooter and function(p)
	if not (p ~= nil and p.type == "RatingWithGenre") then
		return nil
	end

	local genre = p.genre

	return if genre ~= nil then genre.textLiteral else nil
end or nil

function extended:renderGridTilesFooter()
	local v4

	if FFlagLuaAppContinueSortInstantPlay then
		v4 = fn(self.props.enableInstantPlay, self.props.instantPlayTreatment)
	end

	if FFlagLuaAppContinueSortInstantPlay and (v4.isTreatment2 or v4.isTreatment3) then
		return React.createElement(InstantPlayButton, {
			onActivated = self.onInstantPlayActivated,
			showIcon = v4.isTreatment2,
			showText = v4.isTreatment3
		})
	end

	local useLargerFont = self.props.useHoverTile or self.props.useExperienceTileMetadata

	local friendFooterEnabled = self.props.friendFooterEnabled
	local v5 = self.props.hasInGameFriends
	local inGameUserIds

	if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		inGameUserIds = self.props.inGameUserIds
	end

	local users = self.props.users
	local inGameUsersByGame = self.props.inGameUsersByGame
	local friends

	if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		friends = self.getSortedFriends(users, inGameUsersByGame)
	end

	if friendFooterEnabled then
		if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			v5 = inGameUserIds and #inGameUserIds > 0
		end
	else
		v5 = friendFooterEnabled
	end

	local v6 = self.props.friendVisits and #self.props.friendVisits > 0

	local text = getTextLiteralForTextFooter(self.props.footerLayoutData) -- inferred equivalent call
	local genreText

	if FFlagLuaAppGenreRatingFooter then
		genreText = fn2(self.props.footerLayoutData)
	end

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
			text = gameAgeDisplayName
			flag = true
		end
	else
		local v7

		if FFlagLuaAppGameTileSelectionVideoPlayback then
			v7 = self.props.isSelected
		else
			v7 = self.state.isSelected
		end

		if v7 and gameAgeDisplayName and not self.props.hidePlayButton then
			text = gameAgeDisplayName
			flag = true
		end
	end

	local v7 = text ~= nil
	local v8

	if FFlagLuaAppGenreRatingFooter then
		v8 = genreText ~= nil
	end

	local entry = self.props.entry
	local isShowSponsoredLabel = entry.isSponsored
		and (entry.isShowSponsoredLabel or self.props.isSponsoredFooterAllowed or self.props.isSponsoredRatingFooterAllowed)

	if
		FFlagLuaAppMigrateGameTileFixConsoleMetadataText
		and self.props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow
		and self.props.useExperienceTileMetadata
		and (isShowSponsoredLabel or v7 or FFlagLuaAppGenreRatingFooter and v8)
		or self.props.compactMetadataFormat
	then
		useLargerFont = false
	end

	local storeVotes = self.state.storeVotes
	local totalUpVotes = not storeVotes and 0 or storeVotes.upVotes
	local totalDownVotes = not storeVotes and 0 or storeVotes.downVotes

	local createElement = Roact.createElement
	local playerCount

	if self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Footer then
		playerCount = self.props.entry.playerCount
	end

	local v9 = {
		stats = {
			totalUpVotes = totalUpVotes,
			totalDownVotes = totalDownVotes,
			playerCount = playerCount
		},
		isGridTile = self.props.useGridTile,
		hideGameStats = self.props.hideGameStats,
		useLargerFont = useLargerFont,
		isUnifiedGameTile = true,
		gameTileLayoutType = self.props.gameTileLayoutType,
		compactMetadataFormat = self.props.compactMetadataFormat,
		hideRating = 0,
		hidePlayerCount = 0
	}
	local hideRating2

	if FFlagLuaAppNarrowTileHideRating then
		hideRating2 = self.props.hideRating
	end

	v9.hideRating = hideRating2
	local hidePlayerCount2

	if FFlagLuaAppNarrowTileHidePlayerCount then
		hidePlayerCount2 = self.props.hidePlayerCount
	end

	v9.hidePlayerCount = hidePlayerCount2
	local element = createElement(GameStats, v9)

	if self.props.hideMetadata then
		if not self.props.isHovered then
			return nil
		end

		if isShowSponsoredLabel then
			return React.createElement(GridTileSponsoredFooter, {
				useLargerFont = useLargerFont,
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
				text = text,
				useLargerFont = useLargerFont,
				isUnifiedGameTile = true
			})
		end

		return nil
	end

	if isShowSponsoredLabel then
		return (React.createElement(GridTileSponsoredFooter, {
			useLargerFont = useLargerFont,
			onActivateSponsoredTooltip = self.onActivateSponsoredTooltip,
			isUnifiedGameTile = true,
			gameTileLayoutType = self.props.gameTileLayoutType,
			isNarrowScreenXSmall = self.props.isNarrowScreenXSmall,
			enableSponsoredFeedback = self.props.enableSponsoredFeedback,
			isSponsoredRatingFooterAllowed = self.props.isSponsoredRatingFooterAllowed,
			gameStatsElement = element
		}))
	end

	if FFlagLuaAppGenreRatingFooter and v8 and not flag then
		return (React.createElement(RatingWithGenreFooter, {
			useLargerFont = useLargerFont,
			totalUpVotes = totalUpVotes,
			totalDownVotes = totalDownVotes,
			genreText = genreText,
			isUnifiedGameTile = true
		}))
	end

	if v7 then
		return (React.createElement(GridTileTextFooter, {
			text = text,
			useLargerFont = useLargerFont,
			isUnifiedGameTile = true
		}))
	end

	if v5 then
		if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			return (Roact.createElement(gridTileFriendFooter, {
				showOnlineBorder = false,
				useLargerFont = useLargerFont,
				friendUserIds = inGameUserIds,
				onFriendFooterActivated = self.onFriendFooterActivated
			}))
		end

		return (Roact.createElement(gridTileFriendFooter, {
			showOnlineBorder = false,
			friends = friends,
			useLargerFont = useLargerFont
		}))
	end

	if self.props.friendVisitedString then
		return (Roact.createElement(GridTileIconTextFooter, {
			icon = Images["icons/menu/recent"],
			text = self.props.friendVisitedString,
			iconSize = useLargerFont and 32 or 24,
			useLargerFont = useLargerFont
		}))
	end

	if not v6 then
		return element
	end

	if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		return (Roact.createElement(gridTileFriendFooter, {
			showOnlineBorder = false,
			friendUserIds = self.getVisitedFriends(),
			useLargerFont = useLargerFont
		}))
	end

	return (Roact.createElement(gridTileFriendFooter, {
		showOnlineBorder = false,
		friends = self.getVisitedFriends(),
		useLargerFont = useLargerFont
	}))
end

function extended:renderContent(reducedMotion, p, p2)
	local size = self.props.Size or UDim2.fromScale(1, 1)
	local imageThumbnail = self.props.imageThumbnail
	local onGameTileActivated = self.props.onGameTileActivated
	local v4

	if FFlagLuaAppContinueSortInstantPlay then
		v4 = fn(self.props.enableInstantPlay, self.props.instantPlayTreatment)
	end

	local v5 = self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Always
		or self.props.isHovered and self.props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Hover

	local imageAspectRatio = GameTileViewConfig.getImageAspectRatio(self.props.gameTileLayoutType)
	local gridTilesFooter = self:renderGridTilesFooter()
	local name = not self.props.hideTitle
		and (self.props.name or self.state.gameInfo and self.state.gameInfo.name or "")
		or nil
	local v6

	if v5 then
		v6 = React.createElement(GameStats, {
			stats = {
				playerCount = self.props.entry.playerCount,
				displayConcurrentUsersPill = true
			}
		})
	end

	local playButtonHeight = GameTileViewConfig.getElementSizes(
		p.Tokens,
		self.props.textSizeOffset,
		self.props.contentTextLineCount,
		self.props.foundationTokens,
		true
	).playButtonHeight
	local thumbnailComponent

	if self.props.isHidden then
		thumbnailComponent = React.createElement(HiddenTileContent, {
			appPage = self.props.appPage,
			collectionId = self.props.topicId,
			setGameHidden = self.props.setGameHidden,
			universeId = self.props.universeId,
			parentRef = self.props.hoverRef,
			isSponsored = self.props.entry.isSponsored
		})
	elseif self.props.videoThumbnail then
		local createElement = React.createElement
		local v7 = {
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
		local accessContext

		if FFlagLuaAppHomeMomentVideoFallback then
			accessContext = self.props.videoAccessContext
		end

		v7.accessContext = accessContext
		v7.image = imageThumbnail
		v7.playing = self.props.isVideoPlaying

		v7.Size = UDim2.fromScale(1, 1)
		v7.isTileContained = self.props.isContained
		v7.cornerRadius = p.Tokens.Size.Size_200
		local onActivated

		if not FFlagLuaAppVideoTileDisableActivation then
			if FFlagLuaAppContinueSortInstantPlay and v4.isTreatment1 then
				onActivated = self.onInstantPlayActivated
			elseif FFlagLuaAppEdpMediaGalleryFullScreen then
				if FFlagLuaAppGameTileExtractGameDetailsCallback then
					onActivated = self.onGameDetailsActivated
				else
					onActivated = FFlagLuaAppGameDetailsAttributionFix and function()
						onGameTileActivated(self.isMounted)
					end or self.onActivated
				end
			end
		end

		v7.onActivated = onActivated

		v7.itemIndex = self.props.index
		v7.videoAnalytics = self.props.videoAnalytics
		v7.universeId = self.props.universeId
		local videoPlaybackCoordinator

		if self.props.videoPlaybackContext then
			videoPlaybackCoordinator = self.props.videoPlaybackContext.videoPlaybackCoordinator
		end

		v7.videoPlaybackCoordinator = videoPlaybackCoordinator
		thumbnailComponent = createElement(GameTileVideoThumbnail, v7)
	end

	if defineFastFlag or not self.props.isVideoPlaying then
		if self.props.tileBadges then
			v6 = Roact.createFragment({
				SocialFeaturePill = v6,
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = self.props.tileBadges
				})
			})
		end
	else
		v6 = nil
	end

	if FFlagLuaAppContinueSortInstantPlay and v4.isTreatment1 and not self.props.isHidden then
		local element = React.createElement(Foundation.View, {
			tag = "align-x-center align-y-center anchor-bottom-left size-600-600 radius-medium",
			backgroundStyle = p2.Color.Extended.Black.Black_70,
			Position = UDim2.new(0, p2.Padding.XSmall, 1, -p2.Padding.XSmall)
		}, {
			Icon = React.createElement(Foundation.Icon, {
				name = Foundation.Enums.IconName.PlaySmall,
				size = Foundation.Enums.IconSize.Small,
				style = p2.Color.Extended.White.White_100
			})
		})

		if v6 then
			v6 = Roact.createFragment({ Existing = v6, PlayOverlay = element })
		else
			v6 = element
		end
	end

	local isHidden = self.props.isHidden
	local overflowMenu

	if next(self.props.availableMenuItems) ~= nil then
		local createElement, v7, v8, isSelected, onGameDetailsActivated

		if self.props.isHovered or self.props.overflowMenuOpen then
			if not isHidden then
				createElement = React.createElement

				if FFlagLuaAppGameTileNotInterestedDirectAction then
					v7 = GameTileContextualActions
				else
					v7 = GameTileOverflowMenu
				end

				v8 = {
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

				if FFlagLuaAppGameTileSelectionVideoPlayback then
					isSelected = self.props.isSelected
				else
					isSelected = self.state.isSelected
				end

				v8.isSelected = isSelected

				v8.universeId = self.props.universeId
				v8.placeId = self.props.entry.placeId
				v8.collectionId = self.props.topicId
				v8.appPage = self.props.appPage
				v8.setGameHidden = self.props.setGameHidden
				v8.menuKey = self.props.hoverKey
				v8.menuOpen = self.props.overflowMenuOpen
				v8.onMenuOpenChanged = self.onMenuOpenChanged
				v8.parentRef = self.props.hoverRef
				v8.isSponsored = self.props.entry.isSponsored
				v8.payerName = self.props.entry.payerName
				v8.sponsoredUserCohort = self.props.sponsoredUserCohort
				v8.adId = self.props.entry.adId
				v8.availableMenuItems = self.props.availableMenuItems

				if FFlagLuaAppContinueSortInstantPlay and v4.isActive then
					onGameDetailsActivated = self.onGameDetailsActivated
				end

				v8.onGameDetailsActivated = onGameDetailsActivated
				overflowMenu = createElement(v7, v8)
			end
		else
			local v9

			if FFlagLuaAppGameTileSelectionVideoPlayback then
				v9 = self.props.isSelected
			else
				v9 = self.state.isSelected
			end

			if v9 then
				if not isHidden then
					createElement = React.createElement

					if FFlagLuaAppGameTileNotInterestedDirectAction then
						v7 = GameTileContextualActions
					else
						v7 = GameTileOverflowMenu
					end

					v8 = {
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

					if FFlagLuaAppGameTileSelectionVideoPlayback then
						isSelected = self.props.isSelected
					else
						isSelected = self.state.isSelected
					end

					v8.isSelected = isSelected

					v8.universeId = self.props.universeId
					v8.placeId = self.props.entry.placeId
					v8.collectionId = self.props.topicId
					v8.appPage = self.props.appPage
					v8.setGameHidden = self.props.setGameHidden
					v8.menuKey = self.props.hoverKey
					v8.menuOpen = self.props.overflowMenuOpen
					v8.onMenuOpenChanged = self.onMenuOpenChanged
					v8.parentRef = self.props.hoverRef
					v8.isSponsored = self.props.entry.isSponsored
					v8.payerName = self.props.entry.payerName
					v8.sponsoredUserCohort = self.props.sponsoredUserCohort
					v8.adId = self.props.entry.adId
					v8.availableMenuItems = self.props.availableMenuItems

					if FFlagLuaAppContinueSortInstantPlay and v4.isActive then
						onGameDetailsActivated = self.onGameDetailsActivated
					end

					v8.onGameDetailsActivated = onGameDetailsActivated
					overflowMenu = createElement(v7, v8)
				end
			end
		end
	end

	local createElement = React.createElement
	local v7 = {
		Size = size,
		ZIndex = self.props.ZIndex,
		BackgroundTransparency = 1,
		LayoutOrder = self.props.layoutOrder,
		ref = self.gameTileRef
	}

	local createElement2 = React.createElement
	local v8 = {
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
	local hoverPadding

	if not (FFlagLuaAppMigrateGameTileHoverFixes or self.props.useGridTile) then
		hoverPadding = p.Tokens.Size.Size_200
	end

	v8.hoverPadding = hoverPadding

	v8.numLinesForTitle = self.props.contentTextLineCount
	v8.numLinesForMetadata = self.props.metadataTextLineCount
	v8.imageAspectRatio = imageAspectRatio
	v8.isContained = self.props.isContained
	v8.containmentSidePadding = GameTileViewConfig.getContainmentSidePadding(
		p.Tokens,
		self.props.gameTileLayoutType,
		self.props.foundationTokens
	)

	v8.Size = UDim2.fromScale(1, 1)
	v8.image = imageThumbnail
	v8.thumbnailComponent = thumbnailComponent

	if isHidden then
		name = nil
	end

	v8.title = name
	v8.isDisabled = isHidden and true or self.props.isDisabled
	local onActivated

	if FFlagLuaAppContinueSortInstantPlay and v4.isTreatment1 and not isHidden then
		onActivated = self.onInstantPlayActivated
	elseif FFlagLuaAppGameTileExtractGameDetailsCallback then
		if isHidden then
			onActivated = self.onActivated
		else
			onActivated = self.onGameDetailsActivated
		end
	else
		onActivated = FFlagLuaAppGameDetailsAttributionFix and not isHidden and function()
			onGameTileActivated(self.isMounted)
		end or self.onActivated
	end

	v8.onActivated = onActivated

	v8.onGuiStateChanged = self.props.onGuiStateChanged
	v8.onSelectionGained = self.onSelectionGained
	v8.onSelectionLost = self.onSelectionLost
	local onTouchLongPress

	if not isHidden then
		onTouchLongPress = self.onTouchLongPress
	end

	v8.onTouchLongPress = onTouchLongPress
	local onMetadataActivated

	if FFlagLuaAppContinueSortInstantPlay and v4.isTreatment1 and not isHidden then
		onMetadataActivated = self.onGameDetailsActivated
	end

	v8.onMetadataActivated = onMetadataActivated

	v8.reducedMotion = reducedMotion
	v8.isHovered = not isHidden and self.props.isHovered
	v8.forwardRef = self.props.hoverRef
	v8.hidePlayButton = isHidden and true or self.props.hidePlayButton
	local hoverActionRow

	if not (self.props.hidePlayButton or isHidden or FFlagLuaAppContinueSortInstantPlay and v4.isActive) then
		local createElement3 = React.createElement
		local v9 = {
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
		local openGameDetails

		if FFlagLuaAppGameTileExtractGameDetailsCallback then
			openGameDetails = self.onGameDetailsActivated
		else
			openGameDetails = FFlagLuaAppGameDetailsAttributionFix and function()
				onGameTileActivated(self.isMounted)
			end or self.onActivated
		end

		v9.openGameDetails = openGameDetails

		v9.entry = self.props.entry
		v9.launchExperienceEventContext = self.props.launchExperienceEventContext
		v9.fetchDelayInSeconds = getHoverDelay() -- inferred equivalent call
		v9.index = self.props.index

		v9.height = playButtonHeight
		v9.showButtonText = imageAspectRatio > 1
		v9.isUnifiedGameTileEnabled = FFlagLuaAppUnifyPlayButtonTile and true or nil
		v9.placeIdOverride = self.props.entry.placeIdOverride
		v9.launchDataOverride = self.props.entry.launchDataOverride
		hoverActionRow = createElement3(AppExperienceActionRow, v9)
	end

	v8.hoverActionRow = hoverActionRow

	if isHidden then
		v6 = nil
	end

	v8.thumbnailOverlay = v6
	v8.overflowMenu = overflowMenu

	if isHidden then
		gridTilesFooter = nil
	end

	v8.footerMetadata = gridTilesFooter

	v8.textSizeOffset = self.props.textSizeOffset
	v8.hideMetadata = self.props.hideMetadata
	local isTouchPreferredInput2

	if FFlagLuaAppContinueSortInstantPlay then
		isTouchPreferredInput2 = self.props.isTouchPreferredInput
	end

	v8.isTouchPreferredInput = isTouchPreferredInput2
	local v9 = {
		Tile = createElement2(GameTileView, v8),
		VideoPlaybackDetector = self.props.videoPlaybackDetector,
		InstantPlayLauncher = 0
	}
	local instantPlayLauncher

	if FFlagLuaAppContinueSortInstantPlay and v4.isActive and self.state.instantPlayRequested then
		instantPlayLauncher = React.createElement(InstantPlayLauncher, {
			universeId = self.props.navigationUniverseId,
			referralSource = self.props.referralSource,
			eventContext = DiscoveryAnalytics.Constants.Context.InstantPlay,
			launchSource = "ExperienceTile",
			launchData = self.props.entry.launchDataOverride,
			placeId = self.props.entry.placeIdOverride,
			reportExperienceLaunched = self.reportExperienceLaunchedFromInstantPlay,
			openGameDetails = self.onGameDetailsActivated,
			onLaunchAttemptCompleted = self.onInstantPlayAttemptCompleted
		})
	end

	v9.InstantPlayLauncher = instantPlayLauncher
	return createElement("Frame", v7, v9)
end

function extended:render()
	if DiscoveryAppLaunchTracker.isEnabled() and DiscoveryAppLaunchTracker.default then
		DiscoveryAppLaunchTracker.default:trackTileRender()
	end

	if self.props.game == nil then
		return nil
	end

	return withStyle(function(p)
		return self:renderContent(p.Settings.ReducedMotion, p, self.props.foundationTokens)
	end)
end

function extended:didMount()
	self.isMounted = true
	ImpressionsTagUtility.AddTag(self.gameTileRef, self.props.impressionsTag, self.props.index)

	if not self.props.useGridTile and self.props.friendFooterEnabled and self.props.hasInGameFriends then
		self:setState({ canDisplayFriendFooter = true })
	end

	if self.props.useGridTile then
		self.loadWideThumbnail()
	end
end

function extended:willUnmount()
	self.isMounted = false
	ImpressionsTagUtility.RemoveTag(self.gameTileRef, self.props.impressionsTag, self.props.index)
	self.gameInfoSubscription.dispose()
end

function extended.didUpdate(object, data)
	object.gameInfoSubscription.update(object.props.entry.universeId)

	if data.impressionsTag ~= object.props.impressionsTag or data.index ~= object.props.index then
		ImpressionsTagUtility.RemoveTag(object.gameTileRef, data.impressionsTag, data.index)
		ImpressionsTagUtility.AddTag(object.gameTileRef, object.props.impressionsTag, object.props.index)
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

local v4 = RoactRodux.connect(function(p, data)
	local universeId = data.entry.universeId
	local navigationUniverseId

	if not FFlagLuaAppGameDetailsAttributionFix then
		if
			data.entry.navigationUniverseId
			and data.entry.navigationUniverseId ~= ""
			and data.entry.navigationUniverseId ~= "0"
		then
			navigationUniverseId = data.entry.navigationUniverseId
		else
			navigationUniverseId = data.entry.universeId
		end
	end

	local Game = p.Personalization[GameInfosReducer.key][universeId]
	local friendActivityTitle

	if Game then
		friendActivityTitle = Game.friendActivityTitle or nil
	end

	local hidePlayButton

	if data.gameTileLayoutType == "Event" then
		hidePlayButton = data.playButtonStyle ~= GameTileConstants.PlayButtonStyleValues.Enabled
	elseif data.gameTileLayoutType == "Wide" then
		hidePlayButton = data.playButtonStyle == GameTileConstants.PlayButtonStyleValues.Disabled
	else
		hidePlayButton = false
	end

	local gameTileLayoutData = getGameTileLayoutData(Game, data.topicId)

	local gameIconUrl = data.gameIconUrl
	local imageThumbnail, wideThumbnail

	if FFlagLuaAppHomeThumbnailPrefetch then
		local function resolveThumbnail(useGridTile: boolean) -- 2 equivalent calls inferred from this helper
			return resolveGameTileThumbnailUri({
				iconUrl = gameIconUrl,
				universeId = universeId,
				placeId = data.entry.placeId,
				useGridTile = useGridTile,
				perEntryWideAssetId = data.entry.primaryWideImageAssetId,
				game = Game,
				topicId = data.topicId
			})
		end

		imageThumbnail = resolveThumbnail(data.useGridTile == true) -- inferred equivalent call

		if data.useGridTile then
			wideThumbnail = imageThumbnail
		else
			wideThumbnail = resolveThumbnail(true) -- inferred equivalent call
		end
	else
		local v4

		if data.entry.primaryWideImageAssetId then
			v4 = data.entry.primaryWideImageAssetId
		else
			v4 = ItemLayoutDataParsingUtils.getWideImageAssetId(gameTileLayoutData)
		end

		if not v4 then
			if Game then
				v4 = Game.primaryWideAssetId or nil
			else
				v4 = nil
			end
		end

		wideThumbnail = formatExperienceThumbnail(v4, data.entry.placeId)

		if data.useGridTile then
			imageThumbnail = wideThumbnail
		else
			imageThumbnail = formatExperienceIcon(gameIconUrl, universeId)
		end
	end

	local accessContext = nil
	local v4

	if FFlagLuaAppHomeMomentVideoFallback then
		local layoutDataVideo = getLayoutDataVideo(gameTileLayoutData, data.entry.primaryWideVideoAssetId)
		v4 = layoutDataVideo and layoutDataVideo.assetId
		accessContext = layoutDataVideo and layoutDataVideo.accessContext
	elseif data.entry.primaryWideVideoAssetId then
		v4 = data.entry.primaryWideVideoAssetId
	else
		v4 = gameTileLayoutData
			and gameTileLayoutData.primaryMediaAsset
			and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
	end

	local videoThumbnail

	if v4 then
		videoThumbnail = `rbxassetid://{v4}`
	end

	local friendVisits = Game and Game.friendVisits or v
	local friendVisitedString

	if Game and Game.friendVisitedString ~= "" then
		friendVisitedString = Game.friendVisitedString
	end

	local footer

	if gameTileLayoutData then
		footer = gameTileLayoutData.footer or nil
	end

	local title = gameTileLayoutData and gameTileLayoutData.title

	local v5 = {
		game = Game,
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

	if FFlagLuaAppGameDetailsAttributionFix then
		navigationUniverseId = nil
	end

	v5.navigationUniverseId = navigationUniverseId
	v5.name = title
	v5.imageThumbnail = imageThumbnail
	v5.wideThumbnail = wideThumbnail
	v5.videoThumbnail = videoThumbnail

	if not FFlagLuaAppHomeMomentVideoFallback then
		accessContext = nil
	end

	v5.videoAccessContext = accessContext
	v5.friendActivityTitle = friendActivityTitle
	v5.friendVisits = friendVisits
	v5.friendVisitedString = friendVisitedString
	v5.hidePlayButton = hidePlayButton
	v5.footerLayoutData = footer
	return v5
end, function(callback)
	return {
		openContextualMenu = function(p, p2, p3)
			callback(OpenCentralOverlayForPlacesList(p, p2, p3))
		end,
		openSponsoredTooltip = function(p)
			return callback(OpenSponsoredTooltip(p))
		end
	}
end)(extended)

if not FFlagLuaAppGameDetailsAttributionFix then
	v4 = roactServices.connect({ networking = RoactNetworking })(v4)
end

local function fn3(props)
	local ref = React.useRef(nil)
	local foundationTokens = useTokens()
	local isHoverSupported = props.useHoverTile

	local gameIconUrl = GameHydrationReact.useGameIcon(props.entry.universeId)

	local formatted = `{props.impressionsTag or ""}_{props.index or "0"}_{props.gameTileLayoutType or "Narrow"}`

	if props.impressionsTag == nil or props.index == nil then
		isHoverSupported = false
	end

	local isHovered2 = useIsHoveredTile(ref, formatted, isHoverSupported)

	local useExperienceTileMetadata = useUiModeInfo().uiMode == UiMode.TenFoot
	local hasBackground = useExperienceTileMetadata and true or props.useHoverTile

	if props.useExperienceTileMetadata ~= nil then
		useExperienceTileMetadata = props.useExperienceTileMetadata
	end

	local tileBadges = useValidTileBadges(props.entry.universeId, props.topicId, props.badgeOverride)

	local v5 = useSelector(function(p)
		return p.LocalUserId
	end)
	local users

	if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		users = useSelector(function(p)
			return p.Users
		end)
	end

	local inGameUsersByGame = useSelector(function(p)
		return p.InGameUsersByGame[props.entry.universeId]
	end)

	local hasInGameFriends = useHasInGameFriends(v5, users, inGameUsersByGame)
	local v6

	if FFlagGameTileMigrateOffLegacyPresence then
		v6 = useGetOnlineFriendsByUniverseId(props.entry.universeId)
	else
		v6 = nil
	end

	local inGameUserIds

	if FFlagGameTileMigrateOffLegacyPresence then
		inGameUserIds = React.useMemo(function()
			return Cryo.List.map(v6 or {}, function(p)
				return p.id
			end)
		end, { v6 })
	end

	if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		if not FFlagGameTileMigrateOffLegacyPresence then
			inGameUserIds = useInGameUserIds(v5, inGameUsersByGame)
		end
	else
		inGameUserIds = nil
	end

	local state, setState = React.useState(false)

	local state2 = nil
	local v7 = nil
	local onSelectionGained2, onSelectionLost2

	if FFlagLuaAppGameTileSelectionVideoPlayback then
		local setState2
		state2, setState2 = React.useState(false)
		v7 = setState2

		onSelectionGained2 = React.useCallback(function(p, p2, p3)
			v7(true)

			if props.onSelectionGained then
				props.onSelectionGained(p, p2, p3)
			end
		end, { props.onSelectionGained })

		onSelectionLost2 = React.useCallback(function()
			v7(false)

			if props.onSelectionLost then
				props.onSelectionLost()
			end
		end, { props.onSelectionLost })
	end

	local v8

	if props.videoPlaybackContext == nil then
		v8 = false
	else
		v8 = props.videoPlaybackContext.disablePlayback == true
	end

	local v9 = FFlagLuaAppSuppressVideoDetectorDuringScroll

	if v9 then
		if props.videoPlaybackContext == nil then
			v9 = false
		else
			v9 = props.videoPlaybackContext.disableDetectors == true
		end
	end

	React.useEffect(function()
		if FFlagLuaAppFixHiddenTileVideoCleanup and props.isHidden or v8 then
			setState(false)
		end
	end, { props.isHidden, v8 })
	local v10, v11, v12, onGameTileActivated

	if FFlagLuaAppGameDetailsAttributionFix then
		v10 = useRoactService(RoactNetworking)

		if
			props.entry.navigationUniverseId
			and props.entry.navigationUniverseId ~= ""
			and props.entry.navigationUniverseId ~= "0"
		then
			v11 = props.entry.navigationUniverseId
		else
			v11 = props.entry.universeId
		end

		v12 = React.useCallback(function()
			local entry = props.entry

			if entry.isSponsored then
				sponsoredGamesRecordClick(v10, entry.adId)
			end
		end, { v10, props.entry.isSponsored, props.entry.adId })

		local useCallback = React.useCallback
		local function fn4(p)
			if props.isHovered then
				HoverTileCoordinator.default:reset()
			end

			if props.videoPlaybackContext and props.videoPlaybackContext.videoPlaybackCoordinator then
				props.videoPlaybackContext.videoPlaybackCoordinator:reset(VideoEndReason.TileClicked, nil, v11, nil)
			else
				VideoPlaybackCoordinator.default:reset(VideoEndReason.TileClicked, nil, v11, nil)
			end

			if p then
				if props.onActivated then
					props.onActivated()
				end

				local v13 = {
					source = props.source,
					index = props.index,
					referralSource = props.referralSource,
					onPeekViewClosed = props.onPeekViewClosed,
					placeIdOverride = props.entry.placeIdOverride,
					experienceJoinData = 0
				}
				local launchData

				if props.entry.launchDataOverride then
					launchData = props.entry.launchDataOverride
				end

				v13.experienceJoinData = {
					launchData = launchData,
					tileType = props.entry.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile,
					nativeAdData = props.entry.adId
				}

				if GetFFlagEnableNavigationPerformanceIntervals() then
					intervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
				end

				props.navigateToGameDetails(v11, v13)

				props.reportGameDetailOpened(props.index, v11)

				v12()
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
		local v13 = v11
		local v14 = v12
		local placeIdOverride = props.entry.placeIdOverride
		local launchDataOverride = props.entry.launchDataOverride
		local v15

		if props.videoPlaybackContext then
			v15 = props.videoPlaybackContext.videoPlaybackCoordinator
		end

		onGameTileActivated = useCallback(fn4, {
			isHovered,
			index,
			videoAnalytics,
			onActivated,
			source,
			referralSource,
			onPeekViewClosed,
			navigateToGameDetails,
			reportGameDetailOpened,
			v13,
			v14,
			placeIdOverride,
			launchDataOverride,
			v15
		})
	else
		v10 = nil
		v11 = nil
		v12 = nil
	end

	local overflowMenuOpen = useOverflowMenuOpen(formatted)
	local triggerFeedback = useTriggerFeedback()
	local v13

	if FFlagLuaAppContinueSortInstantPlay then
		v13 = fn(props.enableInstantPlay, props.instantPlayTreatment)
	else
		v13 = nil
	end

	local useMemo = React.useMemo
	local function fn4()
		local v14 = {
			isSponsored = props.entry.isSponsored,
			enableExplicitFeedback = props.enableExplicitFeedback,
			enableSponsoredFeedback = props.enableSponsoredFeedback,
			enableReportAd = props.enableReportAd,
			enableGameDetails = 0,
			enableReportExperience = 0
		}
		local enableGameDetails

		if FFlagLuaAppContinueSortInstantPlay then
			enableGameDetails = v13.isTreatment1
		end

		v14.enableGameDetails = enableGameDetails
		local enableReportExperience2

		if FFlagLuaAppEnableReportExperience then
			enableReportExperience2 = props.enableReportExperience
		end

		v14.enableReportExperience = enableReportExperience2
		return getAvailableGameTileOverflowMenuItems(v14)
	end

	local isSponsored = props.entry.isSponsored
	local enableExplicitFeedback = props.enableExplicitFeedback
	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local isTreatment1

	if FFlagLuaAppContinueSortInstantPlay then
		isTreatment1 = v13.isTreatment1
	end

	local v14

	if FFlagLuaAppEnableReportExperience then
		v14 = props.enableReportExperience
	end

	local availableMenuItems = useMemo(fn4, {
		isSponsored,
		enableExplicitFeedback,
		enableSponsoredFeedback,
		enableReportAd,
		isTreatment1,
		v14
	})

	local v15 = useHasVideoThumbnailSelector(props.entry.universeId, props.topicId)

	local v16 = props.entry.primaryWideVideoAssetId ~= nil or v15

	local videoPlaybackContext = props.videoPlaybackContext
	local v17

	if FFlagLuaAppTileVideoCandidateOnly then
		v17 = v16
	end

	local v18

	if FFlagLuaAppFixHiddenTileVideoCleanup then
		v18 = props.isHidden
	end

	useTagAsViewportAutoplayCandidate(
		ref,
		videoPlaybackContext,
		v17,
		v18,
		nil,
		nil,
		nil,
		FFlagLuaAppOneByTwoHoverIdleAutoplay and v16 and {
			videoKey = formatted,
			isUserIntentModeAutoplayCandidate = false
		} or nil
	)
	local v19

	if not (FFlagLuaAppGameTileSelectionVideoPlayback or not FFlagLuaAppEdpMediaGalleryVideoPreview) then
		v19 = usePreferredInput()
	end

	local videoPlaybackDetector

	if v16 and not (props.isHidden or FFlagLuaAppSuppressVideoDetectorDuringScroll and v9) and not v8 then
		local createElement = React.createElement
		local v20 = {
			videoKey = formatted,
			itemIndex = props.index,
			universeId = props.entry.universeId,
			tileRef = ref,
			isHoverSupported = isHoverSupported,
			isHovered = isHovered2,
			isSelected = 0,
			autoplay = 0,
			onPlaybackChange = 0,
			videoAnalytics = 0,
			videoDwellTimeInSec = 0,
			videoVisiblePercent = 0,
			hasPrevalidatedVideoGamePlayability = 0,
			pageContext = 0,
			videoPlaybackContext = 0
		}
		local isSelected

		if FFlagLuaAppGameTileSelectionVideoPlayback then
			isSelected = state2
		end

		v20.isSelected = isSelected
		local autoplay

		if not (FFlagLuaAppGameTileSelectionVideoPlayback or not FFlagLuaAppEdpMediaGalleryVideoPreview) then
			autoplay = v19 == Responsive.Input.Touch
		end

		v20.autoplay = autoplay

		v20.onPlaybackChange = setState
		v20.videoAnalytics = props.videoAnalytics
		v20.videoDwellTimeInSec = FIntLuaAppGameTileVideoDwellTimeInSec
		v20.videoVisiblePercent = FIntLuaAppGameTileVideoVisiblePercent
		local hasPrevalidatedVideoGamePlayability2

		if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
			hasPrevalidatedVideoGamePlayability2 = props.hasPrevalidatedVideoGamePlayability
		end

		v20.hasPrevalidatedVideoGamePlayability = hasPrevalidatedVideoGamePlayability2

		v20.pageContext = props.appPage
		v20.videoPlaybackContext = props.videoPlaybackContext
		videoPlaybackDetector = createElement(GameVideoPlaybackDetector, v20)
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	if not FFlagLuaAppGameTileSelectionVideoPlayback then
		state2 = nil
	end

	if not FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		inGameUserIds = nil
	end

	local networking

	if FFlagLuaAppGameDetailsAttributionFix then
		networking = v10
	end

	local navigationUniverseId

	if FFlagLuaAppGameDetailsAttributionFix then
		navigationUniverseId = v11
	end

	if not FFlagLuaAppGameDetailsAttributionFix then
		onGameTileActivated = nil
	end

	local recordSponsoredGameClick2

	if FFlagLuaAppGameDetailsAttributionFix then
		recordSponsoredGameClick2 = v12
	end

	if not FFlagLuaAppGameTileSelectionVideoPlayback then
		onSelectionGained2 = props.onSelectionGained
	end

	if not FFlagLuaAppGameTileSelectionVideoPlayback then
		onSelectionLost2 = props.onSelectionLost
	end

	return (createElement(v4, join(props, {
		useExperienceTileMetadata = useExperienceTileMetadata,
		hasBackground = hasBackground,
		gameIconUrl = gameIconUrl,
		hoverRef = ref,
		isHoverSupported = isHoverSupported,
		isHovered = isHovered2,
		isSelected = state2,
		isVideoPlaying = state,
		tileBadges = tileBadges,
		foundationTokens = foundationTokens,
		users = users,
		inGameUsersByGame = inGameUsersByGame,
		hasInGameFriends = hasInGameFriends,
		inGameUserIds = inGameUserIds,
		networking = networking,
		navigationUniverseId = navigationUniverseId,
		onGameTileActivated = onGameTileActivated,
		recordSponsoredGameClick = recordSponsoredGameClick2,
		overflowMenuOpen = overflowMenuOpen,
		hoverKey = formatted,
		triggerFeedback = triggerFeedback,
		availableMenuItems = availableMenuItems,
		onSelectionGained = onSelectionGained2,
		onSelectionLost = onSelectionLost2,
		videoPlaybackDetector = videoPlaybackDetector
	})))
end

if FFlagSignalsNavP3fGameDetails then
	fn3 = React.memo(fn3)
end

return fn3
