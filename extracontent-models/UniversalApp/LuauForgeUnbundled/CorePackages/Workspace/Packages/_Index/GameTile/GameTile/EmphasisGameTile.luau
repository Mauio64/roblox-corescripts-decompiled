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

local v5 = if fFlagLuaAppHomeThumbnailPrefetch then require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/resolveGameTileThumbnailUri") else nil

return function(props)
	local v6 = useDesignTokens()
	local v7 = useTokens()

	local universeId = props.entry.universeId

	local v8 = useSelector(function(p2)
		return p2.Personalization[gameInfosReducer.key][universeId]
	end)

	local v9 = GameHydrationReact.useGameInfo(universeId)
	local v10 = GameHydrationReact.useGameVotes(universeId)
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
	local v17

	if fFlagLuaAppHomeThumbnailPrefetch then
		v17 = v5({
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
		v17 = formatExperienceThumbnail(
			(if props.entry.primaryWideImageAssetId then props.entry.primaryWideImageAssetId else ItemLayoutDataParsingUtils.getWideImageAssetId(v14)) or v8 and v8.primaryWideAssetId or nil,
			props.entry.placeId,
			true
		)

		if not v15 then
			v17 = v16
		end
	end

	local imageAspectRatio = GameTileViewConfig.getImageAspectRatio(gameTileLayoutType)

	local title = v14 and v14.title or v9 and v9.name or ""

	local v18 = not isVRAppBuild() and props.useHoverTile and props.impressionsTag ~= nil and true or false
	local ref = React.useRef(nil)
	local formatted = `{props.impressionsTag or ""}_{props.index}_{gameTileLayoutType}`
	local v19 = useIsHoveredTile(ref, formatted, v18)
	local v20

	if fFlagLuaAppEmphasisGameTileVideo then
		if props.videoPlaybackContext and props.videoPlaybackContext.videoPlaybackCoordinator then
			v20 = props.videoPlaybackContext.videoPlaybackCoordinator
		else
			v20 = videoPlaybackCoordinator.default
		end
	else
		v20 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if v19 then
			HoverTileCoordinator.default:reset()
		end

		if fFlagLuaAppEmphasisGameTileVideo then
			v20:reset(videoEndReason.TileClicked, nil, universeId, nil)
		end

		local v21 = {
			source = props.source,
			index = props.index,
			referralSource = props.referralSource,
			onPeekViewClosed = props.onPeekViewClosed,
			experienceJoinData = {
				tileType = props.entry.tileType or gameCollectionItemTypes.GameCollectionItemType.EmphasisTile,
				nativeAdData = props.entry.adId
			}
		}

		props.navigateToGameDetails(universeId, v21)

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
	local v23 = useCallback(fn, {
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
		v19,
		if fFlagLuaAppEmphasisGameTileVideo then v20 else nil
	})

	local showDescription = props.showDescription or false

	local upVotes = v10 and v10.upVotes or 0
	local downVotes = v10 and v10.downVotes or 0

	local hasVerifiedBadge = v11 and v11.creator and v11.creator.hasVerifiedBadge
	local description = v11 and v11.description or ""
	local licenseDescription = if v11 then v11.licenseDescription or nil else nil
	local v24 = if v11 then v11.localizedFiatPrice or nil else nil

	local v25 = licenseDescription or v24

	local hideGameStats = props.hideGameStats or showDescription or v25 ~= nil

	local name = v9 and v9.creator and v9.creator.name

	if name == "" or not name then
		name = v11 and v11.creator and v11.creator.name
	end

	local v26 = v25 and 2 or 3
	local v27 = React.useMemo(function()
		local total = 0

		if name and name ~= "" then
			total += 1
		end

		if showDescription then
			total += v26
		end

		if not hideGameStats then
			total += 1
		end

		if v25 then
			total += 1
		end

		return total
	end, { name, showDescription, hideGameStats, v25, v26 })

	local isContained = props.isContained or false

	local playButtonHeight = GameTileViewConfig.getElementSizes(v6, props.textSizeOffset, 1, v7, true, v27).playButtonHeight

	local useCallback2 = React.useCallback
	local function fn2(...)
		if v19 then
			HoverTileCoordinator.default:reset()
		end

		if props.reportExperienceLaunched then
			props.reportExperienceLaunched(...)
		end

		if fFlagLuaAppEmphasisGameTileVideo then
			v20:reset(videoEndReason.ExperienceLaunched, nil, universeId, nil)
		end
	end

	local reportExperienceLaunched = props.reportExperienceLaunched
	local v29 = if fFlagLuaAppEmphasisGameTileVideo then universeId else nil
	local v31 = useCallback2(fn2, {
		v19,
		reportExperienceLaunched,
		v29,
		if fFlagLuaAppEmphasisGameTileVideo then v20 else nil
	})

	local v32 = React.useMemo(function()
		return React.createElement(AppExperienceActionRow, {
			universeId = universeId,
			referralSource = props.referralSource,
			launchSource = "FeaturedSearchTile",
			reportExperienceLaunched = v31,
			openGameDetails = v23,
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
		v31,
		v23,
		props.entry,
		props.launchExperienceEventContext,
		playButtonHeight,
		props.index,
		imageAspectRatio
	})

	local v33 = React.useMemo(function()
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

		local v35 = if v25 then React.createElement(GridTileTextFooter, {
			text = v25,
			LayoutOrder = 1,
			useLargerFont = true,
			isUnifiedGameTile = true
		}) else nil
		children.ExtraMetadata = v35

		children.CreatorName = React.createElement(CreatorNameMetadata, {
			name = name,
			hasVerifiedBadge = hasVerifiedBadge,
			LayoutOrder = 2
		})

		local createElement2 = React.createElement
		local v38 = {
			totalUpVotes = upVotes,
			totalDownVotes = downVotes,
			playerCount = 0
		}

		local v39 = if props.playerCountStyle == GameTileConstants.PlayerCountStyleValues.Footer then props.entry.playerCount else nil
		v38.playerCount = v39
		children.GameStats = createElement2(module4, {
			stats = v38,
			isGridTile = v15,
			hideGameStats = hideGameStats,
			gameTileLayoutType = gameTileLayoutType,
			LayoutOrder = 3,
			useLargerFont = true,
			isUnifiedGameTile = true
		})

		local v40 = if showDescription then React.createElement(GridTileTextFooter, {
			text = description,
			LayoutOrder = 4,
			linesOfText = v26,
			useLargerFont = true,
			isUnifiedGameTile = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			ClipsDescendants = true,
			TextWrapped = true
		}) else nil
		children.Description = v40
		return createElement(fragment, {}, children)
	end, {
		name,
		upVotes,
		downVotes,
		props.playerCountStyle,
		props.entry.playerCount,
		v15,
		hideGameStats,
		gameTileLayoutType,
		showDescription,
		description,
		v25,
		hasVerifiedBadge,
		v26
	})

	local state, setState = React.useState(Vector2.new(0, 0))

	local v34 = React.useMemo(function()
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
			v27,
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
		v27,
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
	local v35 = nil
	local v36 = nil
	local state3 = nil
	local v37 = nil
	local v38 = nil
	local v39 = nil

	local v40 = nil
	local v41, v42

	if fFlagLuaAppEmphasisGameTileVideo then
		v41 = props.videoPlaybackContext ~= nil and props.videoPlaybackContext.disablePlayback == true
		v42 = fFlagLuaAppSuppressVideoDetectorDuringScroll

		if v42 then
			if props.videoPlaybackContext == nil then
				v42 = false
			else
				v42 = props.videoPlaybackContext.disableDetectors == true
			end
		end

		local setState2
		state2, setState2 = React.useState(false)
		v35 = React.useCallback(function(p2)
			setState2(p2)
		end, {})

		if props.entry.primaryWideVideoAssetId then
			v36 = props.entry.primaryWideVideoAssetId
		else
			v36 = v14 and v14.primaryMediaAsset and v14.primaryMediaAsset.wideVideoAssetId
		end

		if fFlagLuaAppGameTileSelectionVideoPlayback then
			local setState3
			state3, setState3 = React.useState(false)
			v37 = setState3

			v38 = React.useCallback(function(...)
				v37(true)

				if props.onSelectionGained then
					props.onSelectionGained(...)
				end
			end, { props.onSelectionGained })

			v39 = React.useCallback(function(...)
				v37(false)

				if props.onSelectionLost then
					props.onSelectionLost(...)
				end
			end, { props.onSelectionLost })
		end

		if not fFlagLuaAppGameTileSelectionVideoPlayback and fFlagLuaAppEdpMediaGalleryVideoPreview then
			v40 = usePreferredInput()
		end

		React.useEffect(function()
			if v41 then
				setState2(false)
			end
		end, { v41 })
	else
		v41 = nil
	end

	local v43 = fFlagLuaAppEmphasisGameTileVideo and v36 ~= nil
	local v45 = if fFlagLuaAppEmphasisGameTileVideo then ref else ref2
	local videoPlaybackContext = props.videoPlaybackContext
	local v46

	if fFlagLuaAppTileVideoCandidateOnly then
		v46 = if fFlagLuaAppEmphasisGameTileVideo then v43 else false
	end

	useTagAsViewportAutoplayCandidate(
		v45,
		videoPlaybackContext,
		v46,
		nil,
		nil,
		nil,
		nil,
		fFlagLuaAppOneByTwoHoverIdleAutoplay and v43 and {
			videoKey = formatted,
			isUserIntentModeAutoplayCandidate = false
		} or nil
	)
	local v47, v48

	if fFlagLuaAppEmphasisGameTileVideo then
		if v43 then
			v47 = React.createElement(GameTileVideoThumbnail, {
				video = `rbxassetid://{v36}`,
				image = v17,
				playing = state2,
				looped = true,
				Size = UDim2.fromScale(1, 1),
				isTileContained = isContained,
				cornerRadius = v7.Radius.Medium,
				ZIndex = -2,
				itemIndex = props.index,
				videoAnalytics = props.videoAnalytics,
				universeId = universeId,
				videoPlaybackCoordinator = v20
			})
		end

		if v43 and not (v41 or fFlagLuaAppSuppressVideoDetectorDuringScroll and v42) then
			local createElement = React.createElement
			local v50 = {
				videoKey = formatted,
				itemIndex = props.index,
				universeId = tostring(universeId),
				tileRef = ref,
				isHoverSupported = v18,
				isHovered = v19,
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

			v50.isSelected = state3

			local v51 = if not (fFlagLuaAppGameTileSelectionVideoPlayback or not fFlagLuaAppEdpMediaGalleryVideoPreview) then v40 == Responsive.Input.Touch else nil
			v50.autoplay = v51

			v50.onPlaybackChange = v35
			v50.videoAnalytics = props.videoAnalytics
			v50.videoDwellTimeInSec = fIntLuaAppGameTileVideoDwellTimeInSec
			v50.videoVisiblePercent = fIntLuaAppGameTileVideoVisiblePercent
			v50.pageContext = props.appPage
			v50.videoPlaybackContext = props.videoPlaybackContext
			v48 = createElement(GameVideoPlaybackDetector, v50)
		end
	end

	local v49 = getTileBadgeByPositionConfigFromEntry(props.entry)
	local v50

	if v49 then
		v50 = React.createElement(GameTileThumbnailBadges, { tileBadgesByPosition = v49 })
	end

	local createElement = React.createElement
	local v52 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = -props.index
	}

	local createElement2 = React.createElement
	local v55 = {
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
	local v58 = {
		forwardRef = ref,
		SelectionOrder = props.SelectionOrder,
		isDisabled = props.isDisabled,
		onActivated = v23,
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
		v38 = props.onSelectionGained
	end

	v58.onSelectionGained = v38

	if not (fFlagLuaAppEmphasisGameTileVideo and fFlagLuaAppGameTileSelectionVideoPlayback) then
		v39 = props.onSelectionLost
	end

	v58.onSelectionLost = v39

	v58.image = v17

	if not fFlagLuaAppEmphasisGameTileVideo then
		v47 = nil
	end

	v58.thumbnailComponent = v47
	v58.title = title

	v58.numLinesForMetadata = v27
	v58.isHovered = v19
	v58.footerMetadata = v33

	v58.imageAspectRatio = imageAspectRatio
	v58.isContained = isContained

	if showDescription then
		v32 = nil
	end

	v58.extraFooterContent = v32

	if showDescription then
		v34 = nil
	end

	v58.extraFooterSpace = v34

	v58.reducedMotion = UserGameSettings.ReducedMotion
	v58.thumbnailOverlay = v50
	local v56 = {
		GameTileView = createElement3(module, v58),
		VideoPlaybackDetector = 0
	}

	if not fFlagLuaAppEmphasisGameTileVideo then
		v48 = nil
	end

	v56.VideoPlaybackDetector = v48
	return createElement("Frame", v52, {
		EmphasisTileContainer = createElement2("Frame", v55, v56)
	})
end
