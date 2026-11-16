local GameTile = script:FindFirstAncestor("GameTile")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local GameTileView = require(GameTile.GameTileView)
local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
require(GameTile.GameTileTypes)
local formatExperienceThumbnail = require(GameTile.formatExperienceThumbnail)
local GameStats = require(GameTile.Footer.GameStats)
local GameTileConstants = require(GameTile.GameTileConstants)
local GameTileViewConfig = require(GameTile.GameTileViewConfig)
local CreatorNameMetadata = require(GameTile.Footer.CreatorNameMetadata)
local AppExperienceActionRow = require(GameTile.AppExperienceActionRow)
local useIsHoveredTile = require(GameTile.useIsHoveredTile)
local GridTileTextFooter = require(GameTile.Footer.GridTileTextFooter)
local ItemLayoutDataParsingUtils = require(GameTile.ItemLayoutDataParsingUtils)
local HoverTileCoordinator = require(GameTile.HoverTileCoordinator)
local getTileBadgeByPositionConfigFromEntry = require(GameTile.getTileBadgeByPositionConfigFromEntry)
local GameTileVideoThumbnail = require(GameTile.GameTileVideoThumbnail)
local GameVideoPlaybackDetector = require(GameTile.Video.GameVideoPlaybackDetector)

local parent = GameTile.Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local GameInfosRodux = require(parent.GameInfosRodux)
local GameInfosReducer = GameInfosRodux.GameInfosReducer
local GameHydrationReact = require(parent.GameHydrationReact)
local GameDetailRodux = require(parent.GameDetailRodux)
local ApiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local AppCommonLib = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local VideoUtils = require(parent.VideoUtils)
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason

local GameTileThumbnailBadges = require(GameTile.Overlays.GameTileThumbnailBadges)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppTileVideoCandidateOnly = SharedFlags.FFlagLuaAppTileVideoCandidateOnly
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags2.FFlagLuaAppOneByTwoHoverIdleAutoplay
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppHomeThumbnailPrefetch = SharedFlags3.FFlagLuaAppHomeThumbnailPrefetch
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryVideoPreview = SharedFlags4.FFlagLuaAppEdpMediaGalleryVideoPreview
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppEmphasisGameTileVideo = SharedFlags5.FFlagLuaAppEmphasisGameTileVideo

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppSuppressVideoDetectorDuringScroll = SharedFlags6.FFlagLuaAppSuppressVideoDetectorDuringScroll
local SharedFlags7 = require(parent.SharedFlags)
local FIntLuaAppGameTileVideoDwellTimeInSec = SharedFlags7.FIntLuaAppGameTileVideoDwellTimeInSec
local SharedFlags8 = require(parent.SharedFlags)
local FIntLuaAppGameTileVideoVisiblePercent = SharedFlags8.FIntLuaAppGameTileVideoVisiblePercent

local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppGameTileSelectionVideoPlayback = SharedFlags9.FFlagLuaAppGameTileSelectionVideoPlayback
local SharedFlags10 = require(parent.SharedFlags)
local FFlagMigrateGameInfoToStore = SharedFlags10.FFlagMigrateGameInfoToStore
local resolveGameTileThumbnailUri

if FFlagLuaAppHomeThumbnailPrefetch then
	resolveGameTileThumbnailUri = require(GameTile.resolveGameTileThumbnailUri)
else
	resolveGameTileThumbnailUri = nil
end

return function(props)
	local v = useDesignTokens()
	local v2 = useTokens()

	local universeId = props.entry.universeId

	local Game = useSelector(function(p)
		return p.Personalization[GameInfosReducer.key][universeId]
	end)
	local v3, v4

	if FFlagMigrateGameInfoToStore then
		v3 = GameHydrationReact.useGameInfo(universeId)
		v4 = GameHydrationReact.useGameVotes(universeId)
	end

	local v5 = useSelector(function(p)
		return p.GameDetails[universeId]
	end)

	local v6 = useRoactService(RoactNetworking)
	local v7 = useDispatch()
	React.useEffect(function()
		if v5 then
			return
		end

		v7(ApiFetchGameDetails.Fetch(v6, { universeId }))
	end, { v5, universeId, v6, v7 })

	local gameTileLayoutData = getGameTileLayoutData(Game, props.topicId)

	local gameTileLayoutType = props.gameTileLayoutType or "Narrow"
	local v8 = gameTileLayoutType == "Wide" or gameTileLayoutType == "Event"

	local v9 = GameHydrationReact.useLargeGameIcon(universeId) or ""

	if FFlagLuaAppHomeThumbnailPrefetch then
		v9 = resolveGameTileThumbnailUri({
			iconUrl = v9,
			universeId = universeId,
			placeId = props.entry.placeId,
			useGridTile = v8,
			isEmphasized = true,
			perEntryWideAssetId = props.entry.primaryWideImageAssetId,
			game = Game,
			topicId = props.topicId
		})
	else
		local v10

		if props.entry.primaryWideImageAssetId then
			v10 = props.entry.primaryWideImageAssetId
		else
			v10 = ItemLayoutDataParsingUtils.getWideImageAssetId(gameTileLayoutData)
		end

		if not v10 then
			if Game then
				v10 = Game.primaryWideAssetId or nil
			else
				v10 = nil
			end
		end

		local v11 = formatExperienceThumbnail(v10, props.entry.placeId, true)

		if v8 then
			v9 = v11
		end
	end

	local imageAspectRatio = GameTileViewConfig.getImageAspectRatio(gameTileLayoutType)
	local title

	if FFlagMigrateGameInfoToStore then
		title = gameTileLayoutData and gameTileLayoutData.title or v3 and v3.name or ""
	else
		title = gameTileLayoutData and gameTileLayoutData.title or Game and Game.name or ""
	end

	local isHoverSupported = not IsVRAppBuild() and props.useHoverTile and props.impressionsTag ~= nil and true or false
	local ref = React.useRef(nil)
	local formatted = `{props.impressionsTag or ""}_{props.index}_{gameTileLayoutType}`
	local isHovered = useIsHoveredTile(ref, formatted, isHoverSupported)
	local videoPlaybackCoordinator

	if FFlagLuaAppEmphasisGameTileVideo then
		if props.videoPlaybackContext and props.videoPlaybackContext.videoPlaybackCoordinator then
			videoPlaybackCoordinator = props.videoPlaybackContext.videoPlaybackCoordinator
		else
			videoPlaybackCoordinator = VideoPlaybackCoordinator.default
		end
	else
		videoPlaybackCoordinator = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if isHovered then
			HoverTileCoordinator.default:reset()
		end

		if FFlagLuaAppEmphasisGameTileVideo then
			videoPlaybackCoordinator:reset(VideoEndReason.TileClicked, nil, universeId, nil)
		end

		local v10 = {
			source = props.source,
			index = props.index,
			referralSource = props.referralSource,
			onPeekViewClosed = props.onPeekViewClosed,
			experienceJoinData = {
				tileType = props.entry.tileType or GameCollectionItemTypes.GameCollectionItemType.EmphasisTile,
				nativeAdData = props.entry.adId
			}
		}

		props.navigateToGameDetails(universeId, v10)

		props.reportGameDetailOpened(props.index, universeId)

		if props.entry.isSponsored then
			sponsoredGamesRecordClick(v6, props.entry.adId)
		end
	end

	local source = props.source
	local onPeekViewClosed = props.onPeekViewClosed
	local isSponsored = props.entry.isSponsored
	local adId = props.entry.adId
	local tileType

	if FFlagLuaAppEmphasisGameTileVideo then
		tileType = props.entry.tileType
	end

	local reportGameDetailOpened = props.reportGameDetailOpened

	local navigateToGameDetails = props.navigateToGameDetails
	local referralSource = props.referralSource
	local index = props.index
	local v10

	if FFlagLuaAppEmphasisGameTileVideo then
		v10 = videoPlaybackCoordinator
	end

	local v11 = useCallback(fn, {
		universeId,
		source,
		onPeekViewClosed,
		isSponsored,
		adId,
		tileType,
		reportGameDetailOpened,
		v6,
		navigateToGameDetails,
		referralSource,
		index,
		isHovered,
		v10
	})

	local showDescription = props.showDescription or false
	local totalUpVotes, totalDownVotes

	if FFlagMigrateGameInfoToStore then
		totalUpVotes = v4 and v4.upVotes or 0
		totalDownVotes = v4 and v4.downVotes or 0
	else
		totalUpVotes = Game and Game.totalUpVotes or 0
		totalDownVotes = Game and Game.totalDownVotes or 0
	end

	local hasVerifiedBadge = v5 and v5.creator and v5.creator.hasVerifiedBadge
	local description = v5 and v5.description or ""
	local licenseDescription

	if v5 then
		licenseDescription = v5.licenseDescription or nil
	end

	local v12

	if v5 then
		v12 = v5.localizedFiatPrice or nil
	end

	local text = licenseDescription or v12

	local hideGameStats = props.hideGameStats or showDescription or text ~= nil
	local name

	if FFlagMigrateGameInfoToStore then
		name = v3 and v3.creator and v3.creator.name

		if name == "" or not name then
			name = v5 and v5.creator and v5.creator.name
		end
	else
		name = Game and Game.creatorName ~= "" and Game.creatorName or v5 and v5.creator and v5.creator.name
	end

	local linesOfText = text and 2 or 3
	local numLinesForMetadata = React.useMemo(function()
		local total = 0

		if name and name ~= "" then
			total += 1
		end

		if showDescription then
			total += linesOfText
		end

		if not hideGameStats then
			total += 1
		end

		if text then
			total += 1
		end

		return total
	end, { name, showDescription, hideGameStats, text, linesOfText })

	local isContained = props.isContained or false

	local playButtonHeight = GameTileViewConfig.getElementSizes(
		v,
		props.textSizeOffset,
		1,
		v2,
		true,
		numLinesForMetadata
	).playButtonHeight

	local useCallback2 = React.useCallback
	local function fn2(...)
		if isHovered then
			HoverTileCoordinator.default:reset()
		end

		if props.reportExperienceLaunched then
			props.reportExperienceLaunched(...)
		end

		if FFlagLuaAppEmphasisGameTileVideo then
			videoPlaybackCoordinator:reset(VideoEndReason.ExperienceLaunched, nil, universeId, nil)
		end
	end

	local reportExperienceLaunched = props.reportExperienceLaunched
	local v13

	if FFlagLuaAppEmphasisGameTileVideo then
		v13 = universeId
	end

	local v14

	if FFlagLuaAppEmphasisGameTileVideo then
		v14 = videoPlaybackCoordinator
	end

	local reportExperienceLaunched2 = useCallback2(fn2, {
		isHovered,
		reportExperienceLaunched,
		v13,
		v14
	})

	local extraFooterContent = React.useMemo(function()
		return React.createElement(AppExperienceActionRow, {
			universeId = universeId,
			referralSource = props.referralSource,
			launchSource = "FeaturedSearchTile",
			reportExperienceLaunched = reportExperienceLaunched2,
			openGameDetails = v11,
			entry = props.entry,
			launchExperienceEventContext = props.launchExperienceEventContext,
			showButtonText = imageAspectRatio > 1,
			horizontalPadding = 0,
			verticalPadding = 0,
			height = playButtonHeight,
			index = props.index,
			isUnifiedGameTileEnabled = true
		})
	end, {
		universeId,
		props.referralSource,
		reportExperienceLaunched2,
		v11,
		props.entry,
		props.launchExperienceEventContext,
		playButtonHeight,
		props.index,
		imageAspectRatio
	})

	local footerMetadata = React.useMemo(function()
		local createElement = React.createElement
		local fragment = React.Fragment
		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ExtraMetadata = 0,
			CreatorName = 0,
			GameStats = 0,
			Description = 0
		}
		local extraMetadata

		if text then
			extraMetadata = React.createElement(GridTileTextFooter, {
				text = text,
				LayoutOrder = 1,
				useLargerFont = true,
				isUnifiedGameTile = true
			})
		end

		children.ExtraMetadata = extraMetadata

		children.CreatorName = React.createElement(CreatorNameMetadata, {
			name = name,
			hasVerifiedBadge = hasVerifiedBadge,
			LayoutOrder = 2
		})

		local createElement2 = React.createElement
		local stats = {
			totalUpVotes = totalUpVotes,
			totalDownVotes = totalDownVotes,
			playerCount = 0
		}
		local playerCount

		if props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Footer then
			playerCount = props.entry.playerCount
		end

		stats.playerCount = playerCount
		children.GameStats = createElement2(GameStats, {
			stats = stats,
			isGridTile = v8,
			hideGameStats = hideGameStats,
			gameTileLayoutType = gameTileLayoutType,
			LayoutOrder = 3,
			useLargerFont = true,
			isUnifiedGameTile = true
		})
		local description2

		if showDescription then
			description2 = React.createElement(GridTileTextFooter, {
				text = description,
				LayoutOrder = 4,
				linesOfText = linesOfText,
				useLargerFont = true,
				isUnifiedGameTile = true,
				TextYAlignment = Enum.TextYAlignment.Top,
				ClipsDescendants = true,
				TextWrapped = true
			})
		end

		children.Description = description2
		return createElement(fragment, {}, children)
	end, {
		name,
		totalUpVotes,
		totalDownVotes,
		props.playerCountStyle,
		props.entry.playerCount,
		v8,
		hideGameStats,
		gameTileLayoutType,
		showDescription,
		description,
		text,
		hasVerifiedBadge,
		linesOfText
	})

	local state, setState = React.useState(Vector2.new(0, 0))

	local extraFooterSpace = React.useMemo(function()
		local tileHeight = GameTileViewConfig.getTileHeight(
			v,
			state.X,
			gameTileLayoutType,
			isContained,
			false,
			false,
			props.textSizeOffset,
			nil,
			1,
			numLinesForMetadata,
			v2,
			true
		)

		return state.Y - tileHeight
	end, {
		v,
		state,
		gameTileLayoutType,
		isContained,
		props.textSizeOffset,
		1,
		numLinesForMetadata,
		v2
	})

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(ref2, props.impressionsTag, props.index)
		return function()
			ImpressionsTagUtility.RemoveTag(ref2, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local state2 = nil
	local onPlaybackChange = nil
	local v15 = nil
	local state3 = nil
	local v16 = nil
	local onSelectionGained = nil
	local onSelectionLost = nil

	local v17 = nil
	local v18, v19

	if FFlagLuaAppEmphasisGameTileVideo then
		v18 = props.videoPlaybackContext ~= nil and props.videoPlaybackContext.disablePlayback == true
		v19 = FFlagLuaAppSuppressVideoDetectorDuringScroll

		if v19 then
			if props.videoPlaybackContext == nil then
				v19 = false
			else
				v19 = props.videoPlaybackContext.disableDetectors == true
			end
		end

		local setState2
		state2, setState2 = React.useState(false)
		onPlaybackChange = React.useCallback(function(flag: boolean)
			setState2(flag)
		end, {})

		if props.entry.primaryWideVideoAssetId then
			v15 = props.entry.primaryWideVideoAssetId
		else
			v15 = gameTileLayoutData
				and gameTileLayoutData.primaryMediaAsset
				and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
		end

		if FFlagLuaAppGameTileSelectionVideoPlayback then
			local setState3
			state3, setState3 = React.useState(false)
			v16 = setState3

			onSelectionGained = React.useCallback(function(...)
				v16(true)

				if props.onSelectionGained then
					props.onSelectionGained(...)
				end
			end, { props.onSelectionGained })

			onSelectionLost = React.useCallback(function(...)
				v16(false)

				if props.onSelectionLost then
					props.onSelectionLost(...)
				end
			end, { props.onSelectionLost })
		end

		if not FFlagLuaAppGameTileSelectionVideoPlayback and FFlagLuaAppEdpMediaGalleryVideoPreview then
			v17 = usePreferredInput()
		end

		React.useEffect(function()
			if v18 then
				setState2(false)
			end
		end, { v18 })
	else
		v18 = nil
	end

	local v20 = FFlagLuaAppEmphasisGameTileVideo and v15 ~= nil
	local v21 = if FFlagLuaAppEmphasisGameTileVideo then ref else ref2
	local videoPlaybackContext = props.videoPlaybackContext
	local v22

	if FFlagLuaAppTileVideoCandidateOnly then
		v22 = if FFlagLuaAppEmphasisGameTileVideo then v20 else false
	end

	useTagAsViewportAutoplayCandidate(
		v21,
		videoPlaybackContext,
		v22,
		nil,
		nil,
		nil,
		nil,
		FFlagLuaAppOneByTwoHoverIdleAutoplay and v20 and {
			videoKey = formatted,
			isUserIntentModeAutoplayCandidate = false
		} or nil
	)
	local thumbnailComponent, videoPlaybackDetector

	if FFlagLuaAppEmphasisGameTileVideo then
		if v20 then
			thumbnailComponent = React.createElement(GameTileVideoThumbnail, {
				video = `rbxassetid://{v15}`,
				image = v9,
				playing = state2,
				looped = true,
				Size = UDim2.fromScale(1, 1),
				isTileContained = isContained,
				cornerRadius = v2.Radius.Medium,
				ZIndex = -2,
				itemIndex = props.index,
				videoAnalytics = props.videoAnalytics,
				universeId = universeId,
				videoPlaybackCoordinator = videoPlaybackCoordinator
			})
		end

		if v20 and not (v18 or FFlagLuaAppSuppressVideoDetectorDuringScroll and v19) then
			local createElement = React.createElement
			local v23 = {
				videoKey = formatted,
				itemIndex = props.index,
				universeId = tostring(universeId),
				tileRef = ref,
				isHoverSupported = isHoverSupported,
				isHovered = isHovered,
				isSelected = 0,
				autoplay = 0,
				onPlaybackChange = 0,
				videoAnalytics = 0,
				videoDwellTimeInSec = 0,
				videoVisiblePercent = 0,
				pageContext = 0,
				videoPlaybackContext = 0
			}

			if not FFlagLuaAppGameTileSelectionVideoPlayback then
				state3 = nil
			end

			v23.isSelected = state3
			local autoplay

			if not (FFlagLuaAppGameTileSelectionVideoPlayback or not FFlagLuaAppEdpMediaGalleryVideoPreview) then
				autoplay = v17 == Responsive.Input.Touch
			end

			v23.autoplay = autoplay

			v23.onPlaybackChange = onPlaybackChange
			v23.videoAnalytics = props.videoAnalytics
			v23.videoDwellTimeInSec = FIntLuaAppGameTileVideoDwellTimeInSec
			v23.videoVisiblePercent = FIntLuaAppGameTileVideoVisiblePercent
			v23.pageContext = props.appPage
			v23.videoPlaybackContext = props.videoPlaybackContext
			videoPlaybackDetector = createElement(GameVideoPlaybackDetector, v23)
		end
	end

	local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(props.entry)
	local thumbnailOverlay

	if tileBadgeByPositionConfigFromEntry then
		thumbnailOverlay = React.createElement(GameTileThumbnailBadges, {
			tileBadgesByPosition = tileBadgeByPositionConfigFromEntry
		})
	end

	local createElement = React.createElement
	local v23 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = -props.index
	}

	local createElement2 = React.createElement
	local v24 = {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromScale(0, 0),
		Size = props.size,
		BackgroundTransparency = 1,
		ref = ref2,
		[React.Change.AbsoluteSize] = function(p)
			setState(p.AbsoluteSize)
		end
	}

	local createElement3 = React.createElement
	local v25 = {
		forwardRef = ref,
		SelectionOrder = props.SelectionOrder,
		isDisabled = props.isDisabled,
		onActivated = v11,
		onSelectionGained = 0,
		onSelectionLost = 0,
		image = 0,
		thumbnailComponent = 0,
		title = 0,
		numLinesForTitle = 1,
		numLinesForMetadata = 0,
		isHovered = 0,
		footerMetadata = 0,
		isUnifiedGameTile = true,
		imageAspectRatio = 0,
		isContained = 0,
		extraFooterContent = 0,
		extraFooterSpace = 0,
		hidePlayButton = true,
		reducedMotion = 0,
		thumbnailOverlay = 0
	}

	if not (FFlagLuaAppEmphasisGameTileVideo and FFlagLuaAppGameTileSelectionVideoPlayback) then
		onSelectionGained = props.onSelectionGained
	end

	v25.onSelectionGained = onSelectionGained

	if not (FFlagLuaAppEmphasisGameTileVideo and FFlagLuaAppGameTileSelectionVideoPlayback) then
		onSelectionLost = props.onSelectionLost
	end

	v25.onSelectionLost = onSelectionLost

	v25.image = v9

	if not FFlagLuaAppEmphasisGameTileVideo then
		thumbnailComponent = nil
	end

	v25.thumbnailComponent = thumbnailComponent
	v25.title = title

	v25.numLinesForMetadata = numLinesForMetadata
	v25.isHovered = isHovered
	v25.footerMetadata = footerMetadata

	v25.imageAspectRatio = imageAspectRatio
	v25.isContained = isContained

	if showDescription then
		extraFooterContent = nil
	end

	v25.extraFooterContent = extraFooterContent

	if showDescription then
		extraFooterSpace = nil
	end

	v25.extraFooterSpace = extraFooterSpace

	v25.reducedMotion = UserGameSettings.ReducedMotion
	v25.thumbnailOverlay = thumbnailOverlay
	local v26 = {
		GameTileView = createElement3(GameTileView, v25),
		VideoPlaybackDetector = 0
	}

	if not FFlagLuaAppEmphasisGameTileVideo then
		videoPlaybackDetector = nil
	end

	v26.VideoPlaybackDetector = videoPlaybackDetector
	return createElement("Frame", v23, {
		EmphasisTileContainer = createElement2("Frame", v24, v26)
	})
end
