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
local FFlagLuaAppGameTileLockedBadge = require(GameTileParent.SharedFlags).FFlagLuaAppGameTileLockedBadge
local v36 = game:DefineFastFlag("LuaAppFixEmphasisHoverLogic", false)
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(GameTileParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomeTouchAutoplay = require(GameTileParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppTileVideoCandidateOnly = require(GameTileParent.SharedFlags).FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppFixCustomTileBugs = require(GameTileParent.SharedFlags).FFlagLuaAppFixCustomTileBugs

return function(t1: {[any]: any}) -- line: 92
	-- upvalues: useDesignTokens (copy), useTokens (copy), useSelector (copy), GameInfosReducer (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), React (copy), ApiFetchGameDetails (copy), getGameTileLayoutData (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), BigGameIconReducer (copy), GameTileViewConfig (copy), v36 (copy), IsVRAppBuild (copy), useIsHoveredTile (copy), HoverTileCoordinator (copy), GameCollectionItemTypes (copy), sponsoredGamesRecordClick (copy), AppExperienceActionRow (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), GameStats (copy), GameTileConstants (copy), v34 (copy), ImpressionsTagUtility (copy), FFlagLuaAppHomeTouchAutoplay (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), FFlagLuaAppGameTileLockedBadge (copy), getTileBadgeByPositionConfigFromEntry (copy), GameTileThumbnailBadges (copy), GameTileView (copy), FFlagLuaAppFixCustomTileBugs (copy), UserGameSettings (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy)
	local v42 = useDesignTokens()
	local v43 = useTokens()
	local universeId = t1.entry.universeId
	local v45 = useSelector(function(p1) -- line: 100
		-- upvalues: GameInfosReducer (copy), universeId (copy)
		return p1.Personalization[GameInfosReducer.key][universeId]
	end)
	local v46 = useSelector(function(p2) -- line: 103
		-- upvalues: universeId (copy)
		return p2.GameDetails[universeId]
	end)
	local v47 = useRoactService(RoactNetworking)
	local v48 = useDispatch()

	React.useEffect(function() -- line: 109
		-- upvalues: v46 (copy), v48 (copy), ApiFetchGameDetails (copy), v47 (copy), universeId (copy)
		if v46 then
			return
		end

		v48(ApiFetchGameDetails.Fetch(v47, { universeId }))
	end, {
		v46,
		universeId,
		v47,
		v48
	})

	local v49 = getGameTileLayoutData(v45, t1.topicId)
	local v50 = t1.gameTileLayoutType or "Narrow"
	local v51 = v50 == "Wide" or v50 == "Event"
	local v52 = ((if not t1.entry.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v49) else t1.entry.primaryWideImageAssetId)) or (v45 and v45.primaryWideAssetId or nil)
	local v53 = formatExperienceThumbnail(v52, t1.entry.placeId, true)
	local v54 = useSelector(function(p3) -- line: 130
		-- upvalues: BigGameIconReducer (copy), universeId (copy)
		return p3[BigGameIconReducer.key][universeId] and p3[BigGameIconReducer.key][universeId].url or ""
	end)
	local v55 = GameTileViewConfig.getImageAspectRatio(v50)
	local v56 = v49 and v49.title or (v45 and v45.name or "")
	local v57 = nil
	local u58 = nil

	if v36 then
		local v59 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v57 = React.useRef(nil)

		local v60 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v50 }`

		u58 = useIsHoveredTile(v57, v60, v59)
	end

	local v61 = React.useCallback(function() -- line: 153
		-- upvalues: v36 (copy), u58 (ref), HoverTileCoordinator (copy), t1 (copy), GameCollectionItemTypes (copy), universeId (copy), sponsoredGamesRecordClick (copy), v47 (copy)
		if v36 and u58 then
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
			sponsoredGamesRecordClick(v47, t1.entry.adId)
		end
	end, {
		universeId,
		t1.source,
		t1.onPeekViewClosed,
		t1.entry.isSponsored,
		t1.entry.adId,
		t1.reportGameDetailOpened,
		v47,
		t1.navigateToGameDetails,
		t1.referralSource,
		t1.index,
		if not v36 then nil else u58
	})

	if not v36 then
		local v62 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v57 = React.useRef(nil)

		local v63 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v50 }`

		u58 = useIsHoveredTile(v57, v63, v62)
	end

	local v64 = t1.showDescription or false
	local v65 = v45 and v45.totalUpVotes or 0
	local v66 = v45 and v45.totalDownVotes or 0
	local v67 = v46 and (v46.creator and v46.creator.hasVerifiedBadge)
	local v68 = v46 and v46.description or ""
	local v69 = v46 and v46.licenseDescription or nil
	local v70 = v46 and v46.localizedFiatPrice or nil
	local v71 = v69 or v70
	local v72 = t1.hideGameStats or (v64 or v71 ~= nil)
	local v73 = v45 and (v45.creatorName ~= "" and v45.creatorName) or v46 and (v46.creator and v46.creator.name)
	local v74 = not v71 and 3 or 2
	local v75 = React.useMemo(function() -- line: 225
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
	local playButtonHeight = GameTileViewConfig.getElementSizes(v42, t1.textSizeOffset, 1, v43, true, v75).playButtonHeight
	local v78 = if not v36 then nil else React.useCallback(function(...) -- line: 259
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
	local v79 = React.useMemo(function() -- line: 271
		-- upvalues: React (copy), AppExperienceActionRow (copy), universeId (copy), t1 (copy), v36 (copy), v78 (copy), v61 (copy), v55 (copy), playButtonHeight (copy)
		return React.createElement(AppExperienceActionRow, {
			launchSource = "FeaturedSearchTile",
			horizontalPadding = 0,
			verticalPadding = 0,
			isUnifiedGameTileEnabled = true,
			universeId = universeId,
			referralSource = t1.referralSource,
			reportExperienceLaunched = if not v36 then t1.reportExperienceLaunched else v78,
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
		if not v36 then t1.reportExperienceLaunched else v78,
		v61,
		t1.entry,
		t1.launchExperienceEventContext,
		playButtonHeight,
		t1.index,
		v55
	})
	local v80 = React.useMemo(function() -- line: 304
		-- upvalues: React (copy), v71 (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), v73 (copy), v67 (copy), GameStats (copy), v65 (copy), v66 (copy), t1 (copy), GameTileConstants (copy), v51 (copy), v72 (copy), v50 (copy), v64 (copy), v68 (copy), v74 (copy), v34 (copy)
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
				isGridTile = v51,
				hideGameStats = v72,
				gameTileLayoutType = v50
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
		v51,
		v72,
		v50,
		v64,
		v68,
		v71,
		v67,
		v74
	})
	local v81, v82 = React.useState(Vector2.new(0, 0))
	local v83 = React.useMemo(function() -- line: 373
		-- upvalues: GameTileViewConfig (copy), v42 (copy), v81 (copy), v50 (copy), v76 (copy), t1 (copy), v75 (copy), v43 (copy)
		local v92 = GameTileViewConfig.getTileHeight(v42, v81.X, v50, v76, false, false, t1.textSizeOffset, nil, 1, v75, v43, true)

		return v81.Y - v92
	end, {
		v42,
		v81,
		v50,
		v76,
		t1.textSizeOffset,
		1,
		v75,
		v43
	})
	local v84 = React.useRef(nil)

	React.useEffect(function() -- line: 404
		-- upvalues: ImpressionsTagUtility (copy), v84 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v84, t1.impressionsTag, t1.index)

		return function() -- line: 406
			-- upvalues: ImpressionsTagUtility (copy), v84 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v84, t1.impressionsTag, t1.index)
		end
	end, {
		t1.impressionsTag,
		t1.index
	})

	if FFlagLuaAppHomeTouchAutoplay then
		useTagAsViewportAutoplayCandidate(v84, t1.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)
	end

	local v85 = nil

	if FFlagLuaAppGameTileLockedBadge then
		local v86 = getTileBadgeByPositionConfigFromEntry(t1.entry)

		if v86 then
			v85 = React.createElement(GameTileThumbnailBadges, {
				tileBadgesByPosition = v86
			})
		end
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
			[React.Change.AbsoluteSize] = function(p4) -- line: 443
				-- upvalues: v82 (copy)
				v82(p4.AbsoluteSize)
			end
		}, {
			GameTileView = React.createElement(GameTileView, {
				numLinesForTitle = 1,
				isUnifiedGameTile = true,
				hidePlayButton = true,
				forwardRef = v57,
				selectionOrder = if not FFlagLuaAppFixCustomTileBugs then t1.selectionOrder else nil,
				SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t1.SelectionOrder,
				isDisabled = t1.isDisabled,
				onActivated = v61,
				onSelectionGained = t1.onSelectionGained,
				onSelectionLost = t1.onSelectionLost,
				image = if not v51 then v54 else v53,
				title = v56,
				numLinesForMetadata = v75,
				isHovered = u58,
				footerMetadata = v80,
				imageAspectRatio = v55,
				isContained = v76,
				extraFooterContent = if not v64 then v79 else nil,
				extraFooterSpace = if not v64 then v83 else nil,
				reducedMotion = UserGameSettings.ReducedMotion,
				thumbnailOverlay = if not FFlagLuaAppGameTileLockedBadge then nil else v85,
				onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded
			})
		})
	})
end
