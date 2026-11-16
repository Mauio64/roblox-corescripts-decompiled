local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/edJ")
local collectionCarousel = module.CollectionCarousel
local useCollectionImpressionsSignal = module.useCollectionImpressionsSignal

local module2 = require("@luauforge/deferred/gao")
local useGameCollectionLayoutParams = module2.useGameCollectionLayoutParams
local useGetGameTileHeight = module2.useGetGameTileHeight
local useRenderGameCollectionItem = module2.useRenderGameCollectionItem

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local appEventIngestService = RoactServiceTags.AppEventIngestService
local roactAnalytics = RoactServiceTags.RoactAnalytics
local roactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local UIBlox = require(CorePackages.Packages.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus

local gameTileConstants = require("@luauforge/bundled/fYU").GameTileConstants

local gameCollectionItemTypes = require("@luauforge/deferred/gao").GameCollectionItemTypes

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local sendGameImpressions = require("@luauforge/deferred/gao").SendGameImpressions

local frameBoundsImpressionsTracker = require("@luauforge/bundled/edd").FrameBoundsImpressionsTracker

local module4 = require("@luauforge/bundled/dwD")
local gamePlayIntent = module4.Events.gamePlayIntent
local context = module4.Constants.Context

local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local ixpServiceWrapper = require("@luauforge/bundled/fvx").IXPServiceWrapper

local module5 = require("@luauforge/deferred/gap")

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry
local defineFastFlag = game:DefineFastFlag("LuaAppFixEmptyRecommendedGames", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppChangeRecommendedGamesTitle", false)

local defineFastFlag3 = game:DefineFastFlag("LuaAppChangeRecommendedGamesTitleLogExposure", false)

return React.memo(function(props)
	local state, setState = React.useState(nil)
	local v5 = useGameCollectionLayoutParams("Narrow", state, false, { sideMargin = 0 })

	local universeId = props.universeId
	local v7 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then props.shouldHydrateLegacyIxp else nil
	local v8 = module5(universeId, v7)

	local recommendedGames = v8.recommendedGames
	local v9 = useTextSizeOffset()
	local v10 = useGetGameTileHeight(
		true,
		"Narrow",
		nil,
		false,
		false,
		0,
		0,
		gameTileConstants.TileTextLines.Narrow.titleTextLines
	)

	local v11 = useLocalization({
		title = defineFastFlag2 and "Common.GameSorts.Label.BlendedSerpPeopleAlsoJoin" or "Feature.GameDetails.Heading.Recommended"
	})

	if defineFastFlag3 then
		React.useEffect(function()
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.ExperienceDetailsPageExposureLayer)
		end, {})
	end

	local v12 = useRoactService(appEventIngestService)
	local v13 = useRoactService(roactAnalytics)
	local v14 = useRoactService(roactAnalyticsCommonGameEvents)

	local ref = React.useRef(HttpService:GenerateGUID())
	local v15 = "GameDetails_" .. tostring(props.universeId) .. tostring(ref.current)
	local ref2 = React.useRef(nil)

	local v16 = React.useCallback(function(p2)
		if #recommendedGames == 0 then
			return
		end

		local recommendedGame = recommendedGames[p2]

		if not recommendedGame then
			return
		end

		local placeId = recommendedGame.placeId
		local isSponsored = recommendedGame.isSponsored
		local adId = recommendedGame.adId
		local universeId2 = recommendedGame.universeId
		local v17 = #recommendedGames
		local universeId3 = props.universeId

		v14.reportOpenGameDetailFromGameDetail(
			placeId,
			p2,
			v17,
			isSponsored,
			adId,
			universeId2,
			props.pageContext,
			universeId3
		)
	end, { v14, recommendedGames, props.universeId, props.pageContext })

	local v17 = React.useCallback(function(data, p2, p3, p4, p5, actionType)
		if not data then
			return
		end

		local experienceTile = context.ExperienceTile
		local v20 = {
			placeId = data.placeId,
			rootPlaceId = tonumber(data.placeId),
			universeId = data.universeId,
			sortIndex = tostring(0),
			sortEntryIndex = tostring(data.index),
			pageName = props.pageContext,
			tileType = gameCollectionItemTypes.GameCollectionItemType.GameTile,
			actionType = 0
		}

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v20.actionType = actionType
		gamePlayIntent(v12, experienceTile, v20)
	end, { v12, props.pageContext })

	local v18 = React.useCallback(function(p2)
		if #recommendedGames == 0 then
			return
		end

		sendGameImpressions.sendFromGameDetails(v12, v13, p2, recommendedGames, props.universeId)
	end, { v12, v13, recommendedGames, props.universeId })

	local v19, v20 = useCollectionImpressionsSignal()
	local v21 = useRenderGameCollectionItem(
		gameTileConstants.PlayerCountStyleValues.Footer,
		false,
		"Narrow",
		true,
		false,
		v15,
		true,
		v16,
		v17,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		false,
		nil,
		nil,
		false,
		false,
		nil,
		nil,
		nil,
		v9,
		gameTileConstants.TileTextLines.Narrow.titleTextLines,
		nil,
		nil,
		nil,
		props.onPeekViewClosed,
		nil
	)

	local v22 = React.useCallback(function()
		if defineFastFlag and #recommendedGames == 0 then
			return nil
		end

		return React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			Size = UDim2.fromScale(1, 0),
			ref = setState
		}, {
			UIPadding = props.padding and React.createElement("UIPadding", props.padding),
			GameCarousel = React.createElement(collectionCarousel, {
				scrollingFrameRef = ref2,
				columnGap = v5.columnGap,
				fractionalItemAmount = v5.fractionalItemAmount,
				getItemHeight = v10,
				items = recommendedGames,
				maxItemsToShow = v5.maxTilesToShow,
				onViewableItemsChanged = v20,
				onChangeCanvasPosition = v20,
				numColumns = v5.numColumns,
				renderItem = v21,
				sideMargin = v5.sideMargin,
				title = v11.title,
				scrollingEnabledOverride = props.scrollingEnabled or false
			}),
			GameSortImpressionsDetector = React.createElement(frameBoundsImpressionsTracker, {
				parentRef = ref2,
				pageContext = { appPage.GameDetail, appPage.ExperienceDetail },
				impressionsTag = v15,
				scrollViewPositionChangedSignal = v19,
				sendImpressions = v18
			})
		})
	end, {
		setState,
		v5.columnGap,
		v5.fractionalItemAmount,
		v5.maxTilesToShow,
		v5.numColumns,
		v5.sideMargin,
		v10,
		recommendedGames,
		v20,
		v21,
		ref2,
		v11.title,
		v15,
		v19,
		v18,
		props.scrollingEnabled,
		props.padding
	})

	return React.createElement(loadingStateContainer, {
		dataStatus = retrievalStatus.fromRawValue(v8.fetchStatus),
		renderOnFailed = function(): nil
			return nil
		end,
		renderOnLoaded = v22
	})
end)
