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
local FFlagLuaAppFixCustomTileBugs = require(GameTileParent.SharedFlags).FFlagLuaAppFixCustomTileBugs
local FFlagLuaAppHomeThumbnailPrefetch = require(GameTileParent.SharedFlags).FFlagLuaAppHomeThumbnailPrefetch
local v40 = if not FFlagLuaAppHomeThumbnailPrefetch then nil else require(GameTile.resolveGameTileThumbnailUri)

return function(t1: {[any]: any}) -- line: 94
	-- upvalues: useDesignTokens (copy), useTokens (copy), useSelector (copy), GameInfosReducer (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), React (copy), ApiFetchGameDetails (copy), getGameTileLayoutData (copy), BigGameIconReducer (copy), FFlagLuaAppHomeThumbnailPrefetch (copy), v40 (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), GameTileViewConfig (copy), v35 (copy), IsVRAppBuild (copy), useIsHoveredTile (copy), HoverTileCoordinator (copy), GameCollectionItemTypes (copy), sponsoredGamesRecordClick (copy), AppExperienceActionRow (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), GameStats (copy), GameTileConstants (copy), v34 (copy), ImpressionsTagUtility (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), getTileBadgeByPositionConfigFromEntry (copy), GameTileThumbnailBadges (copy), GameTileView (copy), FFlagLuaAppFixCustomTileBugs (copy), UserGameSettings (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy)
	local v42 = useDesignTokens()
	local v43 = useTokens()
	local universeId = t1.entry.universeId
	local v45 = useSelector(function(p1) -- line: 102
		-- upvalues: GameInfosReducer (copy), universeId (copy)
		return p1.Personalization[GameInfosReducer.key][universeId]
	end)
	local v46 = useSelector(function(p2) -- line: 105
		-- upvalues: universeId (copy)
		return p2.GameDetails[universeId]
	end)
	local v47 = useRoactService(RoactNetworking)
	local v48 = useDispatch()

	React.useEffect(function() -- line: 111
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
	local v52 = useSelector(function(p3) -- line: 125
		-- upvalues: BigGameIconReducer (copy), universeId (copy)
		return p3[BigGameIconReducer.key][universeId] and p3[BigGameIconReducer.key][universeId].url or ""
	end)
	local v53

	if FFlagLuaAppHomeThumbnailPrefetch then
		v53 = v40({
			isEmphasized = true,
			iconUrl = v52,
			universeId = universeId,
			placeId = t1.entry.placeId,
			useGridTile = v51,
			perEntryWideAssetId = t1.entry.primaryWideImageAssetId,
			game = v45,
			topicId = t1.topicId
		})
	else
		local v54 = ((if not t1.entry.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v49) else t1.entry.primaryWideImageAssetId)) or (v45 and v45.primaryWideAssetId or nil)
		local v55 = formatExperienceThumbnail(v54, t1.entry.placeId, true)

		v53 = if not v51 then v52 else v55
	end

	local v56 = GameTileViewConfig.getImageAspectRatio(v50)
	local v57 = v49 and v49.title or (v45 and v45.name or "")
	local v58 = nil
	local u59 = nil

	if v35 then
		local v60 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v58 = React.useRef(nil)

		local v61 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v50 }`

		u59 = useIsHoveredTile(v58, v61, v60)
	end

	local v62 = React.useCallback(function() -- line: 168
		-- upvalues: v35 (copy), u59 (ref), HoverTileCoordinator (copy), t1 (copy), GameCollectionItemTypes (copy), universeId (copy), sponsoredGamesRecordClick (copy), v47 (copy)
		if v35 and u59 then
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
		if not v35 then nil else u59
	})

	if not v35 then
		local v63 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v58 = React.useRef(nil)

		local v64 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v50 }`

		u59 = useIsHoveredTile(v58, v64, v63)
	end

	local v65 = t1.showDescription or false
	local v66 = v45 and v45.totalUpVotes or 0
	local v67 = v45 and v45.totalDownVotes or 0
	local v68 = v46 and (v46.creator and v46.creator.hasVerifiedBadge)
	local v69 = v46 and v46.description or ""
	local v70 = v46 and v46.licenseDescription or nil
	local v71 = v46 and v46.localizedFiatPrice or nil
	local v72 = v70 or v71
	local v73 = t1.hideGameStats or (v65 or v72 ~= nil)
	local v74 = v45 and (v45.creatorName ~= "" and v45.creatorName) or v46 and (v46.creator and v46.creator.name)
	local v75 = not v72 and 3 or 2
	local v76 = React.useMemo(function() -- line: 240
		-- upvalues: v74 (copy), v65 (copy), v75 (copy), v73 (copy), v72 (copy)
		local n1 = 0

		if v74 and v74 ~= "" then
			n1 += 1
		end

		if v65 then
			n1 += v75
		end

		if not v73 then
			n1 += 1
		end

		if v72 then
			n1 += 1
		end

		return n1
	end, {
		v74,
		v65,
		v73,
		v72,
		v75
	})
	local v77 = t1.isContained or false
	local playButtonHeight = GameTileViewConfig.getElementSizes(v42, t1.textSizeOffset, 1, v43, true, v76).playButtonHeight
	local v79 = if not v35 then nil else React.useCallback(function(...) -- line: 274
		-- upvalues: u59 (ref), HoverTileCoordinator (copy), t1 (copy)
		if u59 then
			HoverTileCoordinator.default:reset()
		end

		if t1.reportExperienceLaunched then
			t1.reportExperienceLaunched(...)
		end
	end, {
		u59,
		t1.reportExperienceLaunched
	})
	local v80 = React.useMemo(function() -- line: 286
		-- upvalues: React (copy), AppExperienceActionRow (copy), universeId (copy), t1 (copy), v35 (copy), v79 (copy), v62 (copy), v56 (copy), playButtonHeight (copy)
		return React.createElement(AppExperienceActionRow, {
			launchSource = "FeaturedSearchTile",
			horizontalPadding = 0,
			verticalPadding = 0,
			isUnifiedGameTileEnabled = true,
			universeId = universeId,
			referralSource = t1.referralSource,
			reportExperienceLaunched = if not v35 then t1.reportExperienceLaunched else v79,
			openGameDetails = v62,
			entry = t1.entry,
			launchExperienceEventContext = t1.launchExperienceEventContext,
			showButtonText = v56 > 1,
			height = playButtonHeight,
			index = t1.index
		})
	end, {
		universeId,
		t1.referralSource,
		if not v35 then t1.reportExperienceLaunched else v79,
		v62,
		t1.entry,
		t1.launchExperienceEventContext,
		playButtonHeight,
		t1.index,
		v56
	})
	local v81 = React.useMemo(function() -- line: 319
		-- upvalues: React (copy), v72 (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), v74 (copy), v68 (copy), GameStats (copy), v66 (copy), v67 (copy), t1 (copy), GameTileConstants (copy), v51 (copy), v73 (copy), v50 (copy), v65 (copy), v69 (copy), v75 (copy), v34 (copy)
		return React.createElement(React.Fragment, {}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ExtraMetadata = if not v72 then nil else React.createElement(GridTileTextFooter, {
				LayoutOrder = 1,
				useLargerFont = true,
				isUnifiedGameTile = true,
				text = v72
			}),
			CreatorName = React.createElement(CreatorNameMetadata, {
				LayoutOrder = 2,
				name = v74,
				hasVerifiedBadge = v68
			}),
			GameStats = React.createElement(GameStats, {
				LayoutOrder = 3,
				useLargerFont = true,
				isUnifiedGameTile = true,
				stats = {
					totalUpVotes = v66,
					totalDownVotes = v67,
					playerCount = if t1.playerCountStyle ~= GameTileConstants.PlayerCountStyleValues.Footer then nil else t1.entry.playerCount
				},
				isGridTile = v51,
				hideGameStats = v73,
				gameTileLayoutType = v50
			}),
			Description = if not v65 then nil else React.createElement(GridTileTextFooter, {
				LayoutOrder = 4,
				useLargerFont = true,
				isUnifiedGameTile = true,
				ClipsDescendants = true,
				text = v69,
				linesOfText = v75,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = not not v34 or nil
			})
		})
	end, {
		v74,
		v66,
		v67,
		t1.playerCountStyle,
		t1.entry.playerCount,
		v51,
		v73,
		v50,
		v65,
		v69,
		v72,
		v68,
		v75
	})
	local v82, v83 = React.useState(Vector2.new(0, 0))
	local v84 = React.useMemo(function() -- line: 388
		-- upvalues: GameTileViewConfig (copy), v42 (copy), v82 (copy), v50 (copy), v77 (copy), t1 (copy), v76 (copy), v43 (copy)
		local v93 = GameTileViewConfig.getTileHeight(v42, v82.X, v50, v77, false, false, t1.textSizeOffset, nil, 1, v76, v43, true)

		return v82.Y - v93
	end, {
		v42,
		v82,
		v50,
		v77,
		t1.textSizeOffset,
		1,
		v76,
		v43
	})
	local v85 = React.useRef(nil)

	React.useEffect(function() -- line: 419
		-- upvalues: ImpressionsTagUtility (copy), v85 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v85, t1.impressionsTag, t1.index)

		return function() -- line: 421
			-- upvalues: ImpressionsTagUtility (copy), v85 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v85, t1.impressionsTag, t1.index)
		end
	end, {
		t1.impressionsTag,
		t1.index
	})
	useTagAsViewportAutoplayCandidate(v85, t1.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)

	local v86 = nil
	local v87 = getTileBadgeByPositionConfigFromEntry(t1.entry)

	if v87 then
		v86 = React.createElement(GameTileThumbnailBadges, {
			tileBadgesByPosition = v87
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
			ref = v85,
			[React.Change.AbsoluteSize] = function(p4) -- line: 454
				-- upvalues: v83 (copy)
				v83(p4.AbsoluteSize)
			end
		}, {
			GameTileView = React.createElement(GameTileView, {
				numLinesForTitle = 1,
				isUnifiedGameTile = true,
				hidePlayButton = true,
				forwardRef = v58,
				selectionOrder = if not FFlagLuaAppFixCustomTileBugs then t1.selectionOrder else nil,
				SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t1.SelectionOrder,
				isDisabled = t1.isDisabled,
				onActivated = v62,
				onSelectionGained = t1.onSelectionGained,
				onSelectionLost = t1.onSelectionLost,
				image = v53,
				title = v57,
				numLinesForMetadata = v76,
				isHovered = u59,
				footerMetadata = v81,
				imageAspectRatio = v56,
				isContained = v77,
				extraFooterContent = if not v65 then v80 else nil,
				extraFooterSpace = if not v65 then v84 else nil,
				reducedMotion = UserGameSettings.ReducedMotion,
				thumbnailOverlay = v86,
				onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded
			})
		})
	})
end
