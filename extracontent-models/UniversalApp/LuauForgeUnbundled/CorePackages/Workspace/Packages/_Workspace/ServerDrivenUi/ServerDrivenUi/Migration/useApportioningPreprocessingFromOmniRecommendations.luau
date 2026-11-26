local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/tutils")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews")
local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameTile")
local gameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType
local topicContentsReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/TopicContentsRodux").TopicContentsReducer
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryTypes")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getGameTileCollectionItemSize = GameTile.getGameTileCollectionItemSize
local omniFeedTypes = DiscoveryTypes.OmniFeedTypes
local omniFeedConstants = DiscoveryTypes.OmniFeedConstants

local getSduiFeedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getSduiFeedStore")
local ApportioningPreprocessingHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/ApportioningPreprocessingHelpers")

local fFlagLuaAppUseEffectInSignalPreprocessing = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppUseEffectInSignalPreprocessing

local fFlagLuaAppAddRequestIdToRfySignalApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddRequestIdToRfySignalApportioning
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppCompositionAlways

local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore

local function useApportioningPreprocessingFromOmniRecommendations(p2, p3, p4)
	local v5 = fFlagLuaAppCompositionAlways or p4

	local v6 = useSelector(function(p5)
		local omniRecommendation = p5.OmniRecommendations[p2]

		if omniRecommendation then
			return omniRecommendation.sorts
		end

		return {}
	end, tutils.shallowEqual)
	local v7

	if fFlagLuaAppAddRequestIdToRfySignalApportioning then
		v7 = useSelector(function(p5)
			local omniRecommendation = p5.OmniRecommendations[p2]

			if omniRecommendation then
				return omniRecommendation.recommendationsId
			end

			return nil
		end)
	else
		v7 = nil
	end

	local v8 = useSelector(function(p5)
		return p5.Personalization[topicContentsReducer.key]
	end)
	local v9

	if fFlagLuaAppUseEffectInSignalPreprocessing then
		v9 = React.useEffect
	else
		v9 = React.useLayoutEffect
	end

	local function fn()
		local v10 = getSduiFeedStore(p2)
		local v11 = {}

		local v12 = if v5 then getMainCollectionLayoutStore(false).getNumItemsForAllCategories(false) else nil

		for k, v13 in v6 do
			local topicId = v13.topicId

			if not (topicId and v13.treatmentType == omniFeedTypes.HomeGameGrid) then
				continue
			end

			local v14 = gameTileLayoutType.Narrow

			if v13.topicLayoutData then
				local v15 = v13.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]

				if v15 then
					if v15 == omniFeedConstants.ComponentTypeDataKeys.EventTile then
						v14 = gameTileLayoutType.Event
					elseif v15 == omniFeedConstants.ComponentTypeDataKeys.GridTile then
						v14 = gameTileLayoutType.Wide
					end
				end
			end

			local gameTileCollectionItemSize = getGameTileCollectionItemSize(v14)
			local v15

			if v5 then
				v15 = v12[gameTileCollectionItemSize]
			else
				v15 = p3[gameTileCollectionItemSize](false).numColumns
			end

			local numberOfRows = v13.numberOfRows or 99999
			local v16 = v15 * (numberOfRows == -1 and 99999 or numberOfRows)

			ApportioningPreprocessingHelpers.addToApportioningData(v11, topicId, v16, k)
		end

		ApportioningPreprocessingHelpers.populateStartingItemIndices(v11)

		for k, v13 in v11 do
			local v14 = if k then v8 and v8[k] or nil else nil

			v13.items = v14 and v14.entries or {}
		end

		v10.updateData(
			{ apportioningData = v11 },
			if fFlagLuaAppAddRequestIdToRfySignalApportioning then v7 else nil
		)

		return function() end
	end

	local v11 = if not fFlagLuaAppCompositionAlways then p3 else nil
	v9(fn, {
		v6,
		v8,
		v11,
		p2,
		if fFlagLuaAppAddRequestIdToRfySignalApportioning then v7 else nil,
		v5
	})
end

return useApportioningPreprocessingFromOmniRecommendations
