local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local React = require(CorePackages.Packages.React)
local CollectionViews = require(CorePackages.Workspace.Packages.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local GameCollections = require(CorePackages.Workspace.Packages.GameCollections)
local useGameCollectionLayoutParams = GameCollections.useGameCollectionLayoutParams
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local useRenderGameCollectionItem = GameCollections.useRenderGameCollectionItem
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local UIBlox = require(CorePackages.Packages.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local GameTileConstants = require(CorePackages.Workspace.Packages.GameTile).GameTileConstants
local GameCollectionItemTypes = require(CorePackages.Workspace.Packages.GameCollections).GameCollectionItemTypes
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local SendGameImpressions = require(CorePackages.Workspace.Packages.GameCollections).SendGameImpressions
local FrameBoundsImpressionsTracker = require(CorePackages.Workspace.Packages.Impressions).FrameBoundsImpressionsTracker
local DiscoveryAnalytics = require(CorePackages.Workspace.Packages.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local Context = DiscoveryAnalytics.Constants.Context
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local useRecommendedGames = require(script.Parent.Hooks.useRecommendedGames)
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local v33 = game:DefineFastFlag("LuaAppFixEmptyRecommendedGames", false)
local v34 = game:DefineFastFlag("LuaAppChangeRecommendedGamesTitle", false)
local v35 = game:DefineFastFlag("LuaAppChangeRecommendedGamesTitleLogExposure", false)

return (React.memo(function(t1: {[any]: any}) -- line: 76
	-- upvalues: React (copy), useGameCollectionLayoutParams (copy), useRecommendedGames (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), useTextSizeOffset (copy), useGetGameTileHeight (copy), GameTileConstants (copy), useLocalization (copy), v34 (copy), v35 (copy), IXPServiceWrapper (copy), AppUserLayers (copy), useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), RoactAnalyticsCommonGameEvents (copy), HttpService (copy), gamePlayIntent (copy), Context (copy), GameCollectionItemTypes (copy), SendGameImpressions (copy), useCollectionImpressionsSignal (copy), useRenderGameCollectionItem (copy), v33 (copy), CollectionCarousel (copy), FrameBoundsImpressionsTracker (copy), AppPage (copy), LoadingStateContainer (copy), RetrievalStatus (copy)
	local v37, v38 = React.useState(nil)
	local v39 = useGameCollectionLayoutParams("Narrow", v37, false, {
		sideMargin = 0
	})
	local v40 = useRecommendedGames(t1.universeId, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t1.shouldHydrateLegacyIxp)
	local recommendedGames = v40.recommendedGames
	local v42 = useTextSizeOffset()
	local v43 = useGetGameTileHeight(true, "Narrow", nil, false, false, 0, 0, GameTileConstants.TileTextLines.Narrow.titleTextLines)
	local v44 = useLocalization({
		title = not v34 and "Feature.GameDetails.Heading.Recommended" or "Common.GameSorts.Label.BlendedSerpPeopleAlsoJoin"
	})

	if v35 then
		React.useEffect(function() -- line: 105
			-- upvalues: IXPServiceWrapper (copy), AppUserLayers (copy)
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ExperienceDetailsPageExposureLayer)
		end, {})
	end

	local v45 = useRoactService(AppEventIngestService)
	local v46 = useRoactService(RoactAnalytics)
	local v47 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v48 = React.useRef(HttpService:GenerateGUID())
	local v49 = "GameDetails_" .. tostring(t1.universeId) .. tostring(v48.current)
	local v50 = React.useRef(nil)
	local v51 = React.useCallback(function(p1) -- line: 118
		-- upvalues: recommendedGames (copy), t1 (copy), v47 (copy)
		if #recommendedGames == 0 then
			return
		end

		local v60 = recommendedGames[p1]

		if not v60 then
			return
		end

		local placeId = v60.placeId
		local isSponsored = v60.isSponsored
		local adId = v60.adId
		local universeId = v60.universeId
		local v65 = #recommendedGames
		local universeId2 = t1.universeId

		v47.reportOpenGameDetailFromGameDetail(placeId, p1, v65, isSponsored, adId, universeId, t1.pageContext, universeId2)
	end, {
		v47,
		recommendedGames,
		t1.universeId,
		t1.pageContext
	})
	local v52 = React.useCallback(function(p2) -- line: 151
		-- upvalues: gamePlayIntent (copy), v45 (copy), Context (copy), t1 (copy), GameCollectionItemTypes (copy)
		if not p2 then
			return
		end

		gamePlayIntent(v45, Context.ExperienceTile, {
			placeId = p2.placeId,
			rootPlaceId = tonumber(p2.placeId),
			universeId = p2.universeId,
			sortIndex = tostring(0),
			sortEntryIndex = tostring(p2.index),
			pageName = t1.pageContext,
			tileType = GameCollectionItemTypes.GameCollectionItemType.GameTile
		})
	end, {
		v45,
		t1.pageContext
	})
	local v53 = React.useCallback(function(p3) -- line: 169
		-- upvalues: recommendedGames (copy), SendGameImpressions (copy), v45 (copy), v46 (copy), t1 (copy)
		if #recommendedGames == 0 then
			return
		end

		SendGameImpressions.sendFromGameDetails(v45, v46, p3, recommendedGames, t1.universeId)
	end, {
		v45,
		v46,
		recommendedGames,
		t1.universeId
	})
	local v54, v55 = useCollectionImpressionsSignal()
	local Footer = GameTileConstants.PlayerCountStyleValues.Footer
	local v57 = useRenderGameCollectionItem(Footer, false, "Narrow", true, false, v49, true, v51, v52, nil, nil, nil, nil, nil, nil, false, nil, nil, false, false, nil, nil, nil, v42, GameTileConstants.TileTextLines.Narrow.titleTextLines, nil, nil, nil, t1.onPeekViewClosed, nil)
	local v58 = React.useCallback(function() -- line: 223
		-- upvalues: v33 (copy), recommendedGames (copy), React (copy), v38 (copy), t1 (copy), CollectionCarousel (copy), v50 (copy), v39 (copy), v43 (copy), v55 (copy), v57 (copy), v44 (copy), FrameBoundsImpressionsTracker (copy), AppPage (copy), v49 (copy), v54 (copy), v53 (copy)
		if v33 and #recommendedGames == 0 then
			return nil
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			ref = v38
		}, {
			UIPadding = t1.padding and React.createElement("UIPadding", t1.padding),
			GameCarousel = React.createElement(CollectionCarousel, {
				scrollingFrameRef = v50,
				columnGap = v39.columnGap,
				fractionalItemAmount = v39.fractionalItemAmount,
				getItemHeight = v43,
				items = recommendedGames,
				maxItemsToShow = v39.maxTilesToShow,
				onViewableItemsChanged = v55,
				onChangeCanvasPosition = v55,
				numColumns = v39.numColumns,
				renderItem = v57,
				sideMargin = v39.sideMargin,
				title = v44.title,
				scrollingEnabledOverride = t1.scrollingEnabled or false
			}),
			GameSortImpressionsDetector = React.createElement(FrameBoundsImpressionsTracker, {
				parentRef = v50,
				pageContext = {
					AppPage.GameDetail,
					AppPage.ExperienceDetail
				},
				impressionsTag = v49,
				scrollViewPositionChangedSignal = v54,
				sendImpressions = v53
			})
		})
	end, {
		v38,
		v39.columnGap,
		v39.fractionalItemAmount,
		v39.maxTilesToShow,
		v39.numColumns,
		v39.sideMargin,
		v43,
		recommendedGames,
		v55,
		v57,
		v50,
		v44.title,
		v49,
		v54,
		v53,
		t1.scrollingEnabled,
		t1.padding
	})

	return React.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus.fromRawValue(v40.fetchStatus),
		renderOnFailed = function() -- line: 287
			return nil
		end,
		renderOnLoaded = v58
	})
end))
