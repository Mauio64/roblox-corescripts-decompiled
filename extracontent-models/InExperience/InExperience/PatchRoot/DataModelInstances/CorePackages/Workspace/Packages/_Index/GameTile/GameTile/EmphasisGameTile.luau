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

	local v3 = GameHydrationReact.useGameInfo(universeId)
	local v4 = GameHydrationReact.useGameVotes(universeId)
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

	local iconUrl = GameHydrationReact.useLargeGameIcon(universeId) or ""
	local image

	if FFlagLuaAppHomeThumbnailPrefetch then
		image = resolveGameTileThumbnailUri({
			iconUrl = iconUrl,
			universeId = universeId,
			placeId = props.entry.placeId,
			useGridTile = v8,
			isEmphasized = true,
			perEntryWideAssetId = props.entry.primaryWideImageAssetId,
			game = Game,
			topicId = props.topicId
		})
	else
		local v9

		if props.entry.primaryWideImageAssetId then
			v9 = props.entry.primaryWideImageAssetId
		else
			v9 = ItemLayoutDataParsingUtils.getWideImageAssetId(gameTileLayoutData)
		end

		image = formatExperienceThumbnail(v9 or Game and Game.primaryWideAssetId or nil, props.entry.placeId, true)

		if not v8 then
			image = iconUrl
		end
	end

	local imageAspectRatio = GameTileViewConfig.getImageAspectRatio(gameTileLayoutType)

	local title = gameTileLayoutData and gameTileLayoutData.title or v3 and v3.name or ""

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

		local v9 = {
			source = props.source,
			index = props.index,
			referralSource = props.referralSource,
			onPeekViewClosed = props.onPeekViewClosed,
			experienceJoinData = {
				tileType = props.entry.tileType or GameCollectionItemTypes.GameCollectionItemType.EmphasisTile,
				nativeAdData = props.entry.adId
			}
		}

		props.navigateToGameDetails(universeId, v9)

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
	local v9

	if FFlagLuaAppEmphasisGameTileVideo then
		v9 = videoPlaybackCoordinator
	end

	local v10 = useCallback(fn, {
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
		v9
	})

	local showDescription = props.showDescription or false

	local upVotes = v4 and v4.upVotes or 0
	local downVotes = v4 and v4.downVotes or 0

	local hasVerifiedBadge = v5 and v5.creator and v5.creator.hasVerifiedBadge
	local description = v5 and v5.description or ""
	local licenseDescription

	if v5 then
		licenseDescription = v5.licenseDescription or nil
	end

	local v11

	if v5 then
		v11 = v5.localizedFiatPrice or nil
	end

	local text = licenseDescription or v11

	local hideGameStats = props.hideGameStats or showDescription or text ~= nil

	local name = v3 and v3.creator and v3.creator.name

	if name == "" or not name then
		name = v5 and v5.creator and v5.creator.name
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
	local v12

	if FFlagLuaAppEmphasisGameTileVideo then
		v12 = universeId
	end

	local v13

	if FFlagLuaAppEmphasisGameTileVideo then
		v13 = videoPlaybackCoordinator
	end

	local reportExperienceLaunched2 = useCallback2(fn2, {
		isHovered,
		reportExperienceLaunched,
		v12,
		v13
	})

	local extraFooterContent = React.useMemo(function()
		return React.createElement(AppExperienceActionRow, {
			universeId = universeId,
			referralSource = props.referralSource,
			launchSource = "FeaturedSearchTile",
			reportExperienceLaunched = reportExperienceLaunched2,
			openGameDetails = v10,
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
		v10,
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
		local stats = { totalUpVotes = upVotes, totalDownVotes = downVotes, playerCount = 0 }
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
		upVotes,
		downVotes,
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
	local v14 = nil
	local state3 = nil
	local v15 = nil
	local onSelectionGained = nil
	local onSelectionLost = nil

	local v16 = nil
	local v17, v18

	if FFlagLuaAppEmphasisGameTileVideo then
		v17 = props.videoPlaybackContext ~= nil and props.videoPlaybackContext.disablePlayback == true
		v18 = FFlagLuaAppSuppressVideoDetectorDuringScroll

		if v18 then
			if props.videoPlaybackContext == nil then
				v18 = false
			else
				v18 = props.videoPlaybackContext.disableDetectors == true
			end
		end

		local setState2
		state2, setState2 = React.useState(false)
		onPlaybackChange = React.useCallback(function(flag: boolean)
			setState2(flag)
		end, {})

		if props.entry.primaryWideVideoAssetId then
			v14 = props.entry.primaryWideVideoAssetId
		else
			v14 = gameTileLayoutData
				and gameTileLayoutData.primaryMediaAsset
				and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
		end

		if FFlagLuaAppGameTileSelectionVideoPlayback then
			local setState3
			state3, setState3 = React.useState(false)
			v15 = setState3

			onSelectionGained = React.useCallback(function(...)
				v15(true)

				if props.onSelectionGained then
					props.onSelectionGained(...)
				end
			end, { props.onSelectionGained })

			onSelectionLost = React.useCallback(function(...)
				v15(false)

				if props.onSelectionLost then
					props.onSelectionLost(...)
				end
			end, { props.onSelectionLost })
		end

		if not FFlagLuaAppGameTileSelectionVideoPlayback and FFlagLuaAppEdpMediaGalleryVideoPreview then
			v16 = usePreferredInput()
		end

		React.useEffect(function()
			if v17 then
				setState2(false)
			end
		end, { v17 })
	else
		v17 = nil
	end

	local v19 = FFlagLuaAppEmphasisGameTileVideo and v14 ~= nil
	local v20 = if FFlagLuaAppEmphasisGameTileVideo then ref else ref2
	local videoPlaybackContext = props.videoPlaybackContext
	local v21

	if FFlagLuaAppTileVideoCandidateOnly then
		v21 = if FFlagLuaAppEmphasisGameTileVideo then v19 else false
	end

	useTagAsViewportAutoplayCandidate(
		v20,
		videoPlaybackContext,
		v21,
		nil,
		nil,
		nil,
		nil,
		FFlagLuaAppOneByTwoHoverIdleAutoplay and v19 and {
			videoKey = formatted,
			isUserIntentModeAutoplayCandidate = false
		} or nil
	)
	local thumbnailComponent, videoPlaybackDetector

	if FFlagLuaAppEmphasisGameTileVideo then
		if v19 then
			thumbnailComponent = React.createElement(GameTileVideoThumbnail, {
				video = `rbxassetid://{v14}`,
				image = image,
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

		if v19 and not (v17 or FFlagLuaAppSuppressVideoDetectorDuringScroll and v18) then
			local createElement = React.createElement
			local v22 = {
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

			v22.isSelected = state3
			local autoplay

			if not (FFlagLuaAppGameTileSelectionVideoPlayback or not FFlagLuaAppEdpMediaGalleryVideoPreview) then
				autoplay = v16 == Responsive.Input.Touch
			end

			v22.autoplay = autoplay

			v22.onPlaybackChange = onPlaybackChange
			v22.videoAnalytics = props.videoAnalytics
			v22.videoDwellTimeInSec = FIntLuaAppGameTileVideoDwellTimeInSec
			v22.videoVisiblePercent = FIntLuaAppGameTileVideoVisiblePercent
			v22.pageContext = props.appPage
			v22.videoPlaybackContext = props.videoPlaybackContext
			videoPlaybackDetector = createElement(GameVideoPlaybackDetector, v22)
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
	local v22 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = -props.index
	}

	local createElement2 = React.createElement
	local v23 = {
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
	local v24 = {
		forwardRef = ref,
		SelectionOrder = props.SelectionOrder,
		isDisabled = props.isDisabled,
		onActivated = v10,
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

	v24.onSelectionGained = onSelectionGained

	if not (FFlagLuaAppEmphasisGameTileVideo and FFlagLuaAppGameTileSelectionVideoPlayback) then
		onSelectionLost = props.onSelectionLost
	end

	v24.onSelectionLost = onSelectionLost

	v24.image = image

	if not FFlagLuaAppEmphasisGameTileVideo then
		thumbnailComponent = nil
	end

	v24.thumbnailComponent = thumbnailComponent
	v24.title = title

	v24.numLinesForMetadata = numLinesForMetadata
	v24.isHovered = isHovered
	v24.footerMetadata = footerMetadata

	v24.imageAspectRatio = imageAspectRatio
	v24.isContained = isContained

	if showDescription then
		extraFooterContent = nil
	end

	v24.extraFooterContent = extraFooterContent

	if showDescription then
		extraFooterSpace = nil
	end

	v24.extraFooterSpace = extraFooterSpace

	v24.reducedMotion = UserGameSettings.ReducedMotion
	v24.thumbnailOverlay = thumbnailOverlay
	local v25 = {
		GameTileView = createElement3(GameTileView, v24),
		VideoPlaybackDetector = 0
	}

	if not FFlagLuaAppEmphasisGameTileVideo then
		videoPlaybackDetector = nil
	end

	v25.VideoPlaybackDetector = videoPlaybackDetector
	return createElement("Frame", v22, {
		EmphasisTileContainer = createElement2("Frame", v23, v25)
	})
end
