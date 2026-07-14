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
local FFlagLuaAppHomeTouchAutoplay = require(GameTileParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppTileVideoCandidateOnly = require(GameTileParent.SharedFlags).FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppFixCustomTileBugs = require(GameTileParent.SharedFlags).FFlagLuaAppFixCustomTileBugs

return function(t1: {[any]: any}) -- line: 91
	-- upvalues: useDesignTokens (copy), useTokens (copy), useSelector (copy), GameInfosReducer (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), React (copy), ApiFetchGameDetails (copy), getGameTileLayoutData (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), BigGameIconReducer (copy), GameTileViewConfig (copy), v35 (copy), IsVRAppBuild (copy), useIsHoveredTile (copy), HoverTileCoordinator (copy), GameCollectionItemTypes (copy), sponsoredGamesRecordClick (copy), AppExperienceActionRow (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), GameStats (copy), GameTileConstants (copy), v34 (copy), ImpressionsTagUtility (copy), FFlagLuaAppHomeTouchAutoplay (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), getTileBadgeByPositionConfigFromEntry (copy), GameTileThumbnailBadges (copy), GameTileView (copy), FFlagLuaAppFixCustomTileBugs (copy), UserGameSettings (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy)
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
	local v51 = ((if not t1.entry.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v48) else t1.entry.primaryWideImageAssetId)) or (v44 and v44.primaryWideAssetId or nil)
	local v52 = formatExperienceThumbnail(v51, t1.entry.placeId, true)
	local v53 = useSelector(function(p3) -- line: 129
		-- upvalues: BigGameIconReducer (copy), universeId (copy)
		return p3[BigGameIconReducer.key][universeId] and p3[BigGameIconReducer.key][universeId].url or ""
	end)
	local v54 = GameTileViewConfig.getImageAspectRatio(v49)
	local v55 = v48 and v48.title or (v44 and v44.name or "")
	local v56 = nil
	local u57 = nil

	if v35 then
		local v58 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v56 = React.useRef(nil)

		local v59 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v49 }`

		u57 = useIsHoveredTile(v56, v59, v58)
	end

	local v60 = React.useCallback(function() -- line: 152
		-- upvalues: v35 (copy), u57 (ref), HoverTileCoordinator (copy), t1 (copy), GameCollectionItemTypes (copy), universeId (copy), sponsoredGamesRecordClick (copy), v46 (copy)
		if v35 and u57 then
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
		if not v35 then nil else u57
	})

	if not v35 then
		local v61 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v56 = React.useRef(nil)

		local v62 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v49 }`

		u57 = useIsHoveredTile(v56, v62, v61)
	end

	local v63 = t1.showDescription or false
	local v64 = v44 and v44.totalUpVotes or 0
	local v65 = v44 and v44.totalDownVotes or 0
	local v66 = v45 and (v45.creator and v45.creator.hasVerifiedBadge)
	local v67 = v45 and v45.description or ""
	local v68 = v45 and v45.licenseDescription or nil
	local v69 = v45 and v45.localizedFiatPrice or nil
	local v70 = v68 or v69
	local v71 = t1.hideGameStats or (v63 or v70 ~= nil)
	local v72 = v44 and (v44.creatorName ~= "" and v44.creatorName) or v45 and (v45.creator and v45.creator.name)
	local v73 = not v70 and 3 or 2
	local v74 = React.useMemo(function() -- line: 224
		-- upvalues: v72 (copy), v63 (copy), v73 (copy), v71 (copy), v70 (copy)
		local n1 = 0

		if v72 and v72 ~= "" then
			n1 += 1
		end

		if v63 then
			n1 += v73
		end

		if not v71 then
			n1 += 1
		end

		if v70 then
			n1 += 1
		end

		return n1
	end, {
		v72,
		v63,
		v71,
		v70,
		v73
	})
	local v75 = t1.isContained or false
	local playButtonHeight = GameTileViewConfig.getElementSizes(v41, t1.textSizeOffset, 1, v42, true, v74).playButtonHeight
	local v77 = if not v35 then nil else React.useCallback(function(...) -- line: 258
		-- upvalues: u57 (ref), HoverTileCoordinator (copy), t1 (copy)
		if u57 then
			HoverTileCoordinator.default:reset()
		end

		if t1.reportExperienceLaunched then
			t1.reportExperienceLaunched(...)
		end
	end, {
		u57,
		t1.reportExperienceLaunched
	})
	local v78 = React.useMemo(function() -- line: 270
		-- upvalues: React (copy), AppExperienceActionRow (copy), universeId (copy), t1 (copy), v35 (copy), v77 (copy), v60 (copy), v54 (copy), playButtonHeight (copy)
		return React.createElement(AppExperienceActionRow, {
			launchSource = "FeaturedSearchTile",
			horizontalPadding = 0,
			verticalPadding = 0,
			isUnifiedGameTileEnabled = true,
			universeId = universeId,
			referralSource = t1.referralSource,
			reportExperienceLaunched = if not v35 then t1.reportExperienceLaunched else v77,
			openGameDetails = v60,
			entry = t1.entry,
			launchExperienceEventContext = t1.launchExperienceEventContext,
			showButtonText = v54 > 1,
			height = playButtonHeight,
			index = t1.index
		})
	end, {
		universeId,
		t1.referralSource,
		if not v35 then t1.reportExperienceLaunched else v77,
		v60,
		t1.entry,
		t1.launchExperienceEventContext,
		playButtonHeight,
		t1.index,
		v54
	})
	local v79 = React.useMemo(function() -- line: 303
		-- upvalues: React (copy), v70 (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), v72 (copy), v66 (copy), GameStats (copy), v64 (copy), v65 (copy), t1 (copy), GameTileConstants (copy), v50 (copy), v71 (copy), v49 (copy), v63 (copy), v67 (copy), v73 (copy), v34 (copy)
		return React.createElement(React.Fragment, {}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ExtraMetadata = if not v70 then nil else React.createElement(GridTileTextFooter, {
				LayoutOrder = 1,
				useLargerFont = true,
				isUnifiedGameTile = true,
				text = v70
			}),
			CreatorName = React.createElement(CreatorNameMetadata, {
				LayoutOrder = 2,
				name = v72,
				hasVerifiedBadge = v66
			}),
			GameStats = React.createElement(GameStats, {
				LayoutOrder = 3,
				useLargerFont = true,
				isUnifiedGameTile = true,
				stats = {
					totalUpVotes = v64,
					totalDownVotes = v65,
					playerCount = if t1.playerCountStyle ~= GameTileConstants.PlayerCountStyleValues.Footer then nil else t1.entry.playerCount
				},
				isGridTile = v50,
				hideGameStats = v71,
				gameTileLayoutType = v49
			}),
			Description = if not v63 then nil else React.createElement(GridTileTextFooter, {
				LayoutOrder = 4,
				useLargerFont = true,
				isUnifiedGameTile = true,
				ClipsDescendants = true,
				text = v67,
				linesOfText = v73,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = not not v34 or nil
			})
		})
	end, {
		v72,
		v64,
		v65,
		t1.playerCountStyle,
		t1.entry.playerCount,
		v50,
		v71,
		v49,
		v63,
		v67,
		v70,
		v66,
		v73
	})
	local v80, v81 = React.useState(Vector2.new(0, 0))
	local v82 = React.useMemo(function() -- line: 372
		-- upvalues: GameTileViewConfig (copy), v41 (copy), v80 (copy), v49 (copy), v75 (copy), t1 (copy), v74 (copy), v42 (copy)
		local v91 = GameTileViewConfig.getTileHeight(v41, v80.X, v49, v75, false, false, t1.textSizeOffset, nil, 1, v74, v42, true)

		return v80.Y - v91
	end, {
		v41,
		v80,
		v49,
		v75,
		t1.textSizeOffset,
		1,
		v74,
		v42
	})
	local v83 = React.useRef(nil)

	React.useEffect(function() -- line: 403
		-- upvalues: ImpressionsTagUtility (copy), v83 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v83, t1.impressionsTag, t1.index)

		return function() -- line: 405
			-- upvalues: ImpressionsTagUtility (copy), v83 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v83, t1.impressionsTag, t1.index)
		end
	end, {
		t1.impressionsTag,
		t1.index
	})

	if FFlagLuaAppHomeTouchAutoplay then
		useTagAsViewportAutoplayCandidate(v83, t1.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)
	end

	local v84 = nil
	local v85 = getTileBadgeByPositionConfigFromEntry(t1.entry)

	if v85 then
		v84 = React.createElement(GameTileThumbnailBadges, {
			tileBadgesByPosition = v85
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
			ref = v83,
			[React.Change.AbsoluteSize] = function(p4) -- line: 440
				-- upvalues: v81 (copy)
				v81(p4.AbsoluteSize)
			end
		}, {
			GameTileView = React.createElement(GameTileView, {
				numLinesForTitle = 1,
				isUnifiedGameTile = true,
				hidePlayButton = true,
				forwardRef = v56,
				selectionOrder = if not FFlagLuaAppFixCustomTileBugs then t1.selectionOrder else nil,
				SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t1.SelectionOrder,
				isDisabled = t1.isDisabled,
				onActivated = v60,
				onSelectionGained = t1.onSelectionGained,
				onSelectionLost = t1.onSelectionLost,
				image = if not v50 then v53 else v52,
				title = v55,
				numLinesForMetadata = v74,
				isHovered = u57,
				footerMetadata = v79,
				imageAspectRatio = v54,
				isContained = v75,
				extraFooterContent = if not v63 then v78 else nil,
				extraFooterSpace = if not v63 then v82 else nil,
				reducedMotion = UserGameSettings.ReducedMotion,
				thumbnailOverlay = v84,
				onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded
			})
		})
	})
end
