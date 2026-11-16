local UserGameSettings = UserSettings():GetService("UserGameSettings")

local module = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileView")
local getGameTileLayoutData = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getGameTileLayoutData")
require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")
local formatExperienceThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/formatExperienceThumbnail")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GameStats")
local GameTileConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants")
local GameTileViewConfig = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileViewConfig")
local CreatorNameMetadata = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/CreatorNameMetadata")
local AppExperienceActionRow = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/AppExperienceActionRow")
local useIsHoveredTile = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/useIsHoveredTile")
local GridTileTextFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileTextFooter")
local ItemLayoutDataParsingUtils = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/ItemLayoutDataParsingUtils")
local HoverTileCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/HoverTileCoordinator")
local getTileBadgeByPositionConfigFromEntry = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getTileBadgeByPositionConfigFromEntry")
local GameTileVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileVideoThumbnail")
local GameVideoPlaybackDetector = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Video/GameVideoPlaybackDetector")

local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryTypes").GameCollectionItemTypes
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local gameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameInfosRodux").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameHydrationReact")
local apiFetchGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameDetailRodux").GameDetails.ApiFetchGameDetails
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks").useRoactService
local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Impressions").ImpressionsTagUtility
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation").Hooks.useTokens
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").useDesignTokens
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppCommonLib").IsVRAppBuild
local sponsoredGamesRecordClick = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryAnalytics").Requests.sponsoredGamesRecordClick
local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/VideoUtils")
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate
local videoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local videoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason

local GameTileThumbnailBadges = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Overlays/GameTileThumbnailBadges")
local fFlagLuaAppTileVideoCandidateOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppTileVideoCandidateOnly
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay
local fFlagLuaAppHomeThumbnailPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeThumbnailPrefetch
local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview
local fFlagLuaAppEmphasisGameTileVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEmphasisGameTileVideo

local fFlagLuaAppSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppSuppressVideoDetectorDuringScroll
local fIntLuaAppGameTileVideoDwellTimeInSec = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FIntLuaAppGameTileVideoDwellTimeInSec
local fIntLuaAppGameTileVideoVisiblePercent = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FIntLuaAppGameTileVideoVisiblePercent

local fFlagLuaAppGameTileSelectionVideoPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGameTileSelectionVideoPlayback
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagMigrateGameInfoToStore

local v5 = if fFlagLuaAppHomeThumbnailPrefetch then require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/resolveGameTileThumbnailUri") else nil

return function(props)
	local v6 = useDesignTokens()
	local v7 = useTokens()

	local universeId = props.entry.universeId

	local v8 = useSelector(function(p2)
		return p2.Personalization[gameInfosReducer.key][universeId]
	end)
	local v9, v10

	if fFlagMigrateGameInfoToStore then
		v9 = GameHydrationReact.useGameInfo(universeId)
		v10 = GameHydrationReact.useGameVotes(universeId)
	end

	local v11 = useSelector(function(p2)
		return p2.GameDetails[universeId]
	end)

	local v12 = useRoactService(roactNetworking)
	local v13 = useDispatch()
	React.useEffect(function()
		if v11 then
			return
		end

		v13(apiFetchGameDetails.Fetch(v12, { universeId }))
	end, { v11, universeId, v12, v13 })

	local v14 = getGameTileLayoutData(v8, props.topicId)

	local gameTileLayoutType = props.gameTileLayoutType or "Narrow"
	local v15 = gameTileLayoutType == "Wide" or gameTileLayoutType == "Event"

	local v16 = GameHydrationReact.useLargeGameIcon(universeId) or ""

	if fFlagLuaAppHomeThumbnailPrefetch then
		v16 = v5({
			iconUrl = v16,
			universeId = universeId,
			placeId = props.entry.placeId,
			useGridTile = v15,
			isEmphasized = true,
			perEntryWideAssetId = props.entry.primaryWideImageAssetId,
			game = v8,
			topicId = props.topicId
		})
	else
		local v17

		if props.entry.primaryWideImageAssetId then
			v17 = props.entry.primaryWideImageAssetId
		else
			v17 = ItemLayoutDataParsingUtils.getWideImageAssetId(v14)
		end

		if not v17 then
			v17 = if v8 then v8.primaryWideAssetId or nil else nil
		end

		local v18 = formatExperienceThumbnail(v17, props.entry.placeId, true)

		if v15 then
			v16 = v18
		end
	end

	local imageAspectRatio = GameTileViewConfig.getImageAspectRatio(gameTileLayoutType)
	local title

	if fFlagMigrateGameInfoToStore then
		title = v14 and v14.title or v9 and v9.name or ""
	else
		title = v14 and v14.title or v8 and v8.name or ""
	end

	local v17 = not isVRAppBuild() and props.useHoverTile and props.impressionsTag ~= nil and true or false
	local ref = React.useRef(nil)
	local formatted = `{props.impressionsTag or ""}_{props.index}_{gameTileLayoutType}`
	local v18 = useIsHoveredTile(ref, formatted, v17)
	local v19

	if fFlagLuaAppEmphasisGameTileVideo then
		if props.videoPlaybackContext and props.videoPlaybackContext.videoPlaybackCoordinator then
			v19 = props.videoPlaybackContext.videoPlaybackCoordinator
		else
			v19 = videoPlaybackCoordinator.default
		end
	else
		v19 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if v18 then
			HoverTileCoordinator.default:reset()
		end

		if fFlagLuaAppEmphasisGameTileVideo then
			v19:reset(videoEndReason.TileClicked, nil, universeId, nil)
		end

		local v20 = {
			source = props.source,
			index = props.index,
			referralSource = props.referralSource,
			onPeekViewClosed = props.onPeekViewClosed,
			experienceJoinData = {
				tileType = props.entry.tileType or gameCollectionItemTypes.GameCollectionItemType.EmphasisTile,
				nativeAdData = props.entry.adId
			}
		}

		props.navigateToGameDetails(universeId, v20)

		props.reportGameDetailOpened(props.index, universeId)

		if props.entry.isSponsored then
			sponsoredGamesRecordClick(v12, props.entry.adId)
		end
	end

	local source = props.source
	local onPeekViewClosed = props.onPeekViewClosed
	local isSponsored = props.entry.isSponsored
	local adId = props.entry.adId
	local tileType = if fFlagLuaAppEmphasisGameTileVideo then props.entry.tileType else nil
	local v22 = useCallback(fn, {
		universeId,
		source,
		onPeekViewClosed,
		isSponsored,
		adId,
		tileType,
		props.reportGameDetailOpened,
		v12,
		props.navigateToGameDetails,
		props.referralSource,
		props.index,
		v18,
		if fFlagLuaAppEmphasisGameTileVideo then v19 else nil
	})

	local showDescription = props.showDescription or false
	local v23, v24

	if fFlagMigrateGameInfoToStore then
		v23 = v10 and v10.upVotes or 0
		v24 = v10 and v10.downVotes or 0
	else
		v23 = v8 and v8.totalUpVotes or 0
		v24 = v8 and v8.totalDownVotes or 0
	end

	local hasVerifiedBadge = v11 and v11.creator and v11.creator.hasVerifiedBadge
	local description = v11 and v11.description or ""
	local licenseDescription = if v11 then v11.licenseDescription or nil else nil
	local v25 = if v11 then v11.localizedFiatPrice or nil else nil

	local v26 = licenseDescription or v25

	local hideGameStats = props.hideGameStats or showDescription or v26 ~= nil
	local v27

	if fFlagMigrateGameInfoToStore then
		v27 = v9 and v9.creator and v9.creator.name

		if v27 == "" or not v27 then
			v27 = v11 and v11.creator and v11.creator.name
		end
	else
		v27 = v8 and v8.creatorName ~= "" and v8.creatorName or v11 and v11.creator and v11.creator.name
	end

	local v28 = v26 and 2 or 3
	local v29 = React.useMemo(function()
		local total = 0

		if v27 and v27 ~= "" then
			total += 1
		end

		if showDescription then
			total += v28
		end

		if not hideGameStats then
			total += 1
		end

		if v26 then
			total += 1
		end

		return total
	end, { v27, showDescription, hideGameStats, v26, v28 })

	local isContained = props.isContained or false

	local playButtonHeight = GameTileViewConfig.getElementSizes(v6, props.textSizeOffset, 1, v7, true, v29).playButtonHeight

	local useCallback2 = React.useCallback
	local function fn2(...)
		if v18 then
			HoverTileCoordinator.default:reset()
		end

		if props.reportExperienceLaunched then
			props.reportExperienceLaunched(...)
		end

		if fFlagLuaAppEmphasisGameTileVideo then
			v19:reset(videoEndReason.ExperienceLaunched, nil, universeId, nil)
		end
	end

	local reportExperienceLaunched = props.reportExperienceLaunched
	local v31 = if fFlagLuaAppEmphasisGameTileVideo then universeId else nil
	local v33 = useCallback2(fn2, {
		v18,
		reportExperienceLaunched,
		v31,
		if fFlagLuaAppEmphasisGameTileVideo then v19 else nil
	})

	local v34 = React.useMemo(function()
		return React.createElement(AppExperienceActionRow, {
			universeId = universeId,
			referralSource = props.referralSource,
			launchSource = "FeaturedSearchTile",
			reportExperienceLaunched = v33,
			openGameDetails = v22,
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
		v33,
		v22,
		props.entry,
		props.launchExperienceEventContext,
		playButtonHeight,
		props.index,
		imageAspectRatio
	})

	local v35 = React.useMemo(function()
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

		local v37 = if v26 then React.createElement(GridTileTextFooter, {
			text = v26,
			LayoutOrder = 1,
			useLargerFont = true,
			isUnifiedGameTile = true
		}) else nil
		children.ExtraMetadata = v37

		children.CreatorName = React.createElement(CreatorNameMetadata, {
			name = v27,
			hasVerifiedBadge = hasVerifiedBadge,
			LayoutOrder = 2
		})

		local createElement2 = React.createElement
		local v40 = { totalUpVotes = v23, totalDownVotes = v24, playerCount = 0 }

		local v41 = if props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Footer then props.entry.playerCount else nil
		v40.playerCount = v41
		children.GameStats = createElement2(module4, {
			stats = v40,
			isGridTile = v15,
			hideGameStats = hideGameStats,
			gameTileLayoutType = gameTileLayoutType,
			LayoutOrder = 3,
			useLargerFont = true,
			isUnifiedGameTile = true
		})

		local v42 = if showDescription then React.createElement(GridTileTextFooter, {
			text = description,
			LayoutOrder = 4,
			linesOfText = v28,
			useLargerFont = true,
			isUnifiedGameTile = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			ClipsDescendants = true,
			TextWrapped = true
		}) else nil
		children.Description = v42
		return createElement(fragment, {}, children)
	end, {
		v27,
		v23,
		v24,
		props.playerCountStyle,
		props.entry.playerCount,
		v15,
		hideGameStats,
		gameTileLayoutType,
		showDescription,
		description,
		v26,
		hasVerifiedBadge,
		v28
	})

	local state, setState = React.useState(Vector2.new(0, 0))

	local v36 = React.useMemo(function()
		local tileHeight = GameTileViewConfig.getTileHeight(
			v6,
			state.X,
			gameTileLayoutType,
			isContained,
			false,
			false,
			props.textSizeOffset,
			nil,
			1,
			v29,
			v7,
			true
		)

		return state.Y - tileHeight
	end, {
		v6,
		state,
		gameTileLayoutType,
		isContained,
		props.textSizeOffset,
		1,
		v29,
		v7
	})

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		impressionsTagUtility.AddTag(ref2, props.impressionsTag, props.index)
		return function()
			impressionsTagUtility.RemoveTag(ref2, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local state2 = nil
	local v37 = nil
	local v38 = nil
	local state3 = nil
	local v39 = nil
	local v40 = nil
	local v41 = nil

	local v42 = nil
	local v43, v44

	if fFlagLuaAppEmphasisGameTileVideo then
		v43 = props.videoPlaybackContext ~= nil and props.videoPlaybackContext.disablePlayback == true
		v44 = fFlagLuaAppSuppressVideoDetectorDuringScroll

		if v44 then
			if props.videoPlaybackContext == nil then
				v44 = false
			else
				v44 = props.videoPlaybackContext.disableDetectors == true
			end
		end

		local setState2
		state2, setState2 = React.useState(false)
		v37 = React.useCallback(function(p2)
			setState2(p2)
		end, {})

		if props.entry.primaryWideVideoAssetId then
			v38 = props.entry.primaryWideVideoAssetId
		else
			v38 = v14 and v14.primaryMediaAsset and v14.primaryMediaAsset.wideVideoAssetId
		end

		if fFlagLuaAppGameTileSelectionVideoPlayback then
			local setState3
			state3, setState3 = React.useState(false)
			v39 = setState3

			v40 = React.useCallback(function(...)
				v39(true)

				if props.onSelectionGained then
					props.onSelectionGained(...)
				end
			end, { props.onSelectionGained })

			v41 = React.useCallback(function(...)
				v39(false)

				if props.onSelectionLost then
					props.onSelectionLost(...)
				end
			end, { props.onSelectionLost })
		end

		if not fFlagLuaAppGameTileSelectionVideoPlayback and fFlagLuaAppEdpMediaGalleryVideoPreview then
			v42 = usePreferredInput()
		end

		React.useEffect(function()
			if v43 then
				setState2(false)
			end
		end, { v43 })
	else
		v43 = nil
	end

	local v45 = fFlagLuaAppEmphasisGameTileVideo and v38 ~= nil
	local v47 = if fFlagLuaAppEmphasisGameTileVideo then ref else ref2
	local videoPlaybackContext = props.videoPlaybackContext
	local v48

	if fFlagLuaAppTileVideoCandidateOnly then
		v48 = if fFlagLuaAppEmphasisGameTileVideo then v45 else false
	end

	useTagAsViewportAutoplayCandidate(
		v47,
		videoPlaybackContext,
		v48,
		nil,
		nil,
		nil,
		nil,
		fFlagLuaAppOneByTwoHoverIdleAutoplay and v45 and {
			videoKey = formatted,
			isUserIntentModeAutoplayCandidate = false
		} or nil
	)
	local v49, v50

	if fFlagLuaAppEmphasisGameTileVideo then
		if v45 then
			v49 = React.createElement(GameTileVideoThumbnail, {
				video = `rbxassetid://{v38}`,
				image = v16,
				playing = state2,
				looped = true,
				Size = UDim2.fromScale(1, 1),
				isTileContained = isContained,
				cornerRadius = v7.Radius.Medium,
				ZIndex = -2,
				itemIndex = props.index,
				videoAnalytics = props.videoAnalytics,
				universeId = universeId,
				videoPlaybackCoordinator = v19
			})
		end

		if v45 and not (v43 or fFlagLuaAppSuppressVideoDetectorDuringScroll and v44) then
			local createElement = React.createElement
			local v52 = {
				videoKey = formatted,
				itemIndex = props.index,
				universeId = tostring(universeId),
				tileRef = ref,
				isHoverSupported = v17,
				isHovered = v18,
				isSelected = 0,
				autoplay = 0,
				onPlaybackChange = 0,
				videoAnalytics = 0,
				videoDwellTimeInSec = 0,
				videoVisiblePercent = 0,
				pageContext = 0,
				videoPlaybackContext = 0
			}

			if not fFlagLuaAppGameTileSelectionVideoPlayback then
				state3 = nil
			end

			v52.isSelected = state3

			local v53 = if not (fFlagLuaAppGameTileSelectionVideoPlayback or not fFlagLuaAppEdpMediaGalleryVideoPreview) then v42 == Responsive.Input.Touch else nil
			v52.autoplay = v53

			v52.onPlaybackChange = v37
			v52.videoAnalytics = props.videoAnalytics
			v52.videoDwellTimeInSec = fIntLuaAppGameTileVideoDwellTimeInSec
			v52.videoVisiblePercent = fIntLuaAppGameTileVideoVisiblePercent
			v52.pageContext = props.appPage
			v52.videoPlaybackContext = props.videoPlaybackContext
			v50 = createElement(GameVideoPlaybackDetector, v52)
		end
	end

	local v51 = getTileBadgeByPositionConfigFromEntry(props.entry)
	local v52

	if v51 then
		v52 = React.createElement(GameTileThumbnailBadges, { tileBadgesByPosition = v51 })
	end

	local createElement = React.createElement
	local v54 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = -props.index
	}

	local createElement2 = React.createElement
	local v57 = {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromScale(0, 0),
		Size = props.size,
		BackgroundTransparency = 1,
		ref = ref2,
		[React.Change.AbsoluteSize] = function(p2)
			setState(p2.AbsoluteSize)
		end
	}

	local createElement3 = React.createElement
	local v60 = {
		forwardRef = ref,
		SelectionOrder = props.SelectionOrder,
		isDisabled = props.isDisabled,
		onActivated = v22,
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

	if not (fFlagLuaAppEmphasisGameTileVideo and fFlagLuaAppGameTileSelectionVideoPlayback) then
		v40 = props.onSelectionGained
	end

	v60.onSelectionGained = v40

	if not (fFlagLuaAppEmphasisGameTileVideo and fFlagLuaAppGameTileSelectionVideoPlayback) then
		v41 = props.onSelectionLost
	end

	v60.onSelectionLost = v41

	v60.image = v16

	if not fFlagLuaAppEmphasisGameTileVideo then
		v49 = nil
	end

	v60.thumbnailComponent = v49
	v60.title = title

	v60.numLinesForMetadata = v29
	v60.isHovered = v18
	v60.footerMetadata = v35

	v60.imageAspectRatio = imageAspectRatio
	v60.isContained = isContained

	if showDescription then
		v34 = nil
	end

	v60.extraFooterContent = v34

	if showDescription then
		v36 = nil
	end

	v60.extraFooterSpace = v36

	v60.reducedMotion = UserGameSettings.ReducedMotion
	v60.thumbnailOverlay = v52
	local v58 = {
		GameTileView = createElement3(module, v60),
		VideoPlaybackDetector = 0
	}

	if not fFlagLuaAppEmphasisGameTileVideo then
		v50 = nil
	end

	v58.VideoPlaybackDetector = v50
	return createElement("Frame", v54, {
		EmphasisTileContainer = createElement2("Frame", v57, v58)
	})
end
