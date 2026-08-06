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
local GameTileParent = GameTile.Parent
local GameCollectionItemTypes = require(GameTileParent.DiscoveryTypes).GameCollectionItemTypes
local React = require(GameTileParent.React)
local RoactUtils = require(GameTileParent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local GameInfosReducer = require(GameTileParent.GameInfosRodux).GameInfosReducer
local BigGameIconReducer = require(GameTileParent.GameIconRodux).BigGameIcons.BigGameIconReducer
local ApiFetchGameDetails = require(GameTileParent.GameDetailRodux).GameDetails.ApiFetchGameDetails
local RoactNetworking = require(GameTileParent.RoactServiceTags).RoactNetworking
local useRoactService = require(GameTileParent.RobloxAppHooks).useRoactService
local ImpressionsTagUtility = require(GameTileParent.Impressions).ImpressionsTagUtility
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local IsVRAppBuild = require(GameTileParent.AppCommonLib).IsVRAppBuild
local sponsoredGamesRecordClick = require(GameTileParent.DiscoveryAnalytics).Requests.sponsoredGamesRecordClick
local useTagAsViewportAutoplayCandidate = require(GameTileParent.VideoUtils).useTagAsViewportAutoplayCandidate
local GameTileThumbnailBadges = require(GameTile.Overlays.GameTileThumbnailBadges)
local v34 = game:DefineFastFlag("WrapEmphasisTileDescriptionText", false)
local v35 = game:DefineFastFlag("LuaAppFixEmphasisHoverLogic", false)
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(GameTileParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppTileVideoCandidateOnly = require(GameTileParent.SharedFlags).FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppHomeThumbnailPrefetch = require(GameTileParent.SharedFlags).FFlagLuaAppHomeThumbnailPrefetch
local v39 = if not FFlagLuaAppHomeThumbnailPrefetch then nil else require(GameTile.resolveGameTileThumbnailUri)

return function(t1: {[any]: any}) -- line: 91
	-- upvalues: useDesignTokens (copy), useTokens (copy), useSelector (copy), GameInfosReducer (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), React (copy), ApiFetchGameDetails (copy), getGameTileLayoutData (copy), BigGameIconReducer (copy), FFlagLuaAppHomeThumbnailPrefetch (copy), v39 (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), GameTileViewConfig (copy), v35 (copy), IsVRAppBuild (copy), useIsHoveredTile (copy), HoverTileCoordinator (copy), GameCollectionItemTypes (copy), sponsoredGamesRecordClick (copy), AppExperienceActionRow (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), GameStats (copy), GameTileConstants (copy), v34 (copy), ImpressionsTagUtility (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), getTileBadgeByPositionConfigFromEntry (copy), GameTileThumbnailBadges (copy), GameTileView (copy), UserGameSettings (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy)
	local v41 = useDesignTokens()
	local v42 = useTokens()
	local universeId = t1.entry.universeId
	local v44 = useSelector(function(p1) -- line: 99
		-- upvalues: GameInfosReducer (copy), universeId (copy)
		return p1.Personalization[GameInfosReducer.key][universeId]
	end)
	local v45 = useSelector(function(p2) -- line: 102
		-- upvalues: universeId (copy)
		return p2.GameDetails[universeId]
	end)
	local v46 = useRoactService(RoactNetworking)
	local v47 = useDispatch()

	React.useEffect(function() -- line: 108
		-- upvalues: v45 (copy), v47 (copy), ApiFetchGameDetails (copy), v46 (copy), universeId (copy)
		if v45 then
			return
		end

		v47(ApiFetchGameDetails.Fetch(v46, { universeId }))
	end, {
		v45,
		universeId,
		v46,
		v47
	})

	local v48 = getGameTileLayoutData(v44, t1.topicId)
	local v49 = t1.gameTileLayoutType or "Narrow"
	local v50 = v49 == "Wide" or v49 == "Event"
	local v51 = useSelector(function(p3) -- line: 122
		-- upvalues: BigGameIconReducer (copy), universeId (copy)
		return p3[BigGameIconReducer.key][universeId] and p3[BigGameIconReducer.key][universeId].url or ""
	end)
	local v52

	if FFlagLuaAppHomeThumbnailPrefetch then
		v52 = v39({
			isEmphasized = true,
			iconUrl = v51,
			universeId = universeId,
			placeId = t1.entry.placeId,
			useGridTile = v50,
			perEntryWideAssetId = t1.entry.primaryWideImageAssetId,
			game = v44,
			topicId = t1.topicId
		})
	else
		local v53 = ((if not t1.entry.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v48) else t1.entry.primaryWideImageAssetId)) or (v44 and v44.primaryWideAssetId or nil)
		local v54 = formatExperienceThumbnail(v53, t1.entry.placeId, true)

		v52 = if not v50 then v51 else v54
	end

	local v55 = GameTileViewConfig.getImageAspectRatio(v49)
	local v56 = v48 and v48.title or (v44 and v44.name or "")
	local v57 = nil
	local u58 = nil

	if v35 then
		local v59 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v57 = React.useRef(nil)

		local v60 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v49 }`

		u58 = useIsHoveredTile(v57, v60, v59)
	end

	local v61 = React.useCallback(function() -- line: 165
		-- upvalues: v35 (copy), u58 (ref), HoverTileCoordinator (copy), t1 (copy), GameCollectionItemTypes (copy), universeId (copy), sponsoredGamesRecordClick (copy), v46 (copy)
		if v35 and u58 then
			HoverTileCoordinator.default:reset()
		end

		local t2 = {
			source = t1.source,
			index = t1.index,
			referralSource = t1.referralSource,
			onPeekViewClosed = t1.onPeekViewClosed,
			experienceJoinData = {
				tileType = t1.entry.tileType or GameCollectionItemTypes.GameCollectionItemType.EmphasisTile,
				nativeAdData = t1.entry.adId
			}
		}

		t1.navigateToGameDetails(universeId, t2)
		t1.reportGameDetailOpened(t1.index, universeId)

		if t1.entry.isSponsored then
			sponsoredGamesRecordClick(v46, t1.entry.adId)
		end
	end, {
		universeId,
		t1.source,
		t1.onPeekViewClosed,
		t1.entry.isSponsored,
		t1.entry.adId,
		t1.reportGameDetailOpened,
		v46,
		t1.navigateToGameDetails,
		t1.referralSource,
		t1.index,
		if not v35 then nil else u58
	})

	if not v35 then
		local v62 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v57 = React.useRef(nil)

		local v63 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v49 }`

		u58 = useIsHoveredTile(v57, v63, v62)
	end

	local v64 = t1.showDescription or false
	local v65 = v44 and v44.totalUpVotes or 0
	local v66 = v44 and v44.totalDownVotes or 0
	local v67 = v45 and (v45.creator and v45.creator.hasVerifiedBadge)
	local v68 = v45 and v45.description or ""
	local v69 = v45 and v45.licenseDescription or nil
	local v70 = v45 and v45.localizedFiatPrice or nil
	local v71 = v69 or v70
	local v72 = t1.hideGameStats or (v64 or v71 ~= nil)
	local v73 = v44 and (v44.creatorName ~= "" and v44.creatorName) or v45 and (v45.creator and v45.creator.name)
	local v74 = not v71 and 3 or 2
	local v75 = React.useMemo(function() -- line: 237
		-- upvalues: v73 (copy), v64 (copy), v74 (copy), v72 (copy), v71 (copy)
		local n1 = 0

		if v73 and v73 ~= "" then
			n1 += 1
		end

		if v64 then
			n1 += v74
		end

		if not v72 then
			n1 += 1
		end

		if v71 then
			n1 += 1
		end

		return n1
	end, {
		v73,
		v64,
		v72,
		v71,
		v74
	})
	local v76 = t1.isContained or false
	local playButtonHeight = GameTileViewConfig.getElementSizes(v41, t1.textSizeOffset, 1, v42, true, v75).playButtonHeight
	local v78 = if not v35 then nil else React.useCallback(function(...) -- line: 271
		-- upvalues: u58 (ref), HoverTileCoordinator (copy), t1 (copy)
		if u58 then
			HoverTileCoordinator.default:reset()
		end

		if t1.reportExperienceLaunched then
			t1.reportExperienceLaunched(...)
		end
	end, {
		u58,
		t1.reportExperienceLaunched
	})
	local v79 = React.useMemo(function() -- line: 283
		-- upvalues: React (copy), AppExperienceActionRow (copy), universeId (copy), t1 (copy), v35 (copy), v78 (copy), v61 (copy), v55 (copy), playButtonHeight (copy)
		return React.createElement(AppExperienceActionRow, {
			launchSource = "FeaturedSearchTile",
			horizontalPadding = 0,
			verticalPadding = 0,
			isUnifiedGameTileEnabled = true,
			universeId = universeId,
			referralSource = t1.referralSource,
			reportExperienceLaunched = if not v35 then t1.reportExperienceLaunched else v78,
			openGameDetails = v61,
			entry = t1.entry,
			launchExperienceEventContext = t1.launchExperienceEventContext,
			showButtonText = v55 > 1,
			height = playButtonHeight,
			index = t1.index
		})
	end, {
		universeId,
		t1.referralSource,
		if not v35 then t1.reportExperienceLaunched else v78,
		v61,
		t1.entry,
		t1.launchExperienceEventContext,
		playButtonHeight,
		t1.index,
		v55
	})
	local v80 = React.useMemo(function() -- line: 316
		-- upvalues: React (copy), v71 (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), v73 (copy), v67 (copy), GameStats (copy), v65 (copy), v66 (copy), t1 (copy), GameTileConstants (copy), v50 (copy), v72 (copy), v49 (copy), v64 (copy), v68 (copy), v74 (copy), v34 (copy)
		return React.createElement(React.Fragment, {}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ExtraMetadata = if not v71 then nil else React.createElement(GridTileTextFooter, {
				LayoutOrder = 1,
				useLargerFont = true,
				isUnifiedGameTile = true,
				text = v71
			}),
			CreatorName = React.createElement(CreatorNameMetadata, {
				LayoutOrder = 2,
				name = v73,
				hasVerifiedBadge = v67
			}),
			GameStats = React.createElement(GameStats, {
				LayoutOrder = 3,
				useLargerFont = true,
				isUnifiedGameTile = true,
				stats = {
					totalUpVotes = v65,
					totalDownVotes = v66,
					playerCount = if t1.playerCountStyle ~= GameTileConstants.PlayerCountStyleValues.Footer then nil else t1.entry.playerCount
				},
				isGridTile = v50,
				hideGameStats = v72,
				gameTileLayoutType = v49
			}),
			Description = if not v64 then nil else React.createElement(GridTileTextFooter, {
				LayoutOrder = 4,
				useLargerFont = true,
				isUnifiedGameTile = true,
				ClipsDescendants = true,
				text = v68,
				linesOfText = v74,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = not not v34 or nil
			})
		})
	end, {
		v73,
		v65,
		v66,
		t1.playerCountStyle,
		t1.entry.playerCount,
		v50,
		v72,
		v49,
		v64,
		v68,
		v71,
		v67,
		v74
	})
	local v81, v82 = React.useState(Vector2.new(0, 0))
	local v83 = React.useMemo(function() -- line: 385
		-- upvalues: GameTileViewConfig (copy), v41 (copy), v81 (copy), v49 (copy), v76 (copy), t1 (copy), v75 (copy), v42 (copy)
		local v92 = GameTileViewConfig.getTileHeight(v41, v81.X, v49, v76, false, false, t1.textSizeOffset, nil, 1, v75, v42, true)

		return v81.Y - v92
	end, {
		v41,
		v81,
		v49,
		v76,
		t1.textSizeOffset,
		1,
		v75,
		v42
	})
	local v84 = React.useRef(nil)

	React.useEffect(function() -- line: 416
		-- upvalues: ImpressionsTagUtility (copy), v84 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v84, t1.impressionsTag, t1.index)

		return function() -- line: 418
			-- upvalues: ImpressionsTagUtility (copy), v84 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v84, t1.impressionsTag, t1.index)
		end
	end, {
		t1.impressionsTag,
		t1.index
	})
	useTagAsViewportAutoplayCandidate(v84, t1.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)

	local v85 = nil
	local v86 = getTileBadgeByPositionConfigFromEntry(t1.entry)

	if v86 then
		v85 = React.createElement(GameTileThumbnailBadges, {
			tileBadgesByPosition = v86
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		ZIndex = -t1.index
	}, {
		EmphasisTileContainer = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromScale(0, 0),
			Size = t1.size,
			BackgroundTransparency = 1,
			ref = v84,
			[React.Change.AbsoluteSize] = function(p4) -- line: 451
				-- upvalues: v82 (copy)
				v82(p4.AbsoluteSize)
			end
		}, {
			GameTileView = React.createElement(GameTileView, {
				numLinesForTitle = 1,
				isUnifiedGameTile = true,
				hidePlayButton = true,
				forwardRef = v57,
				SelectionOrder = t1.SelectionOrder,
				isDisabled = t1.isDisabled,
				onActivated = v61,
				onSelectionGained = t1.onSelectionGained,
				onSelectionLost = t1.onSelectionLost,
				image = v52,
				title = v56,
				numLinesForMetadata = v75,
				isHovered = u58,
				footerMetadata = v80,
				imageAspectRatio = v55,
				isContained = v76,
				extraFooterContent = if not v64 then v79 else nil,
				extraFooterSpace = if not v64 then v83 else nil,
				reducedMotion = UserGameSettings.ReducedMotion,
				thumbnailOverlay = v85,
				onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded
			})
		})
	})
end
