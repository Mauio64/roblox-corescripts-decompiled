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

return function(t1: {[any]: any}) -- line: 90
	-- upvalues: useDesignTokens (copy), useTokens (copy), useSelector (copy), GameInfosReducer (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), React (copy), ApiFetchGameDetails (copy), getGameTileLayoutData (copy), ItemLayoutDataParsingUtils (copy), formatExperienceThumbnail (copy), BigGameIconReducer (copy), GameTileViewConfig (copy), v35 (copy), IsVRAppBuild (copy), useIsHoveredTile (copy), HoverTileCoordinator (copy), GameCollectionItemTypes (copy), sponsoredGamesRecordClick (copy), AppExperienceActionRow (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), GameStats (copy), GameTileConstants (copy), v34 (copy), ImpressionsTagUtility (copy), useTagAsViewportAutoplayCandidate (copy), FFlagLuaAppTileVideoCandidateOnly (copy), getTileBadgeByPositionConfigFromEntry (copy), GameTileThumbnailBadges (copy), GameTileView (copy), FFlagLuaAppFixCustomTileBugs (copy), UserGameSettings (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy)
	local v40 = useDesignTokens()
	local v41 = useTokens()
	local universeId = t1.entry.universeId
	local v43 = useSelector(function(p1) -- line: 98
		-- upvalues: GameInfosReducer (copy), universeId (copy)
		return p1.Personalization[GameInfosReducer.key][universeId]
	end)
	local v44 = useSelector(function(p2) -- line: 101
		-- upvalues: universeId (copy)
		return p2.GameDetails[universeId]
	end)
	local v45 = useRoactService(RoactNetworking)
	local v46 = useDispatch()

	React.useEffect(function() -- line: 107
		-- upvalues: v44 (copy), v46 (copy), ApiFetchGameDetails (copy), v45 (copy), universeId (copy)
		if v44 then
			return
		end

		v46(ApiFetchGameDetails.Fetch(v45, { universeId }))
	end, {
		v44,
		universeId,
		v45,
		v46
	})

	local v47 = getGameTileLayoutData(v43, t1.topicId)
	local v48 = t1.gameTileLayoutType or "Narrow"
	local v49 = v48 == "Wide" or v48 == "Event"
	local v50 = ((if not t1.entry.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v47) else t1.entry.primaryWideImageAssetId)) or (v43 and v43.primaryWideAssetId or nil)
	local v51 = formatExperienceThumbnail(v50, t1.entry.placeId, true)
	local v52 = useSelector(function(p3) -- line: 128
		-- upvalues: BigGameIconReducer (copy), universeId (copy)
		return p3[BigGameIconReducer.key][universeId] and p3[BigGameIconReducer.key][universeId].url or ""
	end)
	local v53 = GameTileViewConfig.getImageAspectRatio(v48)
	local v54 = v47 and v47.title or (v43 and v43.name or "")
	local v55 = nil
	local u56 = nil

	if v35 then
		local v57 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v55 = React.useRef(nil)

		local v58 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v48 }`

		u56 = useIsHoveredTile(v55, v58, v57)
	end

	local v59 = React.useCallback(function() -- line: 151
		-- upvalues: v35 (copy), u56 (ref), HoverTileCoordinator (copy), t1 (copy), GameCollectionItemTypes (copy), universeId (copy), sponsoredGamesRecordClick (copy), v45 (copy)
		if v35 and u56 then
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
			sponsoredGamesRecordClick(v45, t1.entry.adId)
		end
	end, {
		universeId,
		t1.source,
		t1.onPeekViewClosed,
		t1.entry.isSponsored,
		t1.entry.adId,
		t1.reportGameDetailOpened,
		v45,
		t1.navigateToGameDetails,
		t1.referralSource,
		t1.index,
		if not v35 then nil else u56
	})

	if not v35 then
		local v60 = not IsVRAppBuild() and (not not t1.useHoverTile and (t1.impressionsTag ~= nil or false))

		v55 = React.useRef(nil)

		local v61 = `{ t1.impressionsTag or "" }_{ t1.index }_{ v48 }`

		u56 = useIsHoveredTile(v55, v61, v60)
	end

	local v62 = t1.showDescription or false
	local v63 = v43 and v43.totalUpVotes or 0
	local v64 = v43 and v43.totalDownVotes or 0
	local v65 = v44 and (v44.creator and v44.creator.hasVerifiedBadge)
	local v66 = v44 and v44.description or ""
	local v67 = v44 and v44.licenseDescription or nil
	local v68 = v44 and v44.localizedFiatPrice or nil
	local v69 = v67 or v68
	local v70 = t1.hideGameStats or (v62 or v69 ~= nil)
	local v71 = v43 and (v43.creatorName ~= "" and v43.creatorName) or v44 and (v44.creator and v44.creator.name)
	local v72 = not v69 and 3 or 2
	local v73 = React.useMemo(function() -- line: 223
		-- upvalues: v71 (copy), v62 (copy), v72 (copy), v70 (copy), v69 (copy)
		local n1 = 0

		if v71 and v71 ~= "" then
			n1 += 1
		end

		if v62 then
			n1 += v72
		end

		if not v70 then
			n1 += 1
		end

		if v69 then
			n1 += 1
		end

		return n1
	end, {
		v71,
		v62,
		v70,
		v69,
		v72
	})
	local v74 = t1.isContained or false
	local playButtonHeight = GameTileViewConfig.getElementSizes(v40, t1.textSizeOffset, 1, v41, true, v73).playButtonHeight
	local v76 = if not v35 then nil else React.useCallback(function(...) -- line: 257
		-- upvalues: u56 (ref), HoverTileCoordinator (copy), t1 (copy)
		if u56 then
			HoverTileCoordinator.default:reset()
		end

		if t1.reportExperienceLaunched then
			t1.reportExperienceLaunched(...)
		end
	end, {
		u56,
		t1.reportExperienceLaunched
	})
	local v77 = React.useMemo(function() -- line: 269
		-- upvalues: React (copy), AppExperienceActionRow (copy), universeId (copy), t1 (copy), v35 (copy), v76 (copy), v59 (copy), v53 (copy), playButtonHeight (copy)
		return React.createElement(AppExperienceActionRow, {
			launchSource = "FeaturedSearchTile",
			horizontalPadding = 0,
			verticalPadding = 0,
			isUnifiedGameTileEnabled = true,
			universeId = universeId,
			referralSource = t1.referralSource,
			reportExperienceLaunched = if not v35 then t1.reportExperienceLaunched else v76,
			openGameDetails = v59,
			entry = t1.entry,
			launchExperienceEventContext = t1.launchExperienceEventContext,
			showButtonText = v53 > 1,
			height = playButtonHeight,
			index = t1.index
		})
	end, {
		universeId,
		t1.referralSource,
		if not v35 then t1.reportExperienceLaunched else v76,
		v59,
		t1.entry,
		t1.launchExperienceEventContext,
		playButtonHeight,
		t1.index,
		v53
	})
	local v78 = React.useMemo(function() -- line: 302
		-- upvalues: React (copy), v69 (copy), GridTileTextFooter (copy), CreatorNameMetadata (copy), v71 (copy), v65 (copy), GameStats (copy), v63 (copy), v64 (copy), t1 (copy), GameTileConstants (copy), v49 (copy), v70 (copy), v48 (copy), v62 (copy), v66 (copy), v72 (copy), v34 (copy)
		return React.createElement(React.Fragment, {}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ExtraMetadata = if not v69 then nil else React.createElement(GridTileTextFooter, {
				LayoutOrder = 1,
				useLargerFont = true,
				isUnifiedGameTile = true,
				text = v69
			}),
			CreatorName = React.createElement(CreatorNameMetadata, {
				LayoutOrder = 2,
				name = v71,
				hasVerifiedBadge = v65
			}),
			GameStats = React.createElement(GameStats, {
				LayoutOrder = 3,
				useLargerFont = true,
				isUnifiedGameTile = true,
				stats = {
					totalUpVotes = v63,
					totalDownVotes = v64,
					playerCount = if t1.playerCountStyle ~= GameTileConstants.PlayerCountStyleValues.Footer then nil else t1.entry.playerCount
				},
				isGridTile = v49,
				hideGameStats = v70,
				gameTileLayoutType = v48
			}),
			Description = if not v62 then nil else React.createElement(GridTileTextFooter, {
				LayoutOrder = 4,
				useLargerFont = true,
				isUnifiedGameTile = true,
				ClipsDescendants = true,
				text = v66,
				linesOfText = v72,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = not not v34 or nil
			})
		})
	end, {
		v71,
		v63,
		v64,
		t1.playerCountStyle,
		t1.entry.playerCount,
		v49,
		v70,
		v48,
		v62,
		v66,
		v69,
		v65,
		v72
	})
	local v79, v80 = React.useState(Vector2.new(0, 0))
	local v81 = React.useMemo(function() -- line: 371
		-- upvalues: GameTileViewConfig (copy), v40 (copy), v79 (copy), v48 (copy), v74 (copy), t1 (copy), v73 (copy), v41 (copy)
		local v90 = GameTileViewConfig.getTileHeight(v40, v79.X, v48, v74, false, false, t1.textSizeOffset, nil, 1, v73, v41, true)

		return v79.Y - v90
	end, {
		v40,
		v79,
		v48,
		v74,
		t1.textSizeOffset,
		1,
		v73,
		v41
	})
	local v82 = React.useRef(nil)

	React.useEffect(function() -- line: 402
		-- upvalues: ImpressionsTagUtility (copy), v82 (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(v82, t1.impressionsTag, t1.index)

		return function() -- line: 404
			-- upvalues: ImpressionsTagUtility (copy), v82 (copy), t1 (copy)
			ImpressionsTagUtility.RemoveTag(v82, t1.impressionsTag, t1.index)
		end
	end, {
		t1.impressionsTag,
		t1.index
	})
	useTagAsViewportAutoplayCandidate(v82, t1.videoPlaybackContext, not FFlagLuaAppTileVideoCandidateOnly and nil)

	local v83 = nil
	local v84 = getTileBadgeByPositionConfigFromEntry(t1.entry)

	if v84 then
		v83 = React.createElement(GameTileThumbnailBadges, {
			tileBadgesByPosition = v84
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
			ref = v82,
			[React.Change.AbsoluteSize] = function(p4) -- line: 437
				-- upvalues: v80 (copy)
				v80(p4.AbsoluteSize)
			end
		}, {
			GameTileView = React.createElement(GameTileView, {
				numLinesForTitle = 1,
				isUnifiedGameTile = true,
				hidePlayButton = true,
				forwardRef = v55,
				selectionOrder = if not FFlagLuaAppFixCustomTileBugs then t1.selectionOrder else nil,
				SelectionOrder = if not FFlagLuaAppFixCustomTileBugs then nil else t1.SelectionOrder,
				isDisabled = t1.isDisabled,
				onActivated = v59,
				onSelectionGained = t1.onSelectionGained,
				onSelectionLost = t1.onSelectionLost,
				image = if not v49 then v52 else v51,
				title = v54,
				numLinesForMetadata = v73,
				isHovered = u56,
				footerMetadata = v78,
				imageAspectRatio = v53,
				isContained = v74,
				extraFooterContent = if not v62 then v77 else nil,
				extraFooterSpace = if not v62 then v81 else nil,
				reducedMotion = UserGameSettings.ReducedMotion,
				thumbnailOverlay = v83,
				onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded
			})
		})
	})
end
